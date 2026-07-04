## LAS-003 - Tensor Core Model

The Tensor is the central abstraction of Lunatic. It represents an N-dimensional data structure designed to unify all mathematical operations within the library.

A Tensor is composed of four fundamental components:

* Storage: a linear memory buffer that holds raw data.
* Shape: a list of integers defining the dimensional structure of the tensor.
* Strides: a set of integer offsets used to map N-dimensional coordinates to linear memory.
* Offset: a base index used for future view and slicing operations.

## Design Principles
- Tensor is the primary data structure of the system.
- Vector and Matrix are considered legacy abstractions built on top of Tensor.
- Shape defines structure, while Strides define memory semantics.
- All operations must be expressible in terms of Tensor operations.

## v0.1 Constraints
- No views or slicing.
- No broadcasting.
- No automatic differentiation.
- Reshape may allocate new memory.