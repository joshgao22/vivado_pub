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

genvar          m;

// rx data
wire [11:0] rx_raw_i, rx_raw_q;

generate
for (m=0; m<12; m=m+1) begin : rx_data_iddr

IDDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"    ),
    .INIT_Q1        (1'b0           ),
    .INIT_Q2        (1'b0           ),
    .SRTYPE         ("ASYNC"        )
) i_rx_data_iddr (
    .CE             (1'b1           ),
    .R              (1'b0           ),
    .S              (1'b0           ),
    .C              (clk_in         ),
    .D              (rx_data[m]     ),
    .Q1             (rx_raw_q[m]    ),
    .Q2             (rx_raw_i[m]    )
);

end
endgenerate


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
    .rst        (rx_fifo_rst    ), // input wire rst
    .wr_clk     (clk_in         ), // input wire wr_clk
    .rd_clk     (rx_data_clk    ), // input wire rd_clk
    .din        (rx_raw_i       ), // input wire [11 : 0] din
    .wr_en      (rx_fifo_wr_en  ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en  ), // input wire rd_en
    .dout       (rx_data_i      ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (rx_fifo_empty_1)  // output wire empty
);

ad9361_fifo u_rx_fifo_q
(
    .rst        (rx_fifo_rst    ), // input wire rst
    .wr_clk     (clk_in         ), // input wire wr_clk
    .rd_clk     (rx_data_clk    ), // input wire rd_clk
    .din        (rx_raw_q       ), // input wire [11 : 0] din
    .wr_en      (rx_fifo_wr_en  ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en  ), // input wire rd_en
    .dout       (rx_data_q      ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (rx_fifo_empty_2)  // output wire empty
);

endmodule
