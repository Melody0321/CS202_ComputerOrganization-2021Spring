`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/10 01:09:17
// Design Name: 
// Module Name: Idecode32
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


module Idecode32(read_data_1,read_data_2,Instruction,read_data,ALU_result,Jal,RegWrite,MemorIOtoReg,RegDst,imme_extend,clock,reset,opcplus4);
input[31:0] Instruction,read_data,ALU_result,opcplus4;
input Jal,RegWrite,MemorIOtoReg,RegDst,clock,reset;
output[31:0] read_data_1,read_data_2;
output reg[31:0] imme_extend;
wire[4:0] rs,rt,rd,write_ds;
wire[15:0] immediate;
wire[31:0] data;
reg[31:0] register[0:31];
assign immediate = Instruction[15:0];
assign rs = Instruction[25:21];
assign rt = Instruction[20:16];
assign rd = Instruction[15:11];
assign read_data_1 = register[rs];
assign read_data_2 = register[rt];
assign write_ds = RegDst==1? rd:rt;
assign data = MemorIOtoReg==1?read_data:ALU_result;

always@(*)
begin
if(Instruction[15]==0)
imme_extend = {{16{1'b0}},immediate};
else
imme_extend = {{16{1'b1}},immediate};
end

integer t;
always@(posedge clock)
begin
if(!reset)
begin
 if(RegWrite)
    begin
    if(Jal)
    begin
    register[31]<=opcplus4;
    end
    else
    register[write_ds]<=data;
    end
  end
else
 begin
 for(t=0;t<32;t=t+1)
 register[t]<=0;
 end
end
endmodule
