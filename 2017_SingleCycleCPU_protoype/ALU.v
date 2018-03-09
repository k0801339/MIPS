//Subject:     Architecture project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter
`define And 4'b0000
`define Or 4'b0001
`define Add 4'b0010
`define Sub 4'b0110
`define Slt 4'b0111

//Main function
	assign zero_o = (src1_i==src2_i)? 1:0;
	
	always@(*) begin
		case(ctrl_i)
			`And: begin	
				result_o = src1_i & src2_i;
			end
			`Or: begin
				result_o = src1_i | src2_i;
			end
			`Add: begin
				result_o = src1_i + src2_i;
			end
			`Sub: begin 	
				result_o = src1_i - src2_i;
			end
			`Slt: begin
				result_o = ($signed(src1_i)<$signed(src2_i))? 1:0 ;
			end
			default: begin
				
			end
		endcase
	end
endmodule