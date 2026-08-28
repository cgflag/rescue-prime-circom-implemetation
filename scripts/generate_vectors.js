"use strict";

const { hash, permutation } = require("./rescue_prime_reference");

const cases = [
  [],
  [0n],
  [1n],
  [1n, 2n],
  [1n, 0n],
  [42n, 2024n, 65537n],
];

console.log("# Rescue-Prime Circom Test Vectors");
console.log();
console.log("All values are decimal field elements for the demo bn128 parameter set.");
console.log();
console.log("## Permutation");
console.log();
console.log("| Input state | Output state |");
console.log("| --- | --- |");
console.log(`| \`[0, 0]\` | \`[${permutation([0n, 0n]).map(String).join(", ")}]\` |`);
console.log();
console.log("## Sponge Hash");
console.log();
console.log("| Input | Hash |");
console.log("| --- | --- |");
for (const input of cases) {
  console.log(`| \`[${input.map(String).join(", ")}]\` | \`${hash(input).toString()}\` |`);
}
