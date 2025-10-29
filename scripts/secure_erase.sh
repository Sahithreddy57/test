#!/bin/bash
set -e
echo "🧨 Securely erasing local code..."
TARGETS=("frontend/src" "backend/src" "frontend/public" "backend/.env")
for path in "${TARGETS[@]}"; do
  if [ -e "$path" ]; then
    if command -v shred >/dev/null 2>&1; then
      shred -u -z -v -n 3 "$path" || rm -rf "$path"
    else
      rm -rf "$path"
    fi
  fi
done
echo "✅ Local files securely erased."
