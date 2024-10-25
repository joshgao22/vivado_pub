`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/11/06 10:15:51
// Design Name: syb
// Module Name: cx9261a_if
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

module cx9261a_if (
    //rst &  interface mode selection
    input           rst,
    input           sp_dp_sel,
    input           tr_sel,
    input           tdd_fdd_sel,
   	input           r1t1_r2t2_sel,
   	//cx9261a rx-tx data
    output          data_clk,
    output          data_clk2,
    output          data_clk3,
    output          data_valid,
	output          data_valid2,
    output          data_valid3,
    output [15:0]   rx1_i_data,
    output [15:0]   rx1_q_data,
    output [15:0]   rx2_i_data,
    output [15:0]   rx2_q_data,
    output [15:0]   rx3_i_data,
    output [15:0]   rx3_q_data,
    input  [15:0]   tx1_i_data,
    input  [15:0]   tx1_q_data,
    input  [15:0]   tx2_i_data,
    input  [15:0]   tx2_q_data,
    output          tx_data_ready,
    output          tx_data_ready2,
	input           power_on_flag,
    //cx9261a if
	input           RX1_FRAME_N,
	input           RX2_FRAME_P,
	input           RX3_FRAME ,
	input           RX1_MCLK_IN_N,
	input           RX2_MCLK_IN_P,
	input           RX3_MCLK_IN,
	output          TX1_FCLK_IN_N,
    output          TX2_FCLK_IN_P,
	output          TX1_FRAME_IN_N,
	output          TX2_FRAME_IN_P,
	inout  [ 7:0]   RX1_FDD_DATA_IO,
	inout  [ 7:0]   RX2_FDD_DATA_IO,
	inout  [ 7:0]   TX1_FDD_DATA_IO,
	inout  [ 7:0]   TX2_FDD_DATA_IO,
	inout  [ 7:0]   RX3_FDD_DATA_IO,
	inout  [ 7:0]   TX3_FDD_DATA_IO
    );

// cmos port TRX1 TRX2
	cx9261a_if_cmos_port u_cx9261a_if_cmos_port(
	.rst(rst),
	.sp_dp_sel(sp_dp_sel),
	.tr_sel(tr_sel),
	.tdd_fdd_sel(tdd_fdd_sel),
	.r1t1_r2t2_sel(r1t1_r2t2_sel),

	.data_clk1(data_clk),
	.data_clk2(data_clk2),
	.rx1_data_valid(data_valid),
	.rx2_data_valid(data_valid2),
	.rx1_i_data(rx1_i_data),
	.rx1_q_data(rx1_q_data),
	.rx2_i_data(rx2_i_data),
	.rx2_q_data(rx2_q_data),

	.tx_data_valid( power_on_flag ),
	.tx1_i_data( tx1_i_data ),
	.tx1_q_data( tx1_q_data ),
	.tx2_i_data( tx2_i_data ),
	.tx2_q_data( tx2_q_data ),
	.tx1_data_ready( tx_data_ready ),
	.tx2_data_ready( tx_data_ready2 ),
	.RX1_FRAME_N(	RX1_FRAME_N	),
	.RX1_MCLK_IN_N( RX1_MCLK_IN_N	),
	.RX2_FRAME_P(	RX2_FRAME_P	),
	.RX2_MCLK_IN_P( RX2_MCLK_IN_P	),
	.TX1_FCLK_IN_N( TX1_FCLK_IN_N		),
	.TX1_FRAME_IN_N( TX1_FRAME_IN_N		),
	.TX2_FCLK_IN_P( TX2_FCLK_IN_P		),
	.TX2_FRAME_IN_P( TX2_FRAME_IN_P		),
	.RX1_DATA_IO( RX1_FDD_DATA_IO		),
	.TX1_DATA_IO( TX1_FDD_DATA_IO		),
	.RX2_DATA_IO( RX2_FDD_DATA_IO		),
	.TX2_DATA_IO( TX2_FDD_DATA_IO		)
	);

  // cmos port RX3
	cx9261a_if_cmos_singleport u_cx9261a_if_cmos_RX3(
	.rst(rst),
	.tr_sel(1'b1),
	.tdd_fdd_sel(tdd_fdd_sel),
	.r1t1_r2t2_sel(1'b0),
	.data_clk(data_clk3),
	.data_valid(data_valid3),
	.rx_i_data(rx3_i_data),
	.rx_q_data(rx3_q_data),
	.rx2_i_data(),
	.rx2_q_data(),

	.tx_data_valid( 1'b1 ),
	.tx_i_data('b0  ),
	.tx_q_data('b0  ),
	.tx2_i_data('b0  ),
	.tx2_q_data('b0  ),
	.tx_data_ready(  ),
	.RX_FRAME_IN(RX3_FRAME	),
	.RX_MCLK_IN(RX3_MCLK_IN	),
	.TX_FCLK_IN( 		),
	.TX_FRAME_IN( 		),
	.RX_FDD_DATA_IO( RX3_FDD_DATA_IO		),
	.TX_FDD_DATA_IO( TX3_FDD_DATA_IO		)
	);

endmodule
