#!/usr/bin/env bash
# Retrieve the original post-merge GitHub Actions artifact and verify it in disposable WP sites only.
set -euo pipefail
TARGET="${1:-all}"
case "$TARGET" in mariadb|mysql8|all) ;; *) echo 'Usage: verify-exact-16.2.18.sh [mariadb|mysql8|all]' >&2; exit 2;; esac
SOURCE=/workspaces/stockland-erp
HUB=/workspaces/stockland-workspace
RUN_ID=43649406224
ARTIFACT_ID=14134844691
OUTER_SHA=561c3e351c255ea59b29db54bf61e8e8e142434a7bcb6463a25b37db2e1e7c5c
INNER_SHA=4a6bb09b4f5819873fff7f1417de20494c7d791003faf9a55649458458977021
INNER_BYTES=2254042
SOURCE_COMMIT=fe937ea97123a243c410696e4007c48d3332803d
TREE=f89615a764cc3ce391380bf31b9d75b7b9e55357
TMP="$(mktemp -d /tmp/stockland-16218.XXXXXX)"; trap 'rm -rf "$TMP"' EXIT
cd "$SOURCE"
[[ "$(git rev-parse HEAD)" == "$SOURCE_COMMIT" ]]
[[ "$(git rev-parse 'HEAD^{tree}')" == "$TREE" ]]
gh auth status >/dev/null
[[ "$(gh api "repos/aistockland-web/Erp-version-16.1.89/commits/$SOURCE_COMMIT" --jq '.commit.tree.sha')" == "$TREE" ]]
TOKEN="$(gh auth token)"
API_URL="https://api.github.com/repos/aistockland-web/Erp-version-16.1.89/actions/artifacts/$ARTIFACT_ID/zip"
DOWNLOAD_URL="$(curl --fail --silent --show-error --output /dev/null --write-out '%{redirect_url}' -H 'Accept: application/vnd.github+json' -H "Authorization: Bearer $TOKEN" -H 'X-GitHub-Api-Version: 2022-11-28' "$API_URL")"
unset TOKEN
[[ -n "$DOWNLOAD_URL" ]]
OUTER="$TMP/actions-artifact.zip"
curl --fail --silent --show-error --location --retry 3 "$DOWNLOAD_URL" --output "$OUTER"
[[ "$(sha256sum "$OUTER" | awk '{print $1}')" == "$OUTER_SHA" ]]
python3 - "$OUTER" <<'PY'
import pathlib,sys,zipfile
with zipfile.ZipFile(sys.argv[1]) as z:
 n=z.namelist()
 if len(n)!=len(set(n)): raise SystemExit("FAIL outer artifact duplicate paths")
 for x in n:
  p=pathlib.PurePosixPath(x)
  if not x or p.is_absolute() or "\\" in x or any(a in ("",".","..") for a in p.parts): raise SystemExit("FAIL unsafe outer path "+x)
 if z.testzip(): raise SystemExit("FAIL outer ZIP CRC")
PY
mkdir "$TMP/unpacked"; unzip -q "$OUTER" -d "$TMP/unpacked"
ZIP="$TMP/unpacked/STOCKLAND_ERP_16.2.18_MASTER_WORDPRESS_INSTALLER.zip"
SIDECAR="$ZIP.sha256"
[[ -s "$ZIP" && -s "$SIDECAR" ]]
[[ "$(stat -c %s "$ZIP")" == "$INNER_BYTES" ]]
[[ "$(sha256sum "$ZIP" | awk '{print $1}')" == "$INNER_SHA" ]]
grep -Eq "^$INNER_SHA[[:space:]]+STOCKLAND_ERP_16.2.18_MASTER_WORDPRESS_INSTALLER.zip$" "$SIDECAR"
python3 "$HUB/codespaces/verify_installer_zip.py" "$ZIP"
wpqa() {
 local host="$1" db="$2" path="$3"; shift 3
 sudo -u www-data env HOME=/tmp PATH="$PATH" WORDPRESS_DB_HOST="$host" WORDPRESS_DB_NAME="$db" WORDPRESS_DB_USER="$STOCKLAND_DEV_DB_USER" WORDPRESS_DB_PASSWORD="$STOCKLAND_DEV_DB_PASSWORD" STOCKLAND_DISPOSABLE_SITE=yes STOCKLAND_CODESPACES_COMPOSE=yes STOCKLAND_DISPOSABLE_DB_NAME="$db" STOCKLAND_DISPOSABLE_DB_HOST="$host" wp --path="$path" "$@"
}
verify_site() {
 local label="$1" host="$2" db="$3" path="$4"
 case "$host" in mariadb:3306|mysql8:3306) ;; *) echo "Refusing unknown DB host $host" >&2; return 2;; esac
 [[ "$path" == /var/www/html/site-* ]]
 [[ "$(wpqa "$host" "$db" "$path" config get DB_NAME)" == "$db" ]]
 [[ "$(wpqa "$host" "$db" "$path" config get DB_HOST)" == "$host" ]]
 wpqa "$host" "$db" "$path" db reset --yes
 local pass; pass="$(openssl rand -hex 18)"
 wpqa "$host" "$db" "$path" core install --url=http://localhost --title=Stockland-QA --admin_user=admin --admin_password="$pass" --admin_email=qa@example.com --skip-email
 unset pass
 sudo -u www-data rm -rf "$path/wp-content/plugins/stockland-erp-app"
 wpqa "$host" "$db" "$path" --user=admin plugin install "$ZIP" --activate
 wpqa "$host" "$db" "$path" --user=admin eval-file scripts/release/complete_baseline.php
 wpqa "$host" "$db" "$path" --user=admin eval-file scripts/release/verify_master_installer.php
 sudo -u www-data env HOME=/tmp PATH="$PATH" WORDPRESS_DB_HOST="$host" WORDPRESS_DB_NAME="$db" WORDPRESS_DB_USER="$STOCKLAND_DEV_DB_USER" WORDPRESS_DB_PASSWORD="$STOCKLAND_DEV_DB_PASSWORD" STOCKLAND_DISPOSABLE_SITE=yes bash scripts/release/e2e/run_all.sh "$path"
 echo "PASS $label exact installer SHA $INNER_SHA"
}
case "$TARGET" in
 mariadb) verify_site 'MariaDB 10.11' mariadb:3306 "$STOCKLAND_DEV_DB_BASELINE" /var/www/html/site-baseline ;;
 mysql8)
  docker compose --env-file "$HUB/.devcontainer/.env" --project-directory "$HUB/.devcontainer" -f "$HUB/.devcontainer/docker-compose.yml" --profile mysql8 up -d mysql8 wordpress_mysql8
  verify_site 'MySQL 8.0.46' mysql8:3306 "$STOCKLAND_DEV_MYSQL8_DB_NAME" /var/www/html/site-mysql8 ;;
 all)
  verify_site 'MariaDB 10.11' mariadb:3306 "$STOCKLAND_DEV_DB_BASELINE" /var/www/html/site-baseline
  docker compose --env-file "$HUB/.devcontainer/.env" --project-directory "$HUB/.devcontainer" -f "$HUB/.devcontainer/docker-compose.yml" --profile mysql8 up -d mysql8 wordpress_mysql8
  verify_site 'MySQL 8.0.46' mysql8:3306 "$STOCKLAND_DEV_MYSQL8_DB_NAME" /var/www/html/site-mysql8 ;;
esac
echo 'PASS exact post-merge 16.2.18 Actions artifact verified; synthetic data only; production untouched.'
