## LAS013 - Computation Graph Node Specification

### Overview

This document specifies the design and behavior of computation graph nodes in Lunatic's Autograd system.

Nodes are the fundamental units that connect Tensor operations into a dynamic computation graph.

Each node represents a single differentiable operation and stores the information required to perform backward propagation.

---

## Goals

The Node system must provide:

- Representation of Tensor operations.
- Storage of operation inputs and outputs.
- Backward propagation rules.
- Connection between forward execution and gradient computation.
- Extensibility for new differentiable operations.

---

## Non-Goals

The Node system will not handle:

- Tensor numerical storage.
- Memory allocation.
- Optimization algorithms.
- Execution scheduling.
- Neural network components.

These responsibilities belong to other layers.

---

## Node Architecture

A Node represents one operation in the computation graph.

Basic structure:

```lua
Node {
    operation = "add",

    inputs = {
        tensor_a,
        tensor_b
    },

    output = tensor_c,

    backward = function(...)
        ...
    end
}