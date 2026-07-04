# Roadmap

Lunatic is evolving into a modern AI ecosystem for Lua, focused on simplicity, composability, and clarity.

---

## V0.0.2 — Setting up (current)

- Repository structure definition
- Core module system (Class + loader)
- Math foundation (Vector, Matrix)
- Documentation baseline (LAS-000, LAS-001)
- API direction locked (Tensor-first design thinking)
- No ML logic yet

---

## V0.1.0 — Tensor system preparation

- N-dimensional Tensor implementation
- Storage for Tensors' data
- Strides

---

## V0.2.0 — Full Tensor system

- Broadcasting rules
- Shape system unification (Vector/Matrix -> Tensor view)
- Backend abstraction (initial CPU Lua backend)
- Performance-aware design (still CPU-first)

---

## V0.3.0 — Autograd

- Automatic differentiation engine
- Computation graph representation
- Backpropagation system
- Gradient tracking for Tensor operations

---

## V0.4.0 — Neural networks

- Layer system (Dense, Activation, etc.)
- Loss functions
- Optimizers (SGD, Adam basic)
- Simple training loops

---

## V0.5.0 — Machine learning utilities

- Classical ML algorithms (linear regression, clustering, etc.)
- Dataset utilities
- Training pipelines abstraction

---

## V1.0.0 — Stable AI ecosystem

- Stable API
- Documented architecture
- First production-ready release
- LuaRocks publication
- External ecosystem support

---

## Long-term vision

- LLM tooling layer
- Plugin system for external models
- Multi-backend support (Lua / C / GPU bindings)
- Lightweight deployment targets
