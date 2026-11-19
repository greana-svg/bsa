#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${HARDIK_WORK_DIR:-$HOME/hardik-os-work}"
BRANCH="${HARDIK_ANDROID_X86_BRANCH:-r-x86}"
# The official Android-x86 guide lists the OSDN manifest endpoint. Network
# availability is environment-dependent; override this variable if the
# upstream endpoint has moved or your host cannot resolve it.
REPO_URL="${HARDIK_MANIFEST_URL:-https://git.osdn.net/gitroot/android-x86/manifest}"
JOBS="${HARDIK_SYNC_JOBS:-4}"

"$SCRIPT_DIR/check-build-host.sh" "$WORK_DIR"
command -v repo >/dev/null || { echo "ERROR: install the official Android Repo launcher first." >&2; exit 127; }
command -v git >/dev/null || { echo "ERROR: git is required." >&2; exit 127; }

if [[ -e "$WORK_DIR/.repo" ]]; then
  echo "Existing Repo checkout found at $WORK_DIR; syncing branch $BRANCH."
  cd "$WORK_DIR"
  repo sync --current-branch --no-tags --no-clone-bundle -j"$JOBS"
else
  mkdir -p "$WORK_DIR"
  cd "$WORK_DIR"
  repo init -u "$REPO_URL" -b "$BRANCH"
  repo sync --current-branch --no-tags --no-clone-bundle -j"$JOBS"
fi

echo "Source sync completed. Verify repo status before modifying anything."
