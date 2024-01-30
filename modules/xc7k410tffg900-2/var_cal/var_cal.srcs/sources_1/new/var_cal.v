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
// Create Date: 06/11/2023 02:41:47 PM
// Design Name:
// Module Name: var_cal
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
//   Revision 0.01 - File Created
//   20230730-1427 - 修改输入位宽小于乘法器位宽时的处理，由补零变为符号位扩展；
//     修改；修改累加和输出截位方式，依托原始数据位宽进行处理。
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module var_cal
#(
    parameter ACCUM_NUM = 16384,
    parameter DATA_I_WIDTH = 30,
    parameter DATA_O_WIDTH = 32,
    parameter CMPY_I_WIDTH = 18
)
(
    input clk                           ,
    input rst                           ,

    input cal_start                     ,
    input cal_auto_en                   ,
    output cal_busy                     ,

    input din_valid                     ,
    input [DATA_I_WIDTH-1 : 0] din_real ,
    input [DATA_I_WIDTH-1 : 0] din_imag ,

    output var_valid                    ,
    output [DATA_O_WIDTH-1 : 0] var
);

integer i;

localparam CMPY_P_WIDTH = 2*CMPY_I_WIDTH+1;
localparam AXIS_CMPY_I_WIDTH = 8*((CMPY_I_WIDTH-1)/8+1)    ; // axis data width of input real/image data
localparam AXIS_CMPY_P_WIDTH = 8*((CMPY_P_WIDTH-1)/8+1); // axis data width of cmpy output real/image data
localparam CMPY_P_VALID_WIDTH = (DATA_I_WIDTH > CMPY_I_WIDTH) ? 2*CMPY_I_WIDTH : 2*DATA_I_WIDTH;


localparam ACCUM_WIDTH = CMPY_P_VALID_WIDTH + $clog2(ACCUM_NUM);

// status control
reg cal_start_auto = 'b0;
reg cal_start_d1 = 'b0;
reg cal_start_d2 = 'b0;
reg cal_busy_buf = 'b0;
reg [$clog2(ACCUM_NUM)-1 : 0] cnt_accum = 'b0;
reg last_data = 'b0;
reg [6:0] last_data_d = 'b0; // 1 for register input, 6 for cmpy, 1 for register output

assign cal_busy = cal_busy_buf;
assign var_valid = last_data_d[6];

always @(posedge clk) begin
    if (rst) begin
        cal_start_auto <= 'b0;
    end
    else begin
        if (cal_auto_en) begin
            if (~cal_busy_buf) begin
                cal_start_auto <= ~cal_start_auto;
            end
            else begin
                cal_start_auto <= cal_start_auto;
            end
        end
        else begin
            cal_start_auto <= 'b0;
        end
    end
end

always @(posedge clk) begin
    cal_start_d1 <= cal_auto_en ? cal_start_auto : cal_start;
    cal_start_d2 <= cal_start_d1;
end

always @(posedge clk) begin
    if (rst) begin
        cal_busy_buf <= 'b0;
    end
    else begin
        if ((cal_start_d1 ^ cal_start_d2) && din_valid) begin
            cal_busy_buf <= 1'b1;
        end
        else if (cnt_accum == ACCUM_NUM-1) begin
            cal_busy_buf <= 'b0;
        end
        else begin
            cal_busy_buf <= cal_busy_buf;
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        cnt_accum <= 'b0;
    end
    else begin
        cnt_accum <= cal_busy ? (cnt_accum + 1'b1) : 'b0;
    end
end

always @(posedge clk) begin
    if (rst) begin
        last_data <= 'b0;
    end
    else begin
        last_data <= (cnt_accum == ACCUM_NUM-1) ? 1'b1 : 1'b0;
    end
end

always @(posedge clk) begin
    if (rst) begin
        last_data_d[6:0] <= 'b0;
    end
    else begin
        last_data_d[6:0] <= {last_data_d[5:0],last_data};
    end
end


// cmpy
reg [AXIS_CMPY_I_WIDTH-1 : 0] cmpy_a_real = 'b0;
reg [AXIS_CMPY_I_WIDTH-1 : 0] cmpy_a_imag = 'b0;
reg [AXIS_CMPY_I_WIDTH-1 : 0] cmpy_b_real = 'b0;
reg [AXIS_CMPY_I_WIDTH-1 : 0] cmpy_b_imag = 'b0;
wire [AXIS_CMPY_P_WIDTH-1 : 0] cmpy_p_raw_real;
wire [AXIS_CMPY_P_WIDTH-1 : 0] cmpy_p_raw_imag;
wire [CMPY_P_VALID_WIDTH-1 : 0] cmpy_p_real;
wire [CMPY_P_VALID_WIDTH-1 : 0] cmpy_p_imag;

if (CMPY_I_WIDTH > DATA_I_WIDTH) begin
    // sign-bit extension to fit cmpy input data width
    always @(posedge clk) begin
        if (rst) begin
            cmpy_a_real <= 'b0;
            cmpy_a_imag <= 'b0;
            cmpy_b_real <= 'b0;
            cmpy_b_imag <= 'b0;
        end
        else begin
            cmpy_a_real <= {{(AXIS_CMPY_I_WIDTH-DATA_I_WIDTH){din_real[DATA_I_WIDTH-1]}},din_real};
            cmpy_a_imag <= {{(AXIS_CMPY_I_WIDTH-DATA_I_WIDTH){din_imag[DATA_I_WIDTH-1]}},din_imag};
            cmpy_b_real <= {{(AXIS_CMPY_I_WIDTH-DATA_I_WIDTH){din_real[DATA_I_WIDTH-1]}},din_real};
            cmpy_b_imag <= (din_imag == {1'b1,{(DATA_I_WIDTH-1){1'b0}}}) ? {{(AXIS_CMPY_I_WIDTH-DATA_I_WIDTH+1){1'b0}},{(DATA_I_WIDTH-1){1'b1}}} : -{{(AXIS_CMPY_I_WIDTH-DATA_I_WIDTH){din_imag[DATA_I_WIDTH-1]}},din_imag};
        end
    end
end
else begin
    // truncate msb
    always @(posedge clk) begin
        if (rst) begin
            cmpy_a_real <= 'b0;
            cmpy_a_imag <= 'b0;
            cmpy_b_real <= 'b0;
            cmpy_b_imag <= 'b0;
        end
        else begin
            cmpy_a_real <= {{(AXIS_CMPY_I_WIDTH-CMPY_I_WIDTH){din_real[DATA_I_WIDTH-1]}},din_real[DATA_I_WIDTH-1 -: CMPY_I_WIDTH]};
            cmpy_a_imag <= {{(AXIS_CMPY_I_WIDTH-CMPY_I_WIDTH){din_imag[DATA_I_WIDTH-1]}},din_imag[DATA_I_WIDTH-1 -: CMPY_I_WIDTH]};
            cmpy_b_real <= {{(AXIS_CMPY_I_WIDTH-CMPY_I_WIDTH){din_real[DATA_I_WIDTH-1]}},din_real[DATA_I_WIDTH-1 -: CMPY_I_WIDTH]};
            cmpy_b_imag <= (din_imag[DATA_I_WIDTH-1 -: CMPY_I_WIDTH] == {1'b1,{(CMPY_I_WIDTH-1){1'b0}}}) ? {{(AXIS_CMPY_I_WIDTH-CMPY_I_WIDTH+1){1'b0}},{(CMPY_I_WIDTH-1){1'b1}}} : -{{(AXIS_CMPY_I_WIDTH-CMPY_I_WIDTH){din_imag[DATA_I_WIDTH-1]}},din_imag[DATA_I_WIDTH-1 -: CMPY_I_WIDTH]};
        end
    end
end

// truncate valid bits
assign cmpy_p_real = cmpy_p_raw_real[0 +: CMPY_P_VALID_WIDTH];
assign cmpy_p_imag = cmpy_p_raw_imag[0 +: CMPY_P_VALID_WIDTH];


wire [2*AXIS_CMPY_I_WIDTH-1:0] cmpy_a;
wire [2*AXIS_CMPY_I_WIDTH-1:0] cmpy_b;
wire [2*AXIS_CMPY_P_WIDTH-1:0] cmpy_p;
wire cmpy_p_vld;

assign cmpy_a = {cmpy_a_imag,cmpy_a_real};
assign cmpy_b = {cmpy_b_imag,cmpy_b_real};
assign {cmpy_p_raw_imag,cmpy_p_raw_real} = cmpy_p;

cmpy_18x18_mult u_cmpy_18x18
(
    .aclk               (clk        ), // input wire aclk
    .s_axis_a_tvalid    (cal_busy   ), // input wire s_axis_a_tvalid
    .s_axis_a_tdata     (cmpy_a     ), // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tvalid    (cal_busy   ), // input wire s_axis_b_tvalid
    .s_axis_b_tdata     (cmpy_b     ), // input wire [31 : 0] s_axis_b_tdata
    .m_axis_dout_tvalid (cmpy_p_vld ), // output wire m_axis_dout_tvalid
    .m_axis_dout_tdata  (cmpy_p     )  // output wire [63 : 0] m_axis_dout_tdata
);


// accumulation
reg [ACCUM_WIDTH-1 : 0] accum = 'b0;
reg [DATA_O_WIDTH-1 : 0] var_buf = 'b0;

assign var = var_buf;

always @(posedge clk) begin
    if (rst) begin
        accum <= 'b0;
    end
    else begin
        if (cmpy_p_vld) begin
            accum <= accum + cmpy_p_real;
        end
        else begin
            accum <= 'b0;
        end
    end
end

if (DATA_O_WIDTH > ACCUM_WIDTH) begin
    // sign-bit extension to fit output data width
    always @(posedge clk) begin
        if (rst) begin
            var_buf <= 'b0;
        end
        else if (last_data_d[5]) begin
            var_buf <= {{(DATA_O_WIDTH-ACCUM_WIDTH){accum[ACCUM_WIDTH-1]}},accum};
        end
    end
end
else begin
    // truncate msb
    always @(posedge clk) begin
        if (rst) begin
            var_buf <= 'b0;
        end
        else if (last_data_d[5]) begin
            var_buf <= accum[ACCUM_WIDTH-1 -: DATA_O_WIDTH];
        end
    end
end

endmodule
