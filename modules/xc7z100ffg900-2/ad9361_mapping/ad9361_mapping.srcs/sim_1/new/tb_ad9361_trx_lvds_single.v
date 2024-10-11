`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/27/2024 03:43:52 PM
// Design Name:
// Module Name: tb_ad9361_trx_lvds_single
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


module tb_ad9361_trx_lvds_single;

reg clk_2x_in = 'b0;
reg clk_in_rst = 'b0;
reg data_clk = 'b0;
reg data_clk_rst = 'b0;
reg [11:0] tx_data_i = 'b0;
reg [11:0] tx_data_q = 'b0;
wire [11:0] rx_data_i;
wire [11:0] rx_data_q;

wire clk_out_p;
wire clk_out_n;
wire tx_frame_p;
wire tx_frame_n;
wire [5:0] tx_data_p;
wire [5:0] tx_data_n;

ad9361_tx_map_lvds_single dut_tx
(
    .clk_2x_in      (clk_2x_in      ),
    .clk_in_rst     (clk_in_rst     ),

    .tx_data_clk    (data_clk       ),
    .tx_data_clk_rst(data_clk_rst   ),

    .tx_data_i      (tx_data_i      ),
    .tx_data_q      (tx_data_q      ),

    .clk_out_p      (clk_out_p      ),
    .clk_out_n      (clk_out_n      ),
    .tx_frame_p     (tx_frame_p     ),
    .tx_frame_n     (tx_frame_n     ),
    .tx_data_p      (tx_data_p      ),
    .tx_data_n      (tx_data_n      )
);

ad9361_rx_map_lvds_single dut_rx
(
    .clk_2x_in      (clk_2x_in      ),
    .clk_in_rst     (clk_in_rst     ),

    .rx_data_clk    (data_clk       ),
    .rx_data_clk_rst(data_clk_rst   ),

    .rx_fifo_rst    (1'b0           ),

    .rx_frame_p     (tx_frame_p     ),
    .rx_frame_n     (tx_frame_n     ),
    .rx_data_p      (tx_data_p      ),
    .rx_data_n      (tx_data_n      ),

    .rx_data_i      (rx_data_i      ),
    .rx_data_q      (rx_data_q      )
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
        tx_data_i <= 'b0;
        tx_data_q <= 'b0;
    end
    else begin
        tx_data_i <= tx_data_i + 2'd1;
        tx_data_q <= tx_data_q + 2'd2;
    end
end

endmodule
