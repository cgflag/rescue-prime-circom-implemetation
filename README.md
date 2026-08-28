# Rescue-Prime Circom

Educational Rescue-Prime-style hash circuits for Circom, with a small reference implementation, implementation notes, and reproducible test vectors.

This repository packages a compact ZK-friendly hash construction as reusable Circom templates. It is designed for people studying Circom, zero-knowledge circuits, SNARK-friendly hash functions, and Rescue-Prime-style permutations: clone it, compile the example circuit, compare outputs against the JavaScript reference, and adapt the templates for your own parameter set.

> Status: experimental and unaudited. The bundled constants are kept as a demo parameter set, not as a production-ready cryptographic recommendation.

## Why This Exists

ZK-friendly hash functions are often easy to cite but harder to inspect in circuit form. This project focuses on the engineering pieces that are useful when learning Circom:

- a readable Rescue-Prime-style permutation;
- a sponge hash wrapper with explicit padding;
- constrained constant exponentiation instead of unconstrained witness assignment;
- a JavaScript reference implementation for test vectors;
- implementation notes for common Circom mistakes;
- minimal commands for compilation and local verification.

## Repository Layout

```text
.
├── circuits/
│   ├── rescue_prime.circom          # Main reusable Circom templates
│   └── rescue_prime_params.circom   # Demo parameters and constants
├── examples/
│   └── hash_2.circom                # Small compile target for two inputs
├── inputs/
│   └── hash_2.json                  # Example witness input
├── scripts/
│   └── rescue_prime_reference.js    # JavaScript reference implementation
├── test/
│   └── reference.test.js            # Deterministic test vectors
├── docs/
│   ├── IMPLEMENTATION_NOTES.md      # Circom engineering notes
│   ├── RESCUE_PRIME_IN_CIRCOM.md    # Conceptual walkthrough
│   ├── TEST_VECTORS.md              # Fixed reference outputs
│   ├── BENCHMARKS.md                # Benchmark table template
│   └── PROMOTION.md                 # Publishing checklist
└── rescue_prime/
    └── rescue_prime/                # Original course implementation archive
```

## Quick Start

Prerequisites:

- Node.js 18 or newer
- Circom 2.1.x

Run the reference tests:

```bash
npm test
```

Generate the default demo vector for `[1, 2]`:

```bash
npm run vector
```

Generate a Markdown table of test vectors:

```bash
npm run vectors
```

Expected output:

```text
13175527490637101955204475963371910939559814590563829961986671867962204256507
```

Compile the sample circuit:

```bash
mkdir -p build
npm run compile:example
```

The compile command expands to:

```bash
circom examples/hash_2.circom --r1cs --wasm --sym --O2 --inspect -o build
```

Circom output artifacts are ignored by git because they can be regenerated.

## For ZK/Circom Readers

If you are comparing Circom hash implementations, start here:

- [Implementation notes](docs/IMPLEMENTATION_NOTES.md) explain the circuit choices and common pitfalls.
- [Rescue-Prime in Circom](docs/RESCUE_PRIME_IN_CIRCOM.md) maps the hash structure to Circom templates.
- [Test vectors](docs/TEST_VECTORS.md) provide fixed outputs for reference implementations.
- [Benchmarks](docs/BENCHMARKS.md) is prepared for constraint counts and witness timing.

## Circom API

Import the main circuit file:

```circom
pragma circom 2.1.9;

include "../circuits/rescue_prime.circom";

component main = RescuePrimeHash(2);
```

Available templates:

- `PowConst(exp, nBits)`: constrained exponentiation by a compile-time constant.
- `RescuePrimeRound(roundIndex)`: one Rescue-Prime-style round.
- `RescuePrimePermutation()`: full 27-round permutation over a 2-element state.
- `RescuePrimeHash(nInputs)`: rate-1 sponge hash with a trailing `1` padding element.

## Parameters

The current demo parameter set is:

| Parameter | Value |
| --- | --- |
| Circom prime | default `bn128` |
| State width | `2` |
| Rate | `1` |
| Capacity | `1` |
| Rounds | `27` |
| Forward S-box | `x^5` |
| Inverse S-box | `x^alpha_inv` over the `bn128` scalar field |

Important notes:

- Circom arithmetic is performed in the compiler-selected field. Use `circom --prime ...` if you intentionally target a different supported field.
- The constants in `circuits/rescue_prime_params.circom` are demo constants inherited from the original experiment. For production use, regenerate and document parameters for the exact field and security target.
- This repository has not been audited.

## Fixed Vectors

Permutation of the zero state:

```text
[
  8338997341730993063591557245750628210390407507866638011071454420512184110442,
  3054531388350922428914768649338519265180969547984979138884451111851945305553
]
```

Hash of `[1, 2]`:

```text
13175527490637101955204475963371910939559814590563829961986671867962204256507
```

## What Was Improved From The Original Version

The original code was a course experiment archive. The reusable circuit in `circuits/` fixes several engineering issues:

- the final permutation output now returns the state after the last round;
- the second MDS layer is applied to the inverse S-box output;
- MDS linear combinations are reset per row;
- inverse exponentiation is constrained with square-and-multiply;
- sponge capacity state is preserved across absorption rounds;
- the huge hard-coded `Main(65536)` entry point was replaced with small reusable templates and examples.

## Roadmap

- Add Circom witness tests that compare WASM output against the JavaScript reference.
- Add generated parameters for a clearly documented target field.
- Add benchmark tables for constraints and compile time.
- Extend CI to compile the example circuit once Circom installation is added.

## 中文说明

这是一个面向学习和实验的 Rescue-Prime 风格 Circom 电路实现。当前版本已经整理为更适合开源展示的结构：核心电路、示例入口、输入样例、JavaScript 参考实现和固定测试向量都放在清晰的位置。

请注意：当前参数集是实验/demo 参数，项目未经过安全审计，不建议直接用于生产级密码协议。
