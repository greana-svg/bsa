# Building the upstream Android-x86 base with GitHub Actions

## Why the default runner will not work

The workflow is intentionally pinned to the custom runner label `hardik-android-build`, not `ubuntu-latest`. Standard GitHub-hosted Linux jobs have 14 GB SSD; on private repositories the standard Linux runner is 2 CPUs and 8 GB RAM, and on public repositories it is 4 CPUs and 16 GB RAM.[1] These sizes are far below Android's published build workstation baseline of 400 GB free disk and 64 GB RAM.[2] A standard job should fail the resource guard before starting the Android source download.

A GitHub-hosted **larger runner** or an isolated self-hosted Linux x86_64 runner can be configured for the custom label. The 16-CPU/64-GB/600-GB Ubuntu larger-runner size meets the AOSP RAM and disk baseline on paper; the guard still checks *free* disk at runtime, because the runner image and reserved space reduce usable capacity.[3] A 32-CPU/128-GB/1,200-GB configuration provides more headroom but can cost more. GitHub larger runners are billed by runner-minute when workflows execute, and availability/pricing depends on the account and configuration.[4]

## Set up and run

1. Add this project to a GitHub repository and commit `.github/workflows/build-android-x86.yml`. Repository creation/push from this session was blocked by the connected account's `CreateRepository` permission; the source archive and Git bundle are supplied separately.
2. In GitHub, create or register a dedicated Ubuntu 24.04 x86_64 larger runner or self-hosted runner with at least **64 GB RAM** and **400 GB free disk before source sync**. Assign the runner label `hardik-android-build`. For a larger runner, configure the workflow to the runner group and label shown in that account's settings; the label in this file is a requested custom label, not an existing runner guaranteed by GitHub.
3. Make the runner disposable or dedicated, and do not allow untrusted pull-request code to run on it. Android build scripts execute code from a large external source tree. Do not expose repository secrets, cloud credentials, or access to internal networks to this job. The workflow is manually triggered and requests only `contents: read`.
4. Open **Actions → Build Android-x86 base ISO → Run workflow**. If the job passes its resource gate and the upstream manifest can be reached, it syncs the upstream `r-x86` branch and builds an Android-x86 `android_x86_64` ISO. The artifact is uploaded with a SHA-256 sidecar for 14 days; GitHub's default artifact retention is 90 days, but this workflow deliberately uses a shorter period.[5]

The resulting artifact is an **upstream Android-x86 base ISO**, not a completed Hardik OS. This workflow does not add the requested launcher/theme into Android, GApps, root, RAM Plus, ARM translation, keymapper, persistence, a Windows-safe installer, or a tested boot menu. It does not produce a verified end-user Hardik OS image.

## Known workflow limitations

The OSDN manifest host could not be resolved from the current sandbox during a lightweight reachability test. The action will fail at `repo init` if the endpoint remains unreachable; `HARDIK_MANIFEST_URL` can override the URL, but an alternative must be verified against the Android-x86 project before use.[6] The action has not been run on a suitable runner. The build's runtime, actual disk footprint, resulting file size, and artifact upload/download are therefore unverified.

Do not add release publishing or auto-release steps until a specific image has passed source provenance checks, build verification, license review, and boot/install tests. The GitHub artifact is temporary and is not a substitute for a signed release or approved redistribution of proprietary apps.

## References

[1] [GitHub Actions — GitHub-hosted runners reference](https://docs.github.com/en/actions/reference/runners/github-hosted-runners).

[2] [Android Open Source Project — Build hardware requirements](https://source.android.com/docs/setup/start/requirements).

[3] [GitHub Actions — Larger runner machine sizes](https://docs.github.com/en/actions/reference/runners/larger-runners).

[4] [GitHub Actions — Larger runners and billing](https://docs.github.com/en/actions/concepts/runners/larger-runners).

[5] [GitHub Actions — Downloading workflow artifacts](https://docs.github.com/en/actions/how-tos/manage-workflow-runs/download-workflow-artifacts).

[6] [Android-x86 — Source and build instructions](https://www.android-x86.org/source.html).
