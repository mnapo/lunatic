## LAS-006 — Tensor API Design Principles

This document defines the design principles governing the Tensor API.

### Core Principles
- Tensor-first design: all mathematical operations must be expressed through Tensor. No external numerical abstractions are allowed.

- Consistency over completeness: the API should remain small, coherent, and predictable rather than feature-complete.

- Explicit memory behavior: operations must not hide unexpected allocations or side effects.

- Clear shape semantics: shape must always be explicitly accessible and consistently defined.

- Controlled evolution: backward compatibility is allowed within v0.x, but internal architecture may evolve.

### v0.1 API Scope

The initial API includes:

- Construction: new, copy, reshape
- Arithmetic: add, sub, scale
- Reductions: sum, mean
- Transformations: map, flatten
- Access: get, set (flat and N-dimensional experimental)