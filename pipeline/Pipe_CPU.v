`timescale 1ns / 1ps
/*******************************************************************
 * Create Date: 	2016/05/03
 * Design Name: 	Pipeline CPU
 * Module Name:		Pipe_CPU 
 * Project Name: 	Architecture Project_3 Pipeline CPU
 
 * Please DO NOT change the module name, or your'll get ZERO point.
 * You should add your code here to complete the project 3.
 ******************************************************************/
module Pipe_CPU(
        clk_i,
		rst_i
		);
    
/****************************************
*            I/O ports                  *
****************************************/
input clk_i;
input rst_i;

/****************************************
*          Internal signal              *
****************************************/

/**** IF stage ****/
//control signal...
wire [32-1:0] mux_pc_result_w;
wire [32-1:0] pc_addr_w;
wire [32-1:0] add1_source_w;
assign add1_source_w = 32'd4;
wire [32-1:0] add1_result_w;
wire [32-1:0] instr_w;

wire [64-1:0] IF_ID_Reg;
wire [5-1:0] IF_IDRegisterRs, IF_IDRegisterRt, IF_IDRegisterRd;
wire [32-1:0] IF_ID_pc;
assign IF_IDRegisterRs = IF_ID_Reg[25:21];
assign IF_IDRegisterRt = IF_ID_Reg[20:16];
assign IF_IDRegisterRd = IF_ID_Reg[15:11];
assign IF_ID_pc = IF_ID_Reg[63:32];

/**** ID stage ****/
//control signal...
wire [2-1:0] IF_ID_WB;
wire [3-1:0] IF_ID_M;
wire [5-1:0] IF_ID_EX;
wire [32-1:0] IF_ID_rs_data_w;
wire [32-1:0] IF_ID_rt_data_w;
wire [32-1:0] IF_ID_signExtend_sig;

wire [153-1:0] ID_EX_Reg;
wire [2-1:0] ID_EX_WB;
wire [3-1:0] ID_EX_M;
wire [5-1:0] ID_EX_EX;
wire [32-1:0] ID_EX_pc;
wire [32-1:0] ID_EX_rs_data_w;
wire [32-1:0] ID_EX_rt_data_w;
wire [32-1:0] ID_EX_signExtend_sig;
wire [5-1:0] ID_EXRegisterRs, ID_EXRegisterRt, ID_EXRegisterRd;

assign ID_EX_WB = ID_EX_Reg[152:151];
assign ID_EX_M = ID_EX_Reg[150:148];
assign ID_EX_EX = ID_EX_Reg[147:143];
assign ID_EX_pc = ID_EX_Reg[142:111];
assign ID_EX_rs_data_w = ID_EX_Reg[110:79];
assign ID_EX_rt_data_w = ID_EX_Reg[78:47];
assign ID_EX_signExtend_sig = ID_EX_Reg[46:15];
assign ID_EXRegisterRs = ID_EX_Reg[14:10];
assign ID_EXRegisterRt = ID_EX_Reg[9:5];
assign ID_EXRegisterRd = ID_EX_Reg[4:0];


/**** EX stage ****/
//control signal...
wire [2-1:0] ForwardA, ForwardB;
wire [32-1:0] ShiftLeftSig;
wire [32-1:0] mux_rs_result;
wire [32-1:0] mux2_rt_result;
wire [32-1:0] mux3_rt_result;
wire [5-1:0] mux_rd_result;
wire [4-1:0] alu_control_w;
wire zero;
wire [32-1:0] alu_result_w;
wire [32-1:0] add2_sum_w;

wire [107-1:0] EX_MEM_Reg;
wire [2-1:0] EX_MEM_WB;
wire [3-1:0] EX_MEM_M;
wire [32-1:0] EX_MEM_pc_sum;
wire EX_MEM_zero;
wire [32-1:0] EX_MEM_DataAddr;
wire [32-1:0] EX_MEM_WriteData;
wire [5-1:0] EX_MEMRegisterRd;

assign EX_MEM_WB = EX_MEM_Reg[106:105];
assign EX_MEM_M = EX_MEM_Reg[104:102];
assign EX_MEM_pc_sum = EX_MEM_Reg[101:70];
assign EX_MEM_zero = EX_MEM_Reg[69];
assign EX_MEM_DataAddr = EX_MEM_Reg[68:37];
assign EX_MEM_WriteData = EX_MEM_Reg[36:5];
assign EX_MEMRegisterRd = EX_MEM_Reg[4:0];

/**** MEM stage ****/
//control signal...
wire and_result_w;
wire [32-1:0] EX_MEM_ReadData;

wire [71-1:0] MEM_WB_Reg;
wire [2-1:0] MEM_WB_WB;
wire [32-1:0] MEM_WB_ReadData;
wire [32-1:0] MEM_WB_DataAddr;
wire [5-1:0] MEM_WBRegisterRd;

assign MEM_WB_WB = MEM_WB_Reg[70:69];
assign MEM_WB_ReadData = MEM_WB_Reg[68:37];
assign MEM_WB_DataAddr = MEM_WB_Reg[36:5];
assign MEM_WBRegisterRd = MEM_WB_Reg[4:0];

/**** WB stage ****/
//control signal...
wire [32-1:0] mux_dataMem_result_w;

/**** Data hazard ****/
//control signal...


/****************************************
*       Instantiate modules             *
****************************************/
//Instantiate the components in IF stage
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(mux_pc_result_w) ,   
	    .pc_out_o(pc_addr_w) 
	    );

Instr_Memory IM(	//Instructions
        .pc_addr_i(pc_addr_w),  
	    .instr_o(instr_w)    
	    );
			
Adder Add_pc(
		.src1_i(pc_addr_w),     
	    .src2_i(add1_source_w),     
	    .sum_o(add1_result_w)
		);

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(add1_result_w),
        .data1_i(EX_MEM_pc_sum),
        .select_i(and_result_w),
        .data_o(mux_pc_result_w)
        );

		
Pipe_Reg #(.size(64)) IF_ID(       
		.rst_i(rst_i),
		.clk_i(clk_i),
		.data_i({add1_result_w, instr_w}),
		.data_o(IF_ID_Reg)
		);
		
//Instantiate the components in ID stage
Reg_File RF(
        .clk_i(clk_i),
		.rst_i(rst_i),
		.RSaddr_i(IF_IDRegisterRs) ,
		.RTaddr_i(IF_IDRegisterRt) ,
		.RDaddr_i(MEM_WBRegisterRd) ,
		.RDdata_i(mux_dataMem_result_w),
		.RegWrite_i(MEM_WB_WB[1]),
		.RSdata_o(IF_ID_rs_data_w) ,
		.RTdata_o(IF_ID_rt_data_w)
        );

Decoder Decoder(
        .instr_op_i(IF_ID_Reg[31:26]), 
	    .RegWrite_o(IF_ID_WB[1]), 
	    .ALU_op_o(IF_ID_EX[3:1]),   
	    .ALUSrc_o(IF_ID_EX[0]),   
	    .RegDst_o(IF_ID_EX[4]),   
		.Branch_o(IF_ID_M[2]), 
		.MemWrite_o(IF_ID_M[0]),
		.MemRead_o(IF_ID_M[1]),
		.MemtoReg_o(IF_ID_WB[0])
	    );

Sign_Extend Sign_Extend(
		.data_i(IF_ID_Reg[15:0]),
        .data_o(IF_ID_signExtend_sig)
        );	

Pipe_Reg #(.size(153)) ID_EX(
		.rst_i(rst_i),
		.clk_i(clk_i),
		.data_i({IF_ID_WB,IF_ID_M,IF_ID_EX,IF_ID_pc,IF_ID_rs_data_w,IF_ID_rt_data_w,IF_ID_signExtend_sig,IF_IDRegisterRs,IF_IDRegisterRt,IF_IDRegisterRd}),
		.data_o(ID_EX_Reg)
		);
		
//Instantiate the components in EX stage	   
ALU ALU(
		.src1_i(mux_rs_result),
	    .src2_i(mux2_rt_result),
	    .ctrl_i(alu_control_w),
	    .result_o(alu_result_w),
		.zero_o(zero)
		);
		
ALU_Ctrl ALU_Control(
		.funct_i(ID_EX_signExtend_sig[5:0]),   
        .ALUOp_i(ID_EX_EX[3:1]),   
        .ALUCtrl_o(alu_control_w) 
		);

MUX_2to1 #(.size(32)) Mux1(
		.data0_i(mux3_rt_result),
        .data1_i(ID_EX_signExtend_sig),
        .select_i(ID_EX_EX[0]),
        .data_o(mux2_rt_result)
        );

MUX_2to1 #(.size(5)) Mux2(
		.data0_i(ID_EXRegisterRt),
        .data1_i(ID_EXRegisterRd),
        .select_i(ID_EX_EX[4]),
        .data_o(mux_rd_result)
        );
		
MUX_3to1 #(.size(32)) Mux3_Rs(
		.data0_i(ID_EX_rs_data_w),
        .data1_i(mux_dataMem_result_w),
	    .data2_i(EX_MEM_DataAddr),
        .select_i(ForwardA),
        .data_o(mux_rs_result)
        );

MUX_3to1 #(.size(32)) Mux3_Rt(
		.data0_i(ID_EX_rt_data_w),
        .data1_i(mux_dataMem_result_w),
	    .data2_i(EX_MEM_DataAddr),
        .select_i(ForwardB),
        .data_o(mux3_rt_result)
        );		
		
ForwardinUnit ForwardUnit(
		.EX_MEMRegWrite(EX_MEM_WB[1]),
		.MEM_WBRegWrite(MEM_WB_WB[1]),
		.EX_MEMRegisterRd(EX_MEMRegisterRd),
		.MEM_WBRegisterRd(MEM_WBRegisterRd),
		.ID_EXRegisterRs(ID_EXRegisterRs),
		.ID_EXRegisterRt(ID_EXRegisterRt),
		.ForwardA(ForwardA),
		.ForwardB(ForwardB)
		);

Adder Add_result(
		.src1_i(ID_EX_pc),     
	    .src2_i(ShiftLeftSig),     
	    .sum_o(add2_sum_w)
		);

Shift_Left_Two_32 Shifter(
        .data_i(ID_EX_signExtend_sig),
        .data_o(ShiftLeftSig)
        ); 

Pipe_Reg #(.size(107)) EX_MEM(
		.rst_i(rst_i),
		.clk_i(clk_i),
		.data_i({ID_EX_WB, ID_EX_M, add2_sum_w, zero, alu_result_w, mux3_rt_result, mux_rd_result}),
		.data_o(EX_MEM_Reg)
		);

//Instantiate the components in MEM stage
and BranchOrNot(
		and_result_w,
		EX_MEM_M[2],
		EX_MEM_zero
		);

Data_Memory DM(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.addr_i(EX_MEM_DataAddr),
		.data_i(EX_MEM_WriteData),
		.MemRead_i(EX_MEM_M[1]),
		.MemWrite_i(EX_MEM_M[0]),
		.data_o(EX_MEM_ReadData)
	    );

Pipe_Reg #(.size(71)) MEM_WB(
        .rst_i(rst_i),
		.clk_i(clk_i),
		.data_i({EX_MEM_WB, EX_MEM_ReadData, EX_MEM_DataAddr, EX_MEMRegisterRd}),
		.data_o(MEM_WB_Reg)
		);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) MEMToRegMux(
		.data0_i(MEM_WB_DataAddr),
        .data1_i(MEM_WB_ReadData),
        .select_i(MEM_WB_WB[0]),
        .data_o(mux_dataMem_result_w)
        );
/*
MUX_3to1 #(.size()) Mux3(

        );
*/
/****************************************
*         Signal assignment             *
****************************************/
	
endmodule

