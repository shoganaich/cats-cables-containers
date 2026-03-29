#!/usr/bin/env bash
set -euo pipefail

cd /opt/cats-cables-containers
git pull
docker compose up -d