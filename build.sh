#!/bin/sh
# Build 404 NOT FOUND OS. Run as root on a Debian host:  sudo ./build.sh
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root:  sudo ./build.sh" >&2
    exit 1
fi

if ! command -v lb >/dev/null 2>&1; then
    echo "live-build not found. Install it:  sudo apt install -y live-build" >&2
    exit 1
fi

echo "[*] Configuring (lb config)..."
lb config

echo "[*] Building ISO (lb build) — this takes a while..."
lb build

echo
echo "[+] Done. ISO(s) produced:"
ls -lh ./*.iso 2>/dev/null || echo "    (no .iso found — check build log above)"
