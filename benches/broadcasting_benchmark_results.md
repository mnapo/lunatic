# Broadcasting benchmark results

File: `lua tests/benchmark_broadcasting.lua`

## Summary by size

| Operation | 1000 | 10000 | 100000 |
| --- | ---: | ---: | ---: |
| add same-shape | 0.004655 s | 0.046697 s | 0.485486 s |
| mul same-shape | 0.004577 s | 0.047068 s | 0.525490 s |
| scale scalar | 0.000286 s | 0.002766 s | 0.029635 s |
| broadcast scalar -> vector | 0.004520 s | 0.046535 s | 0.534111 s |
| vector + matrix | 0.006657 s | 0.068065 s | 0.784497 s |

## Total time by size

| Size | Total time |
| --- | ---: |
| 1000 | 0.046545 s |
| 10000 | 0.466969 s |
| 100000 | 4.854857 s |

## Notes

- The `scale scalar` operation is the fastest in all tested sizes.
- The `broadcast scalar -> vector` case has a cost very close to `add same-shape`.
- The `vector + matrix` case shows the highest cost among the measured benchmarks.
