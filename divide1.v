`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 23:10:24
// Design Name: 
// Module Name: divide1
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


module divide1(clk,rst,clkout); 
input clk;
input rst;
output clkout;
reg clkout;
reg [31:0] cnt;
parameter period = 200000;
always @(posedge clk or posedge rst)
begin
 if(rst)
 begin
 cnt <= 0;
 clkout<=0;
 end
 else 
 begin
 if(cnt == (period>>1)-1)
 begin
 clkout<=~clkout;
 cnt<=0;
 end
 else
 cnt<=cnt+1;
 end
 end
endmodule
