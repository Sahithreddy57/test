#!/bin/bash
set -e
echo "🚀 Building Docker images..."
docker compose build

echo "🔒 Saving & encrypting Docker image archive..."
IMAGE_NAME="lms_secure_compose_images"
# save all images used by compose into a single tar by referencing compose images
docker save $(docker compose images -q) -o ${IMAGE_NAME}.tar || docker compose save -o ${IMAGE_NAME}.tar || true

if [ ! -f ${IMAGE_NAME}.tar ]; then
  # fallback: save by service names
  docker save $(docker images --format '{{.Repository}}:{{.Tag}}' | grep lms) -o ${IMAGE_NAME}.tar || true
fi

openssl enc -aes-256-cbc -salt -in ${IMAGE_NAME}.tar -out ${IMAGE_NAME}.tar.enc
echo "📤 Uploading to VPS..."
scp ${IMAGE_NAME}.tar.enc ubuntu@/opt/lms-secure/ || scp ${IMAGE_NAME}.tar.enc ubuntu@your-vps:/opt/lms-secure/ || true

echo "📦 Please ssh to your VPS and run:"
echo "  openssl enc -d -aes-256-cbc -in ${IMAGE_NAME}.tar.enc | docker load"
echo "  cd /opt/lms-secure && docker compose up -d"
echo "✅ Manual deployment instructions printed above."
