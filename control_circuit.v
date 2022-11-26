module control_circuit(opcode, Rwe, Rdst, ALUinB, ALUop, BR, DMwe, JP, Rwd, op_Rtype, op_Addi, op_Sw, op_Lw, op_J, op_Bne, op_Jal, op_Jr, op_Blt, op_Bex, op_Setx);

	//input
	input [4:0] opcode;
	
	//Internal wire
	wire [4:0] opcode;
	wire [2:0] op_Rtype_Tmp;
	wire [2:0] op_Addi_Tmp;
	wire [2:0] op_Sw_Tmp;
	wire [2:0] op_Lw_Tmp;
	wire or_Rwe_Tmp1, or_Rwe_Tmp2, or_Rwe_Tmp3;
	wire or_ALUinB_Tmp, or_ALUop_Tmp;

	//output
	output Rwe, Rdst, ALUinB, ALUop, BR, DMwe, JP, Rwd, op_Rtype, op_Addi, op_Sw, op_Lw, op_J, op_Bne, op_Jal, op_Jr, op_Blt, op_Bex, op_Setx;
	
	//op_Rtype 00000
	is_code is_Rtype(opcode, 5'b00000, op_Rtype);
	
	//op_Addi 00101
	is_code is_Addi(opcode, 5'b00101, op_Addi);
	
	//op_Sw 00111
	is_code is_Sw(opcode, 5'b00111, op_Sw);
	
	//op_Lw 01000
	is_code is_Lw(opcode, 5'b01000, op_Lw);
	
	//op_j 00001
	is_code is_j(opcode, 5'b00001, op_J);
	
	//op_bne 00010
	is_code is_bne(opcode, 5'b00010, op_Bne);
	
	//op_jal 00011
	is_code is_jal(opcode, 5'b00011, op_Jal);
	
	//op_jr 00100
	is_code is_jr(opcode, 5'b00100, op_Jr);
	
	//op_blt 00110
	is_code is_(opcode, 5'b00110, op_Blt);
	
	//op_bex 10110
	is_code is_bex(opcode, 5'b10110, op_Bex);
	
	//op_setx 10101
	is_code is_setx(opcode, 5'b10101, op_Setx);
	
	//Rwe = Rtype + Addi + Lw + Jal + Setx
	or or_Rwe_0(or_Rwe_Tmp1, op_Rtype, op_Addi);
	or or_Rwe_1(or_Rwe_Tmp2, or_Rwe_Tmp1, op_Lw);
	or or_Rwe_2(or_Rwe_Tmp3, or_Rwe_Tmp2, op_Jal);
	or or_Rwe_3(Rwe, or_Rwe_Tmp3, op_Setx);
	
	
	//Rdst = Rtype
	assign Rdst = op_Rtype;
	
	//ALUinB = Addi + Lw + Sw
	or or_ALUinB_0(or_ALUinB_Tmp, op_Addi, op_Lw);
	or or_ALUinB_1(ALUinB, or_ALUinB_Tmp, op_Sw);
	
	//ALUop = Bne + Blt + Bex
	or or_ALUop_0(or_ALUop_Tmp, op_Bne, op_Blt);
	or or_ALUop_1(ALUop, or_ALUop_Tmp, op_Bex);
	
	//BR = Bne + Blt
	or or_BR(BR, op_Bne, op_Blt);

	//DMwe = Sw
	assign DMwe = op_Sw;

	//JP = J + Jal
	or or_JP(JP, op_J, op_Jal);
	
	
	//Rwd = Lw
	assign Rwd = op_Lw;
	
endmodule
