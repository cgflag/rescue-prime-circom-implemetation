pragma circom 2.1.9;

include "rescue_prime_params.circom";

template PowConst(exp, nBits) {
    signal input in;
    signal output out;

    signal squares[nBits];
    signal acc[nBits];

    var bit0 = exp & 1;
    squares[0] <== in;
    acc[0] <== 1 + bit0 * (in - 1);

    for (var i = 1; i < nBits; i++) {
        var bit = (exp >> i) & 1;
        squares[i] <== squares[i - 1] * squares[i - 1];
        acc[i] <== acc[i - 1] * (1 + bit * (squares[i] - 1));
    }

    out <== acc[nBits - 1];
}

template RescuePrimeRound(roundIndex) {
    signal input state[STATE_WIDTH()];
    signal output next_state[STATE_WIDTH()];

    var mds[STATE_WIDTH()][STATE_WIDTH()] = MDS_MATRIX();
    var constants[2 * ROUNDS() * STATE_WIDTH()] = ROUND_CONSTANTS();

    signal sbox_forward[STATE_WIDTH()];
    signal mixed_forward[STATE_WIDTH()];
    signal added_forward[STATE_WIDTH()];
    signal sbox_inverse[STATE_WIDTH()];
    signal mixed_inverse[STATE_WIDTH()];

    component forward_pow[STATE_WIDTH()];
    component inverse_pow[STATE_WIDTH()];

    for (var i = 0; i < STATE_WIDTH(); i++) {
        forward_pow[i] = PowConst(ALPHA(), 4);
        forward_pow[i].in <== state[i];
        sbox_forward[i] <== forward_pow[i].out;
    }

    var lc;

    for (var i = 0; i < STATE_WIDTH(); i++) {
        lc = 0;
        for (var j = 0; j < STATE_WIDTH(); j++) {
            lc += mds[i][j] * sbox_forward[j];
        }
        mixed_forward[i] <== lc;
        added_forward[i] <== mixed_forward[i] + constants[roundIndex * 2 * STATE_WIDTH() + i];
    }

    for (var i = 0; i < STATE_WIDTH(); i++) {
        inverse_pow[i] = PowConst(ALPHA_INV(), EXP_BITS());
        inverse_pow[i].in <== added_forward[i];
        sbox_inverse[i] <== inverse_pow[i].out;
    }

    for (var i = 0; i < STATE_WIDTH(); i++) {
        lc = 0;
        for (var j = 0; j < STATE_WIDTH(); j++) {
            lc += mds[i][j] * sbox_inverse[j];
        }
        mixed_inverse[i] <== lc;
        next_state[i] <== mixed_inverse[i] + constants[roundIndex * 2 * STATE_WIDTH() + STATE_WIDTH() + i];
    }
}

template RescuePrimePermutation() {
    signal input state[STATE_WIDTH()];
    signal output out[STATE_WIDTH()];

    signal round_state[ROUNDS() + 1][STATE_WIDTH()];
    component rounds[ROUNDS()];

    for (var i = 0; i < STATE_WIDTH(); i++) {
        round_state[0][i] <== state[i];
    }

    for (var r = 0; r < ROUNDS(); r++) {
        rounds[r] = RescuePrimeRound(r);
        for (var i = 0; i < STATE_WIDTH(); i++) {
            rounds[r].state[i] <== round_state[r][i];
            round_state[r + 1][i] <== rounds[r].next_state[i];
        }
    }

    for (var i = 0; i < STATE_WIDTH(); i++) {
        out[i] <== round_state[ROUNDS()][i];
    }
}

template RescuePrimeHash(nInputs) {
    signal input inputs[nInputs];
    signal output out;

    var nBlocks = nInputs + 1;
    signal padded[nBlocks];
    signal sponge_state[nBlocks + 1][STATE_WIDTH()];
    signal absorbed[nBlocks][STATE_WIDTH()];
    component permutations[nBlocks];

    for (var i = 0; i < nInputs; i++) {
        padded[i] <== inputs[i];
    }
    padded[nInputs] <== 1;

    for (var i = 0; i < STATE_WIDTH(); i++) {
        sponge_state[0][i] <== 0;
    }

    for (var block = 0; block < nBlocks; block++) {
        absorbed[block][0] <== sponge_state[block][0] + padded[block];
        absorbed[block][1] <== sponge_state[block][1];

        permutations[block] = RescuePrimePermutation();
        for (var i = 0; i < STATE_WIDTH(); i++) {
            permutations[block].state[i] <== absorbed[block][i];
            sponge_state[block + 1][i] <== permutations[block].out[i];
        }
    }

    out <== sponge_state[nBlocks][0];
}
