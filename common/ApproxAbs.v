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
    
    
    // 第一级延迟：把输入变负值：
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
       
   	// 第二级延迟：求绝对值：
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
     
   	// 第三级延迟：确定I/Q两路绝对值的大小关系：
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
       
   	// 第四级延迟：MXQ选择的系数：7/8和1/2：
   	//===============================================================
   	reg	[27:0] 	AbsIQ_max_7by8;
   	reg	[27:0]	AbsIQ_min_1by2;
   	always @ (posedge clk) begin
       	AbsIQ_max_7by8[27:0]	<=	AbsIQ_max[27:0]-{3'b000,AbsIQ_max[27:3]};
       	AbsIQ_min_1by2[27:0]	<=	{AbsIQ_min[27],AbsIQ_min[27:1]};
	end
   
   	// 第五级延迟：1bit位扩展求和：
	// (MXQ)中间将最大延迟一个clk赋给 Dout_Temp2,使 Dout_Temp2与 Dout_Temp在同一个clk下进行比较。
	//===============================================================
   	reg [28:0]	Dout_Temp;
	reg [28:0] 	Dout_Temp1;
	reg	[28:0] 	Dout_Temp2;
	always @(posedge clk) begin
 		Dout_Temp	<=	{1'b0,AbsIQ_max_7by8[27:0]}+{1'b0,AbsIQ_min_1by2[27:0]};
	 	Dout_Temp1	<=	{1'b0,AbsIQ_max[27:0]};
		Dout_Temp2	<=	Dout_Temp1[28:0];
	end
   
	// (MXQ)第六级延迟：输出求和值与I/Q两路绝对值最大值比较之后的最大值：
	reg	[28:0]	Dout;
	always @(posedge clk) begin
		if(Dout_Temp[28:0]>=Dout_Temp2[27:0])
	  		Dout[28:0]	<=	Dout_Temp[28:0];
	  	else
			Dout[28:0] 	<=	Dout_Temp2[28:0];
	end
	
		
	// 产生Dout_valid，与Din_valid有七级延迟：
   	reg			Dout_valid_b6;
   	reg 		Dout_valid_b5;
   	reg 		Dout_valid_b4;
   	reg 		Dout_valid_b3;
   	reg 		Dout_valid_b2;
   	reg 		Dout_valid_b1;
   	always@(posedge clk) begin			//(MXQ)必须加 posedge clk ,否则仿真有问题，内存溢出   
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
