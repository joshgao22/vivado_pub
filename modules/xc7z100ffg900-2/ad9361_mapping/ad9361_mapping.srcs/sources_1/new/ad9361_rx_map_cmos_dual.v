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
// Last Modified Date: 2023/03/06 11:26
// Design Name:
// Module Name: ad9361_rx_map_cmos_dual
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


module ad9361_rx_map_cmos_dual
(
    input           clk_2x_in       ,
    input           clk_in_rst      ,

    input           rx_data_clk     , // sync to output data
    input           rx_data_clk_rst ,

    input           rx_fifo_rst     ,  // async fifo reset

    input           rx_frame        ,
    input   [11:0]  rx_data         ,

    output  [11:0]  rx_ch1_i        ,
    output  [11:0]  rx_ch1_q        ,
    output  [11:0]  rx_ch2_i        ,
    output  [11:0]  rx_ch2_q
);

genvar mm;

// rx data
wire [11:0] rx_data_pos;
wire [11:0] rx_data_neg;

generate
for (mm = 0; mm < 12; mm = mm + 1) begin

IDDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"    ),
    .INIT_Q1        (1'b0           ),
    .INIT_Q2        (1'b0           ),
    .SRTYPE         ("ASYNC"        )
) i_rx_data_iddr (
    .CE             (1'b1           ),
    .R              (1'b0           ),
    .S              (1'b0           ),
    .C              (clk_2x_in      ),
    .D              (rx_data[mm]    ),
    .Q1             (rx_data_pos[mm]),
    .Q2             (rx_data_neg[mm])
);

end
endgenerate

// rx frame
wire rx_frame_pos;
wire rx_frame_neg;

IDDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"    ),
    .INIT_Q1        (1'b0           ),
    .INIT_Q2        (1'b0           ),
    .SRTYPE         ("ASYNC"        )
) i_rx_frame_iddr (
    .CE             (1'b1           ),
    .R              (1'b0           ),
    .S              (1'b0           ),
    .C              (clk_2x_in      ),
    .D              (rx_frame       ),
    .Q1             (rx_frame_pos   ),
    .Q2             (rx_frame_neg   )
);

// divide rx_data to dual channel
reg [11:0] rx1_data_i = 'b0;
reg [11:0] rx1_data_q = 'b0;
reg [11:0] rx2_data_i = 'b0;
reg [11:0] rx2_data_q = 'b0;

reg rx_fifo_wr_en = 'b0;
reg rx_fifo_rd_en = 'b0;

wire rx_fifo_empty_1;
wire rx_fifo_empty_2;
wire rx_fifo_empty_3;
wire rx_fifo_empty_4;

always @ (posedge clk_2x_in) begin
    if (clk_in_rst) begin
        rx1_data_i <= 'b0;
        rx1_data_q <= 'b0;
        rx2_data_i <= 'b0;
        rx2_data_q <= 'b0;
        rx_fifo_wr_en <= 'b0;
    end
    else if({rx_frame_neg,rx_frame_pos} == 2'b11) begin
        rx1_data_i <= rx_data_neg;
        rx1_data_q <= rx_data_pos;
        rx2_data_i <= rx2_data_i;
        rx2_data_q <= rx2_data_q;
        rx_fifo_wr_en <= 'b0;
    end
    else if({rx_frame_neg,rx_frame_pos} == 2'b00) begin
        rx1_data_i <= rx1_data_i;
        rx1_data_q <= rx1_data_q;
        rx2_data_i <= rx_data_neg;
        rx2_data_q <= rx_data_pos;
        rx_fifo_wr_en <= 'b1;
    end
    else begin
        rx1_data_i <= 'd1234; // error
        rx1_data_q <= 'd4321; // error
        rx2_data_i <= 'd5678; // error
        rx2_data_q <= 'd8765; // error
        rx_fifo_wr_en <= 'b0;
    end
end

always @(posedge rx_data_clk) begin
    if (rx_data_clk_rst) begin
        rx_fifo_rd_en <= 'b0;
    end
    else begin
        rx_fifo_rd_en <= &{~rx_fifo_empty_1, ~rx_fifo_empty_2, ~rx_fifo_empty_3, ~rx_fifo_empty_4};
    end
end

ad9361_fifo u_rx_fifo_ch1_i
(
    .rst        (clk_in_rst || rx_fifo_rst  ), // input wire rst
    .wr_clk     (clk_2x_in                  ), // input wire wr_clk
    .rd_clk     (rx_data_clk                ), // input wire rd_clk
    .din        (rx1_data_i                 ), // input wire [11 : 0] din
    .wr_en      (rx_fifo_wr_en              ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en              ), // input wire rd_en
    .dout       (rx_ch1_i                   ), // output wire [11 : 0] dout
    .full       (                           ), // output wire full
    .empty      (rx_fifo_empty_1            )  // output wire empty
);

ad9361_fifo u_rx_fifo_ch1_q
(
    .rst        (clk_in_rst || rx_fifo_rst  ), // input wire rst
    .wr_clk     (clk_2x_in                  ), // input wire wr_clk
    .rd_clk     (rx_data_clk                ), // input wire rd_clk
    .din        (rx1_data_q                 ), // input wire [11 : 0] din
    .wr_en      (rx_fifo_wr_en              ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en              ), // input wire rd_en
    .dout       (rx_ch1_q                   ), // output wire [11 : 0] dout
    .full       (                           ), // output wire full
    .empty      (rx_fifo_empty_2            )  // output wire empty
);

ad9361_fifo u_rx_fifo_ch2_i
(
    .rst        (clk_in_rst || rx_fifo_rst  ), // input wire rst
    .wr_clk     (clk_2x_in                  ), // input wire wr_clk
    .rd_clk     (rx_data_clk                ), // input wire rd_clk
    .din        (rx2_data_i                 ), // input wire [11 : 0] din
    .wr_en      (rx_fifo_wr_en              ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en              ), // input wire rd_en
    .dout       (rx_ch2_i                   ), // output wire [11 : 0] dout
    .full       (                           ), // output wire full
    .empty      (rx_fifo_empty_3            )  // output wire empty
);

ad9361_fifo u_rx_fifo_ch2_q
(
    .rst        (clk_in_rst || rx_fifo_rst  ), // input wire rst
    .wr_clk     (clk_2x_in                  ), // input wire wr_clk
    .rd_clk     (rx_data_clk                ), // input wire rd_clk
    .din        (rx2_data_q                 ), // input wire [11 : 0] din
    .wr_en      (rx_fifo_wr_en              ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en              ), // input wire rd_en
    .dout       (rx_ch2_q                   ), // output wire [11 : 0] dout
    .full       (                           ), // output wire full
    .empty      (rx_fifo_empty_4            )  // output wire empty
);

endmodule
