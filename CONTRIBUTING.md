# Contributing

## Dependency PR Triage Policy

This repository keeps dependency updates small and continuously mergeable.

### Goals

- Keep open dependency PR backlog below **5**
- Prioritize security and CI safety updates
- Avoid parallel overlapping bumps for the same dependency lane

### Update lanes

Dependabot PRs are triaged by lane labels:

- `lane:deps-ci` / `risk:ci-only` — GitHub Actions and CI-only updates
- `lane:deps-runtime` / `risk:runtime` — npm runtime updates
- `lane:deps-base-image` / `risk:base-image` — Docker base image updates

### Review cadence

- Review dependency PRs **3x per week** (Mon/Wed/Fri)
- Merge low-risk lanes (`ci-only`, patch/minor runtime) in batches
- Require explicit review for major or base-image shifts

### Overlap and supersede rules

When Dependabot opens overlapping PRs:

1. Keep the newest PR per dependency lane
2. Close older superseded PRs with a short reason
3. If changes conflict, rebase only the newest PR and close the rest

### Merge policy

A dependency PR is merge-ready when:

1. CI is green
2. Required review is present for its risk lane
3. Changelog entry is added when user-visible/runtime behavior changes

### Changelog requirement

If a dependency update changes runtime behavior, registry output, or image behavior,
add an `Unreleased` entry in [`CHANGELOG.md`](CHANGELOG.md).
