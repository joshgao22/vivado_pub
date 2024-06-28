`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/23 20:39:14
// Design Name:
// Module Name: tb_baseband_new
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


module tb_baseband();

reg             clk = 'b0;
reg             rst = 'b1;
wire    [15:0]  tx_data_i;
wire    [15:0]  tx_data_q;

reg     [ 1:0]  waveform_sel = 2'b00;
reg             sweep_on = 1'b0;
reg     [31:0]  freq_set = 32'd0; // 20 / 245.76 * 2^31
reg     [ 1:0]  iq_sel = 2'b11;
reg     [ 3:0]  bb_rshift = 4'd0;

baseband_tx u_baseband_tx
(
    .clk            (clk            ),
    .rst            (rst            ),
    .tx_data_i      (tx_data_i      ),
    .tx_data_q      (tx_data_q      ),

    .waveform_sel   (waveform_sel   ),
    .sweep_on       (sweep_on       ),
    .freq_set       (freq_set       ),
    .iq_sel         (iq_sel         ),
    .bb_rshift      (bb_rshift      )
);

initial begin
    #101 rst = 1'b0;
end

always #3 clk = ~clk;

endmodule
