# Benchmarks

This page is prepared for reproducible benchmark results. Fill it after running Circom locally or in CI.

## Environment

| Item | Value |
| --- | --- |
| OS | TBD |
| Node.js | TBD |
| Circom | TBD |
| Prime | `bn128` |
| Compiler flags | `--r1cs --wasm --sym --O2 --inspect` |

## Constraint Counts

| Circuit | Inputs | Constraints | Non-linear constraints | Compile time | Witness time |
| --- | ---: | ---: | ---: | ---: | ---: |
| `examples/hash_2.circom` | 2 | TBD | TBD | TBD | TBD |

## How To Reproduce

```bash
npm test
mkdir -p build
npm run compile:example
```

After compilation, inspect the Circom output for constraint counts and add them to the table above.
