#!/bin/bash

# Install Ollama
sudo dnf install -y \
  curl \
  rocm \
  rocm-hip \
  rocm-opencl \
  rocminfo \
  hipblas-devel \
  hipblaslt-devel \
  openssl \
  rocblas-devel \
  rocm-cmake \
  rocm-core-devel \
  rocm-omp-devel \
  wget \
  zstd

sudo usermod -aG render,video $USER

#curl -fsSL https://ollama.com/install.sh | sh
#curl -fsSL https://ollama.com/download/ollama-linux-amd64-rocm.tar.zst | sudo tar --zstd -x -C /usr
#
#sudo tee /etc/systemd/system/ollama.service >/dev/null <<'EOF'
#[Unit]
#Description=Ollama Service
#After=network-online.target
#
#[Service]
#ExecStart=/usr/bin/ollama serve
#User=ollama
#Group=ollama
#Restart=always
#RestartSec=3
#Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#Environment="HOME=/usr/share/ollama"
## === Key settings for your use case ===
#Environment="OLLAMA_HOST=0.0.0.0:11434"
## Optional but useful later:
## Environment="OLLAMA_FLASH_ATTENTION=1"
## Environment="OLLAMA_KEEP_ALIVE=5m"
## Environment="ROCR_VISIBLE_DEVICES=0"   # force specific GPU if you add more later
#
#[Install]
#WantedBy=multi-user.target
#EOF
#
#sudo systemctl daemon-reload
#sudo systemctl restart ollama

# Set SELinux to allow containers to use GPUs
sudo setsebool -P container_use_devices 1

# Docker config
sudo tee /etc/docker/daemon.json >/dev/null <<'EOF'
{
  "bip": "192.168.200.1/24",
  "default-address-pools": [
    {
      "base": "192.168.200.0/16",
      "size": 24
    }
  ]
}
EOF

# Install Docker
sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# In case Docker was already running
sudo systemctl stop docker docker.socket
sudo systemctl daemon-reload
sudo ip link delete docker0 2>/dev/null || true

sudo systemctl enable --now docker

sudo firewall-cmd --permanent --zone=docker --add-masquerade
sudo firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.200.0/16" masquerade'
sudo firewall-cmd --reload

sudo usermod -aG docker $USER

tee $HOME/Projects/llm-platform/docker-compose.yml >/dev/null <<'EOF'
services:
  ollama:
    image: ollama/ollama:rocm
    container_name: ollama
    restart: unless-stopped
    ports:
      - "11434:11434"
    environment:
      OLLAMA_HOST: "0.0.0.0:11434"
      HSA_OVERRIDE_GFX_VERSION: "11.0.0"
      #OLLAMA_FLASH_ATTENTION: "1"
      # Uncomment if GPU is not detected automatically:
    volumes:
      - ollama-data:/root/.ollama
    devices:
      - /dev/kfd:/dev/kfd
      - /dev/dri:/dev/dri
    group_add:
      - "39"  # video
      - "105" # render
    networks:
      - llm-net

  postgres:
    image: postgres:16
    container_name: postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - llm-net
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5

  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    restart: unless-stopped
    environment:
      OLLAMA_BASE_URL: http://ollama:11434
      DATABASE_URL: postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
      ENABLE_SIGNUP: "true"
      WEBUI_AUTH: "true"
    volumes:
      - open-webui-data:/app/backend/data
    depends_on:
      ollama:
        condition: service_started
      postgres:
        condition: service_healthy
    networks:
      - llm-net

  nginx-proxy-manager:
    image: jc21/nginx-proxy-manager:latest
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "127.0.0.1:81:81"
    volumes:
      - ./npm-data:/data
      - ./npm-letsencrypt:/etc/letsencrypt
    networks:
      - llm-net

networks:
  llm-net:
    driver: bridge

volumes:
  ollama-data:
  postgres-data:
  open-webui-data:
EOF

pass=$(openssl rand -base64 30 | tr -dc 'A-Za-z0-9' | cut -c1-30)

cat >$HOME/Projects/llm-platform/.env <<'EOF'
POSTGRES_USER=openwebui
POSTGRES_PASSWORD=${pass}
POSTGRES_DB=openwebui
EOF

echo $pass >$HOME/Projects/llm-platform/output.txt

#sudo tee /etc/systemd/system/open-webui.service >/dev/null <<'EOF'
#[Unit]
#Description=LLM Platform Stack (Open WebUI + PostgreSQL)
#After=docker.service
#Requires=docker.service
#
#[Service]
#Type=oneshot
#RemainAfterExit=yes
#WorkingDirectory=/home/bcarter/Projects/open-webui/
#ExecStart=/usr/bin/docker compose up -d
#ExecStop=/usr/bin/docker compose down
#TimeoutStartSec=0
#
#[Install]
#WantedBy=multi-user.target
#EOF
#
#sudo systemctl daemon-reload
#sudo systemctl enable open-webui.service

cd $HOME/Projects/llm-platform/
docker compose --env-file .env up -d
