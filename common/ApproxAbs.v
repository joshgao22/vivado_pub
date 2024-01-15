`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/15 20:02:47
// Design Name: 
// Module Name: ApproxAbs
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


module ApproxAbs(
	input				clk,
	
	input				Nd,
	input		[27:0]	Dini,
	input		[27:0]	Dinq,

	output	reg			Abs_Rdy	=	1'b0,
	output	reg [28:0]	Abs_Dout=	29'd0
    );
    
    
    // ��һ���ӳ٣�������为ֵ��
   	//===============================================================
   	reg [27:0] Din_I_neg;
   	always @(posedge clk)begin
		if(Dini==28'b1000_0000_0000_0000_0000_0000_0000)begin
       		Din_I_neg	<=	28'b0111_1111_1111_1111_1111_1111_1111;
     	end else begin
       		Din_I_neg	<=	-Dini;   
       	end
	end
       
	reg [27:0] Din_Q_neg;
   	always @(posedge clk)begin
		if(Dinq==28'b1000_0000_0000_0000_0000_0000_0000)begin
       		Din_Q_neg	<=	28'b0111_1111_1111_1111_1111_1111_1111;
     	end else begin
       		Din_Q_neg	<=	-Dinq;   
       	end
	end  
       
   	// �ڶ����ӳ٣������ֵ��
   	//===============================================================
	reg	[27:0]	Din_I_D1;
	reg	[27:0]	Din_Q_D1; 
   	always @(posedge clk)begin
		Din_I_D1	<=	Dini;
		Din_Q_D1	<=	Dinq;
	end
     
   	reg	[27:0]	Abs_Din_I;
   	reg	[27:0]	Abs_Din_Q;  
   	always @(posedge clk)begin
		if(Din_I_D1[27]==1'b1)
			Abs_Din_I	<=	Din_I_neg;
		else
			Abs_Din_I	<=	Din_I_D1;
			
       	if(Din_Q_D1[27]==1'b1)
         	Abs_Din_Q	<=	Din_Q_neg;
       	else
        	Abs_Din_Q	<=	Din_Q_D1;       
	end
     
   	// �������ӳ٣�ȷ��I/Q��·����ֵ�Ĵ�С��ϵ��
   	//===============================================================
   	reg	[27:0]	AbsIQ_max;
   	reg	[27:0] 	AbsIQ_min;
	always @(posedge clk)begin
     	if (Abs_Din_I>=Abs_Din_Q) begin
         	AbsIQ_max	<=	Abs_Din_I;
         	AbsIQ_min	<=	Abs_Din_Q;
       	end else begin
         	AbsIQ_max	<=	Abs_Din_Q;
         	AbsIQ_min	<=	Abs_Din_I;
       	end
	end
       
   	// ���ļ��ӳ٣�MXQѡ���ϵ����7/8��1/2��
   	//===============================================================
   	reg	[27:0] 	AbsIQ_max_7by8;
   	reg	[27:0]	AbsIQ_min_1by2;
   	always @ (posedge clk) begin
       	AbsIQ_max_7by8[27:0]	<=	AbsIQ_max[27:0]-{3'b000,AbsIQ_max[27:3]};
       	AbsIQ_min_1by2[27:0]	<=	{AbsIQ_min[27],AbsIQ_min[27:1]};
	end
   
   	// ���弶�ӳ٣�1bitλ��չ��ͣ�
	// (MXQ)�м佫����ӳ�һ��clk���� Dout_Temp2,ʹ Dout_Temp2�� Dout_Temp��ͬһ��clk�½��бȽϡ�
	//===============================================================
   	reg [28:0]	Dout_Temp;
	reg [28:0] 	Dout_Temp1;
	reg	[28:0] 	Dout_Temp2;
	always @(posedge clk) begin
 		Dout_Temp	<=	{1'b0,AbsIQ_max_7by8[27:0]}+{1'b0,AbsIQ_min_1by2[27:0]};
	 	Dout_Temp1	<=	{1'b0,AbsIQ_max[27:0]};
		Dout_Temp2	<=	Dout_Temp1[28:0];
	end
   
	// (MXQ)�������ӳ٣�������ֵ��I/Q��·����ֵ���ֵ�Ƚ�֮������ֵ��
	reg	[28:0]	Dout;
	always @(posedge clk) begin
		if(Dout_Temp[28:0]>=Dout_Temp2[27:0])
	  		Dout[28:0]	<=	Dout_Temp[28:0];
	  	else
			Dout[28:0] 	<=	Dout_Temp2[28:0];
	end
	
		
	// ����Dout_valid����Din_valid���߼��ӳ٣�
   	reg			Dout_valid_b6;
   	reg 		Dout_valid_b5;
   	reg 		Dout_valid_b4;
   	reg 		Dout_valid_b3;
   	reg 		Dout_valid_b2;
   	reg 		Dout_valid_b1;
   	always@(posedge clk) begin			//(MXQ)����� posedge clk ,������������⣬�ڴ����   
		Dout_valid_b6	<=	Nd;
	   	Dout_valid_b5	<=	Dout_valid_b6;
       	Dout_valid_b4	<=	Dout_valid_b5;
       	Dout_valid_b3	<=	Dout_valid_b4;
       	Dout_valid_b2	<=	Dout_valid_b3;
       	Dout_valid_b1	<=	Dout_valid_b2;
	   	Abs_Rdy 		<= 	Dout_valid_b1;
	end
	
	always @ (posedge clk) begin
		if(Dout_valid_b1)
			Abs_Dout	<= 	Dout;
		else
			Abs_Dout 	<= 	29'd0;
	end
		
endmodule
