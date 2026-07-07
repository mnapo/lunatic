## LAS-011 - Tensor Iteration System

### Objective

Define a generic iteration system for traversing tensor spaces independently of tensor storage, broadcasting, or numerical operations.

The iteration system provides a reusable abstraction for visiting every logical element of a tensor while remaining independent from memory layout and backend implementation.

## Core Principle

Iteration is distinct from indexing.

- Indexing answers: "Where is this logical element located in memory?"
- Iteration answers: "How do we visit every logical element of a tensor?"

These responsibilities must remain separated.

### Iterator Model

An iterator traverses a tensor's logical coordinate space.

At any point during iteration, it maintains a current multi-dimensional index and provides a deterministic way to advance to the next logical position.

The iterator does not perform numerical computation.

### Responsibilities

The Iteration System is responsible for:

- Traversing arbitrary N-dimensional tensor spaces
- Producing logical multi-dimensional indices
- Providing deterministic traversal order
- Remaining independent from tensor storage and backend implementation

### Non-Responsibilities

The Iteration System must not:

- Access tensor storage
- Perform memory offset calculations
- Implement broadcasting rules
- Perform numerical operations
- Allocate output tensors

These responsibilities belong to other architectural components.

### Relationship with Indexing

The Iteration System and Indexing System are complementary.

Iteration generates logical coordinates.

Indexing converts logical coordinates into physical storage locations.

An iterator must never calculate memory offsets directly.

### Relationship with Broadcasting

Broadcasting modifies how logical indices are interpreted.

Iteration itself is unaware of broadcasting semantics.

Broadcasting consumes iterator-generated indices and maps them to each input tensor independently.

### Traversal Order

The initial implementation performs deterministic row-major traversal.

Future versions may introduce alternative traversal strategies without modifying the public iteration interface.

### Extensibility

The Iteration System is designed to support multiple implementations.

Examples include:

- Generic iterator
- Stride-aware iterator
- Contiguous-memory iterator
- Broadcast-aware iterator
- Backend-optimized iterator

All implementations must expose the same logical iteration behavior.

### Performance Considerations

The initial implementation prioritizes correctness, readability, and architectural consistency.

Future implementations may optimize traversal by:

- Eliminating repeated index reconstruction
- Reusing internal buffers
- Exploiting contiguous memory regions
- Leveraging backend-specific optimizations

These optimizations must not alter observable behavior.

### Architectural Role

The Iteration System occupies the layer between Broadcasting and Indexing.

Its role is to separate logical tensor traversal from physical memory access, providing a reusable foundation for arithmetic operations, reductions, and future backend optimizations.