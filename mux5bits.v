module mux5bits(cout, a, b, cin);
	input[4:0] a;
	input[4:0] b;
	input cin;
	output[4:0] cout;
	
	assign cout = cin?a:b;
	
	
endmodule