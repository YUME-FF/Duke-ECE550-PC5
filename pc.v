module pc(clock, reset, PC_INPUT, PC_OUTPUT);
   //Inputs
	input clock, reset;
	input [31:0] PC_INPUT;
	
	//Output
	output [31:0] PC_OUTPUT;
	
	
	//pc update
	dffe_ref DFFE(PC_OUTPUT, PC_INPUT, clock, 1'b1, reset);
	
endmodule
