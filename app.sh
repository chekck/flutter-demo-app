#!/bin/bash
set -euo pipefail

# ── Validate inputs ──────────────────────────────────────────
CONNECT="${1:-8}"
NAME="${2:-003}"

if ! [[ "$CONNECT" =~ ^[0-9]+$ ]]; then
  echo "[ERROR] CONNECT phải là số nguyên" >&2
  exit 1
fi

if ! [[ "$NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "[ERROR] NAME chứa ký tự không hợp lệ" >&2
  exit 1
fi

# ── Load secrets từ file riêng (không hardcode) ──────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_FILE="${SECRETS_FILE:-$SCRIPT_DIR/secrets.env}"

if [[ ! -f "$SECRETS_FILE" ]]; then
  echo "[ERROR] Không tìm thấy file secrets: $SECRETS_FILE" >&2
  exit 1
fi

# Đọc secrets với quyền hạn chế
source "$SECRETS_FILE"  # Chứa SERVER_WS, SERVER_TARGET, SERVER_SECRET

# ── Tạo .env với quyền chỉ owner đọc được ────────────────────
umask 077
cat > .env <<EOF
SERVER_WS=${SERVER_WS:?Thiếu SERVER_WS}
SERVER_TARGET=${SERVER_TARGET:?Thiếu SERVER_TARGET}
SERVER_DOMAIN=${SERVER_DOMAIN_PREFIX:?Thiếu SERVER_DOMAIN_PREFIX}.${NAME}
SERVER_SECRET=${SERVER_SECRET:?Thiếu SERVER_SECRET}
SERVER_CONNECTION=${CONNECT}
EOF

# ── PATH an toàn ─────────────────────────────────────────────
export PATH="/user/bin:/user/local/bin:/bin"

# ── Vòng lặp có giới hạn restart và logging ──────────────────
MAX_RESTARTS=10
RESTART_COUNT=0
SLEEP_TIME=15

trap 'echo "[INFO] Đang thoát..."; rm -f .env; exit 0' SIGTERM SIGINT

while true; do
  echo "[INFO] $(date -u +%FT%TZ) - Khởi động node index.js (lần $((RESTART_COUNT+1)))"
  
  node index.js
  EXIT_CODE=$?

  echo "[WARN] $(date -u +%FT%TZ) - Process thoát với code $EXIT_CODE"

  RESTART_COUNT=$((RESTART_COUNT + 1))
  if [[ $RESTART_COUNT -ge $MAX_RESTARTS ]]; then
    echo "[ERROR] Đã restart $MAX_RESTARTS lần, dừng lại." >&2
    rm -f .env
    exit 1
  fi

  sleep "$SLEEP_TIME"
done
