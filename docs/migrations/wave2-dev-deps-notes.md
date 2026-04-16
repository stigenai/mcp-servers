# qdrant-mcp Dependency Baseline Refresh — Migration Map

Tracks disposition of 8 dependency PRs from the archived `stigenai/qdrant-mcp` repo.
Parent issue: stigenai/mcp-servers#46 | Linear: STI-5

## Disposition

| Archived PR | Description | Disposition | mcp-servers Reference |
|---|---|---|---|
| qdrant-mcp#10 | actions/checkout 4→5 | **Resolved** — already at v6 | PRs #22, #29; v5→v6 fix in this PR |
| qdrant-mcp#4 | docker/build-push-action 5→6 | **Resolved** — already at v6 | Native in all workflows |
| qdrant-mcp#12 | Python 3.11-slim→3.14-slim | **Resolved** — base image at 3.14-alpine | PR #26 |
| qdrant-mcp#1 | peter-evans/create-pull-request 5→7 | **N/A** — action not used in mcp-servers | — |
| qdrant-mcp#5 | softprops/action-gh-release 1→2 | **N/A** — action not used in mcp-servers | — |
| qdrant-mcp#9 | codecov/codecov-action 4→5 | **N/A** — action not used in mcp-servers | — |
| qdrant-mcp#7 | Dev deps (pytest 7→8, pytest-asyncio, pytest-cov, pytest-mock, pytest-timeout) | **N/A** — mcp-servers uses unittest, not pytest; no qdrant server directory | — |
| qdrant-mcp#8 | Prod deps (fastapi, qdrant-client, sentence-transformers, etc. — 13 packages) | **Deferred** — qdrant-mcp code not yet ported as a server; deps will be picked up when qdrant server is added | — |

## Summary

- **3 resolved**: CI actions and Python base image already updated via dependabot and prior PRs
- **3 N/A**: Actions not used in mcp-servers workflows
- **1 N/A**: Dev dependencies for a codebase not present in mcp-servers
- **1 deferred**: Production dependencies — will be addressed when qdrant server is added to the monorepo

## Changes in this PR

- Fixed `actions/checkout@v5` → `@v6` inconsistency in `build-servers.yml` validate job (line 40)
