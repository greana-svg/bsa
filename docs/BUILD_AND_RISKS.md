# Hardik OS build guide and risk register

## Current result

This repository is a **starter kit**, not a forked or rebranded operating system. No Android-x86 repository was cloned, no APKs or proprietary components were downloaded, no Android image was built, and no ISO was booted. The Android-x86 OSDN manifest host did not resolve from the current network environment during a lightweight `git ls-remote` check. The provided `fetch-source.sh` keeps the source URL configurable; its upstream availability is not verified here.

The available task sandbox had 6 CPU cores, approximately 12 GB total RAM (about 10 GB available at inspection), no swap, and 39 GB free on its root filesystem. That is not a suitable full AOSP build host. Current AOSP workstation guidance specifies at least 400 GB free disk and 64 GB RAM.[1] Android-x86's own guide says its older `oreo-x86` source tree exceeded 20 GB and describes the `r-x86` Android 11 branch and x86_64 ISO build commands.[2] Do not lower the default build guard just to force a build on an undersized host.

## Preparation on a capable Linux machine

The intended initial base is the Android-x86 `r-x86` branch, which the upstream build page identifies as Android 11.[2] This choice remains provisional: test Chrome, Gmail, and Play Store against the actual resulting build before deciding whether the base meets the requirement. Do not silently switch to another operating-system fork or Android release without the user's approval.

Install the prerequisites from the current Android-x86 and AOSP instructions, including the Repo tool and the packages appropriate to the exact branch.[1][2] Copy this project to the build machine and run:

```bash
./scripts/check-build-host.sh "$HOME/hardik-os-work"
./scripts/fetch-source.sh
./scripts/build-iso.sh
```

The scripts default to 400 GiB free disk and 64 GiB available RAM. They support `HARDIK_WORK_DIR`, `HARDIK_MANIFEST_URL`, `HARDIK_ANDROID_X86_BRANCH`, `HARDIK_SYNC_JOBS`, and `HARDIK_BUILD_JOBS` overrides. Treat overrides as expert-only. An override changes the safety gate; it does not create resources or guarantee a build. The manifest URL has not been tested successfully in this session because its host could not be resolved.

The ISO script follows the upstream target (`android_x86_64-userdebug`) and `m iso_img` pattern.[2] If it succeeds, it prints a SHA-256 hash. An upstream ISO is not Hardik OS: all product customizations still need implementation, integration and tests.

## Safety boundaries

The included `config/grub.cfg` is a menu-text mockup only. Its entries deliberately perform no boot action. It is **not** a bootloader configuration and is not safe to install. This project has no UEFI installer, EFI boot-entry manager, Windows detection logic, disk partitioner, or tested Windows Boot Manager preservation. Do not point any draft command at a real disk. Before proposing installation, implement and test on disposable virtual disks with GPT/UEFI, an EFI System Partition, a mock Windows installation, and the exact supported layouts. Live mode must also be tested for zero writes to internal disks.

Secure Boot behavior has not been implemented. Any final design must document whether the kernel/boot chain is signed for Secure Boot or whether users must disable Secure Boot in firmware, and must test each supported path. No real-PC install instructions should be used until the installer is tested.

## Feature status

| Requested capability | Present in this starter kit | Verified status |
| --- | --- | --- |
| Hardik OS name and dark/cyan reference-inspired desktop concept | SVG wallpaper and static HTML mockup | Visual files included; not installed on Android |
| Android-x86 source checkout/build entry points | Configurable scripts and target settings | Syntax/resource gate can be checked; source fetch and ISO build not run |
| Live, safe-graphics, install, and debug entries | Placeholder labels in draft config | Not bootable; no implementation |
| Windows dual boot / UEFI EFI boot entry | None | Not implemented or tested |
| Google Play Services, Play Store, Gmail, Chrome | None | Not included or tested |
| F-Droid, BusyBox, file manager, terminal | None | Not included or tested |
| Root and root manager | None | Not implemented or tested |
| RAM Plus (zram + disk swap) | None | Not implemented or tested |
| ARM app translation | None | Not implemented or tested; no licensed bridge included |
| Hardik Keymapper | None | Not implemented or tested |
| Intel graphics, Wi-Fi, Bluetooth, audio, suspend, brightness | No kernel changes or hardware testing | Not implemented or tested |
| USB persistence | None | Not implemented or tested |
| ISO SHA-256 and real-device instructions | No ISO exists | Not available |

## Licensing and compatibility risks

Android-x86 identifies its codebase as Apache 2.0 with some components under GPL.[3] That does not grant rights to redistribute Google Play Services, Play Store, Gmail, Chrome, or proprietary ARM translation binaries. Obtain the applicable distribution rights or leave those components out; do not put proprietary APKs in a public repository or release ISO without authorization. Google Play certification/device registration and rooted-device behavior are also not validated here.

## References

[1] [Android Open Source Project — Meet hardware requirements](https://source.android.com/docs/setup/start/requirements).

[2] [Android-x86 — Source code and build instructions](https://www.android-x86.org/source.html).

[3] [Android-x86 — project homepage and license notes](https://www.android-x86.org/).
