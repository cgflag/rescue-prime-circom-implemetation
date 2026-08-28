# Rescue-Prime In Circom

This note gives a compact mental model for readers searching for `rescue prime circom`, `zk-friendly hash circom`, or `circom hash circuit`.

## What Makes Rescue-Prime ZK-Friendly

A hash function used inside a SNARK circuit should avoid bit-heavy operations when possible. Rescue-Prime-style designs are built from field arithmetic:

- exponentiation S-boxes;
- MDS matrix multiplication;
- round constant addition;
- sponge absorption and squeezing.

These operations map naturally to arithmetic constraints, which is why Rescue, Poseidon, Griffin, Anemoi, and related designs often appear in zero-knowledge systems.

## How This Repository Maps The Design

The implementation has four layers:

| Layer | Circom template | Purpose |
| --- | --- | --- |
| Exponentiation | `PowConst` | Computes constrained `x^e` for constant `e` |
| Round | `RescuePrimeRound` | Applies S-box, MDS, constants, inverse S-box, MDS, constants |
| Permutation | `RescuePrimePermutation` | Applies all rounds over a 2-element state |
| Hash | `RescuePrimeHash` | Wraps the permutation in a rate-1 sponge |

This split is useful for learning because each layer can be inspected independently.

## Common Circom Pitfalls

When implementing ZK-friendly hashes in Circom, watch for these issues:

- Using `<--` without adding constraints.
- Choosing an S-box exponent that is not invertible over the target field.
- Forgetting that Circom uses its compiler-selected arithmetic field, not a field declared as a normal circuit variable.
- Reusing an accumulator variable across MDS rows.
- Accidentally outputting the pre-final-round state.
- Resetting the capacity element during sponge absorption.

The cleaned implementation was structured specifically to make these mistakes visible.

## How To Extend It

Good next experiments:

- add a second example circuit for `RescuePrimeHash(8)`;
- generate constants from a documented script;
- compare constraint counts against Poseidon for the same message length;
- add witness tests that compare Circom WASM outputs against `scripts/rescue_prime_reference.js`;
- add a small benchmark table for compile time, witness time, and constraints.
