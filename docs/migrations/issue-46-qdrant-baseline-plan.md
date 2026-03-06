# Issue #46 Migration Plan — qdrant-mcp dependency baseline refresh

Source issue: https://github.com/stigenai/mcp-servers/issues/46

## Objective
Recreate archived dependency/security updates from `stigenai/qdrant-mcp` in active repo `stigenai/mcp-servers` using risk-based waves, with explicit test and rollback gates.

## Archived PR Inputs (ledger)
| Archived PR | Scope | Planned destination |
|---|---|---|
| qdrant-mcp#10 | `actions/checkout` v4 → v5 | Wave 1 PR |
| qdrant-mcp#9 | `codecov-action` v4 → v5 | Wave 1 PR |
| qdrant-mcp#5 | `softprops/action-gh-release` v1 → v2 | Wave 1 PR |
| qdrant-mcp#4 | `docker/build-push-action` v5 → v6 | Wave 1 PR |
| qdrant-mcp#1 | `peter-evans/create-pull-request` v5 → v7 | Wave 1 PR |
| qdrant-mcp#7 | Dev/test dependency group updates | Wave 2 PR |
| qdrant-mcp#8 | Production dependency group updates | Wave 3 PR-A |
| qdrant-mcp#12 | Python runtime/base image jump 3.11 → 3.14 | Wave 3 PR-B |

## Execution Plan

### Wave 1 (low risk): CI workflow updates
**Goal:** land action-version updates with no runtime changes.

**Implementation**
- Update GitHub Actions versions in workflow files.
- Keep this wave isolated to `.github/workflows/**` and automation config only.

**Validation gates**
- Workflow lint (if present).
- Full repo CI must pass on PR.
- Confirm release workflow dry path still resolves action inputs.

**Rollback gate**
- Revert single Wave 1 PR commit set (no data/runtime migration required).

---

### Wave 2 (medium risk): dev/test dependencies
**Goal:** refresh test/development dependencies while preserving current runtime behavior.

**Implementation**
- Update test/dev dependencies in package manifests and lockfiles.
- Address test harness breakages with minimal code changes.

**Validation gates**
- Unit tests pass.
- Lint/typecheck pass.
- Any snapshot/test-fixture deltas are reviewed and documented.

**Rollback gate**
- Revert Wave 2 PR.
- Restore previous lockfile + dependency pins.

---

### Wave 3 (high risk): production deps + runtime jump
Split to reduce blast radius.

#### Wave 3 PR-A: production dependency updates
**Validation gates**
- Full CI green.
- Integration tests green.
- Container smoke tests green.
- Dependency/security scan parity check (no unexpected critical increase).

**Rollback gate**
- Revert PR-A and redeploy prior image tag.
- Keep previous production lock/pins documented in PR notes.

#### Wave 3 PR-B: Python base/runtime 3.11 → 3.14
**Validation gates**
- Build image on new base and run server startup smoke tests.
- Integration tests on both old and new runtime where feasible.
- Verify compatibility for transitive native modules.
- Benchmark startup/health-check behavior for regressions.

**Rollback gate**
- Revert runtime bump PR.
- Rebuild/publish image from last known-good 3.11 baseline.
- Keep dual-version Dockerfile patch ready until rollout confidence is established.

## PR Ownership Matrix (per issue policy)
- DRI: `@nixfleet-axel[bot]` (fallback `@zach-source`)
- Security reviewer: Quinn
- Product/release comms: Marcus
- Final approver: ztaylor@stigen.ai

## Branching + PR sequence
1. `chore/46-wave1-workflow-actions`
2. `chore/46-wave2-devtest-deps`
3. `chore/46-wave3a-prod-deps`
4. `chore/46-wave3b-python314-runtime`

## Completion Ledger (to be updated in issue #46)
- [ ] Wave 1 PR linked
- [ ] Wave 2 PR linked
- [ ] Wave 3 PR-A linked
- [ ] Wave 3 PR-B linked
- [ ] Archived PR mapping completed (all 8 inputs dispositioned)
