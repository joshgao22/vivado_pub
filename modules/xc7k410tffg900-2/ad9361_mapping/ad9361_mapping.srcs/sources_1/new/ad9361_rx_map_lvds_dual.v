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
// Last Modified Date: 2023/03/06 10:54
// Design Name:
// Module Name: ad9361_rx_mapping_dual
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

genvar          m;

// rx data
wire [5:0] rx_data;
wire [5:0] rx_data_i, rx_data_q;

generate
for (m=0; m<6; m=m+1) begin : rx_data_iddr

IBUFDS #(
    .DIFF_TERM  ("TRUE"         )
) u_ibufds_rx_data
(
    .I          (rx_data_p[m]   ),
    .IB         (rx_data_n[m]   ),
    .O          (rx_data[m]     )
);

IDDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"    ),
    .INIT_Q1        (1'b0           ),
    .INIT_Q2        (1'b0           ),
    .SRTYPE         ("ASYNC"        )
) u_rx_data_iddr (
    .CE             (1'b1           ), // clock enable
    .R              (1'b0           ), // iddr reset
    .S              (1'b0           ), // iddr set
    .C              (clk_4x_in      ), // iddr clock
    .D              (rx_data[m]     ), // ddr data
    .Q1             (rx_data_q[m]   ), // sdr data at rising edge
    .Q2             (rx_data_i[m]   )  // sdr data at falling edge
);

end
endgenerate

// rx frame
wire            rx_frame;
wire            rx_frame_i;
wire            rx_frame_q;

IBUFDS #(
    .DIFF_TERM  ("TRUE"     )
) u_ibufds_rx_frame
(
    .I          (rx_frame_p ),
    .IB         (rx_frame_n ),
    .O          (rx_frame   )
);

IDDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"    ),
    .INIT_Q1        (1'b0           ),
    .INIT_Q2        (1'b0           ),
    .SRTYPE         ("ASYNC"        )
) u_rx_frame_iddr (
    .CE             (1'b1           ), // clock enable
    .R              (1'b0           ), // iddr reset
    .S              (1'b0           ), // iddr set
    .C              (clk_4x_in      ), // iddr clock
    .D              (rx_frame       ), // ddr data
    .Q1             (rx_frame_q     ), // sdr data at rising edge
    .Q2             (rx_frame_i     )  // sdr data at falling edge
);

// unpack rx frame & data
reg             rx_frame_i_d1   = 'b0;
reg     [ 5:0]  rx_data_i_d1    = 'b0;
reg     [ 5:0]  rx_data_q_d1    = 'b0;
reg             rx_flag         = 'b0; // rx frame rising edge indicator
reg     [ 1:0]  rx_cnt          = 'b0; // unpack stage counter

always @(posedge clk_4x_in) begin
    // wait for [rx_flag]
    rx_frame_i_d1 <= rx_frame_i;
     rx_data_i_d1 <=  rx_data_i;
     rx_data_q_d1 <=  rx_data_q;
end

always @(posedge clk_4x_in) begin
    if (clk_in_rst) begin
        rx_flag <= 'b0;
    end
    else if (~rx_frame_i_d1 & rx_frame_i) begin
        // assert when rising edge of rx frame is detected
        rx_flag <= 'b1;
    end
    else begin
        rx_flag <= rx_flag;
    end
end

always @(posedge clk_4x_in) begin
    if (clk_in_rst) begin
        rx_cnt <= 'b0;
    end
    else begin
        rx_cnt <= (rx_flag) ? rx_cnt + 1'b1 : rx_cnt;
    end
end

reg     [11:0]  rx1_data_i = 'b0;
reg     [11:0]  rx1_data_q = 'b0;
reg     [11:0]  rx2_data_i = 'b0;
reg     [11:0]  rx2_data_q = 'b0;

always @(posedge clk_4x_in) begin
    if (clk_in_rst) begin
        rx1_data_i <= 'b0;
        rx1_data_q <= 'b0;
        rx2_data_i <= 'b0;
        rx2_data_q <= 'b0;
    end
    else begin
        case (rx_cnt)
            3'd0: begin
                // 1st clock cycle: upper 6-bit of rx ch1 inphase/quadrature data
                rx1_data_i[11:6] <= rx_data_i_d1;
                rx1_data_q[11:6] <= rx_data_q_d1;
            end
            3'd1: begin
                // 2nd clock cycle: lower 6-bit of rx ch1 inphase/quadrature data
                rx1_data_i[ 5:0] <= rx_data_i_d1;
                rx1_data_q[ 5:0] <= rx_data_q_d1;
            end
            3'd2: begin
                // 3rd clock cycle: upper 6-bit of rx ch2 inphase/quadrature data
                rx2_data_i[11:6] <= rx_data_i_d1;
                rx2_data_q[11:6] <= rx_data_q_d1;
            end
            3'd3: begin
                // 4th clock cycle: lower 6-bit of rx ch2 inphase/quadrature data
                rx2_data_i[ 5:0] <= rx_data_i_d1;
                rx2_data_q[ 5:0] <= rx_data_q_d1;
            end
            default: begin
                rx1_data_i <= 'b0;
                rx1_data_q <= 'b0;
                rx2_data_i <= 'b0;
                rx2_data_q <= 'b0;
            end
        endcase
    end
end

// write fifo when rx1/2_data_i/q are all prepared with 192MHz clock
// read fifo at every clock cycle with 48MHz clock
reg fifo_wr_en = 'b0;
reg fifo_rd_en = 'b0;
wire rx_fifo_empty_1;
wire rx_fifo_empty_2;
wire rx_fifo_empty_3;
wire rx_fifo_empty_4;

always @(posedge clk_4x_in) begin
    if (clk_in_rst) begin
        fifo_wr_en <= 'b0;
    end
    else if (rx_cnt == 2'd3) begin
        fifo_wr_en <= 1'b1;
    end
    else begin
        fifo_wr_en <= 'b0;
    end
end

always @(posedge rx_data_clk) begin
    if (rx_data_clk_rst) begin
        fifo_rd_en <= 1'b0;
    end
    else begin
        fifo_rd_en <= &{~rx_fifo_empty_1, ~rx_fifo_empty_2, ~rx_fifo_empty_3, ~rx_fifo_empty_4};
    end
end

ad9361_fifo u_rx_fifo_ch1_i
(
    .rst        (rx_fifo_rst    ), // input wire rst
    .wr_clk     (clk_4x_in      ), // input wire wr_clk
    .rd_clk     (rx_data_clk    ), // input wire rd_clk
    .din        (rx1_data_i     ), // input wire [11 : 0] din
    .wr_en      (fifo_wr_en     ), // input wire wr_en
    .rd_en      (fifo_rd_en     ), // input wire rd_en
    .dout       (rx_ch1_i       ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (rx_fifo_empty_1)  // output wire empty
);

ad9361_fifo u_rx_fifo_ch1_q
(
    .rst        (rx_fifo_rst    ), // input wire rst
    .wr_clk     (clk_4x_in      ), // input wire wr_clk
    .rd_clk     (rx_data_clk    ), // input wire rd_clk
    .din        (rx1_data_q     ), // input wire [11 : 0] din
    .wr_en      (fifo_wr_en     ), // input wire wr_en
    .rd_en      (fifo_rd_en     ), // input wire rd_en
    .dout       (rx_ch1_q       ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (rx_fifo_empty_2)  // output wire empty
);

ad9361_fifo u_rx_fifo_ch2_i
(
    .rst        (rx_fifo_rst    ), // input wire rst
    .wr_clk     (clk_4x_in      ), // input wire wr_clk
    .rd_clk     (rx_data_clk    ), // input wire rd_clk
    .din        (rx2_data_i     ), // input wire [11 : 0] din
    .wr_en      (fifo_wr_en     ), // input wire wr_en
    .rd_en      (fifo_rd_en     ), // input wire rd_en
    .dout       (rx_ch2_i       ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (rx_fifo_empty_3)  // output wire empty
);

ad9361_fifo u_rx_fifo_ch2_q
(
    .rst        (rx_fifo_rst    ), // input wire rst
    .wr_clk     (clk_4x_in      ), // input wire wr_clk
    .rd_clk     (rx_data_clk    ), // input wire rd_clk
    .din        (rx2_data_q     ), // input wire [11 : 0] din
    .wr_en      (fifo_wr_en     ), // input wire wr_en
    .rd_en      (fifo_rd_en     ), // input wire rd_en
    .dout       (rx_ch2_q       ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (rx_fifo_empty_4)  // output wire empty
);

endmodule
