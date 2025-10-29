#!/bin/bash
set -e
echo "🔒 Encrypting environment variables..."
if [ ! -f .env ]; then
  echo ".env not found in current directory."
  exit 1
fi
sops --encrypt .env > secrets/secrets.enc.yaml
echo "✅ .env encrypted -> secrets/secrets.enc.yaml"
rm -f .env
