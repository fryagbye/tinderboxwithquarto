#!/bin/bash
# Automatically generated build & deployment wrapper.
# Enforces supply-chain safety rules.
# Note: Verification steps execute trusted project-defined script bodies.

# Enforce strict fail-closed safety (exit immediately on any error or pipeline failures)
# NOTE on trustedRaw: Raw custom block executions bypass normal error trapping and rely on this.
set -euo pipefail

# Secure absolute tool path resolution function that recursively resolves symlinks
resolve_tool() {
  local name="$1"
  local resolved=""
  
  if [[ "$name" = /* ]]; then
    resolved="$name"
  else
    resolved="$(command -v "$name" 2>/dev/null || true)"
  fi
  
  if [ -z "$resolved" ]; then
    return 1
  fi
  
  # Recursively resolve symlink
  local target="$resolved"
  local visited=""
  while [ -L "$target" ]; do
    if [[ "$visited" =~ "(^| )$target( |$)" ]]; then
      # Circular symlink detected
      return 1
    fi
    visited="$visited $target"
    local link_dest
    link_dest="$(readlink "$target")"
    if [[ "$link_dest" = /* ]]; then
      target="$link_dest"
    else
      target="$(dirname "$target")/$link_dest"
    fi
    target="$(cd "$(dirname "$target")" && pwd)/$(basename "$target")"
  done
  
  # Check if absolute path is fully executable and a regular file
  if [ ! -f "$target" ] || [ ! -x "$target" ]; then
    return 1
  fi
  
  # Validate target directory is a trusted system path and NOT in temp/writable areas
  if [[ "$target" =~ ^/tmp/ ]] || [[ "$target" =~ ^/var/tmp/ ]] || [[ "$target" =~ ^/Users/[^/]+/Desktop/ ]]; then
    printf "\x1b[1;31m✘ CRITICAL SECURITY ERROR: Resolved binary path %s is in an untrusted user directory.\n\x1b[0m" "$target" >&2
    return 1
  fi
  
  echo "$target"
  return 0
}

# Runtime Validation Gate: Strictly check package.json scripts for forbidden commands before execution
if [ -f package.json ] && [ ! -L package.json ]; then
  if ! command -v node >/dev/null 2>&1; then
    printf "\x1b[1;31m✘ CRITICAL SECURITY ERROR: Node.js is required to audit package.json scripts but is missing.\n\x1b[0m" >&2
    exit 1
  fi
  node -e '
    const fs = require("fs");
    try {
      const pkg = JSON.parse(fs.readFileSync("package.json", "utf8"));
      if (pkg.scripts) {
        for (const [name, body] of Object.entries(pkg.scripts)) {
          if (typeof body === "string") {
            if (/\b(npm|npx|pnpx|yarn)\b/.test(body) || /\b(pip|pip3|pipx)\b|python\s+-m\s+pip\b/.test(body) || /@latest\b/.test(body)) {
              console.error(`\x1b[1;31m✘ CRITICAL SECURITY ERROR: Prohibited command (npm, npx, pip, @latest) detected in package.json script "${name}": "${body}"\x1b[0m`);
              process.exit(1);
            }
          }
        }
      }
    } catch (e) {
      console.error("Failed to parse package.json: " + e.message);
      process.exit(1);
    }
  ' || exit 1
fi

printf "\x1b[1;35m[Antigravity Deployer] Starting verification & release...\x1b[0m\n"

# Resolve uv path securely (prefers /opt/homebrew/bin/uv or ~/.local/bin/uv)
UV_BIN="$(resolve_tool "/opt/homebrew/bin/uv" || resolve_tool "$HOME/.local/bin/uv" || resolve_tool "uv" || true)"
if [ -z "$UV_BIN" ]; then
  printf "\x1b[1;31m✘ Error: uv was not found at /opt/homebrew/bin/uv, ~/.local/bin/uv, or in PATH.\x1b[0m\n" >&2
  exit 1
fi

# 1. Reproducible clean install
printf "\x1b[1;34m[1/4] Running Clean Install...\x1b[0m\n"
"$UV_BIN" sync --locked || { printf "\x1b[1;31m✘ Clean install failed.\n\x1b[0m"; exit 1; }
# If package.json is present, also enforce Node.js toolchain clean install (for Firebase/Vercel)
if [ -f package.json ]; then
  printf "\x1b[1;34mRunning Node.js toolchain Clean Install...\x1b[0m\n"
  if [ ! -f pnpm-lock.yaml ]; then
    printf "\x1b[1;31m✘ Error: pnpm-lock.yaml is missing. Node.js toolchain must be locked.\x1b[0m\n" >&2
    exit 1
  fi
  "$PNPM_BIN" install --frozen-lockfile --ignore-scripts || { printf "\x1b[1;31m✘ Node.js toolchain clean install failed.\x1b[0m\n"; exit 1; }
fi


# 2. Code Linting
printf "\x1b[1;34m[2/4] Running Code Linting...\x1b[0m\n"
# [WARNING] Optional validation step "Lint check failed. Fix errors before deployment." is SKIPPED because no command is configured.
# Workstation guidelines recommend configuring tests and linters to prevent bad deployments.
#   No ruff configured in pyproject.toml
printf "\x1b[1;33m⚠ Skipped: Lint check failed. Fix errors before deployment. (no command configured).\n\x1b[0m" >&2
# To configure and enable this step, uncomment and edit the command below:
# "$UV_BIN" run --locked ruff check || { printf "\x1b[1;31m✘ Lint check failed. Fix errors before deployment.\n\x1b[0m"; exit 1; }

# 3. Unit Tests execution
printf "\x1b[1;34m[3/4] Running Unit Tests...\x1b[0m\n"
# [WARNING] Optional validation step "Test suite failed. Deployment cancelled." is SKIPPED because no command is configured.
# Workstation guidelines recommend configuring tests and linters to prevent bad deployments.
#   No pytest configured in pyproject.toml
printf "\x1b[1;33m⚠ Skipped: Test suite failed. Deployment cancelled. (no command configured).\n\x1b[0m" >&2
# To configure and enable this step, uncomment and edit the command below:
# "$UV_BIN" run --locked pytest || { printf "\x1b[1;31m✘ Test suite failed. Deployment cancelled.\n\x1b[0m"; exit 1; }

# 4. Compilation Build & Deploy
printf "\x1b[1;34m[4/4] Building and Deploying Application...\x1b[0m\n"
# [WARNING] Optional validation step "Application build failed." is SKIPPED because no command is configured.
# Workstation guidelines recommend configuring tests and linters to prevent bad deployments.
#   No compilation build needed for Python
printf "\x1b[1;33m⚠ Skipped: Application build failed. (no command configured).\n\x1b[0m" >&2
# To configure and enable this step, uncomment and edit the command below:
# # No build required || { printf "\x1b[1;31m✘ Application build failed.\n\x1b[0m"; exit 1; }
# [WARNING] Optional validation step "Deployment failed." is SKIPPED because no command is configured.
# Workstation guidelines recommend configuring tests and linters to prevent bad deployments.
#   No deploy command configured
printf "\x1b[1;33m⚠ Skipped: Deployment failed. (no command configured).\n\x1b[0m" >&2
# To configure and enable this step, uncomment and edit the command below:
# "$UV_BIN" run --locked deploy_script.py || { printf "\x1b[1;31m✘ Deployment failed.\n\x1b[0m"; exit 1; }

printf "\x1b[1;32m✔ Verification and deployment finished successfully!\x1b[0m\n"
