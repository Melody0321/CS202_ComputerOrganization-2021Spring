`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 19:54:49
// Design Name: 
// Module Name: Ifetc32
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


module Ifetc32(Instruction,branch_base_addr,Addr_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jr,Zero,clock,reset,link_addr,pco,Next_PC);
input[31:0] Addr_result,Read_data_1;
input Branch,nBranch,Jmp,Jal,Jr,Zero,clock,reset;
output[31:0] Instruction,branch_base_addr,pco;
output reg[31:0]link_addr;
reg[31:0] PC;
output reg [31:0]Next_PC;
assign branch_base_addr = PC+4;
assign pco = PC;
prgrom instmem(
.clka(clock),
.addra(PC[15:2]),
.douta(Instruction)
);

always @* begin
if(((Branch == 1) && (Zero == 1 )) || ((nBranch == 1) && (Zero == 0))) 
Next_PC = Addr_result*4;
else if(Jr == 1)
Next_PC = Read_data_1*4;
else Next_PC = PC+4;
end


always @(negedge clock) 
begin
if(reset == 1)
PC <= 32'h0000_0000;
else if((Jmp == 1) || (Jal == 1)) 
PC <= {4'b0000,Instruction[25:0],2'b00};
else PC <= Next_PC;
end



 always@(Jal or Jmp)
 begin
 if(Jal==1||Jmp==1)
 link_addr = (PC + 4)/4;
 end


endmodule