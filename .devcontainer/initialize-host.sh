#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_ENV="$ROOT/.env"; CONTAINER_ENV="$ROOT/.devcontainer/.env"
if [[ -f "$ROOT_ENV" && -f "$CONTAINER_ENV" ]] && ! cmp -s "$ROOT_ENV" "$CONTAINER_ENV"; then
  echo 'Root and .devcontainer credentials differ; refusing to guess.' >&2; exit 1
fi
SOURCE=""
if [[ -f "$ROOT_ENV" ]]; then SOURCE="$ROOT_ENV"; elif [[ -f "$CONTAINER_ENV" ]]; then SOURCE="$CONTAINER_ENV"; else
  umask 077; TMP="$(mktemp "$ROOT/.env.codespaces.XXXXXX")"; trap 'rm -f "$TMP"' EXIT
  python3 - <<'PYINNER' > "$TMP"
import secrets
print('STOCKLAND_DEV_DB_ROOT_PASSWORD='+secrets.token_hex(32))
print('STOCKLAND_DEV_DB_PASSWORD='+secrets.token_hex(32))
print('STOCKLAND_DEV_WP_ADMIN_PASSWORD='+secrets.token_urlsafe(36))
PYINNER
  chmod 600 "$TMP"; mv "$TMP" "$ROOT_ENV"; trap - EXIT; SOURCE="$ROOT_ENV"
fi
mkdir -p "$(dirname "$CONTAINER_ENV")"
[[ "$SOURCE" == "$ROOT_ENV" ]] || cp "$SOURCE" "$ROOT_ENV"
[[ "$SOURCE" == "$CONTAINER_ENV" ]] || cp "$SOURCE" "$CONTAINER_ENV"
chmod 600 "$ROOT_ENV" "$CONTAINER_ENV"
for KEY in STOCKLAND_DEV_DB_ROOT_PASSWORD STOCKLAND_DEV_DB_PASSWORD STOCKLAND_DEV_WP_ADMIN_PASSWORD; do grep -q "^$KEY=." "$ROOT_ENV" || { echo "Missing $KEY" >&2; exit 1; }; done
echo 'Created/reused random local-only disposable QA credentials; values are not printed.'
