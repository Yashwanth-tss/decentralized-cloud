#!/bin/bash

set -e

if ! command -v helm >/dev/null 2>&1; then
  echo "[INFO] Installing Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
  echo "[INFO] Helm is already installed"
fi
