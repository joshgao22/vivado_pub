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
// Last Modified Date: 2024/09/27 16:22
// Design Name:
// Module Name: ad9361_tx_map_cmos_dual
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


module ad9361_tx_map_cmos_dual
(
    input           clk_2x_in       ,
    input           clk_in_rst      ,

    input           tx_data_clk     ,
    input           tx_data_clk_rst ,

    input   [11:0]  tx_ch1_i        ,
    input   [11:0]  tx_ch1_q        ,
    input   [11:0]  tx_ch2_i        ,
    input   [11:0]  tx_ch2_q        ,

    output          clk_out         ,
    output          tx_frame        ,
    output  [11:0]  tx_data
);

genvar mm;

// input data fifo
reg tx_fifo_rd_en = 'b0;
wire [11:0] tx_fifo_ch1_i;
wire [11:0] tx_fifo_ch1_q;
wire [11:0] tx_fifo_ch2_i;
wire [11:0] tx_fifo_ch2_q;

wire rx_fifo_empty_1;
wire rx_fifo_empty_2;
wire rx_fifo_empty_3;
wire rx_fifo_empty_4;

always @(posedge clk_2x_in) begin
    if (clk_in_rst) begin
        tx_fifo_rd_en <= 'b0;
    end
    else begin
        if (&{~rx_fifo_empty_1, ~rx_fifo_empty_2, ~rx_fifo_empty_3, ~rx_fifo_empty_4}) begin
            tx_fifo_rd_en <= ~tx_fifo_rd_en;
        end
        else begin
            tx_fifo_rd_en <= 'b0;
        end
    end
end

ad9361_fifo u_tx_fifo_ch1_i
(
    .rst        (clk_in_rst     ), // input wire rst
    .wr_clk     (tx_data_clk    ), // input wire wr_clk
    .rd_clk     (clk_2x_in      ), // input wire rd_clk
    .din        (tx_ch1_i       ), // input wire [11 : 0] din
    .wr_en      (1'b1           ), // input wire wr_en
    .rd_en      (tx_fifo_rd_en  ), // input wire rd_en
    .dout       (tx_fifo_ch1_i  ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (rx_fifo_empty_1)  // output wire empty
);

ad9361_fifo u_tx_fifo_ch1_q
(
    .rst        (clk_in_rst     ), // input wire rst
    .wr_clk     (tx_data_clk    ), // input wire wr_clk
    .rd_clk     (clk_2x_in      ), // input wire rd_clk
    .din        (tx_ch1_q       ), // input wire [11 : 0] din
    .wr_en      (1'b1           ), // input wire wr_en
    .rd_en      (tx_fifo_rd_en  ), // input wire rd_en
    .dout       (tx_fifo_ch1_q  ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (rx_fifo_empty_2)  // output wire empty
);

ad9361_fifo u_tx_fifo_ch2_i
(
    .rst        (clk_in_rst     ), // input wire rst
    .wr_clk     (tx_data_clk    ), // input wire wr_clk
    .rd_clk     (clk_2x_in      ), // input wire rd_clk
    .din        (tx_ch2_i       ), // input wire [11 : 0] din
    .wr_en      (1'b1           ), // input wire wr_en
    .rd_en      (tx_fifo_rd_en  ), // input wire rd_en
    .dout       (tx_fifo_ch2_i  ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (rx_fifo_empty_3)  // output wire empty
);

ad9361_fifo u_tx_fifo_ch2_q
(
    .rst        (clk_in_rst     ), // input wire rst
    .wr_clk     (tx_data_clk    ), // input wire wr_clk
    .rd_clk     (clk_2x_in      ), // input wire rd_clk
    .din        (tx_ch2_q       ), // input wire [11 : 0] din
    .wr_en      (1'b1           ), // input wire wr_en
    .rd_en      (tx_fifo_rd_en  ), // input wire rd_en
    .dout       (tx_fifo_ch2_q  ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (rx_fifo_empty_4)  // output wire empty
);

// frame and data control
reg tx_frame_i = 'b0;
reg tx_frame_q = 'b0;
reg [11:0] tx_data_i = 'b0;
reg [11:0] tx_data_q = 'b0;

always @(posedge clk_2x_in) begin
    if (clk_in_rst) begin
        tx_frame_i <= 'b0;
        tx_frame_q <= 'b0;
        tx_data_i <= 'b0;
        tx_data_q <= 'b0;
    end
    else if (tx_fifo_rd_en == 1'b0) begin
        tx_frame_i <= 1'b1;
        tx_frame_q <= 1'b1;
        tx_data_i <= tx_fifo_ch1_i;
        tx_data_q <= tx_fifo_ch1_q;
    end
    else begin
        tx_frame_i <= 1'b0;
        tx_frame_q <= 1'b0;
        tx_data_i <= tx_fifo_ch2_i;
        tx_data_q <= tx_fifo_ch2_q;
    end
end

// output clock to port
assign clk_out = clk_2x_in;

// output tx frame to port
ODDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"    ),
    .INIT           (1'b0           ),
    .SRTYPE         ("ASYNC"        )
) u_tx_frame_oddr (
    .CE             (1'b1           ),
    .R              (1'b0           ),
    .S              (1'b0           ),
    .C              (clk_2x_in      ),
    .D1             (tx_frame_i     ),
    .D2             (tx_frame_q     ),
    .Q              (tx_frame       )
);

generate
for (mm = 0; mm < 12; mm = mm + 1) begin

// output tx data to port
ODDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"   ),
    .INIT           (1'b0          ),
    .SRTYPE         ("ASYNC"       )
) u_tx_data_oddr (
    .CE             (1'b1          ),
    .R              (1'b0          ),
    .S              (1'b0          ),
    .C              (clk_2x_in     ),
    .D1             (tx_data_i[mm] ),
    .D2             (tx_data_q[mm] ),
    .Q              (tx_data[mm]   )
);

end
endgenerate

endmodule
