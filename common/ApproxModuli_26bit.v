`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/16 14:26:28
// Design Name: 
// Module Name: ApproxModuli_26bit
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


module ApproxModuli_26bit(
    input clk,
    input din_valid,
    input [25:0] din_I,
    input [25:0] din_Q,
    output reg dout_valid = 0,
    output reg [25:0] dout = 0
    );

reg [25:0] din_I_D1 = 0, din_Q_D1 = 0, din_I_D2 = 0, din_Q_D2 = 0;
reg [25:0] Sub1_s = 0;
reg [25:0] Xmax = 0, Xmin = 0;
always @(posedge clk)
	begin 
		if(din_valid)
			din_I_D1[25:0] <= (din_I[25]==1'b0)? din_I[25:0]:-din_I[25:0];
		else 
			din_I_D1[25:0] <= 26'd0;
		
		din_I_D2[25:0] <= din_I_D1[25:0];
		
		if(din_valid)
			din_Q_D1[25:0] <= (din_Q[25]==1'b0)? din_Q[25:0]:-din_Q[25:0];
		else 
			din_Q_D1[25:0] <= 26'd0;
		
		din_Q_D2[25:0] <= din_Q_D1[25:0];
		
		Sub1_s[25:0] <= din_I_D1[25:0] - din_Q_D1[25:0];
		
		if(Sub1_s[25])
			Xmax[25:0] <= din_Q_D2[25:0];
		else 
			Xmax[25:0] <= din_I_D2[25:0];
		
		if(Sub1_s[25])
			Xmin[25:0] <= din_I_D2[25:0];
		else 
			Xmin[25:0] <= din_Q_D2[25:0];
	end 

reg [25:0] Xmax_D1 = 0, Xmax_31by32 = 0, Xmax_13by16 = 0;
reg [25:0] Xmin_9by32 = 0, Xmin_19by32 = 0;
always @(posedge clk)
	begin 
		Xmax_D1[25:0] <= Xmax[25:0];
		Xmax_31by32[25:0] <= Xmax[25:0] - {5'd0, Xmax[25:5]};
		Xmax_13by16[25:0] <= Xmax[25:0] - {3'd0, Xmax[25:3]} - {4'd0, Xmax[25:4]};
		
		Xmin_9by32[25:0] <= {2'd0, Xmin[25:2]} + {5'd0, Xmin[25:5]};
		Xmin_19by32[25:0] <= {1'd0, Xmin[25:1]} + {4'd0, Xmin[25:4]} +  {5'd0, Xmin[25:5]};
	end 
	
reg [25:0] t1 = 0, t2 = 0, t3 = 0;
always @(posedge clk)
	begin 
		t1[25:0] <= Xmax_D1[25:0];
		t2[25:0] <= Xmax_31by32[25:0] + Xmin_9by32[25:0];
		t3[25:0] <= Xmax_13by16[25:0] + Xmin_19by32[25:0];
	end 

reg [25:0] sub2_s = 0;
reg [25:0] sub3_a = 0, sub3_b = 0, sub3_s = 0;
reg [25:0] sub3_a_D1 = 0, sub3_b_D1 = 0;
reg [25:0] t1_D1 = 0, t2_D1 = 0, t3_D1 = 0;
always @(posedge clk)
	begin 
		t1_D1[25:0] <= t1[25:0];
		t2_D1[25:0] <= t2[25:0];
		t3_D1[25:0] <= t3[25:0];
		
		sub2_s[25:0] <= t1[25:0] - t2[25:0];
		
		if(sub2_s[25])
			sub3_a[25:0] <= t2_D1[25:0];
		else 
			sub3_a[25:0] <= t1_D1[25:0];
		
		sub3_b[25:0] <= t3_D1[25:0];
		
		sub3_a_D1[25:0] <= sub3_a[25:0];
		sub3_b_D1[25:0] <= sub3_b[25:0];
		
		sub3_s[25:0] <= sub3_a[25:0] - sub3_b[25:0];
		
		if(sub3_s[25])
			dout[25:0] <= sub3_b_D1[25:0];
		else 
			dout[25:0] <= sub3_a_D1[25:0];
	end 

reg din_valid_D1 = 0, din_valid_D2 = 0, din_valid_D3 = 0, din_valid_D4 = 0;
reg din_valid_D5 = 0, din_valid_D6 = 0, din_valid_D7 = 0, din_valid_D8 = 0;
always @(posedge clk)
	begin 
		din_valid_D1 <= din_valid;
		din_valid_D2 <= din_valid_D1;
		din_valid_D3 <= din_valid_D2;
		din_valid_D4 <= din_valid_D3;
		din_valid_D5 <= din_valid_D4;
		din_valid_D6 <= din_valid_D5;
		din_valid_D7 <= din_valid_D6;
		din_valid_D8 <= din_valid_D7;
		
		dout_valid <= din_valid_D8;
	end 
endmodule
