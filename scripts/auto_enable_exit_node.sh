#!/bin/bash
set -e

API_KEY="$1"
TAILNET="$2"

echo "Fetching node ID..."

NODE_ID=$(tailscale status --json | jq -r '.Self.ID')

if [ -z "$NODE_ID" ]; then
  echo "Failed to get node ID"
  exit 1
fi

echo "Enabling exit node via API..."

curl -s -X POST "https://api.tailscale.com/api/v2/device/$NODE_ID/routes" \
  -u "$API_KEY:" \
  -H "Content-Type: application/json" \
  -d '{"routes":["0.0.0.0/0","::/0"]}' > /dev/null

echo "Exit node enabled!"
