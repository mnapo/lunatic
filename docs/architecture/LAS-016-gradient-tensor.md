## LAS016 - Gradient Tensor Specification

### Overview

This document defines the gradient system behavior inside Lunatic's Autograd layer.

Gradients are numerical representations of derivatives generated during backward propagation. This specification defines how gradients are stored, accumulated, validated, and associated with Tensor objects.

### Goals

The Gradient Tensor system must provide:

- Storage for computed derivatives.
- Gradient accumulation from multiple graph paths.
- Shape validation.
- Compatibility with Tensor operations.
- Clear separation between data and gradient state.

### Gradient State

A Tensor participating in Autograd contains gradient-related metadata.

Example:

```lua
Tensor {
    data = {...},
    shape = {...},

    requires_grad = true,
    grad = nil,
    grad_fn = nil
}
```

The gradient state is independent from the Tensor data.

The original Tensor stores values used during computation, while the gradient stores derivatives generated during backward execution.

### Gradient Creation

Gradients are created during backward propagation.

Example:

```lua
x = Tensor(5)
x.requires_grad = true

y = x * 2

y:backward()
```

After execution:

```lua
x.grad = 2
```

The gradient does not exist before backward execution unless manually assigned.

### Gradient Accumulation

A Tensor may receive multiple gradient contributions.

Example:

```lua
y = x + x
```

The derivative is:

```lua
dy/dx = 2
```

The system must accumulate both contributions.

Internal behavior:

```lua
tensor.grad = tensor.grad + incoming_gradient
```

Gradients must never be overwritten during normal backward execution.

### Gradient Initialization

Before accumulation, gradients must be initialized.

For the first contribution:

```lua
tensor.grad = incoming_gradient
```

For subsequent contributions:

```lua
tensor.grad = tensor.grad + incoming_gradient
```

The implementation must correctly handle both cases.

### Gradient Shape Rules

Gradient shapes must match the Tensor they belong to.

Example:

```lua
tensor.shape = {2, 3}

tensor.grad.shape = {2, 3}
```

Invalid gradient shapes must generate errors.

Operations responsible for broadcasting or reduction must generate compatible gradients before accumulation.

### Leaf Tensor Gradients

Leaf tensors represent user-created tensors.

Example:

```lua
x = Tensor(10)
x.requires_grad = true
```

Leaf tensors:

- Store final gradients.
- Do not have a grad_fn.
- Are the primary target for optimization algorithms.

### Intermediate Tensor Gradients

Intermediate tensors are created by operations.

Example:

```lua
y = x * 2
z = y + 3
```

By default:

- Intermediate gradients are temporary.
- They are used internally during backward execution.
- They may be discarded after propagation.

Future versions may support retaining intermediate gradients.

### Gradient Clearing

Gradients must be reset before starting a new independent backward pass.

Example:

```lua
tensor:zero_grad()
```

Expected behavior:

```lua
tensor.grad = nil
```

or an equivalent zero tensor representation.

The exact implementation is defined by the Tensor API.

### Gradient Accumulation Example

Given:

```lua
a = Tensor(2)
a.requires_grad = true

b = a * a
c = b + a

c:backward()
```

The gradient of `a` receives contributions from:

```lua
a -> b -> c

a -> c
```

The final gradient must include both paths.

### Gradient Validation

The system must validate:

- Gradient existence.
- Gradient shape compatibility.
- Numerical compatibility.
- Device compatibility when supported.

Invalid gradient states must produce explicit errors.

### Memory Management

The gradient system must avoid unnecessary retention of computation history.

After backward execution:

- Temporary gradients may be released.
- Graph references may be removed.
- Leaf gradients must remain available.

### Design Principles

The gradient system must remain:

- Independent from optimization algorithms.
- Independent from neural network modules.
- Compatible with future Tensor extensions.
- Predictable for users.

### Future Extensions

Possible improvements:

- Gradient hooks.
- Sparse gradients.
- Gradient checkpointing.
- Higher-order differentiation.
- Mixed precision gradients.

### Version

Initial version: v0.3.0

Status: Proposed