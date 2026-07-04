## LAS-005 - Stride System

The Stride system defines how N-dimensional indices are mapped into linear memory.

A stride represents the step size required to move along a given dimension.

### Index Mapping

The linear index is computed as:

index = offset + Σ (i_k - 1) * stride_k

### Layout Convention
- Row-major memory layout is used.
- The last dimension always has stride 1.
- Strides are derived exclusively from shape.

### v0.1 Usage
Strides are used only for indexing.
They are not yet used for views, slicing, or broadcasting.