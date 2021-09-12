`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 21:02:41
// Design Name: 
// Module Name: dmeo_tb
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

module dmeo_tb( );
reg clock = 1'b0;
reg memWrite = 1'b0;
reg [31:0] addr = 32'h0000_0010;
reg [31:0] writeData = 32'ha000_0000;
wire [31:0] readData;
dmemory32 uram
(readData,addr,writeData,memWrite,clock);
always
#50 clock = ~clock;
initial begin
#200
writeData = 32'h0000_00f5;
memWrite = 1'b1;
#200
memWrite = 1'b0;
end
endmodule
