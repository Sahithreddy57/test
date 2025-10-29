#!/bin/bash
set -e
echo "🔓 Decrypting secrets..."
if [ ! -f secrets/secrets.enc.yaml ]; then
  echo "secrets/secrets.enc.yaml not found."
  exit 1
fi
sops --decrypt secrets/secrets.enc.yaml > .env
echo "✅ secrets decrypted to .env (temporary)"
