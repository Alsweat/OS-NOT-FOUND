#!/bin/sh
# Build 404 NOT FOUND OS into an ISO using Docker — works on Linux, macOS,
# or Windows (WSL2) as long as Docker is installed and running.
#
#   ./docker-build.sh
#
# Output: ./out/404-not-found-os-amd64.iso
set -e

if ! command -v docker >/dev/null 2>&1; then
    echo "Docker not found. Install Docker Desktop (mac/win) or docker.io (linux)." >&2
    exit 1
fi

echo "[*] Building the builder image..."
docker build -t notfoundos-builder .

mkdir -p out

echo "[*] Running the ISO build (this takes 30-60 min, downloads packages)..."
# --privileged is required: live-build uses chroot/mount/loop devices.
docker run --rm --privileged -v "$(pwd)/out:/out" notfoundos-builder

# normalize the name
iso=$(ls out/*.iso 2>/dev/null | head -1 || true)
if [ -n "$iso" ] && [ "$iso" != "out/404-not-found-os-amd64.iso" ]; then
    mv "$iso" out/404-not-found-os-amd64.iso
fi

echo
echo "[+] Done:"
ls -lh out/*.iso 2>/dev/null || echo "    (no ISO produced — check the log above)"
echo
echo "Flash to USB (Linux):  sudo dd if=out/404-not-found-os-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync"
echo "Or boot it in a VM (VirtualBox / QEMU / GNOME Boxes) to test first."
