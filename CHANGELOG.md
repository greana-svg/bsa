# Changelog

## 0.1.0 — starter kit

- Established the **Hardik OS** name and an Android-desktop visual concept inspired by the user's supplied reference image.
- Added an original SVG wallpaper and an editable responsive HTML mockup.
- Added a conservative build-host resource gate, configurable Android-x86 source-fetch script, and ISO build entry point.
- Added starter x86_64 build settings and a non-functional GRUB menu concept.
- Documented source/build status, feature gaps, security boundaries, and proprietary-software licensing risks.
- Verified shell syntax, confirmed the build guard blocks the undersized environment, and rendered the static mockup preview in Chromium.
- **Not done:** Android-x86 source checkout, product rebranding in Android, APK integration, kernel/installer changes, ISO creation, VM boot, install testing, or real-hardware validation.

## 0.2.0 — GitHub Actions build path

- Added a manually triggered Android-x86 base ISO workflow for a custom, high-capacity runner; it checks resources, syncs upstream source, builds the x86_64 ISO, and uploads a SHA-256 sidecar.
- Added a manual manifest URL override while keeping the upstream-documented endpoint as the default; current OSDN DNS reachability remains unresolved.
- Added runner sizing, billing, security, artifact-download, and workflow limitations documentation.
- **Not done:** Workflow execution, source synchronization, ISO production, Hardik OS system integration, or boot/install testing.
