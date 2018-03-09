//Subject:     Architecture project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter
`define ADD 6'h20
`define SUB 6'h22
`define AND 6'h24
`define OR 6'h25
`define SLT 6'h2a

//Select exact operation, please finish the following code
always@(funct_i or ALUOp_i) begin
    case(ALUOp_i)
		3'b000: //lw or sw or ADDi
			begin
				ALUCtrl_o = 4'b0010;
			end
		3'b001:	//beq
			begin
				ALUCtrl_o = 4'b0110;
			end
        3'b010: //R-type
            begin
                case(funct_i)
					`ADD:  begin
						ALUCtrl_o = 4'b0010;	//ADD
					end
					`SUB: begin
						ALUCtrl_o = 4'b0110;	//SUB
					end
                    `AND: begin 
						ALUCtrl_o = 4'b0000; // AND
					end
					`OR: begin
						ALUCtrl_o = 4'b0001;	// OR
					end
					`SLT: begin 
						ALUCtrl_o = 4'b0111; //SET ON LESS THAN
					end
                    default: ALUCtrl_o = 4'b1111;
                endcase
            end
		3'b011: //SET-ON-LESS-THAN-IMMEDIATE
			begin
				ALUCtrl_o = 4'b0111;
			end
		default:	ALUCtrl_o = 4'b1111;
    endcase
end
endmodule
