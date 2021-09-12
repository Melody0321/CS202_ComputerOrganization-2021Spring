module leds(led_clk, ledrst, ledwrite,ledcs,ledwdata, ledout);
    input led_clk;    		    // ʱ���ź�
    input ledrst; 		        // ��λ�ź�
    input ledwrite;		       	// д�ź�
    input ledcs;		      	// ��memorio����LEDƬѡ�ź�   !!!!!!!!!!!!!!!!!
            //  ��LEDģ��ĵ�ַ�Ͷ�  !!!!!!!!!!!!!!!!!!!!
    input[31:0] ledwdata;	  	//  д��LEDģ������ݣ�ע��������ֻ��16��
    output[16:0] ledout;		//  ������������24λLED�ź�
  
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