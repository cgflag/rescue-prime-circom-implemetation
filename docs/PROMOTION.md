# Promotion Checklist

Use this checklist before sharing the repository on GitHub, X, Zhihu, Bilibili, or technical communities.

## Before Publishing

- Rename the repository from `rescue-prime-circom-implemetation` to `rescue-prime-circom`.
- Add a real open-source license after choosing one deliberately, for example MIT or Apache-2.0.
- Run `npm test`.
- Run `npm run vectors` and paste important outputs into the README if parameters change.
- Update `docs/TEST_VECTORS.md` if parameters or padding change.
- Run `npm run compile:example` on a machine with Circom 2.1.x installed.
- Add a screenshot or terminal snippet showing the compile result and constraint count.
- Fill `docs/BENCHMARKS.md`.
- Pin the repository on your GitHub profile only after the README and first release are ready.

## Suggested GitHub Description

```text
Educational Rescue-Prime-style hash circuits for Circom, with reference vectors and reproducible tests.
```

## Suggested Topics

```text
circom, zero-knowledge, zkp, snark, rescue-prime, cryptography, hash-function
```

## Release Notes Draft

```md
## v0.1.0

Initial cleaned-up release:

- reusable Circom templates for a Rescue-Prime-style sponge hash;
- JavaScript reference implementation;
- deterministic test vectors;
- small compile target under examples/;
- documentation for parameters, caveats, and roadmap.
```

## Sharing Copy

English:

```text
I cleaned up my Rescue-Prime Circom experiment into a reusable educational repo: readable circuits, reference vectors, and a small compile target. It is experimental/unaudited, but useful for learning ZK-friendly hash circuit structure.
```

Chinese:

```text
整理了一个 Rescue-Prime 风格的 Circom 电路实验仓库：包含可复用模板、JS 参考实现、固定测试向量和最小编译示例。当前定位是学习/实验项目，未审计，不做生产安全承诺。
```
