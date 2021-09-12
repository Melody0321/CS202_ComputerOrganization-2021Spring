`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 19:02:27
// Design Name: 
// Module Name: ioread
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


module ioread(reset,ior,switchctrl,ioread_data,ioread_data_switch);
input reset; // Reset signal
input ior; // I/O read signal from the controller
// The chip switch module chip selection obtained from memorio through the address high-end line
input switchctrl;
input[31:0] ioread_data_switch; // Read data from peripherals, here from the DIP switch
output[31:0] ioread_data; // Send the data from the peripheral to memorio
reg[31:0] ioread_data;
always @* begin
if(reset == 1)
ioread_data = 0;
else if(ior == 1)
if(switchctrl == 1) ioread_data = ioread_data_switch;
else ioread_data = ioread_data;
end
endmodule
