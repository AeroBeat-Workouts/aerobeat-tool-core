# aerobeat-tool-core

Shared AeroBeat tool-side contracts for workflow DTOs, operation results, progress/diagnostic reporting, tool settings or persistence models, and tool workflow interfaces for package-oriented import/export/migration operations.

## Architecture role

`aerobeat-tool-core` is the shared contract home for the Tool lane. It gives concrete tool repos a stable place to share tool-common data shapes and interfaces without turning every tool concern into an app-specific implementation detail.

For the current downscoped v1 architecture, the likely contract categories here include:

- import, export, migration, and packaging request/response DTOs
- workflow or job result models
- progress, warning, error, and diagnostic report contracts
- tool settings, persistence, and local index/cache metadata models
- orchestration interfaces used by CLI, editor, and automation-facing tool workflows

## Intended consumers

Concrete `aerobeat-tool-*` repos should depend on `aerobeat-tool-core` when they need shared tool-side contracts.

That dependency should stay intentional rather than universal: tools should consume the specific tool-common DTOs and interfaces they actually use, while `aerobeat-content-core`, `aerobeat-feature-core`, and other lane repos remain separate sources of truth for their own domains.

## Repository boundaries

This repo intentionally does **not** own:

- canonical authored content schemas or ids
- shared structural content validation rules
- gameplay semantics, scoring, or runtime interpretation
- feature/runtime presentation contracts
- a blanket universal dependency that every AeroBeat repo must import

Those concerns belong in the appropriate content, feature, asset, UI, or concrete tool repos instead.

## Repository status

This repo is the canonical home for shared Tool-lane contracts in the downscoped AeroBeat v1 package/content/tool split. Keep the public surface focused on tool-common interfaces and report models, not on redefining content truth or absorbing runtime behavior.
