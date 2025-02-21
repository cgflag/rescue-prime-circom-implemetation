pragma circom 2.1.9;
include "rescue_XLIX_permutation_single_round.circom";

template RescueXLIXPermutation(p, m, capacity, security_level, alpha, alphainv, N, MDS, round_constants) {
	signal input state[m];
	signal state_arr[N][m];
    signal output new_state[m];
	component singleRound[N];

    for (var i = 0; i < m; i++) {
        state_arr[0][i] <== state[i];
    }

    for (var r = 0; r < N; r++) {
 	singleRound[r]= RescueXLIXPermutationSingleRound(p, m, capacity, security_level, alpha, alphainv, N, MDS, round_constants, r);
        
        // 将当前轮的状态作为输入传递给单轮置换组件
        for (var i = 0; i < m; i++) {
            singleRound[r].state[i] <== state_arr[r][i];
        }

        // 将单轮置换的输出存储到状态数组的下一行
        if (r < N - 1) {
            for (var i = 0; i < m; i++) {
                state_arr[r + 1][i] <== singleRound[r].new_state[i];
            }
        }
    }

    // 将最后一轮的输出设置为最终新状态
    for (var i = 0; i < m; i++) {
        new_state[i] <== state_arr[N - 1][i];
    }
}
/*template Main() {
    var p=407 * (1 << 119) + 1;
    var m=2;
    var capacity=1;
    var security_level;
    var alpha=3;
    var alphainv=180331931428153586757283157844700080811;
    var N=27;
    var MDS[2][2]=[[270497897142230380135924736767050121214, 4],[270497897142230380135924736767050121205, 13]];

    var round_constants[108];
    var state[2];

    component permutation = RescueXLIXPermutation(p, m, capacity, security_level, alpha, alphainv, N, MDS, round_constants);
	for (var i=0; i < 2; i++)
	{
		permutation.state[i] <== state[i];
	}
    // 这里可以添加其他逻辑或组件
}
component main=Main();*/