/*
* The is_code takes in several inputs from ALUop to get the instruciton.
 *
 * Inputs
 * ALUop: this is ALUop
 * Instrop: this is the real instruction code
 *
 * Outputs
 * OUTPUT: this is the output to decide if input is the objective instrcution 
*/

module is_code(
	//input ALUop and instruction code
	input [4:0] ALUop,
	input [4:0] Instrop,
	
	//output
	output OUTPUT);
	
	wire [4:0] opTMP;
	wire [2:0] outTMP;
	
	generate
		genvar index;
		for(index=0;index<5;index=index+1'b1)
        begin: codeCheck
				assign opTMP[index] = Instrop[index]?ALUop[index]:~ALUop[index];
        end
	endgenerate
	
	and and_0(outTMP[0], opTMP[0], opTMP[1]);
	and and_1(outTMP[1], opTMP[2], opTMP[3]);
	and and_2(outTMP[2], outTMP[0], outTMP[1]);
	and and_3(OUTPUT, opTMP[4], outTMP[2]);
endmodule
