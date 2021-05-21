`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/15 11:37:12
// Design Name: 
// Module Name: Executs32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Executs32(Read_data_1,Read_data_2,Imme_extend,Function_opcode,opcode,ALUOp,Shamt,ALUSrc,I_format,Zero,Sftmd,ALU_Result,Addr_Result,PC_plus_4,Jr);
input[31:0]  Read_data_1,Read_data_2,Imme_extend;
input[5:0]   Function_opcode,opcode;
input[1:0]   ALUOp;
input[4:0]   Shamt;
input Sftmd,ALUSrc,I_format,Jr;
input[31:0]  PC_plus_4;  //from ifetch's branch_base_addr
output reg Zero;       //In ALU,Zero is determined by ALU_output_mux, not ALU_Result
output reg[31:0] ALU_Result;
output[31:0]Addr_Result; 
wire[31:0] Ainput,Binput;
wire[5:0] Exe_code;
wire[2:0] ALU_ctl,Sftm;
reg[31:0] ALU_output_mux,Shift_Result;
wire[32:0] Branch_Addr;
assign Ainput = Read_data_1;
assign Binput =(ALUSrc==0)? Read_data_2:{16'h0000,Imme_extend[15:0]};
assign Exe_code = (I_format==0)?Function_opcode:{3'b000,opcode[2:0]};
assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
assign Addr_Result = (PC_plus_4>>2)+Imme_extend;
always @(ALU_ctl or Ainput or Binput)
begin
case(ALU_ctl)
3'b000:ALU_output_mux=Ainput&Binput;
3'b001:ALU_output_mux=Ainput|Binput;
3'b010:ALU_output_mux=Ainput+Binput;
3'b011:ALU_output_mux=Ainput+Binput;
3'b100:ALU_output_mux=Ainput^Binput;
3'b101:ALU_output_mux=~(Ainput|Binput);
3'b110:ALU_output_mux=Ainput-Binput;
3'b111:ALU_output_mux=Ainput-Binput;
default:ALU_output_mux = 32'h00000000;
endcase
end

assign Sftm = Function_opcode[2:0];
always @* begin // six types of shift instructions
if(Sftmd)
case(Sftm[2:0])
3'b000:Shift_Result = Binput << Shamt;
3'b010:Shift_Result = Binput >> Shamt; 
3'b100:Shift_Result = Binput << Ainput;
3'b110:Shift_Result = Binput >> Ainput; 
3'b011:Shift_Result = $signed(Binput) >>> Shamt; 
3'b111:Shift_Result = $signed(Binput) >>> Ainput; 
default:Shift_Result = Binput;
endcase
else
Shift_Result = Binput;
end


always @(*) 
begin
if(((ALU_ctl==3'b111) && (Exe_code[3]==1))||((ALU_ctl[2:1]==2'b11) && (I_format==1)))
 ALU_Result = $signed(Ainput)<$signed(Binput);
else if((ALU_ctl==3'b101) && (I_format==1))
ALU_Result[31:0]={Binput[15:0],{16{1'b0}}};
//shift operation
else if(Sftmd==1)
ALU_Result = Shift_Result ;
else
ALU_Result = ALU_output_mux[31:0];
end

always@(*)
begin
Zero = (ALU_output_mux==0)?1'b1:1'b0;
end
endmodule
