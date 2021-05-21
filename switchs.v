module switchs(switclk, switrst, switchread, switchcs,switchaddr, switchrdata, switch_i);
    input switclk;			        //  时钟信号
    input switrst;			        //  复位信号
    input switchcs;			        //从memorio来的switch片选信号  !!!!!!!!!!!!!!!!!
    input[1:0] switchaddr;		    //  到switch模块的地址低端  !!!!!!!!!!!!!!!
    input switchread;			    //  读信号
    output reg[31:0] switchrdata;	//    //  送到CPU的拨码开关值注意数据总线只有16根
    input [18:0] switch_i;		    //  从板上读的24位开关数据

   
    always@(negedge switclk or posedge switrst) begin
        if(switrst) begin
            switchrdata <= 0;
        end
		else if(switchcs && switchread) begin
		          if(switch_i[15]==1)
		         switchrdata <= {13'b1111111111111,switch_i};
		         else
				switchrdata <= {13'b0000000000000,switch_i};   // data output,lower 16 bits non-extended
        end
     
		else begin
            switchrdata <= switchrdata;
        end
    end
endmodule