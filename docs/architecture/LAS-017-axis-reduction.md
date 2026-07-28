## LAS-017 - Tensor Reduction Along Dimensions

### Status

Accepted

### Context

Lunatic currently supports full tensor reductions:

```lua
Tensor:sum()
Tensor:mean()
```

These operations reduce all elements of a tensor into a single value.

However, future functionality requires reductions along specific dimensions:

- Broadcasting gradient reduction.
- Axis-based tensor operations.
- Future neural network operations such as softmax and normalization layers.

A general axis reduction primitive is required before implementing these features.

### Decision

Introduce an internal axis reduction operation:

```lua
sum_axis(tensor, axis, keepdim)
```

This operation reduces a single tensor dimension while preserving the existing tensor abstraction.

The operation must:

- Support tensors of arbitrary dimensionality.
- Return a Tensor object.
- Preserve storage and indexing conventions.
- Work independently of Autograd.

### Axis Semantics

Lunatic uses 1-based indexing for dimensions, following Lua conventions.

Example:

```lua
Tensor shape:

{2, 3}

1 2 3
4 5 6
```

Reducing:

```lua
axis = 1
```

produces:

```lua
{1, 3}

5 7 9
```

Reducing:

```lua
axis = 2
```

produces:

```lua
{2, 1}

6
15
```

### Keep Dimension Behavior

The operation must support preserving the reduced dimension.

When:

```lua
keepdim = true
```

the reduced axis remains with size 1.

Example:

```lua
Input:

{2,3}

Reduce axis 1:

{1,3}
```

Without keeping dimensions, the reduced axis may be removed:

```lua
{3}
```

Keeping dimensions simplifies broadcasting and gradient operations.

### Implementation Constraints

The implementation should avoid specialized cases for specific tensor ranks.

The algorithm should rely on existing Lunatic primitives:

- shape utilities.
- stride computation.
- indexing conversion.

The expected approach:

```lua
For every element in the input tensor:

1. Convert flat index to multidimensional coordinates.
2. Remove or collapse the reduced axis.
3. Compute the corresponding output index.
4. Accumulate the value.
```

This ensures support for arbitrary tensor dimensions.

### Autograd Interaction

This operation is not responsible for gradient computation.

Autograd support will be implemented separately.

The backward operation will reuse this primitive for gradient transformations, especially:

```lua
broadcast.reduce_gradient()
```

### Future Extensions

This design prepares the library for:

- sum over multiple axes.
- mean over axes.
- max/min reductions.
- statistical operations.
- neural network normalization layers.