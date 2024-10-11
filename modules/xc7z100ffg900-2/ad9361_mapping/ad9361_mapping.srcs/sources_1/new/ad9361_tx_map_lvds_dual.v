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
// Create Date: 09/27/2024 03:26:45 PM
// Design Name:
// Module Name: ad9361_tx_map_lvds_dual
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


module ad9361_tx_map_lvds_dual
(
    input           clk_4x_in       ,
    input           clk_in_rst      ,

    input           tx_data_clk     ,
    input           tx_data_clk_rst ,

    input   [11:0]  tx_ch1_i        ,
    input   [11:0]  tx_ch1_q        ,
    input   [11:0]  tx_ch2_i        ,
    input   [11:0]  tx_ch2_q        ,

    output          clk_out_p       ,
    output          clk_out_n       ,
    output          tx_frame_p      ,
    output          tx_frame_n      ,
    output  [ 5:0]  tx_data_p       ,
    output  [ 5:0]  tx_data_n
);

genvar mm;

// input data fifo
reg [1:0] tx_fifo_rd_en_cnt = 'b0;
reg tx_fifo_rd_en = 'b0;
wire [11:0] tx_fifo_ch1_i;
wire [11:0] tx_fifo_ch1_q;
wire [11:0] tx_fifo_ch2_i;
wire [11:0] tx_fifo_ch2_q;

wire rx_fifo_empty_1;
wire rx_fifo_empty_2;
wire rx_fifo_empty_3;
wire rx_fifo_empty_4;

always @(posedge clk_4x_in) begin
    if (clk_in_rst) begin
        tx_fifo_rd_en_cnt <= 'b0;
    end
    else begin
        tx_fifo_rd_en_cnt <= tx_fifo_rd_en_cnt + 1'b1;
    end
end

always @(posedge clk_4x_in) begin
    if (clk_in_rst) begin
        tx_fifo_rd_en <= 'b0;
    end
    else begin
        if (&{~rx_fifo_empty_1, ~rx_fifo_empty_2, ~rx_fifo_empty_3, ~rx_fifo_empty_4}) begin
            tx_fifo_rd_en <= (tx_fifo_rd_en_cnt == 2'd3) ? 1'b1 : 'b0;
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
    .rd_clk     (clk_4x_in      ), // input wire rd_clk
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
    .rd_clk     (clk_4x_in      ), // input wire rd_clk
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
    .rd_clk     (clk_4x_in      ), // input wire rd_clk
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
    .rd_clk     (clk_4x_in      ), // input wire rd_clk
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
reg [5:0] tx_buf_i = 'b0;
reg [5:0] tx_buf_q = 'b0;

always @(posedge clk_4x_in) begin
    if (clk_in_rst) begin
        tx_frame_i <= 'b0;
        tx_frame_q <= 'b0;
        tx_buf_i <= 'b0;
        tx_buf_q <= 'b0;
    end
    else begin
        case (tx_fifo_rd_en_cnt)
            2'd0: begin
                tx_frame_i <= 1'b1;
                tx_frame_q <= 1'b1;
                tx_buf_i <= tx_fifo_ch1_i[11:6];
                tx_buf_q <= tx_fifo_ch1_q[11:6];
            end
            2'd1: begin
                tx_frame_i <= 1'b1;
                tx_frame_q <= 1'b1;
                tx_buf_i <= tx_fifo_ch1_i[5:0];
                tx_buf_q <= tx_fifo_ch1_q[5:0];
            end
            2'd2: begin
                tx_frame_i <= 1'b0;
                tx_frame_q <= 1'b0;
                tx_buf_i <= tx_fifo_ch2_i[11:6];
                tx_buf_q <= tx_fifo_ch2_q[11:6];
            end
            2'd3: begin
                tx_frame_i <= 1'b0;
                tx_frame_q <= 1'b0;
                tx_buf_i <= tx_fifo_ch2_i[5:0];
                tx_buf_q <= tx_fifo_ch2_q[5:0];
            end
            default: begin
                tx_frame_i <= 'b0; // error
                tx_frame_q <= 'b0; // error
                tx_buf_i <= 'b0; // error
                tx_buf_q <= 'b0; // error
            end
        endcase
    end
end

// output clock to port
wire clk_out;

assign clk_out = clk_4x_in;

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
    .C              (clk_4x_in      ),
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
    .C              (clk_4x_in     ),
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