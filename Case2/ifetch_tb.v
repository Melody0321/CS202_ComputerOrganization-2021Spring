`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/16 14:55:50
// Design Name: 
// Module Name: ifetch_tb
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/16 13:37:41
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


module ifetch_tb( );
    // input
    reg[31:0]  Addr_result=32'h00000000;
    reg[31:0]  Read_data_1=32'h00000000;
    reg        Branch=1'b0;
    reg        nBranch=1'b0;
    reg        Jmp=1'b0;
    reg        Jal=1'b0;
    reg        Jr=1'b0;
    reg        Zero=1'b0;
    reg        clock=1'b0;
reg        reset=1'b1;    //1'b1 is 'reset' enable, 1'b0 means 'reset' disable. while 'reset' enable, the value of PC is set as 32'h0000_0000

    // output
    wire[31:0] Instruction;            
    wire[31:0] branch_base_addr;
    wire[31:0] link_addr;
wire[31:0] pco;      // bind with the new output port 'pco' in IFetc32 
       
    Ifetc32 Uifetch(.Instruction(Instruction),.branch_base_addr(branch_base_addr),.Addr_result(Addr_result),
            .Read_data_1(Read_data_1),.Branch(Branch),.nBranch(nBranch),.Jmp(Jmp),.Jal(Jal),.Jr(Jr),.Zero(Zero),
            .clock(clock),.reset(reset),.link_addr(link_addr),.pco(pco));    

always #2 clock = ~clock;   //4,8,12... negedge(4n),updtate pc,  //2,6,10... posedge(4n+2),get instruction according to the value of PC
initial fork
    #22 Jmp=1'b1;
    #26 Jmp=1'b0;
    #30 Jal=1'b1;
    #34 Jal=1'b0;
    #50 Jr=1'b1;
    #54 Jr=1'b0;
    
    #38 Addr_result=32'h00000001;
    #46 Addr_result=32'h00000002;
    #50 Addr_result=32'h00000001;
    
    #50 Read_data_1=32'h00050007;
    #54 Read_data_1=32'h00000000;
    
    #42 Zero=1'b1;
    #46 Zero=1'b0;
    #58 Zero=1'b1;
    #58 Branch=1'b1;
    #42 nBranch=1'b1;
    #50 nBranch=1'b0;
    
    #8 reset=1'b0;
    
join
endmodule
