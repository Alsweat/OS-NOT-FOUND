# 404 NOT FOUND OS — build a bootable pentest ISO

A custom **Debian live ISO** for authorized penetration testing (Parrot-style
dark MATE desktop, Tor/anonsurf, a curated open-source security toolset). Built
with `live-build` — the same toolchain Kali and Parrot OS use.

> ⚠️ **Why there's no ready-made `.iso` in this download:** a finished ISO is
> 2–4 GB and must be built with root privileges (chroot/loop devices), so it
> can't be produced or sent through a chat. Instead this kit builds the ISO
> **for you** in one step. Pick a path below.
>
> ⚠️ **Legal/ethical use only.** Use these tools only on systems you own or are
> explicitly authorized in writing to test.

---

## Fastest: build in the cloud, download from your browser (no Linux needed)

Uses **GitHub Actions** — free, runs on GitHub's servers, gives you a
downloadable ISO.

1. Create a new **GitHub repo** (private is fine).
2. Upload this whole folder to it (drag-and-drop in the GitHub web UI, or
   `git push`). Make sure the `.github/` folder is included.
3. In the repo: **Actions** tab → **Build ISO** → **Run workflow**.
4. Wait ~30–60 min. When the run is green, open it and download the
   **`parrot-404-iso`** artifact (a `.zip` with the `.iso` inside).
   - Bonus: push a tag (`git tag v1.0 && git push --tags`) and it also
     attaches the ISO to a **GitHub Release**.

That's the closest thing to "click and download the finished ISO."

---

## Local: build with Docker (one command, any OS)

Needs Docker Desktop (macOS/Windows) or `docker.io` (Linux).

```bash
./docker-build.sh
```

Output: `./out/404-not-found-os-amd64.iso` (~30–60 min; downloads packages).

---

## Native: build on a Debian host

Debian 12/13, root, ~25 GB free:

```bash
sudo apt update && sudo apt install -y live-build
sudo ./build.sh
```

Output: `live-image-amd64.hybrid.iso`.

---

## After you have the ISO

**Boot it in a VM first** (VirtualBox / QEMU / GNOME Boxes) to check it, then
flash to USB:

```bash
# Linux — DOUBLE-CHECK the device with lsblk first!
sudo dd if=404-not-found-os-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

On Windows/macOS use **balenaEtcher** or **Rufus** to write the ISO to USB.

**Default login (live session):** user `ghost` / password `toor` (root `toor`).
Change these in `auto/config` before any real use.

---

## What's inside

| Area | Tools |
|------|-------|
| Recon | nmap, masscan, dnsenum, theharvester, recon-ng, amass, netdiscover |
| Web | burpsuite*, zaproxy, sqlmap, wpscan, ffuf, gobuster, dirb, nikto, whatweb |
| Passwords | john, hashcat, hydra, medusa, crunch, cewl |
| Wireless | aircrack-ng, kismet, reaver, wifite, bettercap, macchanger |
| Exploitation | metasploit*, exploitdb (searchsploit), set*, beef* |
| Sniffing | wireshark, tcpdump, ettercap, responder, mitmproxy, dsniff |
| Reversing | radare2, gdb, ghidra*, apktool, binwalk |
| Forensics | autopsy, sleuthkit, foremost, exiftool |
| Anonymity | tor, torsocks, proxychains4, macchanger |

`*` not in plain Debian repos. The package list installs everything that *is*
in Debian; to add metasploit/ghidra/beef/anonsurf, enable the Kali repo (see
below) or install them after first boot.

## Customize

- **Tools:** edit `config/package-lists/pentest.list.chroot` (one package per
  line), then rebuild.
- **Branding:** `config/includes.chroot/etc/os-release`, `/etc/motd`, and the
  greeter in `config/hooks/live/0100-branding.hook.chroot`.
- **Desktop:** XFCE/MATE metapackage in the package list — swap as you like.
- **Kali-packaged tools:** add Kali's repo + key via a `config/archives/` entry
  and uncomment the lines at the bottom of the package list. Mixing Debian +
  Kali needs apt pinning — do it only if you're comfortable with that.

## Project layout

```
.
├── .github/workflows/build-iso.yml   # cloud build → downloadable ISO
├── Dockerfile                         # local Docker build
├── docker-build.sh                    # one-command Docker build
├── build.sh                           # native Debian build
├── auto/config                        # live-build configuration
└── config/
    ├── package-lists/pentest.list.chroot
    ├── hooks/live/0100-branding.hook.chroot
    └── includes.chroot/etc/{os-release,motd}
```
