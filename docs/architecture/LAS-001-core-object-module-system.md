# LAS-001 — Core Object & Module System

## Status
Active (early design)

---

## Purpose

This document defines the foundational system for objects and modules in Lunatic.

It establishes how code is structured, composed, and connected.

---

## Philosophy

The core system follows three rules:

### 1. Simplicity
Objects should be easy to create, extend, and inspect.

---

### 2. Transparency
No hidden behavior. Everything must be traceable in Lua.

---

### 3. Composition over inheritance
Inheritance exists, but composition is preferred for system design.

---

## Object system

Lunatic uses a lightweight prototype-based model.

Objects are tables with metatables.

No strict schema enforcement is required.

---

## Class system

A minimal class abstraction is provided in `core/class.lua`.

### Features

- Class creation via `Class()`
- Optional inheritance
- `:new()` constructor
- Optional `:init()` lifecycle method

### Example

```lua
local Class = require("lunatic.core.class")

local Animal = Class()

function Animal:init(name)
    self.name = name
end
