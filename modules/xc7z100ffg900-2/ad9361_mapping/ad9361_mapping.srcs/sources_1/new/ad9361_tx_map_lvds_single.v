`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/27/2024 03:26:45 PM
// Design Name:
// Module Name: ad9361_tx_map_lvds_single
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


module ad9361_tx_map_lvds_single
(
    input           clk_2x_in       ,
    input           clk_in_rst      ,

    input           tx_data_clk     ,
    input           tx_data_clk_rst ,

    input   [11:0]  tx_data_i       ,
    input   [11:0]  tx_data_q       ,

    output          clk_out_p       ,
    output          clk_out_n       ,
    output          tx_frame_p      ,
    output          tx_frame_n      ,
    output  [ 5:0]  tx_data_p       ,
    output  [ 5:0]  tx_data_n
);

genvar mm;

// input data fifo
reg tx_fifo_rd_en = 'b0;
wire [11:0] tx_fifo_i;
wire [11:0] tx_fifo_q;

wire rx_fifo_empty_1;
wire rx_fifo_empty_2;

always @(posedge clk_2x_in) begin
    if (clk_in_rst) begin
        tx_fifo_rd_en <= 'b0;
    end
    else begin
        if (&{~rx_fifo_empty_1, ~rx_fifo_empty_2}) begin
            tx_fifo_rd_en <= ~tx_fifo_rd_en;
        end
        else begin
            tx_fifo_rd_en <= 'b0;
        end
    end
end

ad9361_fifo u_tx_fifo_i
(
    .rst        (clk_in_rst     ), // input wire rst
    .wr_clk     (tx_data_clk    ), // input wire wr_clk
    .rd_clk     (clk_2x_in      ), // input wire rd_clk
    .din        (tx_data_i      ), // input wire [11 : 0] din
    .wr_en      (1'b1           ), // input wire wr_en
    .rd_en      (tx_fifo_rd_en  ), // input wire rd_en
    .dout       (tx_fifo_i      ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (rx_fifo_empty_1)  // output wire empty
);

ad9361_fifo u_tx_fifo_q
(
    .rst        (clk_in_rst     ), // input wire rst
    .wr_clk     (tx_data_clk    ), // input wire wr_clk
    .rd_clk     (clk_2x_in      ), // input wire rd_clk
    .din        (tx_data_q      ), // input wire [11 : 0] din
    .wr_en      (1'b1           ), // input wire wr_en
    .rd_en      (tx_fifo_rd_en  ), // input wire rd_en
    .dout       (tx_fifo_q      ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (rx_fifo_empty_2)  // output wire empty
);

// frame and data control
reg tx_frame_i = 'b0;
reg tx_frame_q = 'b0;
reg [ 5:0] tx_buf_i = 'b0;
reg [ 5:0] tx_buf_q = 'b0;

always @(posedge clk_2x_in) begin
    if (clk_in_rst) begin
        tx_frame_i <= 'b0;
        tx_frame_q <= 'b0;
        tx_buf_i <= 'b0;
        tx_buf_q <= 'b0;
    end
    else begin
        if (tx_fifo_rd_en == 1'b0) begin
            tx_frame_i <= 1'b1;
            tx_frame_q <= 1'b1;
            tx_buf_i <= tx_fifo_i[11:6];
            tx_buf_q <= tx_fifo_q[11:6];
        end
        else begin
            tx_frame_i <= 1'b0;
            tx_frame_q <= 1'b0;
            tx_buf_i <= tx_fifo_i[5:0];
            tx_buf_q <= tx_fifo_q[5:0];
        end
    end
end

// output clock to port
wire clk_out;

assign clk_out = clk_2x_in;

OBUFDS u_clk_out_obufds
(
    .I  (clk_out    ),
    .O  (clk_out_p  ),
    .OB (clk_out_n  )
);

// output tx frame to port
wire tx_frame;

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

OBUFDS u_tx_frame_obufds
(
    .O  (tx_frame_p ), // Diff_p output (connect directly to top-level port)
    .OB (tx_frame_n ), // Diff_n output (connect directly to top-level port)
    .I  (tx_frame   )  // Buffer input
);

// ouput tx data to port
wire [5:0] tx_data;

generate
for (mm = 0; mm < 6; mm = mm + 1) begin

ODDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"   ),
    .INIT           (1'b0          ),
    .SRTYPE         ("ASYNC"       )
) u_tx_data_oddr (
    .CE             (1'b1          ),
    .R              (1'b0          ),
    .S              (1'b0          ),
    .C              (clk_2x_in     ),
    .D1             (tx_buf_i[mm]  ),
    .D2             (tx_buf_q[mm]  ),
    .Q              (tx_data[mm]   )
);

OBUFDS u_tx_data_obufds
(
    .O  (tx_data_p[mm]  ), // Diff_p output (connect directly to top-level port)
    .OB (tx_data_n[mm]  ), // Diff_n output (connect directly to top-level port)
    .I  (tx_data[mm]    )  // Buffer input
);

end
endgenerate

endmodule
