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
// Create Date: 09/27/2024 04:49:13 PM
// Design Name:
// Module Name: ad9361_rx_map_lvds_dual
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


module ad9361_rx_map_lvds_dual
(
    input           clk_4x_in       , // sync to input data
    input           clk_in_rst      ,

    input           rx_data_clk     , // sync to output data
    input           rx_data_clk_rst ,

    input           rx_fifo_rst     , // async fifo reset

    input           rx_frame_p      ,
    input           rx_frame_n      ,
    input   [ 5:0]  rx_data_p       , // data from ad9361 p1 port
    input   [ 5:0]  rx_data_n       ,

    output  [11:0]  rx_ch1_i        ,
    output  [11:0]  rx_ch1_q        ,
    output  [11:0]  rx_ch2_i        ,
    output  [11:0]  rx_ch2_q
);

genvar mm;

// rx data from port
wire [5:0] rx_data;
wire [5:0] rx_data_pos;
wire [5:0] rx_data_neg;

generate
for (mm = 0; mm < 6; mm = mm + 1) begin

IBUFDS #(
    .DIFF_TERM  ("TRUE"         )  // Differential Termination
) u_rx_data_ibufds
(
    .I          (rx_data_p[mm]  ), // Diff_p buffer input (connect directly to top-level port)
    .IB         (rx_data_n[mm]  ), // Diff_n buffer input (connect directly to top-level port)
    .O          (rx_data[mm]    )  // Buffer output
);

IDDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"    ), // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED"
    .INIT_Q1        (1'b0           ), // Initial value of Q1: 1'b0 or 1'b1
    .INIT_Q2        (1'b0           ), // Initial value of Q2: 1'b0 or 1'b1
    .SRTYPE         ("ASYNC"        )  // Set/Reset type: "SYNC" or "ASYNC"
) i_rx_data_iddr (
    .CE             (1'b1           ), // 1-bit clock enable input
    .R              (1'b0           ), // 1-bit reset
    .S              (1'b0           ), // 1-bit set
    .C              (clk_4x_in      ), // 1-bit clock input
    .D              (rx_data[mm]    ), // 1-bit DDR data input
    .Q1             (rx_data_pos[mm]), // 1-bit output for positive edge of clock
    .Q2             (rx_data_neg[mm])  // 1-bit output for negative edge of clock
);

end
endgenerate

// rx frame from port
wire rx_frame;
wire rx_frame_pos;
wire rx_frame_neg;

IBUFDS #(
    .DIFF_TERM  ("TRUE"     )  // Differential Termination
) u_rx_frame_ibufds
(
    .I          (rx_frame_p ), // Diff_p buffer input (connect directly to top-level port)
    .IB         (rx_frame_n ), // Diff_n buffer input (connect directly to top-level port)
    .O          (rx_frame   )  // Buffer output
);

IDDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"    ), // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED"
    .INIT_Q1        (1'b0           ), // Initial value of Q1: 1'b0 or 1'b1
    .INIT_Q2        (1'b0           ), // Initial value of Q2: 1'b0 or 1'b1
    .SRTYPE         ("ASYNC"        )  // Set/Reset type: "SYNC" or "ASYNC"
) i_rx_frame_iddr (
    .CE             (1'b1           ), // 1-bit clock enable input
    .R              (1'b0           ), // 1-bit reset
    .S              (1'b0           ), // 1-bit set
    .C              (clk_4x_in      ), // 1-bit clock input
    .D              (rx_frame       ), // 1-bit DDR data input
    .Q1             (rx_frame_pos   ), // 1-bit output for positive edge of clock
    .Q2             (rx_frame_neg   )  // 1-bit output for negative edge of clock
);

// unpack rx frame & data
reg rx_frame_pos_d = 'b0;
reg rx_frame_neg_d = 'b0;

reg [11:0] rx_fifo_ch1_i = 'b0;
reg [11:0] rx_fifo_ch1_q = 'b0;
reg [11:0] rx_fifo_ch2_i = 'b0;
reg [11:0] rx_fifo_ch2_q = 'b0;

reg rx_fifo_wr_en = 'b0;
reg rx_fifo_rd_en = 'b0;

wire rx_fifo_empty_1;
wire rx_fifo_empty_2;
wire rx_fifo_empty_3;
wire rx_fifo_empty_4;

always @(posedge clk_4x_in) begin
    if (clk_in_rst) begin
        rx_frame_pos_d <= 'b0;
        rx_frame_neg_d <= 'b0;
    end
    else begin
        rx_frame_pos_d <= rx_frame_pos;
        rx_frame_neg_d <= rx_frame_neg;
    end
end

always @(posedge clk_4x_in) begin
    if (clk_in_rst) begin
        rx_fifo_ch1_i <= 'b0;
        rx_fifo_ch1_q <= 'b0;
        rx_fifo_ch2_i <= 'b0;
        rx_fifo_ch2_q <= 'b0;
        rx_fifo_wr_en <= 'b0;
    end
    else begin
        case ({rx_frame_neg_d,rx_frame_pos_d,rx_frame_neg,rx_frame_pos})
            4'b0011: begin
                rx_fifo_ch1_i[11:6] <= rx_data_neg;
                rx_fifo_ch1_q[11:6] <= rx_data_pos;
                rx_fifo_ch2_i <= rx_fifo_ch2_i;
                rx_fifo_ch2_q <= rx_fifo_ch2_q;
                rx_fifo_wr_en <= 'b0;
            end
            4'b1111: begin
                rx_fifo_ch1_i[5:0] <= rx_data_neg;
                rx_fifo_ch1_q[5:0] <= rx_data_pos;
                rx_fifo_ch2_i <= rx_fifo_ch2_i;
                rx_fifo_ch2_q <= rx_fifo_ch2_q;
                rx_fifo_wr_en <= 'b0;
            end
            4'b1100: begin
                rx_fifo_ch1_i <= rx_fifo_ch1_i;
                rx_fifo_ch1_q <= rx_fifo_ch1_q;
                rx_fifo_ch2_i[11:6] <= rx_data_neg;
                rx_fifo_ch2_q[11:6] <= rx_data_pos;
                rx_fifo_wr_en <= 'b0;
            end
            4'b0000: begin
                rx_fifo_ch1_i <= rx_fifo_ch1_i;
                rx_fifo_ch1_q <= rx_fifo_ch1_q;
                rx_fifo_ch2_i[5:0] <= rx_data_neg;
                rx_fifo_ch2_q[5:0] <= rx_data_pos;
                rx_fifo_wr_en <= 1'b1;
            end
            default: begin
                rx_fifo_ch1_i <= 'd1234; // error
                rx_fifo_ch1_q <= 'd4321; // error
                rx_fifo_ch2_i <= 'd5678; // error
                rx_fifo_ch2_q <= 'd8765; // error
                rx_fifo_wr_en <= 'b0;
            end
        endcase
    end
end
always @(posedge rx_data_clk) begin
    if (rx_data_clk_rst) begin
        rx_fifo_rd_en <= 'b0;
    end
    else begin
        rx_fifo_rd_en <= &{~rx_fifo_empty_1, ~rx_fifo_empty_2,~rx_fifo_empty_3, ~rx_fifo_empty_4};
    end
end

ad9361_fifo u_rx_fifo_ch1_i
(
    .rst        (clk_in_rst || rx_fifo_rst  ), // input wire rst
    .wr_clk     (clk_4x_in                  ), // input wire wr_clk
    .rd_clk     (rx_data_clk                ), // input wire rd_clk
    .din        (rx_fifo_ch1_i              ), // input wire [11 : 0] din
    .wr_en      (rx_fifo_wr_en              ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en              ), // input wire rd_en
    .dout       (rx_ch1_i                   ), // output wire [11 : 0] dout
    .full       (                           ), // output wire full
    .empty      (rx_fifo_empty_1            )  // output wire empty
);

ad9361_fifo u_rx_fifo_ch1_q
(
    .rst        (clk_in_rst || rx_fifo_rst  ), // input wire rst
    .wr_clk     (clk_4x_in                  ), // input wire wr_clk
    .rd_clk     (rx_data_clk                ), // input wire rd_clk
    .din        (rx_fifo_ch1_q              ), // input wire [11 : 0] din
    .wr_en      (rx_fifo_wr_en              ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en              ), // input wire rd_en
    .dout       (rx_ch1_q                   ), // output wire [11 : 0] dout
    .full       (                           ), // output wire full
    .empty      (rx_fifo_empty_2            )  // output wire empty
);

ad9361_fifo u_rx_fifo_ch2_i
(
    .rst        (clk_in_rst || rx_fifo_rst  ), // input wire rst
    .wr_clk     (clk_4x_in                  ), // input wire wr_clk
    .rd_clk     (rx_data_clk                ), // input wire rd_clk
    .din        (rx_fifo_ch2_i              ), // input wire [11 : 0] din
    .wr_en      (rx_fifo_wr_en              ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en              ), // input wire rd_en
    .dout       (rx_ch2_i                   ), // output wire [11 : 0] dout
    .full       (                           ), // output wire full
    .empty      (rx_fifo_empty_3            )  // output wire empty
);

ad9361_fifo u_rx_fifo_ch2_q
(
    .rst        (clk_in_rst || rx_fifo_rst  ), // input wire rst
    .wr_clk     (clk_4x_in                  ), // input wire wr_clk
    .rd_clk     (rx_data_clk                ), // input wire rd_clk
    .din        (rx_fifo_ch2_q              ), // input wire [11 : 0] din
    .wr_en      (rx_fifo_wr_en              ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en              ), // input wire rd_en
    .dout       (rx_ch2_q                   ), // output wire [11 : 0] dout
    .full       (                           ), // output wire full
    .empty      (rx_fifo_empty_4            )  // output wire empty
);

endmodule
