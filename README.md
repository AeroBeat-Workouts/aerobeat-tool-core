# aerobeat-tool-core

Shared AeroBeat tool-side contracts for settings, backend or API integration, validation, and other common tooling models.

## Architecture role

`aerobeat-tool-core` is the lane owner for reusable tooling contracts. It exists so editor tools, settings systems, and backend-facing helpers can share stable tool-side types without pulling in unrelated runtime or presentation concerns.

## Intended consumers

Tool repos and assemblies should depend on this repo for shared tooling models, settings contracts, validation surfaces, and backend-facing abstractions they actually consume.

## Repository status

This repo is the canonical home for shared tool-lane contracts in the six-core AeroBeat architecture. Keep the public surface focused on tooling models and integration boundaries rather than collapsing it into a universal cross-project hub.
