module leds(led_clk, ledrst, ledwrite,ledcs,ledwdata, ledout);
    input led_clk;    		    // 时钟信号
    input ledrst; 		        // 复位信号
    input ledwrite;		       	// 写信号
    input ledcs;		      	// 从memorio来的LED片选信号   !!!!!!!!!!!!!!!!!
            //  到LED模块的地址低端  !!!!!!!!!!!!!!!!!!!!
    input[31:0] ledwdata;	  	//  写到LED模块的数据，注意数据线只有16根
    output[16:0] ledout;		//  向板子上输出的24位LED信号
  
    reg [16:0] ledout;
    
    always@(negedge led_clk or posedge ledrst) begin
        if(ledrst) begin
            ledout <= 17'b10000000000000000;
        end
		else if(ledcs && ledwrite) begin
				ledout <=  {1'b0,ledwdata[15:0]} ;
        end
		else begin
            ledout <= ledout;
        end
    end
endmodule