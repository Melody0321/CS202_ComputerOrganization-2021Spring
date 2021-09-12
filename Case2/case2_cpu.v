`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 21:31:42
// Design Name: 
// Module Name: cpu
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


module cpu(
clk,
rst,
switch2N4/*,
led2N4*/,DIG,Y);
input clk;//
input rst;
input[18:0] switch2N4;
/*output*/ wire [16:0]led2N4;



wire clock;

wire [31:0]Instruction; 
wire [31:0]PC_plus_4_out;
wire [31:0]Add_Result; 
wire [31:0]Read_data_1; 
wire Branch,nBranch,Jmp,Jal,Jrn;
wire Zero;
wire [31:0]opcplus4;
wire [31:0] next_PC;
wire [31:0]PC;
//
wire [31:0] Read_data_2; 
wire [31:0] read_data;
wire RegWrite; 
wire RegDst; 
wire [31:0]Sign_extend;

//
wire ALUSrc; 
wire MemorIOtoReg; 
wire MemRead; 
wire MemWrite;
wire IORead;
wire IOWrite;
wire I_format;
wire Sftmd;
wire [1:0]ALUOp;
//
wire [4:0]Shamt;
wire [31:0]ALU_Result; 
wire[31:0] read_data_fromMemory; 
wire[31:0] address; 
wire[31:0] write_data; 
wire [31:0]ioread_data;
wire switchcs;
wire [1:0]switchaddr; 
wire [31:0]switchrdata; 
wire [23:0]switch_i;

wire ledcs;
wire [1:0]ledaddr;     
wire[31:0]Next_PC; 
wire clkout;          


cpuclk cpuclk (
.clk_in1(clk),
.clk_out1(clock));

Ifetc32 ifetch(
.Instruction(Instruction),.branch_base_addr(PC_plus_4_out),.Addr_result(Add_Result),.Read_data_1(Read_data_1),.Branch(Branch),.nBranch(nBranch),.Jmp(Jmp),.Jal(Jal),
.Jr(Jrn),.Zero(Zero),.clock(clock),.reset(rst),.link_addr(opcplus4),.pco(PC),.Next_PC(Next_PC)
);

Idecode32 idecode(
.read_data_1(Read_data_1),.read_data_2(Read_data_2),.Instruction(Instruction),.read_data(read_data),
.ALU_result(ALU_Result),.Jal(Jal),.RegWrite(RegWrite),.MemorIOtoReg(MemorIOtoReg),.RegDst(RegDst),
.imme_extend(Sign_extend),.clock(clock),.reset(rst),.opcplus4(opcplus4)
);


control32 control(
.Opcode(Instruction[31:26]),.Function_opcode(Instruction[5:0]),.Alu_resultHigh(ALU_Result[31:10]),.Jr(Jrn),.RegDST(RegDst),.ALUSrc(ALUSrc),
.MemorIOtoReg(MemorIOtoReg),.RegWrite(RegWrite),.MemRead(MemRead),.MemWrite(MemWrite),.IORead(IORead),.IOWrite(IOWrite),.Branch(Branch),.nBranch(nBranch),
.Jmp(Jmp),.Jal(Jal),.I_format(I_format),.Sftmd(Sftmd),.ALUOp(ALUOp)
);
//finish

Executs32 execute(
.Read_data_1(Read_data_1),.Read_data_2(Read_data_2),.Imme_extend(Sign_extend),.Function_opcode(Instruction[5:0]),    //好几个都是instruction的部
.opcode(Instruction[31:26]),.ALUOp(ALUOp),.Shamt(Instruction[10:6]),    
.ALUSrc(ALUSrc),.I_format(I_format),
.Zero(Zero),.Jr(Jrn),.Sftmd(Sftmd),.ALU_Result(ALU_Result),    
.Addr_Result(Add_Result),.PC_plus_4(PC_plus_4_out)
);
//finish


dmemory32 memory(.read_data(read_data_fromMemory),.address(address),
.write_data(write_data),.Memwrite(MemWrite),.clock(clock)
//不是直接来自idecode,而是先从memorio里经过wdata变成write_data
);
//finish
MemOrIO memio(.addr_in(ALU_Result),.mRead(MemRead),.mWrite(MemWrite),
.ioRead(IORead),.ioWrite(IOWrite),.m_rdata(read_data_fromMemory),
.io_rdata(ioread_data),.r_rdata(Read_data_2),.r_wdata(read_data),
.write_data(write_data),.addr_out(address),.LEDCtrl(ledcs),.SwitchCtrl(switchcs)
//read_data,idecode的
);
//finish

ioread multiioread(
.reset(rst),.ior(IORead),.switchctrl(switchcs),
.ioread_data(ioread_data),.ioread_data_switch(switchrdata)
);
//finish


switchs switch24(
.switclk(clock),.switrst(rst),.switchread(IORead),.switchcs(switchcs),
.switchrdata(switchrdata),.switch_i(switch2N4)

);
//finish

leds led24(
.led_clk(clock),
.ledrst(rst),
.ledwrite(IOWrite),
.ledcs(ledcs),
.ledwdata(write_data[23:0]),
.ledout(led2N4)
);


//finish


output wire  [7:0] DIG;
output wire [7:0] Y;
reg [6:0] Y_r;
reg [7:0] DIG_r;
assign Y = {1'b1,(~Y_r[6:0])};
assign DIG = ~DIG_r;
reg [2:0] scan;
always @(posedge clkout or posedge rst)
begin
if(rst)
scan <= 0;
else begin
scan <= scan +1;
if(scan == 3'd7) scan <= 0;
end
end
always@(scan)
begin
case (scan)
 0:DIG_r = 8'b0000_0001;
 1:DIG_r = 8'b0000_0010;
 2:DIG_r = 8'b0000_0100;
 3:DIG_r = 8'b0000_1000;
 4:DIG_r = 8'b0001_0000;
 5:DIG_r = 8'b0010_0000;
 6:DIG_r = 8'b0100_0000;
 7:DIG_r = 8'b1000_0000;
 default: DIG_r = 8'b0000_0000;
 endcase
end
always@(scan)
begin
case (scan)
 0:
 begin
 case(led2N4[0])
           0:Y_r = 7'b0111111;//0
           1:Y_r = 7'b0110000;//1
           default:Y_r = 7'b1111111;
 endcase
 end
  1:
 begin
 case(led2N4[1])
           0:Y_r = 7'b0111111;//0
           1:Y_r = 7'b0110000;//1
           default:Y_r = 7'b1111111;
 endcase
 end
  2:
 begin
 case(led2N4[2])
           0:Y_r = 7'b0111111;//0
           1:Y_r = 7'b0110000;//1
           default:Y_r = 7'b1111111;
 endcase
 end
  3:
 begin
 case(led2N4[3])
           0:Y_r = 7'b0111111;//0
           1:Y_r = 7'b0110000;//1
           default:Y_r = 7'b1111111;
 endcase
 end
  4:
 begin
 case(led2N4[4])
           0:Y_r = 7'b0111111;//0
           1:Y_r = 7'b0110000;//1
           default:Y_r = 7'b1111111;
 endcase
 end
  5:
 begin
 case(led2N4[5])
           0:Y_r = 7'b0111111;//0
           1:Y_r = 7'b0110000;//1
           default:Y_r = 7'b1111111;
 endcase
 end
  6:
 begin
 case(led2N4[6])
           0:Y_r = 7'b0111111;//0
           1:Y_r = 7'b0110000;//1
           default:Y_r = 7'b1111111;
 endcase
 end
  7:
 begin
 case(led2N4[7])
           0:Y_r = 7'b0111111;//0
           1:Y_r = 7'b0110000;//1
           default:Y_r = 7'b1111111;
 endcase
 end
 default:Y_r = 7'b1111111;
 endcase
end

divide1 u1(clk,rst,clkout);



endmodule
