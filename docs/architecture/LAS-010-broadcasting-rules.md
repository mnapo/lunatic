## LAS-010 — Broadcasting Rules
### Objective

Define a deterministic system for resolving shape compatibility and index mapping between tensors in element-wise operations.

Broadcasting enables operations between tensors of different shapes without explicit materialization.

### Core Principle

Broadcasting is a shape transformation system, not a computation system.

It defines how tensor dimensions interact logically before any numerical operation is executed.

### Shape Compatibility Rules

Two shapes are compatible if, when aligned from the right:

* Dimensions are equal, or
* One of them is 1

If neither condition holds, the shapes are incompatible and the operation must fail.

### Shape Resolution

Given two shapes A and B:

* Both shapes are normalized to equal rank using left-padding with 1s
* Each dimension is resolved independently:
    - If equal -> keep value
    - If one is 1 -> adopt the other
    - Else -> error

The result is the output shape of the operation.

### Broadcasting Behavior

A dimension of size 1 acts as a repeating dimension.

It does not allocate new memory but is logically expanded during indexing.

### Index Mapping

For each output tensor index:

* The index is represented as a multi-dimensional coordinate
* Each input tensor receives a mapped index:
    - If its dimension is 1 -> index is fixed at 1
    - Otherwise -> index is taken from output

This mapping ensures correct reuse of values without materialization.

### Interaction with Indexing System

Broadcasting depends on the Indexing system for:

* Conversion between linear and multi-dimensional indices
* Correct memory addressing of tensors

Broadcasting does not compute memory offsets directly.

### Non-Responsibilities

Broadcasting must NOT:

* Perform numerical computation
* Allocate expanded tensors
* Modify storage layout
* Implement element-wise operations

### System Boundaries

* Broadcasting operates strictly between: Shape system and Indexing system

* It is consumed by: Arithmetic and future Reduction system

### Role in Architecture

Broadcasting is the semantic layer that enables:

* Element-wise arithmetic on tensors of different shapes
* Scalar-tensor operations
* Future autograd broadcasting alignment