module switchs(switclk, switrst, switchread, switchcs,switchaddr, switchrdata, switch_i);
    input switclk;			        //  ʱ���ź�
    input switrst;			        //  ��λ�ź�
    input switchcs;			        //��memorio����switchƬѡ�ź�  !!!!!!!!!!!!!!!!!
    input[1:0] switchaddr;		    //  ��switchģ��ĵ�ַ�Ͷ�  !!!!!!!!!!!!!!!
    input switchread;			    //  ���ź�
    output reg[31:0] switchrdata;	//    //  �͵�CPU�Ĳ��뿪��ֵע����������ֻ��16��
    input [18:0] switch_i;		    //  �Ӱ��϶���24λ��������

   
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