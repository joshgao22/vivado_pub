`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/02/2024 10:34:10 AM
// Design Name:
// Module Name: system_top
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

`define C_NUM_QUADS 1
`define C_REFCLKS_USED 1

module system_top
(
    // GT ports
    TXN_O,
    TXP_O,
    RXN_I,
    RXP_I,
    GTREFCLK0P_I,
    GTREFCLK0N_I,
    GTREFCLK1P_I,
    GTREFCLK1N_I,

    // PS ports
    DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb
);

// GT ports
output [(4*`C_NUM_QUADS)-1:0] TXN_O;
output [(4*`C_NUM_QUADS)-1:0] TXP_O;
input [(4*`C_NUM_QUADS)-1:0] RXN_I;
input [(4*`C_NUM_QUADS)-1:0] RXP_I;
input [`C_REFCLKS_USED-1:0] GTREFCLK0P_I;
input [`C_REFCLKS_USED-1:0] GTREFCLK0N_I;
input [`C_REFCLKS_USED-1:0] GTREFCLK1P_I;
input [`C_REFCLKS_USED-1:0] GTREFCLK1N_I;

// PS ports
inout [14:0]DDR_addr;
inout [2:0]DDR_ba;
inout DDR_cas_n;
inout DDR_ck_n;
inout DDR_ck_p;
inout DDR_cke;
inout DDR_cs_n;
inout [3:0]DDR_dm;
inout [31:0]DDR_dq;
inout [3:0]DDR_dqs_n;
inout [3:0]DDR_dqs_p;
inout DDR_odt;
inout DDR_ras_n;
inout DDR_reset_n;
inout DDR_we_n;
inout FIXED_IO_ddr_vrn;
inout FIXED_IO_ddr_vrp;
inout [53:0]FIXED_IO_mio;
inout FIXED_IO_ps_clk;
inout FIXED_IO_ps_porb;
inout FIXED_IO_ps_srstb;

system_bd_wrapper u_system_bd_wrapper
(
    .DDR_addr           (DDR_addr           ),
    .DDR_ba             (DDR_ba             ),
    .DDR_cas_n          (DDR_cas_n          ),
    .DDR_ck_n           (DDR_ck_n           ),
    .DDR_ck_p           (DDR_ck_p           ),
    .DDR_cke            (DDR_cke            ),
    .DDR_cs_n           (DDR_cs_n           ),
    .DDR_dm             (DDR_dm             ),
    .DDR_dq             (DDR_dq             ),
    .DDR_dqs_n          (DDR_dqs_n          ),
    .DDR_dqs_p          (DDR_dqs_p          ),
    .DDR_odt            (DDR_odt            ),
    .DDR_ras_n          (DDR_ras_n          ),
    .DDR_reset_n        (DDR_reset_n        ),
    .DDR_we_n           (DDR_we_n           ),
    .FIXED_IO_ddr_vrn   (FIXED_IO_ddr_vrn   ),
    .FIXED_IO_ddr_vrp   (FIXED_IO_ddr_vrp   ),
    .FIXED_IO_mio       (FIXED_IO_mio       ),
    .FIXED_IO_ps_clk    (FIXED_IO_ps_clk    ),
    .FIXED_IO_ps_porb   (FIXED_IO_ps_porb   ),
    .FIXED_IO_ps_srstb  (FIXED_IO_ps_srstb  )
);


//
// Ibert refclk internal signals
//
wire [`C_NUM_QUADS-1:0] gtrefclk0_i;
wire [`C_NUM_QUADS-1:0] gtrefclk1_i;
wire [`C_REFCLKS_USED-1:0] refclk0_i;
wire [`C_REFCLKS_USED-1:0] refclk1_i;

//
// Refclk IBUFDS instantiations
//
IBUFDS_GTE2 u_buf_q1_clk0
(
    .O      (refclk0_i[0]   ),
    .ODIV2  (               ),
    .CEB    (1'b0           ),
    .I      (GTREFCLK0P_I[0]),
    .IB     (GTREFCLK0N_I[0])
);

IBUFDS_GTE2 u_buf_q1_clk1
(
    .O      (refclk1_i[0]   ),
    .ODIV2  (               ),
    .CEB    (1'b0           ),
    .I      (GTREFCLK1P_I[0]),
    .IB     (GTREFCLK1N_I[0])
);

//
// Refclk connection from each IBUFDS to respective quads depending on the source selected in gui
//
assign gtrefclk0_i[0] = refclk0_i[0];
assign gtrefclk1_i[0] = refclk1_i[0];

//
// IBERT core instantiation
//
ibert_7series_gtx_0 u_ibert_core
(
    .TXN_O      (TXN_O      ),
    .TXP_O      (TXP_O      ),
    .RXN_I      (RXN_I      ),
    .RXP_I      (RXP_I      ),
    .GTREFCLK0_I(gtrefclk0_i),
    .GTREFCLK1_I(gtrefclk1_i)
);

endmodule
