#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/opt/cats-cables-containers"

# What to run periodically (uses your existing script)
DEPLOY_SCRIPT="${REPO_DIR}/deploy.sh"

# Cron schedule (default: every 2 minutes). Override like:
# CRON_SCHEDULE="*/1 * * * *" sudo -E ./setup.sh
CRON_SCHEDULE="${CRON_SCHEDULE:-*/2 * * * *}"

# Where cron logs go
CRON_LOG="${CRON_LOG:-/var/log/cats-cables-containers-deploy.log}"

# Nginx container name in your compose file
COMPOSE_PROJECT_DIR="${REPO_DIR}"
CRON_ID="# cats-cables-containers:auto-deploy"

need_cmd() { command -v "$1" >/dev/null 2>&1; }

main() {
  [[ $EUID -eq 0 ]] || { echo "Run as root (sudo)"; exit 1; }

  [[ -d "$REPO_DIR" ]] || { echo "Missing repo dir: $REPO_DIR"; exit 1; }
  [[ -f "$DEPLOY_SCRIPT" ]] || { echo "Missing deploy script: $DEPLOY_SCRIPT"; exit 1; }

  need_cmd docker || { echo "docker not found"; exit 1; }
  docker compose version >/dev/null 2>&1 || { echo "docker compose plugin not found"; exit 1; }
  need_cmd crontab || { echo "crontab not found"; exit 1; }

  chmod +x "$DEPLOY_SCRIPT"

  # Start/update the nginx container using your repo's compose + configs
  echo "Starting nginx via docker compose in $COMPOSE_PROJECT_DIR ..."
  ( cd "$COMPOSE_PROJECT_DIR" && docker compose up -d )

  # Create log file if missing
  touch "$CRON_LOG"
  chmod 0644 "$CRON_LOG"

  # Install/replace cron entry (idempotent)
  echo "Installing cron job: $CRON_SCHEDULE $DEPLOY_SCRIPT"
  tmp="$(mktemp)"
  crontab -l 2>/dev/null | grep -vF "$CRON_ID" > "$tmp" || true

  cat >> "$tmp" <<EOF
$CRON_ID
$CRON_SCHEDULE cd $REPO_DIR && /usr/bin/env bash $DEPLOY_SCRIPT >> $CRON_LOG 2>&1
EOF

  crontab "$tmp"
  rm -f "$tmp"

  echo
  echo "Done."
  echo "Cron installed for root. View with: sudo crontab -l"
  echo "Logs: $CRON_LOG"
  echo "Run deploy now: sudo bash $DEPLOY_SCRIPT"
}

main "$@"