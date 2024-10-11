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
// Create Date: 2022/07/01 16:39:19
// Design Name:
// Module Name: ad9361_tx_mapping_single
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


module ad9361_tx_map_cmos_single
(
    input           clk_in          ,
    input           clk_in_rst      ,

    input           tx_data_clk     ,
    input           tx_data_clk_rst ,

    input   [11:0]  tx_data_i       ,
    input   [11:0]  tx_data_q       ,

    output          clk_out         ,
    output          tx_frame        ,
    output  [11:0]  tx_data
);

genvar mm;

// inout data fifo
wire [11:0] tx_fifo_i;
wire [11:0] tx_fifo_q;

ad9361_fifo u_tx_fifo_i
(
    .rst        (clk_in_rst     ), // input wire rst
    .wr_clk     (tx_data_clk    ), // input wire wr_clk
    .rd_clk     (clk_in         ), // input wire rd_clk
    .din        (tx_data_i      ), // input wire [11 : 0] din
    .wr_en      (1'b1           ), // input wire wr_en
    .rd_en      (1'b1           ), // input wire rd_en
    .dout       (tx_fifo_i      ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (               )  // output wire empty
);

ad9361_fifo u_tx_fifo_q
(
    .rst        (clk_in_rst     ), // input wire rst
    .wr_clk     (tx_data_clk    ), // input wire wr_clk
    .rd_clk     (clk_in         ), // input wire rd_clk
    .din        (tx_data_q      ), // input wire [11 : 0] din
    .wr_en      (1'b1           ), // input wire wr_en
    .rd_en      (1'b1           ), // input wire rd_en
    .dout       (tx_fifo_q      ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (               )  // output wire empty
);

// frame and data control
assign tx_frame_i = 1'b1;
assign tx_frame_q = 1'b0;

// output clock to port
assign clk_out = clk_in;

// output tx frame to port
ODDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"    ), // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT           (1'b0           ), // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE         ("ASYNC"        )  // Set/Reset type: "SYNC" or "ASYNC"
) u_tx_frame_oddr (
    .CE             (1'b1           ), // 1-bit clock enable input
    .R              (1'b0           ), // 1-bit reset
    .S              (1'b0           ), // 1-bit set
    .C              (clk_in         ), // 1-bit clock input
    .D1             (tx_frame_i     ), // 1-bit data input (positive edge)
    .D2             (tx_frame_q     ), // 1-bit data input (negative edge)
    .Q              (tx_frame       )  // 1-bit DDR output
);

// output tx data to port
generate
for (mm = 0; mm < 12; mm = mm + 1) begin: tx_data_oddr

ODDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"   ), // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT           (1'b0          ), // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE         ("ASYNC"       )  // Set/Reset type: "SYNC" or "ASYNC"
) u_tx_data_oddr (
    .CE             (1'b1          ), // 1-bit clock enable input
    .R              (1'b0          ), // 1-bit reset
    .S              (1'b0          ), // 1-bit set
    .C              (clk_in        ), // 1-bit clock input
    .D1             (tx_fifo_i[mm] ), // 1-bit data input (positive edge)
    .D2             (tx_fifo_q[mm] ), // 1-bit data input (negative edge)
    .Q              (tx_data[mm]   )  // 1-bit DDR output
);

end
endgenerate

endmodule
