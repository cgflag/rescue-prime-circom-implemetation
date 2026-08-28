# Implementation Notes

These notes explain the circuit engineering choices in `circuits/rescue_prime.circom`. They are written for readers who already know basic Circom and want to inspect a small ZK-friendly hash implementation.

## Circuit Scope

The current circuit is an educational Rescue-Prime-style sponge over Circom's default `bn128` scalar field.

It is intentionally small:

- state width: 2 field elements;
- rate: 1 field element;
- capacity: 1 field element;
- rounds: 27;
- forward S-box: `x^5`;
- inverse S-box: `x^alpha_inv`, where `alpha_inv` is the inverse of 5 modulo `bn128 - 1`.

The parameter constants are separated in `circuits/rescue_prime_params.circom` so that the main circuit logic stays readable.

## Why `x^5`

The original experiment used `alpha = 3`, but 3 is not invertible modulo `bn128 - 1`, so it cannot be paired with a valid inverse S-box over Circom's default field. The cleaned implementation uses `alpha = 5`, which is invertible in this field.

This matters because Rescue-Prime-style rounds rely on alternating an S-box and its inverse. If the exponent is not invertible over the chosen field, the circuit may still compile, but the construction is not the intended permutation.

## Avoiding Unconstrained Witness Assignment

In Circom, `<--` assigns a witness value without adding a constraint. That is useful for hints, but dangerous if not followed by explicit constraints.

This implementation uses `<==` throughout the reusable templates so each computed value is constrained. Constant exponentiation is implemented by repeated squaring in `PowConst(exp, nBits)` instead of assigning the result as a witness hint.

## Round Structure

Each round follows this shape:

```text
state
  -> forward S-box
  -> MDS matrix
  -> add first round constants
  -> inverse S-box
  -> MDS matrix
  -> add second round constants
```

Two details are easy to get wrong:

- the second MDS layer must mix the inverse S-box output, not the first S-box output;
- the permutation output must be the state after the final round, not the input state of the final round.

Both are fixed in `RescuePrimePermutation()`.

## Sponge Wrapper

`RescuePrimeHash(nInputs)` uses rate-1 absorption:

```text
state = [0, 0]
message = inputs || [1]
for block in message:
  state[0] += block
  state = permutation(state)
return state[0]
```

The trailing `1` is a simple domain-separating padding element. It makes `[1]` and `[1, 0]` different messages, which is covered by the test suite.

## Security Boundary

This repository is not a production cryptographic library.

The demo constants are inherited from the original experiment and have not been regenerated from a documented parameter-generation procedure. Before using this in a protocol, regenerate constants for the exact field, state width, capacity, and security target, then audit the implementation.
