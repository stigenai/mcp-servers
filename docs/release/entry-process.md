# Release Entry Process

Use this process for each merged PR that changes server behavior, images, or registry metadata.

## When to add an entry

Add a changelog entry for:
- changes to `servers/registry.json`
- server `config.yml` changes (version, env, resources)
- Dockerfile/build logic updates
- workflow changes that affect build/publish/release behavior

Skip changelog entries for:
- typo-only docs fixes
- refactors with no observable behavior change

## How to add an entry

1. Open `CHANGELOG.md`
2. Add a bullet under `## [Unreleased]` in one section:
   - `Added`, `Changed`, `Fixed`, `Removed`, `Security`
3. Keep entries short and user-facing
4. Include PR or issue reference when useful (e.g. `(#39)`)

## Breaking changes

For breaking changes:
- place under `Changed` with `**BREAKING:**` prefix
- include migration note in the same bullet

## During release cut

1. Move `Unreleased` entries into a dated version section
2. Reset `Unreleased` to empty headings
3. Update compare links at the bottom
