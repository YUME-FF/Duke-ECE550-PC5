/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
	// Control signals
	clock,                          // I: The master clock
	reset,                          // I: A reset signal

	// Imem
	address_imem,                   // O: The address of the data to get from imem
	q_imem,                         // I: The data from imem

	// Dmem
	address_dmem,                   // O: The address of the data to get or put from/to dmem
	data,                           // O: The data to write to dmem
	wren,                           // O: Write enable for dmem
	q_dmem,                         // I: The data from dmem

	// Regfile
	ctrl_writeEnable,               // O: Write enable for regfile
	ctrl_writeReg,                  // O: Register to write to in regfile
	ctrl_readRegA,                  // O: Register to read from port A of regfile
	ctrl_readRegB,                  // O: Register to read from port B of regfile
	data_writeReg,                  // O: Data to write to for regfile
	data_readRegA,                  // I: Data from port A of regfile
	data_readRegB                   // I: Data from port B of regfile
	);
	// Control signals
	input clock, reset;

	// Imem
	output [11:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [11:0] address_dmem;
	output [31:0] data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
	//wire: PC
	wire[31:0] PC_INPUT, PC_OUTPUT, PCplusN_OUTPUT, PC_INPUT_TMP;
	wire isNotEqual_PC_Plus4, isLessThan_PC_Plus4, overflow_PC_Plus4;
	wire isNotEqual_PC_PlusN, isLessThan_PC_PlusN, overflow_PC_PlusN;

	//bne blt
	wire is_bne, is_blt, is_blt_tmp, is_bneblt, out_bneblt;

	wire[26:0] T;
	wire[31:0] T_extension;

	//wire: instruction format
	wire[31:0] instruction;
	wire [4:0] opcode, ALUopcode, RD, RS, RT, shamt;
	wire [16:0] Immediate;
	wire [31:0] Immediate_extension;

	//wire: register
	wire [31:0] reg_A, reg_B;

	//wire: control signal
	wire Rwe, Rdst, ALUinB, ALUop, BR, DMwe, JP, Rwd;

	//wire: operation being controlled
	wire op_Rtype, op_Addi, op_Sw, op_Lw;

	//wire: Rtype
	wire op_ADD, op_SUB, op_AND, op_OR, op_SLL, op_SRA;
	wire op_ADD_TMP, op_SUB_TMP, op_AND_TMP, op_OR_TMP, op_SLL_TMP, op_SRA_TMP;

	//wire: alu
	wire [31:0] aluOut;
	wire alu_isEqual, alu_lessThan, overflow;

	//wire: overflow->rstatus(the value in $r30)
	wire if_ovf, if_ovf_tmp;
	wire [31:0] rstatus;

	//wire: sw
	wire [31:0] dmem_out;
	wire wren, ctrl_writeEnable;

	//wire: J type and 2 I type
	wire op_J, op_Bne, op_Jal, op_Jr, op_Blt, op_Bex, op_Setx;

	//PC
	pc pc1(clock, reset, PC_INPUT, PC_OUTPUT);
	// NOTE: PC should plus one when update
	// TODO: change related naming (pcPlus4 -> pcPlus1)
	alu pcPlus4(PC_OUTPUT, 32'h00000001, 5'b00000,
		5'b00000, PC_INPUT_TMP, isNotEqual_PC_Plus4, isLessThan_PC_Plus4, overflow_PC_Plus4);
	alu pcPlusN(PC_INPUT_TMP, Immediate_extension, 5'b00000,
		5'b00000, PCplusN_OUTPUT, isNotEqual_PC_PlusN, isLessThan_PC_PlusN, overflow_PC_PlusN);

	//is_bne
	and is_bne0(is_bne, op_Bne, alu_isEqual);

	//is_blt
	and is_blt0(is_blt_tmp, op_Blt, ~alu_lessThan);
	and is_blt1(is_blt, is_blt_tmp, alu_isEqual);

	or is_bneblt0(is_bneblt, is_blt, is_bne);

	assign out_bneblt = is_bneblt ? PCplusN_OUTPUT : PC_INPUT_TMP;

	//is_bex
	and is_bex0(is_bex, op_Bex, alu_isEqual);
	//jr -> PC_INPUT = regfile_dataB
	//bne or blt -> PC_INPUT = PCplusN_OUTPUT
	// other j types and bex -> PC_INPUT =
	assign PC_INPUT = op_Jr ? reg_B : JP?T_extension : is_bex ? T_extension : out_bneblt;


	//imem
	assign address_imem = PC_OUTPUT[11:0];
	assign instruction = q_imem;

	//Instruction
	assign T = instruction[26:0];
	assign T_extension = {5'd0,T};
	assign opcode = instruction[31:27];
	assign RS = instruction[21:17];
	assign RT = instruction[16:12];
	assign shamt = op_Rtype?instruction[11:7]:5'b00000;
	assign ALUopcode = op_Rtype? instruction[6:2]: ALUop? 5'b00001:5'b00000;//instruction[6:2];

	//control signal assignment
	control_circuit controlCircuit(opcode, Rwe, Rdst, ALUinB, ALUop, BR, DMwe, JP, Rwd, op_Rtype, op_Addi, op_Sw, op_Lw, op_J, op_Bne, op_Jal, op_Jr, op_Blt, op_Bex, op_Setx);

	//overflow -> rstatus
	assign rstatus = op_ADD?32'd1:(op_SUB?32'd3:op_Addi?32'd2:32'd0);

	//Add 00000
	is_code is_Add(ALUopcode, 5'b00000, op_ADD_TMP);
	and and_isadd(op_ADD, op_ADD_TMP, op_Rtype);

	//Sub 00001
	is_code is_Sub(ALUopcode, 5'b00001, op_SUB_TMP);
	and and_is_Sub(op_SUB, op_SUB_TMP, op_Rtype);

	//is_Add || is_Sub || is_Addi -> It is possible for them overflow
	or if_ovf0(if_ovf_tmp, op_ADD, op_SUB);
	or if_ovf1(if_ovf, if_ovf_tmp, op_Addi);

	//if overflow -> $r[5'd30] = data_writeReg (see details in regfile)
	//if op_Jal -> $r[5'd31] = data_writeReg (see details in regfile)
	//if op_Setx -> $r[5'd30] = data_writeReg (see details in regfile)
	assign RD =  op_Jal?5'd31:op_Setx?5'd30:if_ovf?(overflow?5'd30:instruction[26:22]):instruction[26:22];

	//extend immediate to 32 bit
	assign Immediate = instruction[16:0];
	signExtension se(Immediate, Immediate_extension);

	// Regfile
	assign ctrl_writeEnable = Rwe; //add addi lw
	assign ctrl_writeReg = RD;
	assign ctrl_readRegA = op_Bex?5'd0:RS;

	//if 5'd30 -? check $r[5'd30]
	//if Rtype, then instruction[16:12], otherwise instruction[26:22]
	assign ctrl_readRegB = op_Bex?5'd30:Rdst?RT:instruction[26:22];
	assign data_writeReg = op_Jal?PC_INPUT_TMP:op_Setx?T_extension:op_Lw? dmem_out:if_ovf?(overflow?rstatus:aluOut):aluOut;
	assign reg_A = data_readRegA;
	assign reg_B = ALUinB?Immediate_extension: data_readRegB;

	//get aluOut
	alu alu_main(reg_A, reg_B, ALUopcode, shamt, aluOut, alu_isEqual, alu_lessThan, overflow);

	// Dmem
	assign address_dmem = aluOut[11:0];
	assign data = data_readRegB;
	assign wren = DMwe;

	assign dmem_out = q_dmem;

endmodule
