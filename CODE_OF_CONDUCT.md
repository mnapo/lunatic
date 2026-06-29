# Contributing to Lunatic

Lunatic is a structured, evolving AI ecosystem for Lua.  
Contributions should follow the architecture-first design philosophy.

---

## Core principles

- Readability over complexity
- Composition over inheritance
- Explicit behavior over hidden magic
- API-first design
- Stability through layered architecture (LAS-driven)

---

## Architecture awareness

Before contributing, understand the current design documents:

- `docs/architecture/LAS-000-philosophy.md`
- `docs/architecture/LAS-001-core-object-module-system.md`

These define the system boundaries and must guide all changes.

---

## Development workflow

All contributions should be made through Pull Requests.

### Branch naming

Use descriptive versioned branches:

```text id="branch_ex"
v0.0.2-setting-up
v0.0.3-math-foundation
v0.1.0-tensor-system