`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 21:09:26
// Design Name: 
// Module Name: MemOrIO
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


module MemOrIO( mRead, mWrite, ioRead, ioWrite,addr_in, addr_out, m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl, SwitchCtrl);
input mRead; // read memory, from control32
input mWrite; // write memory, from control32
input ioRead; // read IO, from control32
input ioWrite; // write IO, from control32
input[31:0] addr_in; // from alu_result in executs32
output[31:0] addr_out; // address to memory
input[31:0] m_rdata; // data read from memory
input[31:0] io_rdata; // data read from io,16 bits
output[31:0] r_wdata; // data to idecode32(register file)
input[31:0] r_rdata; // data read from idecode32(register file)
output reg[31:0] write_data; // data to memory or I/O£¨m_wdata, io_wdata£©
output LEDCtrl; // LED Chip Select
output SwitchCtrl; // Switch Chip Select

assign addr_out= addr_in;
// The data wirte to register file may be from memory or io.
 // While the data is from io, it should be the lower 16bit of r_wdata. 
assign r_wdata = (mRead==1)?m_rdata:io_rdata;
// Chip select signal of Led and Switch are all active high;
assign LEDCtrl= ioWrite;
assign SwitchCtrl= ioRead;
always @* begin
if((mWrite==1)||(ioWrite==1))
    write_data=r_rdata;
else
write_data = 32'hZZZZZZZZ;
end
endmodule