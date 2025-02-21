pragma circom 2.1.9;

function n2bfn(num)
{
	var bits[256];
	for (var i = 0; i < 256; i++)
	{
		bits[i] = (num >> i) & 1;
	}
	return bits;
}
/*function max(a, b) {
    return a > b ? a : b;
}*/
template power (p) {
    signal input a;
    signal output out;

    assert(p > 0);

    signal prod[p];

    prod[0] <== a;
    
    for (var i=1; i < p; i++) {
        prod[i] <== prod[i-1] * a;
    }

    out <== prod[p-1];
}
template RescueXLIXPermutationSingleRound(p, m, capacity, security_level, alpha, alphainv, N, MDS, round_constants,r) {
	signal input state[m];
	    signal temp1[m];
	signal temp2[m];
    signal output new_state[m];
	var pow_old;
	signal powers[m][256];
	signal arr[m][256];
	signal s_boxed1[m];
	signal s_boxed2[m];
	signal added1[m];
	signal MDSed1[m];
	signal MDSed2[m];
	component pow1[m];
	


        // S-box
        for (var j = 0; j < m; j++) {

    		pow1[j] = power(alpha);
    		pow1[j].a <== state[j];
    		s_boxed1[j] <== pow1[j].out;
		/*pow_new[j][0] <== state[j];
		for (var k = 1; k < alpha; k++)
		{
			
			pow_new[j][k] <==pow_new[j][k-1]*state[j];
		}
		s_boxed1[j] <== pow_new[j][alpha-1];*/

        }


        // MDS
	var lc=0;
        for (var i = 0; i < m; i++) {
		
            for (var j = 0; j < m; j++) {
                //temp[i] <== temp[i] + MDS[i][j] * s_boxed1[j];
		lc += MDS[i][j] * s_boxed1[j];
            }
		temp1[i]<==lc;
        }
	for (var i = 0; i < m; i++) {
		MDSed1[i]<==temp1[i];
	}

        // Constants
        for (var j = 0; j < m; j++) {
            added1[j] <== MDSed1[j] + round_constants[r * 2 * m + j];
        }
	// Inverse S-box（not fast exp）
	var bits[256];
	for (var i = 0; i < 256; i++)
	{
		bits[i] = (alphainv >> i) & 1;
	}
	
        for (var j = 0; j < m; j++) {
		powers[j][0] <== added1[j];
		for (var k = 1; k < 256; k++)
		{
			powers[j][k] <== powers[j][k-1]*powers[j][k-1];
		}

		arr[j][0] <== powers[j][0] * bits[0];
		for (var k = 1; k < 256; k++)
		{
			arr[j][k] <== arr[j][k-1]+powers[j][k] * bits[k];
		}

		s_boxed2[j] <== arr[j][255];

        }

        // MDS
	lc=0;
        for (var i = 0; i < m; i++) {
            for (var j = 0; j < m; j++) {
		lc += MDS[i][j] * s_boxed1[j];
            }
		temp2[i] <== lc;
        }
        //state = temp;
	for (var i = 0; i < m; i++) {
		MDSed2[i]<==temp2[i];
	}


        // Constants
        for (var j = 0; j < m; j++) {
            new_state[j] <== MDSed2[j] + round_constants[r * 2 * m + m + j];
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
	var r=0;

    component permutation = RescueXLIXPermutationSingleRound(p, m, capacity, security_level, alpha, alphainv, N, MDS, round_constants,r);
	for (var i=0; i < 2; i++)
	{
		permutation.state[i] <== state[i];
	}

    // 这里可以添加其他逻辑或组件
}
component main=Main();*/