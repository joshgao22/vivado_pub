`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/29 10:25:59
// Design Name:
// Module Name: cx9261a_if_cmos
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


module cx9261a_if_cmos_singleport(
    input wire rst,
    output data_clk,
    input wire tr_sel,
    input wire tdd_fdd_sel,
    input wire r1t1_r2t2_sel,
    output reg data_valid,
    output reg [15:0] rx_i_data,
    output reg [15:0] rx_q_data,
    output reg [15:0] rx2_i_data,
    output reg [15:0] rx2_q_data,


    input tx_data_valid,
    input wire [15:0] tx_i_data,
    input wire [15:0] tx_q_data,
    input wire [15:0] tx2_i_data,
    input wire [15:0] tx2_q_data,
    output reg tx_data_ready,
	input wire RX_FRAME_IN,
	input wire RX_MCLK_IN,

	output wire TX_FCLK_IN,
	output wire TX_FRAME_IN,

	inout wire [7:0] RX_FDD_DATA_IO,
	inout wire [7:0] TX_FDD_DATA_IO
    );

localparam  TDD_MODE = 1'b1 ,
            FDD_MODE = 1'b0 ,
            R1T1_MODE = 1'b0,
            R2T2_MODE = 1'b1;

wire mclk_g;
wire R;
wire T;
wire RX_FRAME_pos;
wire RX_FRAME_neg;
wire [7:0]TX_FDD_DATA_pos;
wire [7:0]TX_FDD_DATA_neg;
wire [7:0]RX_FDD_DATA_pos;
wire [7:0]RX_FDD_DATA_neg;

wire [7:0] RX_FDD_DATA;
wire [7:0] TX_FDD_DATA;
wire [7:0] RX_FDD_DATA_O;
wire [7:0] TX_FDD_DATA_O;

reg [7:0]TX_FDD_DATA_pos_o;
reg [7:0]TX_FDD_DATA_neg_o;
reg [7:0]RX_FDD_DATA_pos_o;
reg [7:0]RX_FDD_DATA_neg_o;

BUFG MCLK_BUFG(.I(RX_MCLK_IN),.O(mclk_g));

assign data_clk = mclk_g;
assign T = tr_sel;
//***************************************************CDC**************************************************************//
   xpm_cdc_async_rst #(
      .DEST_SYNC_FF(4),    // DECIMAL; range: 2-10
      .INIT_SYNC_FF(0),    // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
      .RST_ACTIVE_HIGH(1)  // DECIMAL; 0=active low reset, 1=active high reset
   )
   xpm_cdc_async_rst_inst (
      .dest_arst(R), // 1-bit output: src_arst asynchronous reset signal synchronized to destination
                             // clock domain. This output is registered. NOTE: Signal asserts asynchronously
                             // but deasserts synchronously to dest_clk. Width of the reset signal is at least
                             // (DEST_SYNC_FF*dest_clk) period.

      .dest_clk(mclk_g),   // 1-bit input: Destination clock.
      .src_arst(rst)    // 1-bit input: Source asynchronous reset signal.
   );
//***************************************************CDC**************************************************************//

//***************************************************IOBUF**************************************************************//
   IOBUF #(
      .DRIVE(12), // Specify the output drive strength
      .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
      .IOSTANDARD("DEFAULT"), // Specify the I/O standard
      .SLEW("SLOW") // Specify the output slew rate
   ) IOBUF_RX_FDD_DATA[7:0] (
      .O(RX_FDD_DATA),     // Buffer output
      .IO(RX_FDD_DATA_IO),   // Buffer inout port (connect directly to top-level port)
      .I(RX_FDD_DATA_O),     // Buffer input
      .T(tdd_fdd_sel?T:1'b1)      // 3-state enable input, high=input, low=output
   );

      IOBUF #(
      .DRIVE(12), // Specify the output drive strength
      .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
      .IOSTANDARD("DEFAULT"), // Specify the I/O standard
      .SLEW("SLOW") // Specify the output slew rate
   ) IOBUF_TX_FDD_DATA[7:0] (
      .O(TX_FDD_DATA),     // Buffer output
      .IO(TX_FDD_DATA_IO),   // Buffer inout port (connect directly to top-level port)
      .I(TX_FDD_DATA_O),     // Buffer input
      .T(tdd_fdd_sel?T:1'b0)      // 3-state enable input, high=input, low=output
   );
//***************************************************IOBUF**************************************************************//

//***************************************************IDDR**************************************************************//
       IDDR #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
                                      //    or "SAME_EDGE_PIPELINED"
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) IDDR_TX[7:0] (
      .Q1(TX_FDD_DATA_pos), // 1-bit output for positive edge of clock
      .Q2(TX_FDD_DATA_neg), // 1-bit output for negative edge of clock
      .C(mclk_g),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D(TX_FDD_DATA),   // 1-bit DDR data input
      .R(R),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );

       IDDR #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
                                      //    or "SAME_EDGE_PIPELINED"
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) IDDR_RX[7:0] (
      .Q1(RX_FDD_DATA_pos), // 1-bit output for positive edge of clock
      .Q2(RX_FDD_DATA_neg), // 1-bit output for negative edge of clock
      .C(mclk_g),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D(RX_FDD_DATA),   // 1-bit DDR data input
      .R(R),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
       IDDR #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
                                      //    or "SAME_EDGE_PIPELINED"
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) IDDR_rx_FRAME (
      .Q1(RX_FRAME_pos), // 1-bit output for positive edge of clock
      .Q2(RX_FRAME_neg), // 1-bit output for negative edge of clock
      .C(mclk_g),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D(RX_FRAME_IN),   // 1-bit DDR data input
      .R(R),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
//***************************************************IDDR**************************************************************//

//***************************************************DATA**************************************************************//
wire [1:0] RX_FRAME;
reg [3:0] RX_FRAME_BUFF;
reg [15:0] RX_I_DATA_BUFF;
reg [15:0] RX_Q_DATA_BUFF;

reg [15:0] RX2_I_DATA_BUFF;
reg [15:0] RX2_Q_DATA_BUFF;


assign RX_FRAME = {RX_FRAME_pos,RX_FRAME_neg};
always @(posedge mclk_g)
if(R)begin
    RX_FRAME_BUFF<=0;
end
else begin//1100,0011...
    RX_FRAME_BUFF <= {RX_FRAME_BUFF[1:0],RX_FRAME} ;
end

always @(posedge mclk_g)
if(R)begin
    RX_I_DATA_BUFF<=0;
    RX_Q_DATA_BUFF<=0;
    RX2_I_DATA_BUFF<=0;
    RX2_Q_DATA_BUFF<=0;

end
else begin
if(r1t1_r2t2_sel == R2T2_MODE)begin
    if(RX_FRAME == 2'b11)begin//normal case
        RX2_I_DATA_BUFF<= {RX_FDD_DATA_pos,TX_FDD_DATA_pos};
        RX2_Q_DATA_BUFF<= {RX_FDD_DATA_neg,TX_FDD_DATA_neg};
    end
    else if(RX_FRAME == 2'b00)begin
        RX_I_DATA_BUFF<= {RX_FDD_DATA_pos,TX_FDD_DATA_pos};
        RX_Q_DATA_BUFF<= {RX_FDD_DATA_neg,TX_FDD_DATA_neg};
    end
    else begin
        RX_I_DATA_BUFF<=0;
        RX_Q_DATA_BUFF<=0;

    end

end
else
if(tdd_fdd_sel == TDD_MODE)
    if(RX_FRAME == 2'b10)begin//normal case
        RX_I_DATA_BUFF<= {RX_FDD_DATA_pos,TX_FDD_DATA_pos};
        RX_Q_DATA_BUFF<= {RX_FDD_DATA_neg,TX_FDD_DATA_neg};
    end
    else if(RX_FRAME == 2'b01)begin//invert case
        RX_Q_DATA_BUFF<= {RX_FDD_DATA_pos,TX_FDD_DATA_pos};
        RX_I_DATA_BUFF<= {RX_FDD_DATA_neg,TX_FDD_DATA_neg};
    end
    else begin
        RX_I_DATA_BUFF<=0;
        RX_Q_DATA_BUFF<=0;

    end
else begin //(tdd_fdd_sel == FDD_MODE)
    if(RX_FRAME == 2'b11)begin//
        RX_I_DATA_BUFF<= {RX_FDD_DATA_pos,RX_FDD_DATA_neg};
    end
    else if(RX_FRAME == 2'b00)begin
        RX_Q_DATA_BUFF<= {RX_FDD_DATA_pos,RX_FDD_DATA_neg};
    end
    else begin
        RX_I_DATA_BUFF<=0;
        RX_Q_DATA_BUFF<=0;
    end
end
end

always @(posedge mclk_g)
if(R)begin
    rx_i_data<=0;
    rx_q_data<=0;
    rx2_i_data<=0;
    rx2_q_data<=0;
    data_valid<=1'b0;
end
else begin
if(r1t1_r2t2_sel == R2T2_MODE)begin
    if(RX_FRAME_BUFF == 4'b1100)begin
        rx_i_data<=RX_I_DATA_BUFF;
        rx_q_data<=RX_Q_DATA_BUFF;
        rx2_i_data<=RX2_I_DATA_BUFF;
        rx2_q_data<=RX2_Q_DATA_BUFF;
        data_valid<=1'b1;
    end
    else begin
        rx_i_data<=rx_i_data;
        rx_q_data<=rx_q_data;
        data_valid<=1'b0;
    end
end
else
if( tdd_fdd_sel == TDD_MODE )
    if(RX_FRAME_BUFF == 4'b1010)begin
        rx_i_data<=RX_I_DATA_BUFF;
        rx_q_data<=RX_Q_DATA_BUFF;
        data_valid<=1'b1;
    end
    else begin
        rx_i_data<=rx_i_data;
        rx_q_data<=rx_q_data;
        data_valid<=1'b0;
    end
else begin//(tdd_fdd_sel == FDD_MODE)
    if(RX_FRAME_BUFF == 4'b1100)begin
        rx_i_data<=RX_I_DATA_BUFF;
        rx_q_data<=RX_Q_DATA_BUFF;
        data_valid<=1'b1;
    end
    else begin
        rx_i_data<=rx_i_data;
        rx_q_data<=rx_q_data;
        data_valid<=1'b0;
    end
end
end
//***************************************************DATA**************************************************************//

//***************************************************TX DATA**************************************************************//
reg [15:0] TX_I_DATA_BUFF;
reg [15:0] TX_Q_DATA_BUFF;
reg [15:0] TX2_I_DATA_BUFF;
reg [15:0] TX2_Q_DATA_BUFF;



always @(posedge mclk_g)
if(R)begin
    TX_I_DATA_BUFF<=0;
    TX_Q_DATA_BUFF<=0;
    TX2_I_DATA_BUFF<=0;
    TX2_Q_DATA_BUFF<=0;
    tx_data_ready = 1'b0;
end
else begin
if(r1t1_r2t2_sel == R2T2_MODE)begin
    if(tx_data_valid & tx_data_ready)begin
        TX_I_DATA_BUFF <= tx_i_data;
        TX_Q_DATA_BUFF <= tx_q_data;
        TX2_I_DATA_BUFF <= tx2_i_data;
        TX2_Q_DATA_BUFF <= tx2_q_data;
        tx_data_ready <= 1'b0;
    end
    else if(tx_data_ready == 1'b0) begin
            TX_I_DATA_BUFF <= TX_I_DATA_BUFF;
            TX_Q_DATA_BUFF <= TX_Q_DATA_BUFF;
            TX2_I_DATA_BUFF <= TX2_I_DATA_BUFF;
            TX2_Q_DATA_BUFF <= TX2_Q_DATA_BUFF;
            tx_data_ready<=1'b1;
        end
        else begin
            TX_I_DATA_BUFF <= TX_I_DATA_BUFF;
            TX_Q_DATA_BUFF <= TX_Q_DATA_BUFF;
            TX2_I_DATA_BUFF <= TX2_I_DATA_BUFF;
            TX2_Q_DATA_BUFF <= TX2_Q_DATA_BUFF;
            tx_data_ready<=tx_data_ready;
        end
end
else
if( tdd_fdd_sel == TDD_MODE )
    if(tx_data_valid & tx_data_ready)begin
        TX_I_DATA_BUFF <= tx_i_data;
        TX_Q_DATA_BUFF <= tx_q_data;
        tx_data_ready <= 1'b1;
    end
    else if(tx_data_ready == 1'b0) begin
        TX_I_DATA_BUFF <= tx_i_data;
        TX_Q_DATA_BUFF <= tx_q_data;
        tx_data_ready<=1'b1;
        end
        else begin
            TX_I_DATA_BUFF <= TX_I_DATA_BUFF;
            TX_Q_DATA_BUFF <= TX_Q_DATA_BUFF;
            tx_data_ready<=tx_data_ready;
        end
else begin//(tdd_fdd_sel == FDD_MODE)
    if(tx_data_valid & tx_data_ready)begin
        TX_I_DATA_BUFF <= tx_i_data;
        TX_Q_DATA_BUFF <= tx_q_data;
        tx_data_ready <= 1'b0;
    end
    else if(tx_data_ready == 1'b0) begin
            TX_I_DATA_BUFF <= TX_I_DATA_BUFF;
            TX_Q_DATA_BUFF <= TX_Q_DATA_BUFF;
            tx_data_ready<=1'b1;
        end
        else begin
            TX_I_DATA_BUFF <= TX_I_DATA_BUFF;
            TX_Q_DATA_BUFF <= TX_Q_DATA_BUFF;
            tx_data_ready<=tx_data_ready;
        end
end
end
reg tx_frame_pos;
reg tx_frame_neg;

always @(posedge mclk_g)
if(R)begin
    RX_FDD_DATA_pos_o<=0;
    TX_FDD_DATA_pos_o<=0;
    RX_FDD_DATA_neg_o<=0;
    TX_FDD_DATA_neg_o<=0;
    tx_frame_pos<= 1'b0;
end
else begin
if(r1t1_r2t2_sel == R2T2_MODE)begin
    if(tx_data_ready==0)begin
        RX_FDD_DATA_pos_o<=TX2_I_DATA_BUFF[15:8];
        TX_FDD_DATA_pos_o<=TX2_I_DATA_BUFF[7:0];
        RX_FDD_DATA_neg_o<=TX2_Q_DATA_BUFF[15:8];
        TX_FDD_DATA_neg_o<=TX2_Q_DATA_BUFF[7:0];
        tx_frame_pos<= 1'b1;
        tx_frame_neg<= 1'b1;
    end
    else begin
        RX_FDD_DATA_pos_o<=TX_I_DATA_BUFF[15:8];
        TX_FDD_DATA_pos_o<=TX_I_DATA_BUFF[7:0];
        RX_FDD_DATA_neg_o<=TX_Q_DATA_BUFF[15:8];
        TX_FDD_DATA_neg_o<=TX_Q_DATA_BUFF[7:0];
        tx_frame_pos<= 1'b0;
        tx_frame_neg<= 1'b0;
    end
end
else
if( tdd_fdd_sel == TDD_MODE )
    if(tx_data_ready==1)begin
        RX_FDD_DATA_pos_o<=TX_I_DATA_BUFF[15:8];
        TX_FDD_DATA_pos_o<=TX_I_DATA_BUFF[7:0];
        RX_FDD_DATA_neg_o<=TX_Q_DATA_BUFF[15:8];
        TX_FDD_DATA_neg_o<=TX_Q_DATA_BUFF[7:0];
        tx_frame_pos<= 1'b1;
        tx_frame_neg<= 1'b0;
    end
    else begin
        RX_FDD_DATA_pos_o<=8'd0;
        TX_FDD_DATA_pos_o<=8'd0;
        RX_FDD_DATA_neg_o<=8'd0;
        TX_FDD_DATA_neg_o<=8'd0;
        tx_frame_pos<= 1'b1;
        tx_frame_neg<= 1'b0;
    end

else//(tdd_fdd_sel == FDD_MODE)
    if(tx_data_ready==0)begin
        TX_FDD_DATA_pos_o<=TX_I_DATA_BUFF[15:8];
        TX_FDD_DATA_neg_o<=TX_I_DATA_BUFF[7:0];
        tx_frame_pos<= 1'b1;
        tx_frame_neg<= 1'b1;
    end
    else begin
        TX_FDD_DATA_pos_o<=TX_Q_DATA_BUFF[15:8];
        TX_FDD_DATA_neg_o<=TX_Q_DATA_BUFF[7:0];
        tx_frame_pos<= 1'b0;
        tx_frame_neg<= 1'b0;
    end

end
//***************************************************TX DATA**************************************************************//

//***************************************************ODDR**************************************************************//
   ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) ODDR_TX1[7:0] (
      .Q(TX_FDD_DATA_O),   // 1-bit DDR output
      .C(mclk_g),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(TX_FDD_DATA_pos_o), // 1-bit data input (positive edge)
      .D2(TX_FDD_DATA_neg_o), // 1-bit data input (negative edge)
      .R(R),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
   ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) ODDR_RX1[7:0] (
      .Q(RX_FDD_DATA_O),   // 1-bit DDR output
      .C(mclk_g),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(RX_FDD_DATA_pos_o), // 1-bit data input (positive edge)
      .D2(RX_FDD_DATA_neg_o), // 1-bit data input (negative edge)
      .R(R),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );

   ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) ODDR_TX_FRAME (
      .Q(TX_FRAME_IN),   // 1-bit DDR output
      .C(mclk_g),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(tx_frame_pos), // 1-bit data input (positive edge)
      .D2(tx_frame_neg), // 1-bit data input (negative edge)
      .R(R),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
   ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) ODDR_TX_FCLK (
      .Q(TX_FCLK_IN),   // 1-bit DDR output
      .C(mclk_g),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(1'b1), // 1-bit data input (positive edge)
      .D2(1'b0), // 1-bit data input (negative edge)
      .R(R),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
//***************************************************ODDR**************************************************************//
endmodule
