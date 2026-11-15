#!/usr/bin/env bash
# Prepare the pinned Stockland engineering toolchain. This intentionally does
# not run historical 16.2.13/16.2.15 candidate repair or materialization.
set -euo pipefail
cd /workspaces/stockland-erp

git config --global --add safe.directory "$PWD"
EXPECTED_COMMIT='fe937ea97123a243c410696e4007c48d3332803d'
EXPECTED_TREE='f89615a764cc3ce391380bf31b9d75b7b9e55357'
[[ "$(git rev-parse HEAD)" == "$EXPECTED_COMMIT" ]] || { echo 'Canonical source commit is not the pinned 16.2.18 base.' >&2; exit 1; }
[[ "$(git rev-parse 'HEAD^{tree}')" == "$EXPECTED_TREE" ]] || { echo 'Canonical source tree does not match the pinned tree.' >&2; exit 1; }

printf '%s\n' '=== Stockland exact-source Codespaces toolchain ==='
php --version
node --version
npm --version
python3 --version
composer --version
git --version
for extension in curl dom fileinfo json mbstring mysqli openssl pdo_mysql simplexml xml zip; do
  php -r "exit(extension_loaded('$extension') ? 0 : 1);" || { echo "Missing PHP extension: $extension" >&2; exit 1; }
done

if [[ -f ci/cssqa/package-lock.json ]]; then
  npm ci --prefix ci/cssqa --ignore-scripts --no-audit --no-fund
fi
if [[ -f ci/phpcs/composer.lock ]]; then
  composer validate --working-dir=ci/phpcs --strict
  composer install --working-dir=ci/phpcs --no-interaction --prefer-dist --no-progress
fi

if ! command -v wp >/dev/null 2>&1; then
  TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
  curl --fail --silent --show-error --location --retry 3 https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar --output "$TMP/wp-cli.phar"
  curl --fail --silent --show-error --location --retry 3 https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar.sha256 --output "$TMP/wp-cli.phar.sha256"
  EXPECTED="$(awk '{print $1}' "$TMP/wp-cli.phar.sha256")"
  ACTUAL="$(sha256sum "$TMP/wp-cli.phar" | awk '{print $1}')"
  [[ -n "$EXPECTED" && "$ACTUAL" == "$EXPECTED" ]] || { echo 'WP-CLI checksum mismatch; refusing installation.' >&2; exit 1; }
  php "$TMP/wp-cli.phar" --info >/dev/null
  sudo install -m 0755 "$TMP/wp-cli.phar" /usr/local/bin/wp
  rm -rf "$TMP"; trap - EXIT
fi
wp --info

mkdir -p artifacts/codespaces
if command -v codex >/dev/null 2>&1; then
  codex --version || true
else
  bash scripts/codespaces/bootstrap_codex.sh
fi

echo 'PASS pinned Stockland ERP 16.2.18 Codespaces toolchain prepared.'
echo 'Historical .13/.15 candidate flows were not run. No live credentials or business data were loaded.'
echo 'To verify the exact post-merge 16.2.18 artifact on disposable WordPress sites:'
echo '  bash /workspaces/stockland-workspace/codespaces/verify-exact-16.2.18.sh all'
echo 'To sign into local Codex CLI later: codex login --device-auth'
