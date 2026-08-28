"use strict";

const assert = require("node:assert/strict");
const test = require("node:test");
const { hash, permutation } = require("../scripts/rescue_prime_reference");

test("permutation is deterministic for the zero state", () => {
  assert.deepEqual(
    permutation([0n, 0n]).map(String),
    [
      "8338997341730993063591557245750628210390407507866638011071454420512184110442",
      "3054531388350922428914768649338519265180969547984979138884451111851945305553",
    ],
  );
});

test("hashes a two-element input with domain-separating padding", () => {
  assert.equal(
    hash([1n, 2n]).toString(),
    "13175527490637101955204475963371910939559814590563829961986671867962204256507",
  );
});

test("padding makes [1] and [1, 0] different messages", () => {
  assert.notEqual(hash([1n]).toString(), hash([1n, 0n]).toString());
});
