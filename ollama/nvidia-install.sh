#!/bin/bash

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
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo |
  sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
sudo dnf install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker

# In case Docker was already running
sudo systemctl stop docker docker.socket
sudo systemctl daemon-reload
sudo ip link delete docker0 2>/dev/null || true

sudo systemctl enable --now docker

sudo firewall-cmd --permanent --zone=docker --add-masquerade
sudo firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.200.0/16" masquerade'
sudo firewall-cmd --reload

sudo usermod -aG docker $USER

mkdir -p $HOME/Projects/llm-platform/

tee $HOME/Projects/llm-platform/docker-compose.yml >/dev/null <<'EOF'
services:
  ollama:
    image: ollama/ollama
    container_name: ollama
    restart: unless-stopped
    ports:
      - "11434:11434"
    environment:
      OLLAMA_HOST: "0.0.0.0:11434"
    volumes:
      - ollama-data:/root/.ollama
    group_add:
      - "39"  # video
      - "105" # render
    networks:
      - llm-net
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

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

cd $HOME/Projects/llm-platform/
docker compose --env-file .env up -d
