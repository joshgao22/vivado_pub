`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//      _           _        ____
//     | | ___  ___| |__    / ___| __ _  ___
//  _  | |/ _ \/ __| '_ \  | |  _ / _` |/ _ \
// | |_| | (_) \__ \ | | | | |_| | (_| | (_) |
//  \___/ \___/|___/_| |_|  \____|\__,_|\___/
//
// Create Date: 2022/07/01 17:37:27
// Last Modified Date: 2023/03/03 13:01
// Design Name:
// Module Name: ad9361_rx_map_cmos_single
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


module ad9361_rx_map_cmos_single
(
    input           clk_in          ,
    input           clk_in_rst      ,

    input           rx_data_clk     ,
    input           rx_data_clk_rst ,

    input           rx_fifo_rst     ,

    input           rx_frame        ,
    input   [11:0]  rx_data         ,

    output  [11:0]  rx_data_i       ,
    output  [11:0]  rx_data_q
);

genvar mm;

// rx data from port
wire [11:0] rx_data_pos;
wire [11:0] rx_data_neg;

generate
for (mm = 0; mm < 12; mm = mm + 1) begin : rx_data_iddr
IDDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"    ), // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED"
    .INIT_Q1        (1'b0           ), // Initial value of Q1: 1'b0 or 1'b1
    .INIT_Q2        (1'b0           ), // Initial value of Q2: 1'b0 or 1'b1
    .SRTYPE         ("ASYNC"        )  // Set/Reset type: "SYNC" or "ASYNC"
) i_rx_data_iddr (
    .CE             (1'b1           ), // 1-bit clock enable input
    .R              (1'b0           ), // 1-bit reset
    .S              (1'b0           ), // 1-bit set
    .C              (clk_in         ), // 1-bit clock input
    .D              (rx_data[mm]    ), // 1-bit DDR data input
    .Q1             (rx_data_pos[mm]), // 1-bit output for positive edge of clock
    .Q2             (rx_data_neg[mm])  // 1-bit output for negative edge of clock
);

end
endgenerate

// rx frame from port
wire rx_frame_pos;
wire rx_frame_neg;

IDDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"    ), // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED"
    .INIT_Q1        (1'b0           ), // Initial value of Q1: 1'b0 or 1'b1
    .INIT_Q2        (1'b0           ), // Initial value of Q2: 1'b0 or 1'b1
    .SRTYPE         ("ASYNC"        )  // Set/Reset type: "SYNC" or "ASYNC"
) i_rx_frame_iddr (
    .CE             (1'b1           ), // 1-bit clock enable input
    .R              (1'b0           ), // 1-bit reset
    .S              (1'b0           ), // 1-bit set
    .C              (clk_in         ), // 1-bit clock input
    .D              (rx_frame       ), // 1-bit DDR data input
    .Q1             (rx_frame_pos   ), // 1-bit output for positive edge of clock
    .Q2             (rx_frame_neg   )  // 1-bit output for negative edge of clock
);

// rx data
reg [11:0] rx_fifo_i = 'b0;
reg [11:0] rx_fifo_q = 'b0;

always @(posedge clk_in) begin
    if (clk_in_rst) begin
        rx_fifo_i <= 'b0;
        rx_fifo_q <= 'b0;
    end
    else begin
        if ({rx_frame_neg,rx_frame_pos} == 2'b10) begin
            rx_fifo_i <= rx_data_neg;
            rx_fifo_q <= rx_data_pos;
        end
        else begin
            rx_fifo_i <= 'd1234; // error
            rx_fifo_q <= 'd4321; // error
        end
    end
end

// divide rx_data to dual channel
reg             rx_fifo_wr_en = 1'b0;
reg             rx_fifo_rd_en = 'b0;

wire            rx_fifo_empty_1;
wire            rx_fifo_empty_2;

always @(posedge clk_in) begin
    if (clk_in_rst) begin
        rx_fifo_wr_en <= 1'b0;
    end
    else begin
        rx_fifo_wr_en <= 1'b1;
    end
end

always @(posedge rx_data_clk) begin
    if (rx_data_clk_rst) begin
        rx_fifo_rd_en <= 'b0;
    end
    else begin
        rx_fifo_rd_en <= &{~rx_fifo_empty_1, ~rx_fifo_empty_2};
    end
end

ad9361_fifo u_rx_fifo_i
(
    .rst        (clk_in_rst || rx_fifo_rst  ), // input wire rst
    .wr_clk     (clk_in                     ), // input wire wr_clk
    .rd_clk     (rx_data_clk                ), // input wire rd_clk
    .din        (rx_fifo_i                  ), // input wire [11 : 0] din
    .wr_en      (rx_fifo_wr_en              ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en              ), // input wire rd_en
    .dout       (rx_data_i                  ), // output wire [11 : 0] dout
    .full       (                           ), // output wire full
    .empty      (rx_fifo_empty_1            )  // output wire empty
);

ad9361_fifo u_rx_fifo_q
(
    .rst        (clk_in_rst || rx_fifo_rst  ), // input wire rst
    .wr_clk     (clk_in                     ), // input wire wr_clk
    .rd_clk     (rx_data_clk                ), // input wire rd_clk
    .din        (rx_fifo_q                  ), // input wire [11 : 0] din
    .wr_en      (rx_fifo_wr_en              ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en              ), // input wire rd_en
    .dout       (rx_data_q                  ), // output wire [11 : 0] dout
    .full       (                           ), // output wire full
    .empty      (rx_fifo_empty_2            )  // output wire empty
);

endmodule
