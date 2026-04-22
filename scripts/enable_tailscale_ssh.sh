#!/bin/bash
set -e

echo "Enabling Tailscale SSH support..."

# Make sure SSH server exists
sudo apt install -y openssh-server

# Enable SSH service
sudo systemctl enable --now ssh

echo "Tailscale SSH will be enabled via 'tailscale up --ssh'"

