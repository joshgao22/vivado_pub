`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/02/04 10:28:47
// Design Name:
// Module Name: mclk_delay
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


module mclk_delay(
	input  wire    RX2_MCLK_IN_P,
	input  wire    RX1_MCLK_IN_N,
	input  wire    RX3_MCLK_IN,
    input  wire    rst,
	output wire    MCLK1,
	output wire    MCLK2,
	output wire    MCLK3,
	(* MARK_DEBUG="true" *)input  wire    MCLK_DELAY_CTRL0,
    (* MARK_DEBUG="true" *)input  wire    MCLK_DELAY_CTRL1,
    (* MARK_DEBUG="true" *)input  wire    MCLK_DELAY_CTRL2,
    input  wire    CX3E04_CLK_P,
    input  wire    CX3E04_CLK_N,
    input  wire    CX3E04_SYNC_P,
    input  wire    CX3E04_SYNC_N,
	inout  wire    FREF_DIV_MODE,
	input  wire    ui_clk,
	input  wire    sma_clk,
	input  wire    OSC_OUT
    );

//Debug Signal
wire                  cx3e04_sync;
reg                   r_cx3e04_sync;
wire                  cx3e04_clk;

//wire                  s_mclk;
//wire                  RX_MCLK;
//wire                  locked;
wire [4:0] MCLK_DELAY_SETVALUE0;
wire [4:0] MCLK_DELAY_SETVALUE1;
wire [4:0] MCLK_DELAY_SETVALUE2;
wire [4:0] MCLK_DELAY_CURVALUE0;
wire [4:0] MCLK_DELAY_CURVALUE1;
wire [4:0] MCLK_DELAY_CURVALUE2;

wire                  ld;
wire                  ce;
wire                  inv;

reg    r_MCLK_DELAY_CTRL0;
reg    r_MCLK_DELAY_CTRL0_DFF;
reg    r_MCLK_DELAY_CTRL1;
reg    r_MCLK_DELAY_CTRL1_DFF;
reg    r_MCLK_DELAY_CTRL2;
//--------------------time of power_on to stable_rtx--------------------//
/*
FREF_DIV_MODE=0；f(OSC_OUT)= f(CX9261A_ref)
FREF_DIV_MODE=1；f(OSC_OUT)= f(CX9261A_ref)/2
*/
//IOBUF OSC_OUT_DIV(
//    .I  ( 1'b0 ),//IOBUF output
//    .IO ( FREF_DIV_MODE ),//IOBUF inout
//    .O  (),//IOBUF input
//    .T  ( 1'b0 ) //IOBUF input  high=fpga rx, low= fpga tx
//);

IBUFDS #(
   .DIFF_TERM   ("FALSE"),       // Differential Termination
   .IBUF_LOW_PWR("TRUE" ),       // Low power="TRUE", Highest performance="FALSE"
   .IOSTANDARD  ("DEFAULT")      // Specify the input I/O standard
) IBUFDS_sync (
   .O(cx3e04_sync),         // Buffer output
   .I (CX3E04_SYNC_P),  // Diff_p buffer input (connect directly to top-level port)
   .IB(CX3E04_SYNC_N)   // Diff_n buffer input (connect directly to top-level port)
);

IBUFDS #(
   .DIFF_TERM   ("FALSE"),       // Differential Termination
   .IBUF_LOW_PWR("TRUE" ),       // Low power="TRUE", Highest performance="FALSE"
   .IOSTANDARD  ("DEFAULT")      // Specify the input I/O standard
) IBUFDS_clk (
   .O(cx3e04_clk),         // Buffer output
   .I (CX3E04_CLK_P),  // Diff_p buffer input (connect directly to top-level port)
   .IB(CX3E04_CLK_N)   // Diff_n buffer input (connect directly to top-level port)
);
always @(posedge cx3e04_clk)begin
    r_cx3e04_sync <= cx3e04_sync;
end

    //---------------------sync/clk---------------------//
vio_mclk_delay mclk_delay (
  .clk(ui_clk),                // input wire clk
  .probe_in0(MCLK_DELAY_CURVALUE0),  // output wire [0 : 0] probe_out0
  .probe_in1(MCLK_DELAY_CURVALUE1),  // output wire [0 : 0] probe_out0
  .probe_in2(MCLK_DELAY_CURVALUE2),  // output wire [0 : 0] probe_out0
  .probe_out0(MCLK_DELAY_SETVALUE0),  // output wire [0 : 0] probe_out1
  .probe_out1(MCLK_DELAY_SETVALUE1),  // output wire [0 : 0] probe_out1
  .probe_out2(MCLK_DELAY_SETVALUE2)  // output wire [0 : 0] probe_out1
);
//确定延迟后，将IDELAY_TYPE改为FIXED,确认后延迟写入IDELAY_VALUE，其他不变

(* IODELAY_GROUP = "IDELAY_CTRL_RX12" *)
IDELAYE2 #(
      .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
      .DELAY_SRC("IDATAIN"),           // Delay input (IDATAIN, DATAIN)
      .HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
      .IDELAY_TYPE("VAR_LOAD"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      .IDELAY_VALUE(0),                // Input delay tap setting (0-31)
      .PIPE_SEL("FALSE"),              // Select pipelined mode, FALSE, TRUE
      .REFCLK_FREQUENCY(200.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
      .SIGNAL_PATTERN("CLOCK")          // DATA, CLOCK input signal
   )
   IDELAYE2_RX1 (
      .CNTVALUEOUT(MCLK_DELAY_CURVALUE0), // 5-bit output: Counter value output
      .DATAOUT(MCLK1),         // 1-bit output: Delayed data output
      .C(ui_clk),                     // 1-bit input: Clock input
      .CE(ce),                   // 1-bit input: Active high enable increment/decrement input
      .CINVCTRL(1'b0),       // 1-bit input: Dynamic clock inversion input
      .CNTVALUEIN(MCLK_DELAY_SETVALUE0),   // 5-bit input: Counter value input
      .DATAIN(1'b0),           // 1-bit input: Internal delay data input
      .IDATAIN(RX1_MCLK_IN_N),         // 1-bit input: Data input from the I/O
      .INC(r_MCLK_DELAY_CTRL2),  // 1-bit input: Increment / Decrement tap delay input
      .LD(ld),                   // 1-bit input: Load IDELAY_VALUE input
      .LDPIPEEN(1'b0),       // 1-bit input: Enable PIPELINE register to load data input
      .REGRST(rst)            // 1-bit input: Active-high reset tap-delay input
   );

(* IODELAY_GROUP = "IDELAY_CTRL_RX12" *)
IDELAYE2 #(
      .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
      .DELAY_SRC("IDATAIN"),           // Delay input (IDATAIN, DATAIN)
      .HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
      .IDELAY_TYPE("VAR_LOAD"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      .IDELAY_VALUE(0),                // Input delay tap setting (0-31)
      .PIPE_SEL("FALSE"),              // Select pipelined mode, FALSE, TRUE
      .REFCLK_FREQUENCY(200.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
      .SIGNAL_PATTERN("CLOCK")          // DATA, CLOCK input signal
   )
   IDELAYE2_RX2 (
      .CNTVALUEOUT(MCLK_DELAY_CURVALUE1), // 5-bit output: Counter value output
      .DATAOUT(MCLK2),         // 1-bit output: Delayed data output
      .C(ui_clk),                     // 1-bit input: Clock input
      .CE(ce),                   // 1-bit input: Active high enable increment/decrement input
      .CINVCTRL(1'b0),       // 1-bit input: Dynamic clock inversion input
      .CNTVALUEIN(MCLK_DELAY_SETVALUE1),   // 5-bit input: Counter value input
      .DATAIN(1'b0),           // 1-bit input: Internal delay data input
      .IDATAIN(RX2_MCLK_IN_P),         // 1-bit input: Data input from the I/O
      .INC(r_MCLK_DELAY_CTRL2),  // 1-bit input: Increment / Decrement tap delay input
      .LD(ld),                   // 1-bit input: Load IDELAY_VALUE input
      .LDPIPEEN(1'b0),       // 1-bit input: Enable PIPELINE register to load data input
      .REGRST(rst)            // 1-bit input: Active-high reset tap-delay input
   );

   (* IODELAY_GROUP = "IDELAY_CTRL_RX12" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

   IDELAYCTRL IDELAYCTRL_RX12 (
      .RDY(),       // 1-bit output: Ready output
      .REFCLK(ui_clk), // 1-bit input: Reference clock input
      .RST(rst)        // 1-bit input: Active high reset input
   );


(* IODELAY_GROUP = "IDELAY_CTRL_RX3" *)
IDELAYE2 #(
      .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
      .DELAY_SRC("IDATAIN"),           // Delay input (IDATAIN, DATAIN)
      .HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
      .IDELAY_TYPE("VAR_LOAD"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      .IDELAY_VALUE(0),                // Input delay tap setting (0-31)
      .PIPE_SEL("FALSE"),              // Select pipelined mode, FALSE, TRUE
      .REFCLK_FREQUENCY(200.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
      .SIGNAL_PATTERN("CLOCK")          // DATA, CLOCK input signal
   )
   IDELAYE2_RXFB (
      .CNTVALUEOUT(MCLK_DELAY_CURVALUE2), // 5-bit output: Counter value output
      .DATAOUT(MCLK3),         // 1-bit output: Delayed data output
      .C(ui_clk),                     // 1-bit input: Clock input
      .CE(ce),                   // 1-bit input: Active high enable increment/decrement input
      .CINVCTRL(1'b0),       // 1-bit input: Dynamic clock inversion input
      .CNTVALUEIN(MCLK_DELAY_SETVALUE2),   // 5-bit input: Counter value input
      .DATAIN(1'b0),           // 1-bit input: Internal delay data input
      .IDATAIN(RX3_MCLK_IN),         // 1-bit input: Data input from the I/O
      .INC(r_MCLK_DELAY_CTRL2),  // 1-bit input: Increment / Decrement tap delay input
      .LD(ld),                   // 1-bit input: Load IDELAY_VALUE input
      .LDPIPEEN(1'b0),       // 1-bit input: Enable PIPELINE register to load data input
      .REGRST(rst)            // 1-bit input: Active-high reset tap-delay input
   );

   (* IODELAY_GROUP = "IDELAY_CTRL_RX3" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

   IDELAYCTRL IDELAYCTRL_RX3 (
      .RDY(),       // 1-bit output: Ready output
      .REFCLK(ui_clk), // 1-bit input: Reference clock input
      .RST(rst)        // 1-bit input: Active high reset input
   );


	always @(posedge ui_clk)begin
	    r_MCLK_DELAY_CTRL0      <=   MCLK_DELAY_CTRL0 ;
        r_MCLK_DELAY_CTRL0_DFF  <= r_MCLK_DELAY_CTRL0 ;
        r_MCLK_DELAY_CTRL1      <=   MCLK_DELAY_CTRL1 ;
        r_MCLK_DELAY_CTRL1_DFF  <= r_MCLK_DELAY_CTRL1 ;
        r_MCLK_DELAY_CTRL2      <=   MCLK_DELAY_CTRL2 ;
	end

	assign ld = ~r_MCLK_DELAY_CTRL0_DFF & r_MCLK_DELAY_CTRL0;
	assign ce = ~r_MCLK_DELAY_CTRL1_DFF & r_MCLK_DELAY_CTRL1;

endmodule
