#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO='https://github.com/aistockland-web/Erp-version-16.1.89.git'
BRANCH='delivery/stockland-full-erp-completion-2026-11-11'
COMMIT='fe937ea97123a243c410696e4007c48d3332803d'
TREE='f89615a764cc3ce391380bf31b9d75b7b9e55357'
SOURCE="$ROOT/canonical-source"
bash "$ROOT/.devcontainer/initialize-host.sh"
if [[ ! -d "$SOURCE/.git" ]]; then
  [[ ! -e "$SOURCE" ]] || { echo 'canonical-source exists but is not a Git repository; preserving it and refusing overwrite.' >&2; exit 1; }
  git clone --no-checkout "$REPO" "$SOURCE"
fi
ORIGIN="$(git -C "$SOURCE" remote get-url origin)"
[[ "$ORIGIN" == "$REPO" || "$ORIGIN" == 'https://github.com/aistockland-web/Erp-version-16.1.89' ]] || { echo "Unexpected source origin: $ORIGIN" >&2; exit 1; }
if [[ -n "$(git -C "$SOURCE" status --porcelain)" ]]; then
  echo 'canonical-source contains local changes. Preserve them and resolve before resetting to the pinned source.' >&2; exit 1
fi
git -C "$SOURCE" fetch --no-tags origin "$BRANCH"
git -C "$SOURCE" checkout --detach "$COMMIT"
ACTUAL_TREE="$(git -C "$SOURCE" rev-parse 'HEAD^{tree}')"
[[ "$ACTUAL_TREE" == "$TREE" ]] || { echo "Source tree mismatch: $ACTUAL_TREE" >&2; exit 1; }
if git -C "$SOURCE" show-ref --verify --quiet refs/heads/codex/stockland-final-integration; then
  git -C "$SOURCE" checkout codex/stockland-final-integration
else
  git -C "$SOURCE" checkout -b codex/stockland-final-integration "$COMMIT"
fi
cp "$ROOT/.devcontainer/.env" "$SOURCE/.devcontainer/.env"
chmod 600 "$SOURCE/.devcontainer/.env"
echo "PASS canonical Stockland source checked out at $COMMIT (tree $TREE)."
echo 'This creates a local Codespaces branch only; it does not push, merge or deploy.'
