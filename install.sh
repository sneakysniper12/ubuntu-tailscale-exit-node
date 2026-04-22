#!/bin/bash
set -e

echo "=== Ubuntu Tailscale Exit Node Installer ==="

# Load config
source ./config.env

echo "[1/4] Installing Tailscale..."
bash scripts/install_tailscale.sh

echo "[2/4] Configuring system..."
bash scripts/configure_exit_node.sh

echo "[3/4] Enabling Tailscale SSH..."
if [ "$ENABLE_TAILSCALE_SSH" = "true" ]; then
  bash scripts/enable_tailscale_ssh.sh
fi

echo "[4/4] Bringing Tailscale online..."

TAILSCALE_CMD="sudo tailscale up --advertise-tags=$TAGS"

if [ "$ADVERTISE_EXIT_NODE" = "true" ]; then
  TAILSCALE_CMD="$TAILSCALE_CMD --advertise-exit-node"
fi

if [ "$ENABLE_TAILSCALE_SSH" = "true" ]; then
  TAILSCALE_CMD="$TAILSCALE_CMD --ssh"
fi

eval $TAILSCALE_CMD

echo "=== DONE ==="
echo "Authorize device at: https://login.tailscale.com/admin/machines"

