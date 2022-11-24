module signExtension(immed, out);
	input[16:0] immed;
	output[31:0] out;

	// First 17 bits
	genvar i;
	generate
		for(i = 0; i <= 16; i = i + 1) begin: for1
			and and1(out[i], immed[i], immed[i]);
		end
	endgenerate

	// Last 15 bits
	genvar j;
	generate
		for(j = 17; j <= 31; j = j + 1) begin: for2
			and and2(out[j], immed[16], immed[16]);
		end
	endgenerate
endmodule
