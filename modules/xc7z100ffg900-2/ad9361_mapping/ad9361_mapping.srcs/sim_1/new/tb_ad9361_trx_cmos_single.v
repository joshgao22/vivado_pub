`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/27/2024 04:34:43 PM
// Design Name:
// Module Name: tb_ad9361_trx_cmos_single
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


module tb_ad9361_trx_cmos_single;

reg clk_in = 'b0;
reg clk_in_rst = 'b0;
wire data_clk;
reg data_clk_rst = 'b0;
reg [11:0] tx_data_i = 'b0;
reg [11:0] tx_data_q = 'b0;
wire [11:0] rx_data_i;
wire [11:0] rx_data_q;

wire clk_out;
wire tx_frame;
wire [11:0] tx_data;

ad9361_tx_map_cmos_single dut_tx
(
    .clk_in         (clk_in         ),
    .clk_in_rst     (clk_in_rst     ),

    .tx_data_clk    (data_clk       ),
    .tx_data_clk_rst(data_clk_rst   ),

    .tx_data_i      (tx_data_i      ),
    .tx_data_q      (tx_data_q      ),

    .clk_out        (clk_out        ),
    .tx_frame       (tx_frame       ),
    .tx_data        (tx_data        )
);

ad9361_rx_map_cmos_single dut_rx
(
    .clk_in         (clk_in         ),
    .clk_in_rst     (clk_in_rst     ),

    .rx_data_clk    (data_clk       ),
    .rx_data_clk_rst(data_clk_rst   ),

    .rx_fifo_rst    (1'b0           ),

    .rx_frame       (tx_frame       ),
    .rx_data        (tx_data        ),

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

always #20 clk_in = ~clk_in;
assign #7 data_clk = clk_in;

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
