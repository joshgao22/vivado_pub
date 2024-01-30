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
// Create Date: 2023/02/17 16:51:52
// Design Name:
// Module Name: tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description: testbench for [multi_ch_cal]
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module tb_multi_ch_cal;

localparam DATA_FILE_PATH = "../fine_cal_data.txt";
localparam DATA_LEN = 16384;
localparam DATA_WIDTH = 12;
localparam ACCUM_SYMBOL_NUM = 4;

// localparam DATA_FILE_PATH = "D:\\iladata_pn_trx_4.csv";
// localparam DATA_LEN = 131072;
// localparam DATA_WIDTH = 12;

reg  clk = 'b0;
reg  rst = 1'b1;

reg  ad9361_1_cal_start = 'b0;
wire ad9361_1_cal_done ;
reg  ad9361_2_cal_start = 'b0;
wire ad9361_2_cal_done ;
wire ad9361_cal_result ;
wire ad9361_cal_valid;
reg  ad9361_recal       = 'b0;

// phase difference of 180 degree
reg signed [11:0] rx_ch1_i = 'b0;
reg signed [11:0] rx_ch1_q = 'b0;
reg signed [11:0] rx_ch2_i = 'b0;
reg signed [11:0] rx_ch2_q = 'b0;
reg signed [11:0] rx_ch3_q = 'b0;
reg signed [11:0] rx_ch3_i = 'b0;
reg signed [11:0] rx_ch4_i = 'b0;
reg signed [11:0] rx_ch4_q = 'b0;

wire [11:0] rx_cal_ch1_i;
wire [11:0] rx_cal_ch2_i;
wire [11:0] rx_cal_ch3_i;
wire [11:0] rx_cal_ch4_i;
wire [11:0] rx_cal_ch1_q;
wire [11:0] rx_cal_ch2_q;
wire [11:0] rx_cal_ch3_q;
wire [11:0] rx_cal_ch4_q;

integer i = 0;
integer r_file;

multi_ch_cal #(
    .ACCUM_SYMBOL_NUM   (ACCUM_SYMBOL_NUM   )
) u_multi_ch_cal
(
    // clock & reset
    .clk                (clk                ), // input           clk
    .rst                (rst                ), // input           rst
    // control interface
    .ad9361_1_cal_start (ad9361_1_cal_start ), // input           ad9361_1_cal_start
    .ad9361_1_cal_done  (ad9361_1_cal_done  ), // output          ad9361_1_cal_done
    .ad9361_2_cal_start (ad9361_2_cal_start ), // input           ad9361_2_cal_start
    .ad9361_2_cal_done  (ad9361_2_cal_done  ), // output          ad9361_2_cal_done
    .ad9361_cal_result  (ad9361_cal_result  ), // output          ad9361_cal_result
    .ad9361_cal_valid   (ad9361_cal_valid   ), // output          ad9361_cal_valid
    .ad9361_recal       (ad9361_recal       ), // input           ad9361_recal
    // input data interface
    .rx_ch1_i           (rx_ch1_i           ), // input   [11:0]  rx_ch1_i
    .rx_ch2_i           (rx_ch2_i           ), // input   [11:0]  rx_ch2_i
    .rx_ch3_i           (rx_ch3_i           ), // input   [11:0]  rx_ch3_i
    .rx_ch4_i           (rx_ch4_i           ), // input   [11:0]  rx_ch4_i
    .rx_ch1_q           (rx_ch1_q           ), // input   [11:0]  rx_ch1_q
    .rx_ch2_q           (rx_ch2_q           ), // input   [11:0]  rx_ch2_q
    .rx_ch3_q           (rx_ch3_q           ), // input   [11:0]  rx_ch3_q
    .rx_ch4_q           (rx_ch4_q           ), // input   [11:0]  rx_ch4_q
    // output data interface
    .rx_cal_ch1_i       (rx_cal_ch1_i       ), // output  [11:0]  rx_cal_ch1_i
    .rx_cal_ch2_i       (rx_cal_ch2_i       ), // output  [11:0]  rx_cal_ch2_i
    .rx_cal_ch3_i       (rx_cal_ch3_i       ), // output  [11:0]  rx_cal_ch3_i
    .rx_cal_ch4_i       (rx_cal_ch4_i       ), // output  [11:0]  rx_cal_ch4_i
    .rx_cal_ch1_q       (rx_cal_ch1_q       ), // output  [11:0]  rx_cal_ch1_q
    .rx_cal_ch2_q       (rx_cal_ch2_q       ), // output  [11:0]  rx_cal_ch2_q
    .rx_cal_ch3_q       (rx_cal_ch3_q       ), // output  [11:0]  rx_cal_ch3_q
    .rx_cal_ch4_q       (rx_cal_ch4_q       )  // output  [11:0]  rx_cal_ch4_q
);

initial begin
    r_file = $fopen(DATA_FILE_PATH,"r");
    #102
    rst = 1'b0;
    #100
    ad9361_1_cal_start = 1'b1;
end

always @(posedge clk) begin
    if (ad9361_1_cal_start) begin
        if (i == DATA_LEN-1) begin
            $fscanf(r_file,"%d,%d,%d,%d",
                rx_ch2_i,
                rx_ch2_q,
                rx_ch4_i,
                rx_ch4_q);
            $fclose(r_file);
            r_file = $fopen(DATA_FILE_PATH,"r");
            i <= 0;
        end
        else begin
            $fscanf(r_file,"%d,%d,%d,%d",
                rx_ch2_i,
                rx_ch2_q,
                rx_ch4_i,
                rx_ch4_q);
            i <= i + 1;
        end
    end
end

always begin
    #10 clk = ~clk;
end

// initial begin
//     #10000
//     ad9361_recal = 1'b1;
//     #20
//     ad9361_recal = 1'b0;
// end

always @(posedge clk) begin
    if (ad9361_1_cal_done) begin
        ad9361_2_cal_start <= 1'b1;
    end
    else begin
        ad9361_2_cal_start <= 1'b0;
    end
end

always @(posedge clk) begin
    if (ad9361_2_cal_done) begin
        #2000
        ad9361_recal <= 1'b1;
    end
    else begin
        ad9361_recal <= 1'b0;
    end
end

endmodule
