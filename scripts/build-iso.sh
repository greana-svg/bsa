#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${HARDIK_WORK_DIR:-$HOME/hardik-os-work}"
JOBS="${HARDIK_BUILD_JOBS:-4}"

"$SCRIPT_DIR/check-build-host.sh" "$WORK_DIR"
[[ -f "$WORK_DIR/build/envsetup.sh" ]] || {
  echo "ERROR: Android-x86 source is missing at $WORK_DIR; run scripts/fetch-source.sh first." >&2
  exit 2
}

cd "$WORK_DIR"
# Android-x86's official build guide documents this x86_64 target and ISO goal.
# The generated artifact remains a stock upstream build until Hardik OS changes
# have been implemented, integrated, and independently tested.
source build/envsetup.sh
lunch android_x86_64-userdebug
m -j"$JOBS" iso_img

ISO_PATH="$WORK_DIR/out/target/product/android_x86_64/android_x86_64.iso"
if [[ -f "$ISO_PATH" ]]; then
  sha256sum "$ISO_PATH" | tee "$ISO_PATH.sha256"
  echo "ISO created at: $ISO_PATH"
else
  echo "ERROR: build returned without the expected ISO at $ISO_PATH." >&2
  exit 1
fi
