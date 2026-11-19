# Test report

## Environment and safe-build gate

The shell scripts passed `bash -n`. The resource-check script was executed against the available build workspace and exited with the expected refusal status (`1`): at that run it reported 38 GiB available disk against the 400 GiB guard and 15 GiB available RAM against the 64 GiB guard. It did not start a source checkout or build.

The environment inventory earlier in the task showed 6 CPU cores, approximately 12 GB total RAM, no swap, and 39 GB free disk. Resource availability can vary; both observed results are below the guard and not sufficient to proceed safely.

## Visual concept

The static HTML mockup loaded in Chromium and produced `design/hardik-desktop-preview.webp`. It follows the supplied reference's charcoal/navy desktop, translucent panels, cyan/teal accents, movable-window visual language, calendar and system monitor widgets, file manager, and bottom app dock. This checks only the rendering of the standalone HTML mockup; it is **not** a screenshot of Android, a virtual machine, or a booted OS.

## Source availability

A lightweight `git ls-remote` check against the Android-x86 project's OSDN manifest URL could not resolve `git.osdn.net` in this environment. The source was not downloaded. The fetch script has an environment variable to replace the manifest URL on a capable build host, but the endpoint and branch have not been validated in this session.

## Not tested

No ISO was produced, no QEMU/OVMF or real hardware boot was performed, and no installer or fake-Windows dual-boot test was performed. Root, Google services, certification, ARM-only apps, keymapping, RAM Plus, persistence, hardware drivers, Secure Boot, and actual live-media disk isolation are all unbuilt and untested. Do not treat them as working features.

## GitHub publishing

The GitHub CLI is authenticated for the user's account, but both available credentials returned an authorization error for repository creation (`CreateRepository`). A lookup found no existing repository named `hardik-os`. No remote was created and no push occurred; the starter kit is being delivered as a local source archive instead.

## GitHub Actions workflow

The new workflow YAML parsed successfully, and its manual trigger, read-only repository permission, custom high-capacity runner label, resource gate, source sync, ISO build, and artifact upload were structurally checked. The workflow has not been run. A lightweight Git query confirmed the Android-x86 GitHub mirror's `r-x86` manifest branch exists, but it is not identified as the project's official source endpoint in the Android-x86 build instructions; the workflow therefore keeps the upstream-documented OSDN URL as its default and allows an operator-supplied verified URL. Both OSDN hostnames tested from this sandbox failed DNS resolution.
