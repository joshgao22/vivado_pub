`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/27/2024 04:42:03 PM
// Design Name:
// Module Name: tb_ad9361_trx_cmos_dual
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


module tb_ad9361_trx_cmos_dual;

reg clk_2x_in = 'b0;
reg clk_in_rst = 'b0;
reg data_clk = 'b0;
reg data_clk_rst = 'b0;
reg [11:0] tx_ch1_i = 'b0;
reg [11:0] tx_ch1_q = 'b0;
reg [11:0] tx_ch2_i = 'b0;
reg [11:0] tx_ch2_q = 'b0;
wire [11:0] rx_ch1_i;
wire [11:0] rx_ch1_q;
wire [11:0] rx_ch2_i;
wire [11:0] rx_ch2_q;

wire clk_out;
wire tx_frame;
wire [11:0] tx_data;

ad9361_tx_map_cmos_dual dut_tx
(
    .clk_2x_in      (clk_2x_in      ),
    .clk_in_rst     (clk_in_rst     ),

    .tx_data_clk    (data_clk       ),
    .tx_data_clk_rst(data_clk_rst   ),

    .tx_ch1_i       (tx_ch1_i       ),
    .tx_ch1_q       (tx_ch1_q       ),
    .tx_ch2_i       (tx_ch2_i       ),
    .tx_ch2_q       (tx_ch2_q       ),

    .clk_out        (clk_out        ),
    .tx_frame       (tx_frame       ),
    .tx_data        (tx_data        )
);

ad9361_rx_map_cmos_dual dut_rx
(
    .clk_2x_in      (clk_2x_in      ),
    .clk_in_rst     (clk_in_rst     ),

    .rx_data_clk    (data_clk       ), // sync to output data
    .rx_data_clk_rst(data_clk_rst   ),

    .rx_fifo_rst    (1'b0           ),  // async fifo reset

    .rx_frame       (tx_frame       ),
    .rx_data        (tx_data        ),

    .rx_ch1_i       (rx_ch1_i       ),
    .rx_ch1_q       (rx_ch1_q       ),
    .rx_ch2_i       (rx_ch2_i       ),
    .rx_ch2_q       (rx_ch2_q       )
);

initial begin
    clk_in_rst = 1'b1;
    data_clk_rst = 1'b1;
    #102
    clk_in_rst = 'b0;
    #333
    data_clk_rst = 'b0;
end

always #20 clk_2x_in = ~clk_2x_in;

always @(posedge clk_2x_in) begin
    #7 data_clk <= ~data_clk;
end

always @(posedge data_clk) begin
    if (data_clk_rst) begin
        tx_ch1_i <= 'b0;
        tx_ch1_q <= 'b0;
        tx_ch2_i <= 'b0;
        tx_ch2_q <= 'b0;
    end
    else begin
        tx_ch1_i <= tx_ch1_i + 3'd1;
        tx_ch1_q <= tx_ch1_q + 3'd2;
        tx_ch2_i <= tx_ch2_i + 3'd3;
        tx_ch2_q <= tx_ch2_q + 3'd4;
    end
end

endmodule
