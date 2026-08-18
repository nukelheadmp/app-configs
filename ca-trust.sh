#!/bin/bash

sudo dnf install ca-certificates
sudo cp ~/.local/share/app-configs/certs/* /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust extract
