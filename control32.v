`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/15 10:52:04
// Design Name: 
// Module Name: control32
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


module control32(Opcode,Function_opcode,Jr,RegDST,ALUSrc,RegWrite,MemWrite,Branch,nBranch,Jmp,Jal,I_format,Sftmd,ALUOp,Alu_resultHigh,MemorIOtoReg,MemRead,IORead,IOWrite);
input[5:0]   Opcode,Function_opcode;     
input[21:0] Alu_resultHigh;
output Jr,RegDST,ALUSrc,RegWrite,MemWrite,Branch,nBranch,Jmp,Jal,I_format,Sftmd,MemorIOtoReg,MemRead,IORead,IOWrite;
output[1:0]  ALUOp;
wire Lw,R_format;
assign R_format = (Opcode==6'b000000)?1'b1:1'b0;
assign RegDST = R_format;
assign Jal = (Opcode==6'b000011)?1'b1:1'b0;
assign Jr = (Opcode==6'b000000&&Function_opcode==6'b001000)?1'b1:1'b0;
assign Lw = (Opcode==6'b100011)?1'b1:1'b0;
assign I_format = (Opcode[5:3]==3'b001)?1'b1:1'b0;
assign RegWrite = (R_format||Lw||Jal||I_format)&&!(Jr);
assign Jmp  = (Opcode==6'b000010)?1'b1:1'b0;
assign Branch  = (Opcode==6'b000100)?1'b1:1'b0;
assign nBranch  = (Opcode==6'b000101)?1'b1:1'b0;
assign ALUOp = {(R_format||I_format),(Branch||nBranch)};
assign Sftmd = (((Function_opcode==6'b000000)||(Function_opcode==6'b000010)||(Function_opcode==6'b000011)||(Function_opcode==6'b000100)||(Function_opcode==6'b000110)||(Function_opcode==6'b000111))&& R_format)? 1'b1:1'b0;
assign MemRead = ((Opcode==6'b100011)&&Alu_resultHigh[21:0]!=22'h3FFFFF)?1'b1:1'b0;
assign MemWrite = ((Opcode==6'b101011)&&Alu_resultHigh[21:0]!=22'h3FFFFF)?1'b1:1'b0;
assign ALUSrc = (Opcode[5:3] == 3'b001||Opcode == 6'b100011||Opcode == 6'b101011)?1'b1:1'b0;
assign IOWrite = ((Opcode==6'b101011)&&Alu_resultHigh[21:0]==22'h3FFFFF)?1'b1:1'b0;
assign IORead = ((Opcode==6'b100011)&&Alu_resultHigh[21:0]==22'h3FFFFF)?1'b1:1'b0;
assign MemorIOtoReg = IORead||MemRead;
endmodule
