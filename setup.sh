#!/bin/sh
# POSIX-sh, OpenBSD/FreeBSD friendly

set -eu

# ---------- utils ----------
green() { printf '\033[1;32m%s\033[0m' "$*"; }
red()   { printf '\033[1;31m%s\033[0m' "$*"; }

log() { printf '%s %s\n' "$(green "[INFO]")" "$*"; }
die() { printf '%s %s\n' "$(red "[ERROR]")" "$*" >&2; exit 1; }

OS=$(uname -s 2>/dev/null || echo unknown)

# Privilege helper (prefer doas on BSD)
DOAS=''
if [ "$(id -u)" -ne 0 ]; then
  if command -v doas >/dev/null 2>&1; then
    DOAS='doas'
  else
    die "Need root privileges for package install. Install and configure 'doas' (BSD) to run this script as root."
  fi
fi

# ---------- packages ----------
PKGS_BASE="go git jq curl fzf ripgrep vim powerline-fonts"

install_pkg_obsd() {
  # Install each package independently so one failure doesn't abort all
  for p in $PKGS_BASE; do
    log "OpenBSD: installing $p ..."
    $DOAS pkg_add -I "$p" || die "Failed to install '$p' (OpenBSD)"
  done
}

install_pkg_fbsd() {
  # Ensure pkg is bootstrapped
  if ! command -v pkg >/dev/null 2>&1; then
    log "FreeBSD: bootstrapping pkg ..."
    $DOAS /usr/sbin/pkg bootstrap -fy || die "Failed to bootstrap pkg"
  fi
  log "FreeBSD: updating catalog ..."
  $DOAS pkg update -f || true
  for p in $PKGS_BASE; do
    log "FreeBSD: installing $p ..."
    $DOAS pkg install -y "$p" || die "Failed to install '$p' (FreeBSD)"
  done
}

case "$OS" in
  OpenBSD) log "Detected OpenBSD"; install_pkg_obsd ;;
  FreeBSD) log "Detected FreeBSD"; install_pkg_fbsd ;;
  *)       die "Unsupported OS: $OS (expected OpenBSD or FreeBSD)";;
esac

# ---------- Go tool (revive) ----------
# Ensure GOBIN and PATH so the binary ends up somewhere predictable
: "${GOBIN:=$HOME/go/bin}"
export GOBIN
mkdir -p "$GOBIN"

if ! command -v go >/dev/null 2>&1; then
  die "'go' not found in PATH after install. Ensure your shell PATH includes Go binaries."
fi

log "Installing revive (Go linter) ..."
if [ ! -x "$HOME/go/bin/revive" ]; then
  go install github.com/mgechev/revive@latest || die "Failed to install revive"
fi

# ---------- vimrc symlink ----------
SRC_VIMRC="$HOME/vimcore/.vimrc"
DST_VIMRC="$HOME/.vimrc"

if [ ! -f "$SRC_VIMRC" ] && [ ! -L "$SRC_VIMRC" ]; then
  die "Source vimrc not found at $SRC_VIMRC"
fi

# Backup existing file (if it's a regular file not pointing to SRC)
if [ -e "$DST_VIMRC" ] && [ ! -L "$DST_VIMRC" ]; then
  BAK="$DST_VIMRC.$(date +%Y%m%d_%H%M%S).bak"
  log "Backing up existing .vimrc to $BAK"
  mv "$DST_VIMRC" "$BAK"
fi

# Create/refresh symlink idempotently
if [ -L "$DST_VIMRC" ]; then
  # Replace only if target differs
  TGT=$(readlink "$DST_VIMRC" || true)
  if [ "$TGT" != "$SRC_VIMRC" ]; then
    log "Updating symlink $DST_VIMRC -> $SRC_VIMRC"
    rm -f "$DST_VIMRC"
    ln -s "$SRC_VIMRC" "$DST_VIMRC"
  fi
else
  log "Creating symlink $DST_VIMRC -> $SRC_VIMRC"
  ln -s "$SRC_VIMRC" "$DST_VIMRC"
fi

# ---------- vim-plug ----------
PLUG="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG" ]; then
  log "Installing vim-plug ..."
  # -fsS to fail fast and be quiet, -L to follow redirects
  curl -fsSL -o "$PLUG" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    || die "Failed to download vim-plug"
fi

# ---------- plugins ----------
log "Installing Vim plugins ..."
# --sync to wait, +qa to quit all; use headless if available
if command -v vim >/dev/null 2>&1; then
  vim +'PlugInstall --sync' +qa || die "Failed to install Vim plugins"
else
  die "vim not found after install"
fi

# ---------- undo dir ----------
mkdir -p "$HOME/.cache/vim/undo"

log "Setup complete. Vim + plugins configured; revive installed at: $(command -v revive || echo "$GOBIN/revive")"
