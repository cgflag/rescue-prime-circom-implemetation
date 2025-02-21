pragma circom 2.1.9;
include "rescue_XLIX_permutation.circom";
include "round_constants.circom";
template RescuePrimeWrapper(p, m, capacity, security_level, alpha, alphainv, N, MDS, round_constants,len_input) {
    signal input input_sequence[len_input];
    signal output padded_input[len_input\(m - capacity)+1];

    var rate = m - capacity;
    var padding_length = rate - (len_input % rate);
    padding_length = padding_length == rate ? 0 : padding_length; // 如果输入序列长度已经是rate的倍数，则不需要填充

    // 初始化填充后的序列
    for (var i = 0; i < len_input; i++) {
        padded_input[i] <== input_sequence[i];
    }

    // 添加填充位
    if (padding_length > 0) {
        padded_input[len_input] <== 1; // 添加分隔符
        for (var i = 1; i < padding_length; i++) {
            padded_input[len_input + i] <== 0; // 添加填充0
        }
    }
}
template RescuePrimeHash(p, m, capacity, security_level, alpha, alphainv, N, MDS, round_constants,len_input)
{
	signal input input_sequence[len_input];
	//var len_input = 32;
		var rate = m - capacity;
	var totlen = (len_input\ rate + 1)*rate;
	signal padded_input[totlen];
	signal output output_sequence[m - capacity];
	signal state_arr[totlen][m];//记录每轮输入，避免信号重复赋值
	signal state_cont[totlen][m];
	signal state[m];

	var input_sequence_length=32;
	component Permu[totlen];
	component Pad;
	Pad = RescuePrimeWrapper(p, m, capacity, security_level, alpha, alphainv, N, MDS, round_constants, len_input);
	for (var i = 0; i < len_input; i++)
	{
		Pad.input_sequence[i] <== input_sequence[i];
	} 
	
	 for (var i = 0; i < totlen; i++)
	{
		
		padded_input[i] <== Pad.padded_input[i];
	} 
	var num_rounds = totlen \ rate;
	for (var j = 0; j < num_rounds; j++)
	{
		for (var i = 0; i < rate; i++) 
		{
			if (j == 0) 
			{
                	// 第一轮直接从输入序列吸收
                		state_arr[j][i] <== padded_input[i];
            		}
			else 
			{
                	// 后续轮从上一轮的输出吸收
               			state_arr[j][i] <== state_cont[j][i] + padded_input[j * rate + i];
            		}
		}
		Permu[j] = RescueXLIXPermutation(p, m, capacity, security_level, alpha, alphainv, N, MDS, round_constants);
		for (var i = 0; i < rate; i++) 
		{
			Permu[j].state[i] <== state_arr[j][i];
		}
        for (var i = rate; i < m; i++) 
		{
			Permu[j].state[i] <== 0;
		}
		for (var i = 0; i < rate; i++) 
		{
			// 将这一轮的输出存储为下一轮的输入
            		if (j < num_rounds - 1) 
			{
                		state_cont[j + 1][i] <== Permu[j].new_state[i];
            		}
			else
			{
			// Squeezing
        			output_sequence[i] <== Permu[j].new_state[i];
			}
		}
        for (var i = rate; i < m; i++) 
		{
            if (j < num_rounds - 1) 
			{
			    state_cont[j + 1][i] <== 0;
            }
		}
	}
}
template Main(len_input) 
{
//用于单个circom文件能否运行测试。
    var p=407 * (1 << 119) + 1;
    var m=2;
    var capacity=1;
    var security_level=128;
    var alpha=3;
    var alphainv=180331931428153586757283157844700080811;
    var N=27;
    var MDS[2][2]=[[270497897142230380135924736767050121214, 4],[270497897142230380135924736767050121205, 13]];

    //var round_constants[108];
	var round_constants[108]=RESCUE_ROUND();

    var input_sq[len_input];//32配套 以后再替成156
	//var len_input = 32;
    component permutation = RescuePrimeHash(p, m, capacity, security_level, alpha, alphainv, N, MDS, round_constants,len_input);
	for (var i=0; i < len_input; i++)
	{
		permutation.input_sequence[i] <== input_sq[i];
	}
    // 这里可以添加其他逻辑或组件
}
component main=Main(65536);