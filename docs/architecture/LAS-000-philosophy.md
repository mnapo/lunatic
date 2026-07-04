# Lunatic Architectural Specifications (LAS) 000 - Philosophy

## Status
Active

---

## Purpose

This document defines the core philosophy of Lunatic.

Lunatic is a modern AI ecosystem for Lua, designed to be readable, modular, and extensible.

It is not a framework built for abstraction complexity, but for clarity and composability.

---

## Core idea

> Readable first, performant by design.

Understanding the system is always prioritized over optimizing it.

---

## Design principles

### 1. Clarity over complexity
Every abstraction must be understandable without hidden behavior.

---

### 2. Composition over inheritance
Systems are built by combining simple parts, not deep hierarchies.

---

### 3. Explicit over implicit
Behavior must be visible in code, not hidden in runtime magic.

---

### 4. API-first design
Interfaces are designed before implementation details.

---

### 5. Tensor-first thinking
Even early abstractions (Vector, Matrix) must be compatible with future Tensor design.

---

## Scope of Lunatic

Lunatic focuses on:

- Machine learning
- Neural networks
- Scientific computing foundations
- LLM tooling (future)

---

## Non-goals

Lunatic is NOT:

- a general-purpose framework
- a heavy enterprise abstraction layer
- a black-box AI system
- a replacement for Python ecosystems
