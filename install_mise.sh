#!/usr/bin/env bash
# Entry point for a fresh Mac. Installs mise and fetches this repo.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/HardDie/My_macos_settings/main/install_mise.sh | bash
set -euo pipefail

REPO="HardDie/My_macos_settings"
BRANCH="main"
DEST="$PWD/My_macos_settings"
MISE="$HOME/.local/bin/mise"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS only." >&2
  exit 1
fi

# 1. mise
if [[ -x "$MISE" ]]; then
  log "mise already installed: $("$MISE" --version)"
else
  log "Installing mise into $HOME/.local/bin"
  curl -fsSL https://mise.run | sh
  log "Ignore the 'mise activate' hint above: this setup uses shims, no prompt hook."
fi

# 2. Repo (tarball, git is not available yet)
if [[ -d "$DEST" ]]; then
  log "Repo folder exists, skipping download: $DEST"
else
  log "Downloading $REPO ($BRANCH) into $DEST"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" \
    | tar -xz -C "$tmp"
  mv "$tmp/My_macos_settings-$BRANCH" "$DEST"
fi

# 3. Trust the repo config so mise can run its tasks
log "Trusting $DEST/mise.toml"
"$MISE" trust "$DEST/mise.toml"

# 4. Ask before bootstrap
cat <<EOF

Next step: mise run bootstrap
  1. Install Homebrew (asks for your password; brings Xcode CLT and git).
  2. Turn $DEST into a git clone of $REPO.

EOF

answer=""
# stdin is the curl pipe, so ask via the terminal; skip if there is none.
if (: </dev/tty) 2>/dev/null; then
  read -r -p "Run it now? [y/N] " answer </dev/tty || true
fi

if [[ "$answer" =~ ^[Yy]$ ]]; then
  cd "$DEST"
  exec "$MISE" run bootstrap
fi

cat <<EOF
Skipped. Run it later with:
  cd "$DEST" && ~/.local/bin/mise run bootstrap
EOF
