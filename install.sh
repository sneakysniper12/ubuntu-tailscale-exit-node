#!/bin/bash
set -e

echo "=== Ubuntu Tailscale Exit Node Installer ==="

source ./config.env

# ==============================
# PROMPT FOR KEYS IF NOT SET
# ==============================

if [ -z "$TAILSCALE_AUTH_KEY" ]; then
  read -p "Enter Tailscale AUTH KEY: " TAILSCALE_AUTH_KEY
fi

if [ -z "$TAILSCALE_API_KEY" ]; then
  read -p "Enter Tailscale API KEY: " TAILSCALE_API_KEY
fi

if [ -z "$TAILSCALE_TAILNET" ]; then
  read -p "Enter your Tailnet name (example: yourname.github): " TAILSCALE_TAILNET
fi

echo "[1/5] Installing Tailscale..."
bash scripts/install_tailscale.sh

echo "[2/5] Configuring system..."
bash scripts/configure_exit_node.sh

echo "[3/5] Enabling Tailscale SSH..."
if [ "$ENABLE_TAILSCALE_SSH" = "true" ]; then
  bash scripts/enable_tailscale_ssh.sh
fi

echo "[4/5] Bringing Tailscale online..."

TAILSCALE_CMD="sudo tailscale up --authkey=$TAILSCALE_AUTH_KEY --advertise-tags=$TAGS"

if [ "$ADVERTISE_EXIT_NODE" = "true" ]; then
  TAILSCALE_CMD="$TAILSCALE_CMD --advertise-exit-node"
fi

if [ "$ENABLE_TAILSCALE_SSH" = "true" ]; then
  TAILSCALE_CMD="$TAILSCALE_CMD --ssh"
fi

eval $TAILSCALE_CMD

echo "[5/5] Auto-enabling exit node via API..."
bash scripts/auto_enable_exit_node.sh "$TAILSCALE_API_KEY" "$TAILSCALE_TAILNET"

echo "=== DONE ==="
