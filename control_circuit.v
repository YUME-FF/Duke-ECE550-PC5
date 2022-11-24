module control_circuit(opcode, Rwe, Rdst, ALUinB, ALUop, BR, DMwe, JP, Rwd, op_Rtype, op_Addi, op_Sw, op_Lw);
	//input
	input [4:0] opcode;
	
	//Internal wire
	wire [4:0] opcode;
	wire [2:0] op_Rtype_Tmp;
	wire [2:0] op_Addi_Tmp;
	wire [2:0] op_Sw_Tmp;
	wire [2:0] op_Lw_Tmp;
	wire or_Rwe_Tmp;
	wire or_ALUinB_Tmp;
	
	//output
	output Rwe, Rdst, ALUinB, ALUop, BR, DMwe, JP, Rwd, op_Rtype, op_Addi, op_Sw, op_Lw;
	
	//op_Rtype 00000
	is_code is_Rtype(opcode, 5'b00000, op_Rtype);
	
	//op_Addi 00101
	is_code is_Addi(opcode, 5'b00101, op_Addi);
	
	//op_Sw 00111
	is_code is_Sw(opcode, 5'b00111, op_Sw);
	
	//op_Lw 01000
	is_code is_Lw(opcode, 5'b01000, op_Lw);
	
	
	//Rwe = Rtype + Addi + Lw
	or or_Rwe_0(or_Rwe_Tmp, op_Rtype, op_Addi);
	or or_Rwe_1(Rwe, or_Rwe_Tmp, op_Lw);
	
	//Rdst = Rtype
	assign Rdst = op_Rtype;
	
	//ALUinB = Addi + Lw + Sw
	or or_ALUinB_0(or_ALUinB_Tmp, op_Addi, op_Lw);
	or or_ALUinB_1(ALUinB, or_ALUinB_Tmp, op_Sw);
	
	//ALUop = Beq(Not in this checkpoint)
	assign ALUop = 1'b0;
	
	//BR = Beq(Not in this checkpoint)
	assign BR = 1'b0;
	
	//DMwe = Sw
	assign DMwe = op_Sw;
	
	//JP = J(Not in this checkpoint)
	assign JP = 1'b0;
	
	//Rwd = Lw
	assign Rwd = op_Lw;
	
endmodule
