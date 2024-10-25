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


module cx9261a_if_cmos_port(
    input  wire         rst,

    input  wire         sp_dp_sel,
    input  wire         tr_sel,
    input  wire         tdd_fdd_sel,
    input  wire         r1t1_r2t2_sel,

    output wire         data_clk1,
    output wire         data_clk2,
    output reg          rx1_data_valid,
    output reg          rx2_data_valid,
    output reg  [15:0]  rx1_i_data,
    output reg  [15:0]  rx1_q_data,
    output reg  [15:0]  rx2_i_data,
    output reg  [15:0]  rx2_q_data,
    input  wire         tx_data_valid,
    input  wire [15:0]  tx1_i_data,
    input  wire [15:0]  tx1_q_data,
    input  wire [15:0]  tx2_i_data,
    input  wire [15:0]  tx2_q_data,
    output reg          tx1_data_ready,
    output reg          tx2_data_ready,

	input  wire         RX1_MCLK_IN_N,
	input  wire         RX2_MCLK_IN_P,
	output wire         TX1_FCLK_IN_N,
    output wire         TX2_FCLK_IN_P,
	input  wire         RX1_FRAME_N,
	input  wire         RX2_FRAME_P,
	output wire         TX1_FRAME_IN_N,
	output wire         TX2_FRAME_IN_P,
	inout  wire [ 7:0]  RX1_DATA_IO,
	inout  wire [ 7:0]  RX2_DATA_IO,
	inout  wire [ 7:0]  TX1_DATA_IO,
	inout  wire [ 7:0]  TX2_DATA_IO
    );

    localparam  TDD_MODE  = 1'b1 ,
                FDD_MODE  = 1'b0 ,
                R1T1_MODE = 1'b0,
                R2T2_MODE = 1'b1;

wire mclk_g;
wire mclk_g1;
wire mclk_g2;
wire R;
wire R1;
wire R2;
wire T;
wire [1:0]RX_FRAME_pos;
wire [1:0]RX_FRAME_neg;

(* MARK_DEBUG="true" *) (* keep="true" *)wire [7:0] TX1_DATA;
(* MARK_DEBUG="true" *) (* keep="true" *)wire [7:0] RX1_DATA;
(* MARK_DEBUG="true" *) (* keep="true" *)wire [7:0] TX2_DATA;
(* MARK_DEBUG="true" *) (* keep="true" *)wire [7:0] RX2_DATA;

wire [7:0] TX1_DATA_O;
wire [7:0] TX2_DATA_O;
wire [7:0] RX1_DATA_O;
wire [7:0] RX2_DATA_O;

wire [7:0] TX2_DATA_pos;
wire [7:0] TX2_DATA_neg;
wire [7:0] RX2_DATA_pos;
wire [7:0] RX2_DATA_neg;

wire [7:0] TX1_DATA_pos;
wire [7:0] TX1_DATA_neg;
wire [7:0] RX1_DATA_pos;
wire [7:0] RX1_DATA_neg;

wire [ 2:0] mode_sel;

//data_clk1 is from RX2_MCLK in NOT 1/2/3 mode.
BUFGMUX_CTRL DATA_CLK_BUFGMUX (
      .O(mclk_g),   // 1-bit output: Clock output
      .I0(RX2_MCLK_IN_P), // 1-bit input: Clock input (S=0)
      .I1(RX1_MCLK_IN_N), // 1-bit input: Clock input (S=1)
      .S((mode_sel == 3'b100) || (mode_sel == 3'b110))    // 1-bit input: Clock select
   );

BUFGMUX_CTRL DATA_CLK2_BUFGMUX (
      .O(mclk_g2),   // 1-bit output: Clock output
      .I0(RX2_MCLK_IN_P), // 1-bit input: Clock input (S=0)
      .I1(RX1_MCLK_IN_N), // 1-bit input: Clock input (S=1)
      .S(1'b0)    // 1-bit input: Clock select
   );

BUFG DATA_CLK1_BUFG(.I(RX1_MCLK_IN_N),.O(mclk_g1));
// BUFG DATA_CLK2_BUFG(.I(RX2_MCLK_IN_P),.O(mclk_g2));

assign data_clk1 = mclk_g;
assign data_clk2 = mclk_g2;

assign T = tr_sel;

//***************************************************CDC***************************************************************//
   xpm_cdc_async_rst #(
      .DEST_SYNC_FF(4),    // DECIMAL; range: 2-10
      .INIT_SYNC_FF(0),    // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
      .RST_ACTIVE_HIGH(1)  // DECIMAL; 0=active low reset, 1=active high reset
   )
   xpm_cdc_async_rst_inst[2:0] (
      .dest_arst({R,R1,R2}), // 1-bit output: src_arst asynchronous reset signal synchronized to destination
                             // clock domain. This output is registered. NOTE: Signal asserts asynchronously
                             // but deasserts synchronously to dest_clk. Width of the reset signal is at least
                             // (DEST_SYNC_FF*dest_clk) period.

      .dest_clk({mclk_g,mclk_g1,mclk_g2}),   // 1-bit input: Destination clock.
      .src_arst(rst)    // 1-bit input: Source asynchronous reset signal.
   );
//***************************************************CDC***************************************************************//
//***************************************************IOBUF*************************************************************//
    IOBUF #(
      .DRIVE(12), // Specify the output drive strength
      .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
      .IOSTANDARD("DEFAULT"), // Specify the I/O standard
      .SLEW("SLOW") // Specify the output slew rate
   ) IOBUF_RX1_FDD_DATA[7:0] (
      .O (RX1_DATA),     // Buffer output
      .IO(RX1_DATA_IO),   // Buffer inout port (connect directly to top-level port)
      .I (RX1_DATA_O),     // Buffer input
      .T (tdd_fdd_sel?T:(mode_sel == 3'b100))      // 3-state enable input, high=input, low=output
   );

    IOBUF #(
      .DRIVE(12), // Specify the output drive strength
      .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
      .IOSTANDARD("DEFAULT"), // Specify the I/O standard
      .SLEW("SLOW") // Specify the output slew rate
   ) IOBUF_TX1_FDD_DATA[7:0] (
      .O (TX1_DATA),     // Buffer output
      .IO(TX1_DATA_IO),   // Buffer inout port (connect directly to top-level port)
      .I (TX1_DATA_O),     // Buffer input
      .T (tdd_fdd_sel?T:1'b0)      // 3-state enable input, high=input, low=output
   );

    IOBUF #(
      .DRIVE(12), // Specify the output drive strength
      .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
      .IOSTANDARD("DEFAULT"), // Specify the I/O standard
      .SLEW("SLOW") // Specify the output slew rate
   ) IOBUF_RX2_FDD_DATA[7:0] (
      .O (RX2_DATA),     // Buffer output
      .IO(RX2_DATA_IO),   // Buffer inout port (connect directly to top-level port)
      .I (RX2_DATA_O),     // Buffer input
      .T (tdd_fdd_sel?T:1'b1)      // 3-state enable input, high=input, low=output
   );

    IOBUF #(
      .DRIVE(12), // Specify the output drive strength
      .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
      .IOSTANDARD("DEFAULT"), // Specify the I/O standard
      .SLEW("SLOW") // Specify the output slew rate
   ) IOBUF_TX2_FDD_DATA[7:0] (
      .O (TX2_DATA),     // Buffer output
      .IO(TX2_DATA_IO),   // Buffer inout port (connect directly to top-level port)
      .I (TX2_DATA_O),     // Buffer input
      .T (tdd_fdd_sel?T:(mode_sel != 3'b100))      // 3-state enable input, high=input, low=output
   );
//***************************************************IOBUF*************************************************************//

//***************************************************IDDR**************************************************************//

    IDDR #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
                                      //    or "SAME_EDGE_PIPELINED"
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) IDDR_TX2[7:0] (
      .Q1(TX2_DATA_pos), // 1-bit output for positive edge of clock
      .Q2(TX2_DATA_neg), // 1-bit output for negative edge of clock
      .C(mclk_g2),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D(TX2_DATA),   // 1-bit DDR data input
      .R(R2),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );

    IDDR #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
                                      //    or "SAME_EDGE_PIPELINED"
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) IDDR_RX2[7:0] (
      .Q1(RX2_DATA_pos), // 1-bit output for positive edge of clock
      .Q2(RX2_DATA_neg), // 1-bit output for negative edge of clock
      .C(mclk_g2),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D(RX2_DATA),   // 1-bit DDR data input
      .R(R2),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );

    IDDR #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
                                      //    or "SAME_EDGE_PIPELINED"
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) IDDR1_TX1[7:0] (
      .Q1(TX1_DATA_pos), // 1-bit output for positive edge of clock
      .Q2(TX1_DATA_neg), // 1-bit output for negative edge of clock
      .C(mclk_g),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D(TX1_DATA),   // 1-bit DDR data input
      .R(R1),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );

    IDDR #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
                                      //    or "SAME_EDGE_PIPELINED"
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) IDDR1_RX1[7:0] (
      .Q1(RX1_DATA_pos), // 1-bit output for positive edge of clock
      .Q2(RX1_DATA_neg), // 1-bit output for negative edge of clock
      .C(mclk_g),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D(RX1_DATA),   // 1-bit DDR data input
      .R(R1),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );

    IDDR #(
      .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE"
                                      //    or "SAME_EDGE_PIPELINED"
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) IDDR2_rx_FRAME[1:0] (
      .Q1(RX_FRAME_pos), // 1-bit output for positive edge of clock
      .Q2(RX_FRAME_neg), // 1-bit output for negative edge of clock
      .C({mclk_g2,mclk_g1}),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D({RX2_FRAME_P,RX1_FRAME_N}),   // 1-bit DDR data input
      .R({R2,R1}),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );

//***************************************************IDDR**************************************************************//

//***************************************************DATA**************************************************************//
//***************************************************RX DATA***********************************************************//

wire [ 1:0] RX1_FRAME;
wire [ 1:0] RX2_FRAME;
(* MARK_DEBUG="true" *) (* keep="true" *)wire [ 1:0] RX_FRAME_N;
reg  [ 3:0] RX_FRAME_BUFF;
reg  [ 3:0] RX2_FRAME_BUFF;
reg  [15:0] RX1_I_DATA_BUFF;
reg  [15:0] RX1_Q_DATA_BUFF;
reg  [15:0] RX1_I_DATA1_BUFF;
reg  [15:0] RX1_Q_DATA1_BUFF;
reg  [15:0] RX2_I_DATA_BUFF;
reg  [15:0] RX2_Q_DATA_BUFF;

assign mode_sel = {sp_dp_sel,tdd_fdd_sel,r1t1_r2t2_sel};

assign RX2_FRAME = {RX_FRAME_pos[1],RX_FRAME_neg[1]};
assign RX1_FRAME = {RX_FRAME_pos[0],RX_FRAME_neg[0]};

assign RX_FRAME_N = ((mode_sel == 3'b100) || (mode_sel == 3'b110)) ? RX1_FRAME : RX2_FRAME ;

always @(posedge mclk_g2)
    if(R2)begin
        RX2_FRAME_BUFF<=0;
    end else begin//1100,0011...
        RX2_FRAME_BUFF <= {RX2_FRAME_BUFF[1:0],RX2_FRAME} ;
    end

always @(posedge mclk_g)
    if(R)begin
        RX_FRAME_BUFF<=0;
    end else begin//1100,0011...
        RX_FRAME_BUFF <= {RX_FRAME_BUFF[1:0],RX_FRAME_N} ;
    end

always @(posedge mclk_g2)
    if(R2)begin
        RX1_I_DATA_BUFF <=0;
        RX2_I_DATA_BUFF <=0;
        RX1_Q_DATA_BUFF <=0;
        RX2_Q_DATA_BUFF <=0;
    end else begin
        case (mode_sel)
            3'b000://dual_port & fdd & r1t1 ---mode 6/7
            begin
                if((RX2_FRAME == 2'b11)||(RX2_FRAME == 2'b10))begin       //add judgment of rx_frame --ybsun
                    RX2_I_DATA_BUFF <= {RX2_DATA_pos,TX2_DATA_pos} ;
                    RX2_Q_DATA_BUFF <= {RX2_DATA_neg,TX2_DATA_neg} ;
                end
            end
            3'b001: //dual_port & fdd & r2t2 ---mode 8
            begin
                if(RX2_FRAME == 2'b11)begin
                    RX2_I_DATA_BUFF <= {RX2_DATA_pos,TX2_DATA_pos} ;
                    RX2_Q_DATA_BUFF <= {RX2_DATA_neg,TX2_DATA_neg} ;
                end else if(RX2_FRAME == 2'b00)begin
                    RX1_I_DATA_BUFF <= {RX2_DATA_pos,TX2_DATA_pos} ;
                    RX1_Q_DATA_BUFF <= {RX2_DATA_neg,TX2_DATA_neg} ;
                end
            end
            3'b010:;//dual_port & tdd & r1t1 ---none
            3'b011: //dual_port & tdd & r2t2 ---mode 5
            begin
                if(RX2_FRAME == 2'b10)begin
                    RX1_I_DATA_BUFF <= {RX2_DATA_neg,TX2_DATA_neg} ;
                    RX1_Q_DATA_BUFF <= {RX1_DATA_neg,TX1_DATA_neg} ;
                    RX2_I_DATA_BUFF <= {RX2_DATA_pos,TX2_DATA_pos} ;
                    RX2_Q_DATA_BUFF <= {RX1_DATA_pos,TX1_DATA_pos} ;
                end
            end
            3'b100: //single_port & fdd & r1t1 ---mode 3
            begin
                if(RX2_FRAME == 2'b11)begin
                    RX2_I_DATA_BUFF <= {RX2_DATA_pos,RX2_DATA_neg};
                end else if(RX2_FRAME == 2'b00)begin
                    RX2_Q_DATA_BUFF <= {RX2_DATA_pos,RX2_DATA_neg};
                end
            end
            3'b101:;//single_port & fdd & r2t2 ---none
            3'b110: //single_port & tdd & r1t1 ---mode 1/2
            begin
                if((RX2_FRAME == 2'b11)||(RX2_FRAME == 2'b10))begin      //add judgment of rx_frame --ybsun
                    RX2_I_DATA_BUFF<= {RX2_DATA_pos,TX2_DATA_pos};
                    RX2_Q_DATA_BUFF<= {RX2_DATA_neg,TX2_DATA_neg};
                end
            end
            3'b111: //single_port & tdd & r2t2 ---mode 4
            begin
                if(RX2_FRAME == 2'b11)begin
                    RX2_I_DATA_BUFF<= {RX2_DATA_pos,TX2_DATA_pos};
                    RX2_Q_DATA_BUFF<= {RX2_DATA_neg,TX2_DATA_neg};
                end else if(RX2_FRAME == 2'b00)begin
                    RX1_I_DATA_BUFF<= {RX2_DATA_pos,TX2_DATA_pos};
                    RX1_Q_DATA_BUFF<= {RX2_DATA_neg,TX2_DATA_neg};
                end
            end
            default:;
        endcase
    end

//mode1/2/3:the different clock region of RX1 data
always @(posedge mclk_g)
    if(R)begin
        RX1_I_DATA1_BUFF <=0;
        RX1_Q_DATA1_BUFF <=0;
    end else begin
        case (mode_sel)
            3'b100: //single_port & fdd & r1t1 ---mode 3
            begin
                if(RX1_FRAME == 2'b11)begin
                    RX1_I_DATA1_BUFF <= {RX1_DATA_pos,RX1_DATA_neg};
                end else if(RX1_FRAME == 2'b00)begin
                    RX1_Q_DATA1_BUFF <= {RX1_DATA_pos,RX1_DATA_neg};
                end
            end
            3'b110: //single_port & tdd & r1t1 ---mode 1/2
            begin
                if((RX1_FRAME == 2'b11)||(RX1_FRAME == 2'b10))begin
                    RX1_I_DATA1_BUFF <= {RX1_DATA_pos,TX1_DATA_pos};
                    RX1_Q_DATA1_BUFF <= {RX1_DATA_neg,TX1_DATA_neg};
                end
            end
            default:;
        endcase
    end

always @(posedge mclk_g2)
    if(R2)begin
        rx2_i_data<=0;
        rx2_q_data<=0;
        rx2_data_valid<=1'b0;
    end else begin
        case (mode_sel)
            3'b000://dual_port & fdd & r1t1 ---mode 6/7
            begin
                if((RX2_FRAME_BUFF[1:0] == 2'b11)||(RX2_FRAME_BUFF[1:0] == 2'b10))begin
                    rx2_i_data<=RX2_I_DATA_BUFF;
                    rx2_q_data<=RX2_Q_DATA_BUFF;
                    rx2_data_valid<=1'b1;
                end else begin
                    rx2_i_data<=rx2_i_data;
                    rx2_q_data<=rx2_q_data;
                    rx2_data_valid<=1'b0;
                end
            end
            3'b001: //dual_port & fdd & r2t2 ---mode 8
            begin
                if(RX2_FRAME_BUFF == 4'b1100)begin
                    rx2_i_data<=RX2_I_DATA_BUFF;
                    rx2_q_data<=RX2_Q_DATA_BUFF;
                    rx2_data_valid<=1'b1;
                end else begin
                    rx2_i_data<=rx2_i_data;
                    rx2_q_data<=rx2_q_data;
                    rx2_data_valid<=1'b0;
                end
            end
            3'b010:;//dual_port & tdd & r1t1 ---none
            3'b011: //dual_port & tdd & r2t2 ---mode 5
            begin
                if(RX2_FRAME_BUFF[1:0] == 2'b10)begin
                    rx2_i_data<=RX2_I_DATA_BUFF;
                    rx2_q_data<=RX2_Q_DATA_BUFF;
                    rx2_data_valid<=1'b1;
                end else begin
                    rx2_i_data<=rx2_i_data;
                    rx2_q_data<=rx2_q_data;
                    rx2_data_valid<=1'b0;
                end
            end
            3'b100: //single_port & fdd & r1t1 ---mode 3
            begin
                if(RX2_FRAME_BUFF == 4'b1100)begin
                    rx2_i_data<=RX2_I_DATA_BUFF;
                    rx2_q_data<=RX2_Q_DATA_BUFF;
                    rx2_data_valid<=1'b1;
                end else begin
                    rx2_i_data<=rx2_i_data;
                    rx2_q_data<=rx2_q_data;
                    rx2_data_valid<=1'b0;
                end
            end
            3'b101:;//single_port & fdd & r2t2 ---none
            3'b110: //single_port & tdd & r1t1 ---mode 1/2
            begin
                if((RX2_FRAME_BUFF[1:0] == 2'b11)||(RX2_FRAME_BUFF[1:0] == 2'b10))begin
                    rx2_i_data<=RX2_I_DATA_BUFF;
                    rx2_q_data<=RX2_Q_DATA_BUFF;
                    rx2_data_valid<=1'b1;
                end else begin
                    rx2_i_data<=rx2_i_data;
                    rx2_q_data<=rx2_q_data;
                    rx2_data_valid<=1'b0;
                end
            end
            3'b111: //single_port & tdd & r2t2 ---mode 4
            begin
                if(RX2_FRAME_BUFF == 4'b1100)begin
                    rx2_i_data<=RX2_I_DATA_BUFF;
                    rx2_q_data<=RX2_Q_DATA_BUFF;
                    rx2_data_valid<=1'b1;
                end else begin
                    rx2_i_data<=rx2_i_data;
                    rx2_q_data<=rx2_q_data;
                    rx2_data_valid<=1'b0;
                end
            end
            default:;
        endcase
    end

always @(posedge mclk_g)
    if(R)begin
        rx1_i_data<=0;
        rx1_q_data<=0;
        rx1_data_valid<=1'b0;
    end else begin
        case (mode_sel)
            3'b000:;//dual_port & fdd & r1t1 ---mode 6/7
            3'b001: //dual_port & fdd & r2t2 ---mode 8
            begin
                if(RX_FRAME_BUFF == 4'b1100)begin
                    rx1_i_data<=RX1_I_DATA_BUFF;
                    rx1_q_data<=RX1_Q_DATA_BUFF;
                    rx1_data_valid<=1'b1;
                end else begin
                    rx1_i_data<=rx1_i_data;
                    rx1_q_data<=rx1_q_data;
                    rx1_data_valid<=1'b0;
                end
            end
            3'b010:;//dual_port & tdd & r1t1 ---none
            3'b011: //dual_port & tdd & r2t2 ---mode 5
            begin
                if(RX_FRAME_BUFF[1:0] == 2'b10)begin
                    rx1_i_data<=RX1_I_DATA_BUFF;
                    rx1_q_data<=RX1_Q_DATA_BUFF;
                    rx1_data_valid<=1'b1;
                end else begin
                    rx1_i_data<=rx1_i_data;
                    rx1_q_data<=rx1_q_data;
                    rx1_data_valid<=1'b0;
                end
            end
            3'b100: //single_port & fdd & r1t1 ---mode 3
            begin
                if(RX_FRAME_BUFF == 4'b1100)begin
                    rx1_i_data<=RX1_I_DATA1_BUFF;
                    rx1_q_data<=RX1_Q_DATA1_BUFF;
                    rx1_data_valid<=1'b1;
                end else begin
                    rx1_i_data<=rx1_i_data;
                    rx1_q_data<=rx1_q_data;
                    rx1_data_valid<=1'b0;
                end
            end
            3'b101:;//single_port & fdd & r2t2 ---none
            3'b110: //single_port & tdd & r1t1 ---mode 1/2
            begin
                if((RX_FRAME_BUFF[1:0] == 2'b11)||(RX_FRAME_BUFF[1:0] == 2'b10))begin
                    rx1_i_data<=RX1_I_DATA1_BUFF;
                    rx1_q_data<=RX1_Q_DATA1_BUFF;
                    rx1_data_valid<=1'b1;
                end else begin
                    rx1_i_data<=rx1_i_data;
                    rx1_q_data<=rx1_q_data;
                    rx1_data_valid<=1'b0;
                end
            end
            3'b111: //single_port & tdd & r2t2 ---mode 4
            begin
                if(RX_FRAME_BUFF == 4'b1100)begin
                    rx1_i_data<=RX1_I_DATA_BUFF;
                    rx1_q_data<=RX1_Q_DATA_BUFF;
                    rx1_data_valid<=1'b1;
                end else begin
                    rx1_i_data<=rx1_i_data;
                    rx1_q_data<=rx1_q_data;
                    rx1_data_valid<=1'b0;
                end
            end
            default:;
        endcase
    end

//***************************************************RX DATA***********************************************************//

//***************************************************TX DATA***********************************************************//

wire tx1_data_ready0;

reg [15:0] TX1_I_DATA_BUFF;
reg [15:0] TX1_Q_DATA_BUFF;
reg [15:0] TX1_I_DATA1_BUFF;
reg [15:0] TX1_Q_DATA1_BUFF;
reg [15:0] TX2_I_DATA_BUFF;
reg [15:0] TX2_Q_DATA_BUFF;

always @(posedge mclk_g2)
    if(R2)begin
        TX2_I_DATA_BUFF<=0;
        TX2_Q_DATA_BUFF<=0;
        tx2_data_ready <= 1'b1;
    end else begin
        case (mode_sel)
            3'b000,3'b011,3'b110: //mode 6/7 - 5 - 1/2
            begin
                if(tx_data_valid & tx2_data_ready)begin
                    TX2_I_DATA_BUFF <= tx2_i_data;
                    TX2_Q_DATA_BUFF <= tx2_q_data;
                end
                tx2_data_ready<=1'b1;
            end
            3'b001,3'b100,3'b111: //mode 8 - 3 - 4
            begin
                if(tx_data_valid & tx2_data_ready)begin
                    TX2_I_DATA_BUFF <= tx2_i_data;
                    TX2_Q_DATA_BUFF <= tx2_q_data;
                    tx2_data_ready   <= 1'b0;
                end else if(tx2_data_ready == 1'b0) begin
                    tx2_data_ready <=1'b1;
                end
            end
            default:;
        endcase
    end

always @(posedge mclk_g)
    if(R)begin
        TX1_I_DATA_BUFF<=0;
        TX1_Q_DATA_BUFF<=0;
        tx1_data_ready <= 1'b0;       //1'b0->1'b1 to aviod error in mode 8--ybsun
    end else begin
        case (mode_sel)
            3'b001,3'b100,3'b111: //mode 8 - 3 - 4
            begin
                if(tx_data_valid & tx1_data_ready)begin
                    TX1_I_DATA_BUFF <= tx1_i_data;
                    TX1_Q_DATA_BUFF <= tx1_q_data;
                    tx1_data_ready  <= 1'b0;
                end else if(tx1_data_ready == 1'b0) begin
                    tx1_data_ready  <= 1'b1;
                end else begin
                    TX1_I_DATA_BUFF <= TX1_I_DATA_BUFF;
                    TX1_Q_DATA_BUFF <= TX1_Q_DATA_BUFF;
                    tx1_data_ready  <= tx1_data_ready;
                end
            end
            3'b011,3'b110: //mode 5 - 1/2
            begin
                if(tx_data_valid & tx1_data_ready)begin
                    TX1_I_DATA_BUFF <= tx1_i_data;
                    TX1_Q_DATA_BUFF <= tx1_q_data;
                end else begin
                    TX1_I_DATA_BUFF <= TX1_I_DATA_BUFF;
                    TX1_Q_DATA_BUFF <= TX1_Q_DATA_BUFF;
                end
                tx1_data_ready <=1'b1;
            end
            default:;
        endcase
    end

assign tx1_data_ready0 = ((mode_sel == 3'b100) || (mode_sel == 3'b110)) ? tx1_data_ready : tx2_data_ready ;

(* MARK_DEBUG="true" *) (* keep="true" *)reg  [7:0]TX2_DATA_pos_o;
(* MARK_DEBUG="true" *) (* keep="true" *)reg  [7:0]TX2_DATA_neg_o;
(* MARK_DEBUG="true" *) (* keep="true" *)reg  [7:0]RX2_DATA_pos_o;
(* MARK_DEBUG="true" *) (* keep="true" *)reg  [7:0]RX2_DATA_neg_o;
(* MARK_DEBUG="true" *) (* keep="true" *)reg  [7:0]TX1_DATA_pos_o;
(* MARK_DEBUG="true" *) (* keep="true" *)reg  [7:0]TX1_DATA_neg_o;
(* MARK_DEBUG="true" *) (* keep="true" *)reg  [7:0]RX1_DATA_pos_o;
(* MARK_DEBUG="true" *) (* keep="true" *)reg  [7:0]RX1_DATA_neg_o;
(* MARK_DEBUG="true" *) (* keep="true" *)reg  tx2_frame_pos;
(* MARK_DEBUG="true" *) (* keep="true" *)reg  tx2_frame_neg;
(* MARK_DEBUG="true" *) (* keep="true" *)reg  tx1_frame_pos;
(* MARK_DEBUG="true" *) (* keep="true" *)reg  tx1_frame_neg;

//wire  [1:0]probe_out0;
//wire  [1:0]probe_out1;
//wire  [1:0]probe_out2;
//wire  [1:0]probe_out3;
//wire  [7:0]probe_out4;
//wire  [7:0]probe_out5;
//wire  [7:0]probe_out6;
//wire  [7:0]probe_out7;
//wire  [7:0]probe_out8 ;
//wire  [7:0]probe_out9 ;
//wire  [7:0]probe_out10;
//wire  [7:0]probe_out11;

//reg  [15:0]TX2_I_DATA_BUFF0;
//reg  [15:0]TX2_Q_DATA_BUFF0;
//reg  [15:0]TX1_I_DATA_BUFF0;
//reg  [15:0]TX1_Q_DATA_BUFF0;
//reg  [15:0]TX2_I_DATA_BUFF1;
//reg  [15:0]TX2_Q_DATA_BUFF1;
//reg  [15:0]TX1_I_DATA_BUFF1;
//reg  [15:0]TX1_Q_DATA_BUFF1;
//wire  [15:0]TX2_I_DATA_BUFF2;
//wire  [15:0]TX2_Q_DATA_BUFF2;
//wire  [15:0]TX1_I_DATA_BUFF2;
//wire  [15:0]TX1_Q_DATA_BUFF2;

//always @(posedge mclk_g2)
//    if(R2)begin
//        TX2_I_DATA_BUFF0 <= 'b0;
//        TX2_Q_DATA_BUFF0 <= 'b0;
//        TX1_I_DATA_BUFF0 <= 'b0;
//        TX1_Q_DATA_BUFF0 <= 'b0;
//        TX2_I_DATA_BUFF1 <= 'b0;
//        TX2_Q_DATA_BUFF1 <= 'b0;
//        TX1_I_DATA_BUFF1 <= 'b0;
//        TX1_Q_DATA_BUFF1 <= 'b0;
//    end else begin
//        case (mode_sel)
//            3'b111: //single_port & tdd & r2t2 ---mode 4
//            begin
//                    TX2_I_DATA_BUFF0<=TX2_I_DATA_BUFF;
//                    TX2_Q_DATA_BUFF0<=TX2_Q_DATA_BUFF;
//                    TX1_I_DATA_BUFF0<=TX1_I_DATA_BUFF;
//                    TX1_Q_DATA_BUFF0<=TX1_Q_DATA_BUFF;
//                    TX2_I_DATA_BUFF1<=TX2_I_DATA_BUFF0;
//                    TX2_Q_DATA_BUFF1<=TX2_Q_DATA_BUFF0;
//                    TX1_I_DATA_BUFF1<=TX1_I_DATA_BUFF0;
//                    TX1_Q_DATA_BUFF1<=TX1_Q_DATA_BUFF0;
//            end
//            default:;
//        endcase
//    end

//assign TX2_I_DATA_BUFF2 = probe_out4[0] ? TX2_I_DATA_BUFF :
//                          probe_out4[1] ? TX2_Q_DATA_BUFF :
//                          probe_out4[2] ? TX1_I_DATA_BUFF :
//                          probe_out4[3] ? TX1_Q_DATA_BUFF :
//                          probe_out4[4] ? TX2_I_DATA_BUFF1 :
//                          probe_out4[5] ? TX2_Q_DATA_BUFF1 :
//                          probe_out4[6] ? TX1_I_DATA_BUFF1 :
//                          probe_out4[7] ? TX1_Q_DATA_BUFF1 :8'b0;
//assign TX2_Q_DATA_BUFF2 = probe_out5[0] ? TX2_I_DATA_BUFF :
//                          probe_out5[1] ? TX2_Q_DATA_BUFF :
//                          probe_out5[2] ? TX1_I_DATA_BUFF :
//                          probe_out5[3] ? TX1_Q_DATA_BUFF :
//                          probe_out5[4] ? TX2_I_DATA_BUFF1 :
//                          probe_out5[5] ? TX2_Q_DATA_BUFF1 :
//                          probe_out5[6] ? TX1_I_DATA_BUFF1 :
//                          probe_out5[7] ? TX1_Q_DATA_BUFF1 :8'b0;
//assign TX1_I_DATA_BUFF2 = probe_out6[0] ? TX2_I_DATA_BUFF :
//                          probe_out6[1] ? TX2_Q_DATA_BUFF :
//                          probe_out6[2] ? TX1_I_DATA_BUFF :
//                          probe_out6[3] ? TX1_Q_DATA_BUFF :
//                          probe_out6[4] ? TX2_I_DATA_BUFF1 :
//                          probe_out6[5] ? TX2_Q_DATA_BUFF1 :
//                          probe_out6[6] ? TX1_I_DATA_BUFF1 :
//                          probe_out6[7] ? TX1_Q_DATA_BUFF1 :8'b0;
//assign TX1_Q_DATA_BUFF2 = probe_out7[0] ? TX2_I_DATA_BUFF :
//                          probe_out7[1] ? TX2_Q_DATA_BUFF :
//                          probe_out7[2] ? TX1_I_DATA_BUFF :
//                          probe_out7[3] ? TX1_Q_DATA_BUFF :
//                          probe_out7[4] ? TX2_I_DATA_BUFF1 :
//                          probe_out7[5] ? TX2_Q_DATA_BUFF1 :
//                          probe_out7[6] ? TX1_I_DATA_BUFF1 :
//                          probe_out7[7] ? TX1_Q_DATA_BUFF1 :8'b0;


//vio_0 mode4_tx_frame (
//  .clk(mclk_g2),            // input wire clk
//  .probe_out0(probe_out0),  // output wire [1 : 0] probe_out0
//  .probe_out1(probe_out1),  // output wire [1 : 0] probe_out1
//  .probe_out2(probe_out2),  // output wire [1 : 0] probe_out2
//  .probe_out3(probe_out3),  // output wire [1 : 0] probe_out3
//  .probe_out4(probe_out4),  // output wire [7 : 0] probe_out4
//  .probe_out5(probe_out5),  // output wire [7 : 0] probe_out5
//  .probe_out6(probe_out6),  // output wire [7 : 0] probe_out6
//  .probe_out7(probe_out7),  // output wire [7 : 0] probe_out7
//  .probe_out8 (probe_out8 ),  // output wire [7 : 0] probe_out8
//  .probe_out9 (probe_out9 ),  // output wire [7 : 0] probe_out9
//  .probe_out10(probe_out10),  // output wire [7 : 0] probe_out10
//  .probe_out11(probe_out11)   // output wire [7 : 0] probe_out11
//);

always @(posedge mclk_g2)
    if(R2)begin
        TX2_DATA_pos_o <= 'b0;
        TX2_DATA_neg_o <= 'b0;
        RX2_DATA_pos_o <= 'b0;
        RX2_DATA_neg_o <= 'b0;
        tx2_frame_pos <= 'b0;
        tx2_frame_neg <= 'b0;

    end else begin
        case (mode_sel)
            3'b000://dual_port & fdd & r1t1 ---mode 6/7
            begin
                if(tx2_data_ready==1)begin
                    if(tx2_frame_pos)begin
                        tx2_frame_pos <= 1'b0;
                        tx2_frame_neg <= 1'b0;
                    end else begin
                        tx2_frame_pos <= 1'b1;
                        tx2_frame_neg <= 1'b1;
                    end
                end
            end
            3'b001: //dual_port & fdd & r2t2 ---mode 8
            begin
                if(tx2_data_ready == 1'b0)begin
                    tx2_frame_pos<= 1'b1;
                    tx2_frame_neg<= 1'b1;
                end else if(tx2_data_ready == 1'b1) begin
                    tx2_frame_pos<= 1'b0;
                    tx2_frame_neg<= 1'b0;
                end
            end
            3'b010:;//dual_port & tdd & r1t1 ---none
            3'b011: //dual_port & tdd & r2t2 ---mode 5
            begin
                if(tx2_data_ready == 1'b1)begin
                    RX2_DATA_pos_o<=TX2_I_DATA_BUFF[15:8];
                    TX2_DATA_pos_o<=TX2_I_DATA_BUFF[7:0];
                    RX2_DATA_neg_o<=TX1_I_DATA_BUFF[15:8];
                    TX2_DATA_neg_o<=TX1_I_DATA_BUFF[7:0];
                    tx2_frame_pos<= 1'b1;
                    tx2_frame_neg<= 1'b0;
                end
            end
            3'b100: //single_port & fdd & r1t1 ---mode 3
            begin
                if(tx2_data_ready==0)begin
                    TX2_DATA_pos_o<=TX2_I_DATA_BUFF[15:8];
                    TX2_DATA_neg_o<=TX2_I_DATA_BUFF[7:0];
                    tx2_frame_pos<= 1'b1;
                    tx2_frame_neg<= 1'b1;
                end else begin
                    TX2_DATA_pos_o<=TX2_Q_DATA_BUFF[15:8];
                    TX2_DATA_neg_o<=TX2_Q_DATA_BUFF[7:0];
                    tx2_frame_pos<= 1'b0;
                    tx2_frame_neg<= 1'b0;
                end
            end
            3'b101:;//single_port & fdd & r2t2 ---none
            3'b110: //single_port & tdd & r1t1 ---mode 1/2
            begin
                if(tx2_data_ready==1)begin
                    RX2_DATA_pos_o<=TX2_I_DATA_BUFF[15:8];
                    TX2_DATA_pos_o<=TX2_I_DATA_BUFF[7:0];
                    RX2_DATA_neg_o<=TX2_Q_DATA_BUFF[15:8];
                    TX2_DATA_neg_o<=TX2_Q_DATA_BUFF[7:0];
                    if(tx2_frame_pos==1)begin
                        tx2_frame_pos<= 1'b0;
                        tx2_frame_neg<= 1'b0;
                    end else begin
                        tx2_frame_pos<= 1'b1;
                        tx2_frame_neg<= 1'b1;
                    end
                end
            end
            3'b111: //single_port & tdd & r2t2 ---mode 4
            begin
                if(tx2_data_ready == 1'b0)begin
                    RX2_DATA_pos_o<= TX2_I_DATA_BUFF[15:8] ;
                    TX2_DATA_pos_o<= TX2_I_DATA_BUFF[7:0]  ;
                    RX2_DATA_neg_o<= TX2_Q_DATA_BUFF[15:8] ;
                    TX2_DATA_neg_o<= TX2_Q_DATA_BUFF[7:0]  ;
                    tx2_frame_pos<= 1'b1;
                    tx2_frame_neg<= 1'b1;
                end else if(tx2_data_ready == 1'b1)begin
                    RX2_DATA_pos_o<= TX1_I_DATA_BUFF[15:8] ;
                    TX2_DATA_pos_o<= TX1_I_DATA_BUFF[7:0]  ;
                    RX2_DATA_neg_o<= TX1_Q_DATA_BUFF[15:8] ;
                    TX2_DATA_neg_o<= TX1_Q_DATA_BUFF[7:0]  ;
                    tx2_frame_pos<= 1'b0;
                    tx2_frame_neg<= 1'b0;
                end
            end
            default:;
        endcase
    end

always @(posedge mclk_g)
    if(R)begin
        TX1_DATA_pos_o <= 'b0;
        TX1_DATA_neg_o <= 'b0;
        RX1_DATA_pos_o <= 'b0;
        RX1_DATA_neg_o <= 'b0;
        tx1_frame_pos <= 'b0;
        tx1_frame_neg <= 'b0;
    end else begin
        case (mode_sel)
            3'b000://dual_port & fdd & r1t1 ---mode 6/7
            begin
                if(tx1_data_ready0==1)begin
                    RX1_DATA_pos_o <= TX2_I_DATA_BUFF[15:8];
                    TX1_DATA_pos_o <= TX2_I_DATA_BUFF[7:0];
                    RX1_DATA_neg_o <= TX2_Q_DATA_BUFF[15:8];
                    TX1_DATA_neg_o <= TX2_Q_DATA_BUFF[7:0];
                end
            end
            3'b001: //dual_port & fdd & r2t2 ---mode 8
            begin
                if(tx1_data_ready0 == 1'b0)begin
                    RX1_DATA_pos_o<=TX2_I_DATA_BUFF[15:8];
                    TX1_DATA_pos_o<=TX2_I_DATA_BUFF[7:0];
                    RX1_DATA_neg_o<=TX2_Q_DATA_BUFF[15:8];
                    TX1_DATA_neg_o<=TX2_Q_DATA_BUFF[7:0];
                end else if(tx1_data_ready0 == 1'b1) begin
                    RX1_DATA_pos_o<=TX1_I_DATA_BUFF[15:8];
                    TX1_DATA_pos_o<=TX1_I_DATA_BUFF[7:0];
                    RX1_DATA_neg_o<=TX1_Q_DATA_BUFF[15:8];
                    TX1_DATA_neg_o<=TX1_Q_DATA_BUFF[7:0];
                end
            end
            3'b010:;//dual_port & tdd & r1t1 ---none
            3'b011: //dual_port & tdd & r2t2 ---mode 5
            begin
                if(tx1_data_ready0 == 1'b1)begin
                    RX1_DATA_pos_o<=TX2_Q_DATA_BUFF[15:8];
                    TX1_DATA_pos_o<=TX2_Q_DATA_BUFF[7:0];
                    RX1_DATA_neg_o<=TX1_Q_DATA_BUFF[15:8];
                    TX1_DATA_neg_o<=TX1_Q_DATA_BUFF[7:0];
                end
            end
            3'b100: //single_port & fdd & r1t1 ---mode 3
            begin
                if(tx1_data_ready0==0)begin
                    TX1_DATA_pos_o<=TX1_I_DATA_BUFF[15:8];
                    TX1_DATA_neg_o<=TX1_I_DATA_BUFF[7:0];
                    tx1_frame_pos<= 1'b1;
                    tx1_frame_neg<= 1'b1;
                end else begin
                    TX1_DATA_pos_o<=TX1_Q_DATA_BUFF[15:8];
                    TX1_DATA_neg_o<=TX1_Q_DATA_BUFF[7:0];
                    tx1_frame_pos<= 1'b0;
                    tx1_frame_neg<= 1'b0;
                end
            end
            3'b101:;//single_port & fdd & r2t2 ---none
            3'b110: //single_port & tdd & r1t1 ---mode 1/2
            begin
                if(tx1_data_ready0==1)begin
                        RX1_DATA_pos_o<=TX1_I_DATA_BUFF[15:8];
                        TX1_DATA_pos_o<=TX1_I_DATA_BUFF[7:0];
                        RX1_DATA_neg_o<=TX1_Q_DATA_BUFF[15:8];
                        TX1_DATA_neg_o<=TX1_Q_DATA_BUFF[7:0];
                    if(tx1_frame_pos==1)begin
                        tx1_frame_pos<= 1'b0;
                        tx1_frame_neg<= 1'b0;
                    end else begin
                        tx1_frame_pos<= 1'b1;
                        tx1_frame_neg<= 1'b1;
                    end
                end
            end
            3'b111:;//single_port & tdd & r2t2 ---mode 4
            default:;
        endcase
    end

//***************************************************TX DATA***********************************************************//

//***************************************************ODDR**************************************************************//

   ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) ODDR_TX1[7:0] (
      .Q(TX1_DATA_O),   // 1-bit DDR output
      .C(mclk_g),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(TX1_DATA_pos_o), // 1-bit data input (positive edge)
      .D2(TX1_DATA_neg_o), // 1-bit data input (negative edge)
      .R(R),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
   ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) ODDR_RX1[7:0] (
      .Q(RX1_DATA_O),   // 1-bit DDR output
      .C(mclk_g),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(RX1_DATA_pos_o), // 1-bit data input (positive edge)
      .D2(RX1_DATA_neg_o), // 1-bit data input (negative edge)
      .R(R),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );

   ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) ODDR_TX2[7:0] (
      .Q(TX2_DATA_O),   // 1-bit DDR output
      .C(mclk_g2),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(TX2_DATA_pos_o), // 1-bit data input (positive edge)
      .D2(TX2_DATA_neg_o), // 1-bit data input (negative edge)
      .R(R2),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
   ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) ODDR_RX2[7:0] (
      .Q(RX2_DATA_O),   // 1-bit DDR output
      .C(mclk_g2),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(RX2_DATA_pos_o), // 1-bit data input (positive edge)
      .D2(RX2_DATA_neg_o), // 1-bit data input (negative edge)
      .R(R2),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );


   ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) ODDR_TX_FRAME[1:0] (
      .Q({TX2_FRAME_IN_P,TX1_FRAME_IN_N}),   // 1-bit DDR output
      .C({mclk_g2,mclk_g}),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1({tx2_frame_pos,tx1_frame_pos}), // 1-bit data input (positive edge)
      .D2({tx2_frame_neg,tx1_frame_neg}), // 1-bit data input (negative edge)
      .R({R2,R1}),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
   ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
   ) ODDR_TX_FCLK[1:0] (
      .Q({TX2_FCLK_IN_P,TX1_FCLK_IN_N}),   // 1-bit DDR output
      .C({mclk_g2,mclk_g}),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1({1'b1,1'b1}), // 1-bit data input (positive edge)
      .D2({1'b0,1'b0}), // 1-bit data input (negative edge)
      .R({R2,R1}),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
//***************************************************ODDR**************************************************************//



endmodule
