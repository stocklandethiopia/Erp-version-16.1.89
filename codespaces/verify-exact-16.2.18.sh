#!/usr/bin/env bash
# Exact Actions artifact 14130879479 only; disposable Compose DBs only. No source rebuild.
set -euo pipefail
TARGET="${1:-all}"
case "$TARGET" in mariadb|mysql8|all) ;; *) echo 'Usage: verify-exact-16.2.18.sh [mariadb|mysql8|all]' >&2; exit 2;; esac
SOURCE=/workspaces/stockland-erp
HUB=/workspaces/stockland-workspace
RUN=43640339960
ARTIFACT=14130879479
OUTER_SHA=848101156d8410d36b0dcd1b29ca630784790785898c37d97589fae3e9aba96a
INNER_SHA=30b3f629e8303d0b30981f311f2f4d32499b012f21e1f44c7f237919aafc9916
MERGED=fe937ea97123a243c410696e4007c48d3332803d
MANIFEST=83a43bc0543ae45bfa9bdab52bbcd5c07b61aeb4
TREE=f89615a764cc3ce391380bf31b9d75b7b9e55357
TMP="$(mktemp -d /tmp/stockland-exact-16218.XXXXXX)"; trap 'rm -rf "$TMP"' EXIT
cd "$SOURCE"
[[ "$(git rev-parse "$MERGED^{tree}")" == "$TREE" && "$(git rev-parse "$MANIFEST^{tree}")" == "$TREE" ]]
gh auth status >/dev/null
GH_TOKEN_VALUE="$(gh auth token)"
URL="https://api.github.com/repos/aistockland-web/Erp-version-16.1.89/actions/artifacts/$ARTIFACT/zip"
DOWNLOAD_URL="$(curl --fail --silent --show-error --output /dev/null --write-out '%{redirect_url}' -H 'Accept: application/vnd.github+json' -H "Authorization: Bearer $GH_TOKEN_VALUE" -H 'X-GitHub-Api-Version: 2022-11-28' "$URL")"
unset GH_TOKEN_VALUE
[[ -n "$DOWNLOAD_URL" ]] || { echo 'GitHub Actions artifact URL missing' >&2; exit 1; }
curl --fail --silent --show-error --location --retry 3 "$DOWNLOAD_URL" -o "$TMP/outer.zip"
[[ "$(sha256sum "$TMP/outer.zip" | awk '{print $1}')" == "$OUTER_SHA" ]]
mkdir "$TMP/unpacked"; unzip -q "$TMP/outer.zip" -d "$TMP/unpacked"
ZIP="$TMP/unpacked/STOCKLAND_ERP_16.2.18_MASTER_WORDPRESS_INSTALLER.zip"
SIDECAR="$ZIP.sha256"
[[ -s "$ZIP" && -s "$SIDECAR" ]]
[[ "$(sha256sum "$ZIP" | awk '{print $1}')" == "$INNER_SHA" ]]
grep -Eq "^$INNER_SHA[[:space:]]+STOCKLAND_ERP_16.2.18_MASTER_WORDPRESS_INSTALLER.zip$" "$SIDECAR"
python3 "$HUB/codespaces/verify_installer_zip.py" "$ZIP"
wpq() {
 local dbhost="$1" dbname="$2" wppath="$3"; shift 3
 sudo -u www-data env HOME=/tmp PATH="$PATH" WORDPRESS_DB_HOST="$dbhost" WORDPRESS_DB_NAME="$dbname" WORDPRESS_DB_USER="$STOCKLAND_DEV_DB_USER" WORDPRESS_DB_PASSWORD="$STOCKLAND_DEV_DB_PASSWORD" STOCKLAND_DISPOSABLE_SITE=yes STOCKLAND_CODESPACES_COMPOSE=yes STOCKLAND_DISPOSABLE_DB_NAME="$dbname" STOCKLAND_DISPOSABLE_DB_HOST="$dbhost" wp --path="$wppath" "$@"
}
site() {
 local label="$1" host="$2" db="$3" path="$4" port="$5"
 case "$host" in mariadb:3306|mysql8:3306) ;; *) echo "Refusing unknown DB host $host" >&2; return 2;; esac
 [[ "$path" == /var/www/html/site-* ]]
 [[ "$(wpq "$host" "$db" "$path" config get DB_NAME)" == "$db" ]]
 [[ "$(wpq "$host" "$db" "$path" config get DB_HOST)" == "$host" ]]
 wpq "$host" "$db" "$path" db reset --yes
 local pass url
 pass="$(openssl rand -hex 18)"
 if [[ -n "${CODESPACE_NAME:-}" && -n "${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-}" ]]; then
   url="https://${CODESPACE_NAME}-$port.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
 else
   url="http://localhost:$port"
 fi
 wpq "$host" "$db" "$path" core install --url="$url" --title=Stockland-QA --admin_user=admin --admin_password="$pass" --admin_email=qa@example.com --skip-email
 unset pass
 sudo -u www-data rm -rf "$path/wp-content/plugins/stockland-erp-app"
 wpq "$host" "$db" "$path" --user=admin plugin install "$ZIP" --activate
 wpq "$host" "$db" "$path" --user=admin eval-file scripts/release/complete_baseline.php
 wpq "$host" "$db" "$path" --user=admin eval-file scripts/release/verify_master_installer.php
 sudo -u www-data env HOME=/tmp PATH="$PATH" WORDPRESS_DB_HOST="$host" WORDPRESS_DB_NAME="$db" WORDPRESS_DB_USER="$STOCKLAND_DEV_DB_USER" WORDPRESS_DB_PASSWORD="$STOCKLAND_DEV_DB_PASSWORD" STOCKLAND_DISPOSABLE_SITE=yes bash scripts/release/e2e/run_all.sh "$path"
 echo "PASS $label — exact package $INNER_SHA"
}
case "$TARGET" in
 mariadb) site 'MariaDB 10.11' mariadb:3306 "$STOCKLAND_DEV_DB_BASELINE" /var/www/html/site-baseline 8080;;
 mysql8) docker compose --env-file "$HUB/.devcontainer/.env" --project-directory "$HUB/.devcontainer" -f "$HUB/.devcontainer/docker-compose.yml" --profile mysql8 up -d mysql8 wordpress_mysql8; site 'MySQL 8.0.46' mysql8:3306 "$STOCKLAND_DEV_MYSQL8_DB_NAME" /var/www/html/site-mysql8 8082;;
 all)
   site 'MariaDB 10.11' mariadb:3306 "$STOCKLAND_DEV_DB_BASELINE" /var/www/html/site-baseline 8080
   docker compose --env-file "$HUB/.devcontainer/.env" --project-directory "$HUB/.devcontainer" -f "$HUB/.devcontainer/docker-compose.yml" --profile mysql8 up -d mysql8 wordpress_mysql8
   site 'MySQL 8.0.46' mysql8:3306 "$STOCKLAND_DEV_MYSQL8_DB_NAME" /var/www/html/site-mysql8 8082;;
esac
echo 'PASS: exact installer checked using synthetic data only; production untouched.'
