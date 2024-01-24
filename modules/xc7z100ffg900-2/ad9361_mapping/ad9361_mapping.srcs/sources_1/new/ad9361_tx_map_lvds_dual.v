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
// Create Date: 2023/03/05 23:21:27
// Last Modified Date: 2023/03/06 11:01
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

genvar m;

// input data fifo
reg [1:0] tx_control_cnt = 'b0;
reg rx_fifo_rd_en = 'b0;
wire [11:0] tx_fifo_ch1_i;
wire [11:0] tx_fifo_ch1_q;
wire [11:0] tx_fifo_ch2_i;
wire [11:0] tx_fifo_ch2_q;

always @(posedge clk_4x_in) begin
    if (clk_in_rst) begin
        tx_control_cnt <= 'b0;
    end
    else begin
        tx_control_cnt <= tx_control_cnt + 1'b1;
    end
end

always @(posedge clk_4x_in) begin
    if (clk_in_rst) begin
        rx_fifo_rd_en <= 'b0;
    end
    else if (tx_control_cnt == 2'd2) begin
        rx_fifo_rd_en <= 1'b1;
    end
    else begin
        rx_fifo_rd_en <= 'b0;
    end
end

ad9361_fifo u_tx_fifo_ch1_i
(
    .rst        (clk_in_rst     ), // input wire rst
    .wr_clk     (tx_data_clk    ), // input wire wr_clk
    .rd_clk     (clk_4x_in      ), // input wire rd_clk
    .din        (tx_ch1_i       ), // input wire [11 : 0] din
    .wr_en      (1'b1           ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en  ), // input wire rd_en
    .dout       (tx_fifo_ch1_i  ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (               )  // output wire empty
);

ad9361_fifo u_tx_fifo_ch1_q
(
    .rst        (clk_in_rst     ), // input wire rst
    .wr_clk     (tx_data_clk    ), // input wire wr_clk
    .rd_clk     (clk_4x_in      ), // input wire rd_clk
    .din        (tx_ch1_q       ), // input wire [11 : 0] din
    .wr_en      (1'b1           ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en  ), // input wire rd_en
    .dout       (tx_fifo_ch1_q  ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (               )  // output wire empty
);

ad9361_fifo u_tx_fifo_ch2_i
(
    .rst        (clk_in_rst     ), // input wire rst
    .wr_clk     (tx_data_clk    ), // input wire wr_clk
    .rd_clk     (clk_4x_in      ), // input wire rd_clk
    .din        (tx_ch2_i       ), // input wire [11 : 0] din
    .wr_en      (1'b1           ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en  ), // input wire rd_en
    .dout       (tx_fifo_ch2_i  ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (               )  // output wire empty
);

ad9361_fifo u_tx_fifo_ch2_q
(
    .rst        (clk_in_rst     ), // input wire rst
    .wr_clk     (tx_data_clk    ), // input wire wr_clk
    .rd_clk     (clk_4x_in      ), // input wire rd_clk
    .din        (tx_ch2_q       ), // input wire [11 : 0] din
    .wr_en      (1'b1           ), // input wire wr_en
    .rd_en      (rx_fifo_rd_en  ), // input wire rd_en
    .dout       (tx_fifo_ch2_q  ), // output wire [11 : 0] dout
    .full       (               ), // output wire full
    .empty      (               )  // output wire empty
);


// frame and data control
reg tx_frame_r = 'b0; // rising edge data
reg tx_frame_f = 'b0; // falling edge data
reg [5:0] tx_data_r = 'b0;
reg [5:0] tx_data_f = 'b0;

always @(posedge clk_4x_in) begin
    if (clk_in_rst) begin
        tx_frame_r <= 'b0;
        tx_frame_f <= 'b0;
        tx_data_r <= 'b0;
        tx_data_f <= 'b0;
    end
    else begin
        case (tx_control_cnt)
            2'd0: begin
                tx_frame_r <= 1'b1;
                tx_frame_f <= 1'b1;
                tx_data_r <= tx_fifo_ch1_i[11: 6];
                tx_data_f <= tx_fifo_ch1_q[11: 6];
            end
            2'd1: begin
                tx_frame_r <= 1'b1;
                tx_frame_f <= 1'b1;
                tx_data_r <= tx_fifo_ch1_i[5:0];
                tx_data_f <= tx_fifo_ch1_q[5:0];
            end
            2'd2: begin
                tx_frame_r <= 1'b0;
                tx_frame_f <= 1'b0;
                tx_data_r <= tx_fifo_ch2_i[11:6];
                tx_data_f <= tx_fifo_ch2_q[11:6];
            end
            2'd3: begin
                tx_frame_r <= 1'b0;
                tx_frame_f <= 1'b0;
                tx_data_r <= tx_fifo_ch2_i[5:0];
                tx_data_f <= tx_fifo_ch2_q[5:0];
            end
            default: begin
                tx_frame_r <= 'b0;
                tx_frame_f <= 'b0;
                tx_data_r <= 'b0;
                tx_data_f <= 'b0;
            end
        endcase
    end
end

// output clock to port
wire clk_out;
assign clk_out = clk_4x_in;

OBUFDS u_obufds_clk_out
(
    .I  (clk_out    ),
    .O  (clk_out_p  ),
    .OB (clk_out_n  )
);

// output tx frame to port
ODDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"    ),
    .INIT           (1'b0           ),
    .SRTYPE         ("ASYNC"        )
) u_tx_frame_oddr (
    .CE             (1'b1           ),
    .R              (1'b0           ),
    .S              (1'b0           ),
    .C              (clk_4x_in      ),
    .D1             (tx_frame_r     ),
    .D2             (tx_frame_f     ),
    .Q              (tx_frame       )
);

OBUFDS u_obufds_tx_frame
(
    .I  (tx_frame   ),
    .O  (tx_frame_p ),
    .OB (tx_frame_n )
);

// output tx data to port
wire [5:0] tx_data;

generate
for (m=0; m<6; m=m+1) begin: tx_data_oddr

ODDR #(
    .DDR_CLK_EDGE   ("SAME_EDGE"   ),
    .INIT           (1'b0          ),
    .SRTYPE         ("ASYNC"       )
) u_tx_data_oddr  (
    .CE             (1'b1          ),
    .R              (1'b0          ),
    .S              (1'b0          ),
    .C              (clk_4x_in     ),
    .D1             (tx_data_r[m]  ),
    .D2             (tx_data_f[m]  ),
    .Q              (tx_data[m]    )
);

OBUFDS u_obufds_tx_data
(
    .I  (tx_data[m]     ),
    .O  (tx_data_p[m]   ),
    .OB (tx_data_n[m]   )
);

end
endgenerate

endmodule
