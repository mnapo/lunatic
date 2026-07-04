# Changelog

All notable changes to Lunatic will be documented in this file.

The project follows a versioned, architecture-driven development model.

---

## [0.0.1] - Initial architecture

Defined initial structure. Archived

---

## [0.0.2] - Setting up

### Added

- Initial repository structure for Lunatic
- Core module system skeleton (`core/`)
- Prototype-based Class system
- Basic Math layer (Vector, Matrix)
- Documentation baseline:
  - LAS-000 (Philosophy)
  - LAS-001 (Core Object & Module System)
- Project roadmap definition
- Contribution guidelines
- Code of conduct
- License placeholder
- Basic directory structure for future modules:
  - linalg
  - statistics
  - random
  - constants

---

## v0.1.0 - Tensor Core
### Added
- Introduced Tensor as the core abstraction of Lunatic
- Implemented Storage module as a dedicated memory layer
- Introduced Stride system for N-dimensional indexing
- Added N-dimensional indexing support through get and set
- Introduced shape validation and consistency helpers
- Defined elementwise operation abstraction for arithmetic operations
- Created LAS-002 to LAS-005 documents 

### Changed
- Tensor no longer stores raw data directly; it depends on Storage
- Arithmetic operations now operate through the Storage abstraction layer
- reshape no longer exposes internal structure assumptions and prepares for future view-based implementation
- Access patterns prepared for stride-based indexing

### Architecture
- Introduced Tensor-first architecture as the core design philosophy
- Established separation of concerns between Tensor, Storage, and Strides
- Defined Vector and Matrix as legacy abstractions to be removed or wrapped in future versions

### Known Limitations
- reshape performs memory allocation and is not a view
- No broadcasting support
- No slicing or view system
- No dtype system
- No memory sharing between tensors
- Indexing is functional but not yet optimized

### Foundation for v0.2

This version establishes the foundation for:

- View-based tensors using strides and offset
- O(1) reshape operations
- Slicing without copying memory
- Broadcasting system
- Future autograd integration

---

### Notes

- This release focuses on architecture definition, not functionality completeness
- APIs are experimental and may change in future versions
- Math layer is intentionally minimal and Tensor-oriented by design
