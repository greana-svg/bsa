#!/usr/bin/env bash
set -euo pipefail

# Conservative defaults based on current AOSP workstation guidance.
# Override only if you understand the resource/time risk for your chosen branch.
MIN_DISK_GB="${HARDIK_MIN_DISK_GB:-400}"
MIN_RAM_GB="${HARDIK_MIN_RAM_GB:-64}"
ROOT_DIR="${1:-$HOME/hardik-os-work}"

if ! [[ "$MIN_DISK_GB" =~ ^[0-9]+$ && "$MIN_RAM_GB" =~ ^[0-9]+$ ]]; then
  echo "ERROR: HARDIK_MIN_DISK_GB and HARDIK_MIN_RAM_GB must be whole numbers." >&2
  exit 2
fi

mkdir -p "$ROOT_DIR"
read -r disk_kb _ < <(df -Pk "$ROOT_DIR" | awk 'NR == 2 {print $4, $2}')
mem_kb="$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)"
disk_gb=$((disk_kb / 1024 / 1024))
mem_gb=$((mem_kb / 1024 / 1024))

printf 'Hardik OS build-host check\n'
printf '  Available disk: %s GiB (minimum gate: %s GiB)\n' "$disk_gb" "$MIN_DISK_GB"
printf '  Available RAM:  %s GiB (minimum gate: %s GiB)\n' "$mem_gb" "$MIN_RAM_GB"
printf '  Source branch:  Android-x86 r-x86 (Android 11, per project docs)\n'

failed=0
if (( disk_gb < MIN_DISK_GB )); then
  echo "ERROR: insufficient free disk for a guarded Android platform build." >&2
  failed=1
fi
if (( mem_gb < MIN_RAM_GB )); then
  echo "ERROR: insufficient available RAM for a guarded Android platform build." >&2
  failed=1
fi
if (( failed )); then
  echo "No source checkout or build was started. Use a larger, persistent Linux build host." >&2
  exit 1
fi

echo "Resource gate passed. This does not guarantee a successful build or a bootable ISO."
