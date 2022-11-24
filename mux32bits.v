module mux32bits(cout, a, b, cin);
	input[31:0] a;
	input[31:0] b;
	input cin;
	output[31:0] cout;
	
	assign cout = cin?a:b;
	
	
endmodule