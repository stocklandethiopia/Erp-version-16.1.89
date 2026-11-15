#!/usr/bin/env bash
set -euo pipefail
cd /workspaces/stockland-erp
git config --global --add safe.directory "$PWD"
export STOCKLAND_DEV_RELEASE_MODE=approved-16.2.18
bash .devcontainer/post-create.sh
