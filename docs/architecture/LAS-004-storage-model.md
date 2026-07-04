## LAS-004 - Storage Model

The Storage layer defines the low-level memory representation used by Tensor.

Storage is a minimal abstraction over a contiguous linear buffer.

### Responsibilities
- Store raw numeric data in a flat structure.
- Provide constant-time indexed access.
- Decouple memory management from tensor semantics.


### Design Rules
- Storage does not know about Tensor.
- Tensor depends on Storage, not the reverse.
- Shape and semantic metadata must never exist inside Storage.
- Storage is intended to remain stable across future tensor views.