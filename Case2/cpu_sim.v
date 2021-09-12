`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 22:27:33
// Design Name: 
// Module Name: cpu_sim
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


module cpu_sim(

    );
    reg clk;
    reg rst;
    reg [23:0]switch;
    wire [23:0]led;
    
    
    wire[31:0]Add_Result;
    wire[31:0]Sign_extend;
    wire [31:0]PC;
    wire[31:0]Next_PC;
    wire Zero;
    wire [31:0]write_data;
    wire[31:0]ALU_Result;
    wire[31:0]Read_data_2;
    wire IOWrite;
    wire [31:0]Instruction;
    
    
    
    wire [7:0] DIG;
    wire  [7:0] Y;
    cpu ucpu(clk,rst,switch,led,DIG,Y,Add_Result,Sign_extend,PC,Next_PC,Zero,write_data,ALU_Result,Read_data_2,IOWrite,Instruction);
    
    always #5 clk=~clk;
    initial begin
    switch[15:0]={8'b0000_0000,8'b0000_0010};
    switch[23:16]=1;
    clk=1'b0;
    rst=1'b1;
    
    #2 rst=1'b0;
    
    #300
    switch[23:16]=2;
    #300 
    
    switch[23:16]=3;
    
    
    end
    
    
    
endmodule
