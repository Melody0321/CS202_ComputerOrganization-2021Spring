`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/08 19:04:53
// Design Name: 
// Module Name: dmemory32
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


module dmemory32(read_data,address,write_data,Memwrite,clock);
input clock;
input[31:0] address;
input Memwrite;
input[31:0] write_data;
output[31:0] read_data;
wire clk;
assign clk = !clock;
RAM ram (
.clka(clk), // 
.wea(Memwrite), // 
.addra(address[15:2]), // 
.dina(write_data), // 
.douta(read_data) // 
);
endmodule
