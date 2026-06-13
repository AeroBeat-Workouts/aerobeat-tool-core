# aerobeat-tool-core

Shared AeroBeat tool-side contracts for workflow DTOs, operation results, progress/diagnostic reporting, tool settings or persistence models, and tool workflow interfaces for package-oriented import/export/migration operations.

## Architecture role

`aerobeat-tool-core` is the lane owner for shared tool-side contracts. It gives concrete AeroBeat tool repos a stable place to share tool-common data shapes and interfaces without turning every tool concern into an app-specific implementation detail.

## V1 scope stance

For the current downscoped v1 architecture, this repo should stay focused on narrow tool-common contract vocabulary rather than pretending to own every concrete tool implementation.

That includes likely shared categories such as:

- import, export, migration, and packaging request/response DTOs
- workflow or job result models
- progress, warning, error, and diagnostic report contracts
- tool settings, persistence, and local index/cache metadata models
- orchestration interfaces used by CLI, editor, and automation-facing tool workflows
- narrow cross-backend playback contracts when a tool-facing package needs shared vocabulary without sharing implementation

## Lane boundaries

This repo intentionally owns:

- shared tool-common DTOs and interfaces
- workflow/reporting vocabulary reused across multiple concrete tools
- tool settings or persistence model seams
- small contract slices that concrete tool repos can build on without re-teaching the same backend-neutral vocabulary

This repo intentionally does **not** own:

- canonical authored content schemas or ids
- gameplay semantics, scoring, or runtime interpretation
- feature/runtime presentation contracts
- platform shell UI behavior
- vendor-specific tool implementations or playback orchestration facades

## Current repository contents

Current checked-in surfaces include:

- `globals/aero_video_playback_contract.gd` for shared playback result keys, state names, source kinds, common error codes, and source normalization/validation helpers
- `interfaces/aero_video_playback_backend.gd` for the minimal backend lifecycle interface that concrete playback vendors can implement
- `tests/` contract coverage for the current video playback contract slice
- hidden `.testbed/` wiring used to run repo-local validation

## Intended consumers

Concrete `aerobeat-tool-*` repos should depend on this package when they need shared tool-side contracts, while still consuming `aerobeat-content-core`, `aerobeat-feature-core`, and other lane repos only where those domain truths are actually needed.

## Development and validation

This repo includes a repo-local contract harness.

Run the headless suite with:

```bash
godot --headless --path .testbed --script res://../tests/run_contract_tests.gd
```

Current suite coverage is intentionally narrow and centered on the shared video playback vocabulary rather than on tool orchestration or vendor-specific playback behavior.

## Repository status

This repo is the canonical home for shared Tool-lane contracts in the downscoped AeroBeat v1 package/content/tool split. Keep the public surface focused on tool-common interfaces and report models, not on redefining content truth, absorbing runtime behavior, or pretending that backend-specific tool implementations belong in the core lane.
