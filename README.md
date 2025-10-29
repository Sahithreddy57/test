# lms-secure (Manual Deployment)

This repository scaffold provides a secure, manual-deployment-ready setup for an LMS website built with React (frontend) + Node.js/Express (backend) + MongoDB, using Docker and encrypted deployment assets.

Defaults: VPS user `ubuntu`, deployment path `/opt/lms-secure/`, frontend port 3000, backend port 5000, mongodb port 27017.

## Quick local test (Windows with Docker Desktop)
1. Copy `.env.example` files to `.env` inside frontend and backend folders and update values.
2. Run `docker compose up --build` to build & run containers locally.
3. Visit `http://localhost:3000` and `http://localhost:5000/api/health`.

## Encrypting environment before push
1. Install `sops` and `gpg` locally.
2. Create `.env` files from `.env.example` and fill secrets.
3. Run `bash scripts/encrypt_env.sh` to create `secrets/secrets.enc.yaml` (this removes the local `.env`).

## Manual deployment to VPS (encrypted image)
1. Run `bash scripts/build_push_server.sh` to build images and create an encrypted tar.
2. Upload `*.tar.enc` to your VPS (default path `/opt/lms-secure/`).
3. On VPS: `openssl enc -d -aes-256-cbc -in <name>.tar.enc | docker load`
4. `cd /opt/lms-secure && docker compose up -d`

## Auto-erase local code after git push
The `.git/hooks/post-push` hook triggers `scripts/secure_erase.sh` to shred local source files (if `shred` exists) after a push.

---
