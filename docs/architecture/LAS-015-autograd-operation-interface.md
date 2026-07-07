## LAS015 - Autograd Operation Interface Specification

### Overview

This document defines the interface used by differentiable operations inside Lunatic's Autograd system.

Operations are responsible for connecting mathematical computation with automatic differentiation. Each operation defines how values are computed during the forward pass and how gradients are propagated during the backward pass.

The operation interface allows the Autograd engine to support new mathematical functions without modifying the core graph system.

### Goals

The operation system must provide:

- A consistent interface for forward execution.
- A consistent interface for backward propagation.
- Separation between mathematical logic and graph management.
- Easy implementation of new differentiable operations.
- Compatibility with the Tensor abstraction.

### Operation Structure

Each differentiable operation is represented as a module containing:

```lua
Operation {
    forward = function(inputs)
        ...
    end,

    backward = function(gradient_output, inputs, output)
        ...
    end
}
```