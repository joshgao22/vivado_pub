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
// Create Date: 2023/02/15 17:47:17
// Last Modified Date: 2023/03/04 12:30:00
// Design Name:
// Module Name: multi_ch_cal
// Project Name:
// Target Devices:
// Tool Versions:
// Description: 本程序用于
//
// Dependencies:
//
// Revision:
//   Revision 0.01 - File Created
//   20230304-1230
//     1. 修改相位差计算结果，原计算结果可能超出 [-pi,pi] 范围，现在会进行修正；
//     2. 修改 CORDIC IP 核相位输入输出为 Scaled Radians 模式；
//     3. 修改 [cnt_decim] 在校准完成状态下的值为 0；
//     4. 通道间相对延迟计算不正确，修改 [peak_index_num] 为无符号数即可；
//     5. 修改 [atan2_data_xxxx] 在累积结果长度小于 CORDIC AXIS 位宽时的符号位扩展方法。
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module multi_ch_cal
#(
    parameter ADC_DATA_WIDTH = 12,
    parameter PRBS = 128'b00000011000010100011110010001011001110101001111101000011100010010011011010110111101100011010010111011100110010101011111110000001, // inverse pseudorandom bit sequence, [0,flip(PRSB7)]
    parameter PRBS_LEN = 128, // length of pseudorandom bit sequence
    parameter INTERP_FACTOR = 8, // interpolation factor, max inter-channel delay ranges in [-INTERP_FACTOR+1,INTERP_FACTOR-1]
    parameter ACCUM_SYMBOL_NUM = 16,
    parameter CORDIC_WIDTH = 16, // input and output data width of cordic-ip-based atan2 and rotation operation
    parameter CHANNEL_NUM = 2 // the channel number of current algorithm is LIMITED to 2
)
(
    // clock & reset
    input           clk                         ,
    input           rst                         ,
    // control interface
    input           ad9361_1_cal_start          ,
    output          ad9361_1_cal_done           ,
    input           ad9361_2_cal_start          ,
    output          ad9361_2_cal_done           ,
    output          ad9361_cal_result           ,
    output          ad9361_cal_valid            ,
    input           ad9361_recal                ,
    // input data interface
    input [ADC_DATA_WIDTH-1 : 0] rx_ch1_i       ,
    input [ADC_DATA_WIDTH-1 : 0] rx_ch1_q       ,
    input [ADC_DATA_WIDTH-1 : 0] rx_ch2_i       ,
    input [ADC_DATA_WIDTH-1 : 0] rx_ch2_q       ,
    input [ADC_DATA_WIDTH-1 : 0] rx_ch3_i       ,
    input [ADC_DATA_WIDTH-1 : 0] rx_ch3_q       ,
    input [ADC_DATA_WIDTH-1 : 0] rx_ch4_i       ,
    input [ADC_DATA_WIDTH-1 : 0] rx_ch4_q       ,
    // output data interface
    output [ADC_DATA_WIDTH-1 : 0] rx_cal_ch1_i  ,
    output [ADC_DATA_WIDTH-1 : 0] rx_cal_ch1_q  ,
    output [ADC_DATA_WIDTH-1 : 0] rx_cal_ch2_i  ,
    output [ADC_DATA_WIDTH-1 : 0] rx_cal_ch2_q  ,
    output [ADC_DATA_WIDTH-1 : 0] rx_cal_ch3_i  ,
    output [ADC_DATA_WIDTH-1 : 0] rx_cal_ch3_q  ,
    output [ADC_DATA_WIDTH-1 : 0] rx_cal_ch4_i  ,
    output [ADC_DATA_WIDTH-1 : 0] rx_cal_ch4_q
);

localparam STATE_IDLE = 2'd0; // idle state
localparam STATE_CAL_1 = 2'd1; // correlation, accumulation and peak finding
localparam STATE_CAL_2 = 2'd2; // phase calculation, rotation and delay compensation
localparam STATE_DONE = 2'd3; // done state

localparam signed POS_PI_2Q13_SCALED = 16'b001_00000_00000_000;
localparam signed NEG_PI_2Q13_SCALED = 16'b111_00000_00000_000;

integer i, j;
genvar m, n;

////////////////////////////////////////////////////////////////////////////////
///////////////////////////// Center State Machine /////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// buffer input control signals (clock domain crossing from ps to pl clock domain)
reg ad9361_1_cal_start_d1 = 'b0;
reg ad9361_1_cal_start_d2 = 'b0;
reg ad9361_2_cal_start_d1 = 'b0;
reg ad9361_2_cal_start_d2 = 'b0;
reg ad9361_recal_d1 = 'b0;
reg ad9361_recal_d2 = 'b0;

always @(posedge clk) begin
    ad9361_1_cal_start_d1 <= ad9361_1_cal_start;
    ad9361_1_cal_start_d2 <= ad9361_1_cal_start_d1;

    ad9361_2_cal_start_d1 <= ad9361_2_cal_start;
    ad9361_2_cal_start_d2 <= ad9361_2_cal_start_d1;

    ad9361_recal_d1 <= ad9361_recal;
    ad9361_recal_d2 <= ad9361_recal_d1;
end

// center state machine
reg     [ 1:0]  curr_state = STATE_IDLE;

always @(posedge clk) begin
    if (rst) begin
        curr_state <= STATE_IDLE;
    end
    else begin
    case (curr_state)
        STATE_IDLE: begin
            // move to next state when [ad9361_1_cal_start] asserts
            curr_state <= ad9361_1_cal_start_d2 ? STATE_CAL_1 : STATE_IDLE;
        end
        STATE_CAL_1: begin
            // move to next state when 1st cal finishes and [ad9361_2_cal_start] asserts
            curr_state <= ad9361_1_cal_done ? STATE_CAL_2 : STATE_CAL_1;
        end
        STATE_CAL_2: begin
            // move to next state when 2nd cal finishes
            curr_state <= ad9361_2_cal_done ? STATE_DONE : STATE_CAL_2;
        end
        STATE_DONE: begin
            // move to IDLE state when it needs to recal
            curr_state <= (ad9361_recal_d2) ? STATE_IDLE : STATE_DONE;
        end
        default: begin
            curr_state <= STATE_IDLE;
        end
    endcase
    end
end

////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// Accumulation /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// state counter
reg [$clog2(INTERP_FACTOR)-1    : 0] cnt_decim    = 'b0; // downsample counter, mod [INTERP_FACTOR]
reg [$clog2(PRBS_LEN)-1         : 0] cnt_chip_in  = 'b0; // input chip counter, mod [PRBS_LEN]
reg [$clog2(PRBS_LEN)-1         : 0] pn_curr_addr = 'b0; // current local pn address, mod [PRBS_LEN]
reg [$clog2(ACCUM_SYMBOL_NUM)-1 : 0] cnt_symbol   = 'b0; // accumulation symbol counter, mod [ACCUM_SYMBOL_NUM]
reg [$clog2(PRBS_LEN)-1         : 0] cnt_accum    = 'b0; // accumulation result index indicator, mod [PRBS_LEN]

always @(posedge clk) begin
    // downsample counter, each clock cycles increase by 1 during calibration state
    if (rst) begin
        cnt_decim <= 'b0;
    end
    else begin
    case (curr_state)
        STATE_IDLE : cnt_decim <= 'b0;
        STATE_CAL_1: cnt_decim <= cnt_decim + 1'b1;
        STATE_CAL_2: cnt_decim <= cnt_decim + 1'b1;
        STATE_DONE : cnt_decim <= 'b0;
        default    : cnt_decim <= 'b0;
    endcase
    end
end

always @(posedge clk) begin
    if (rst) begin
        cnt_chip_in <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        // reset at IDLE state
        cnt_chip_in <= 'b0;
    end
    else if (cnt_decim == INTERP_FACTOR-1) begin
        // each time the number of samples received is [INTERP_FACTOR], increase the counter by 1,
        // indicating a new chip is received
        cnt_chip_in <= cnt_chip_in + 1'b1;
    end
    else begin
        cnt_chip_in <= cnt_chip_in;
    end
end

always @(posedge clk) begin
    if (rst) begin
        pn_curr_addr <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        // reset at IDLE state
        pn_curr_addr <= 'b0;
    end
    else if (cnt_decim == INTERP_FACTOR-1) begin
        // each time the number of samples received is [INTERP_FACTOR], if the number of complete symbols
        // accumulated is [ACCUM_SYMBOL_NUM], increase the address by 2; otherwise by 1. The increasing-by-2
        // behaviour is analogous to `circshift` operation in MATLAB.
        pn_curr_addr <= (cnt_symbol == ACCUM_SYMBOL_NUM-1 && cnt_chip_in == PRBS_LEN-1) ? pn_curr_addr + 2'd2 : pn_curr_addr + 2'd1;
    end
    else begin
        pn_curr_addr <= pn_curr_addr;
    end
end

always @(posedge clk) begin
    if (rst) begin
        cnt_symbol <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        // reset at IDLE state
        cnt_symbol <= 'b0;
    end
    else if (cnt_chip_in == PRBS_LEN-1 && cnt_decim == INTERP_FACTOR-1) begin
        // each time the number of complete chips received is [PRBS_LEN], increase the counter by 1,
        // indicating a complete symbol is received
        cnt_symbol <= cnt_symbol + 1'b1;
    end
    else begin
        cnt_symbol <= cnt_symbol;
    end
end

always @(posedge clk) begin
    if (rst) begin
        cnt_accum <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        // reset at IDLE state
        cnt_accum <= 'b0;
    end
    else if (cnt_symbol == ACCUM_SYMBOL_NUM-1 && cnt_chip_in == PRBS_LEN-1 && cnt_decim == INTERP_FACTOR-1) begin
        // each time the number of complete symbols received is [ACCUM_SYMBOL_NUM], increase the counter by 1,
        // indicating the accumulation of current pn code phased is finished
        cnt_accum <= cnt_accum + 1'b1;
    end
    else begin
        cnt_accum <= cnt_accum;
    end
end

// accumulate the msb of input data at different sample position
localparam MSB_ACCUM_LEN = $clog2(PRBS_LEN*ACCUM_SYMBOL_NUM)+2; // extra 2 bits to ensure signed operation and to prevent overflow

reg signed [MSB_ACCUM_LEN-1 : 0] msb_accum_i [0 : CHANNEL_NUM-1][0 : INTERP_FACTOR-1];
reg signed [MSB_ACCUM_LEN-1 : 0] msb_accum_q [0 : CHANNEL_NUM-1][0 : INTERP_FACTOR-1];

always @(posedge clk) begin
    if (rst) begin
    for (i = 0; i < CHANNEL_NUM; i = i + 1) begin
    for (j = 0; j < INTERP_FACTOR; j = j + 1) begin
        msb_accum_i[i][j] <= 'b0;
        msb_accum_q[i][j] <= 'b0;
    end
    end
    end
    else if (curr_state == STATE_CAL_1) begin
        if (cnt_symbol == 'b0 && cnt_chip_in == 'b0) begin
            // set the initial value to 1 when msb equals current pn code, otherwise set to -1
            msb_accum_i[0][cnt_decim] <= (rx_ch2_i[ADC_DATA_WIDTH-1] == PRBS[pn_curr_addr]) ? 1'b1 : -1'b1;
            msb_accum_q[0][cnt_decim] <= (rx_ch2_q[ADC_DATA_WIDTH-1] == PRBS[pn_curr_addr]) ? 1'b1 : -1'b1;
            msb_accum_i[1][cnt_decim] <= (rx_ch4_i[ADC_DATA_WIDTH-1] == PRBS[pn_curr_addr]) ? 1'b1 : -1'b1;
            msb_accum_q[1][cnt_decim] <= (rx_ch4_q[ADC_DATA_WIDTH-1] == PRBS[pn_curr_addr]) ? 1'b1 : -1'b1;
        end
        else begin
            // increase when msb equals current pn code, otherwise decrease
            msb_accum_i[0][cnt_decim] <= (rx_ch2_i[ADC_DATA_WIDTH-1] == PRBS[pn_curr_addr]) ? (msb_accum_i[0][cnt_decim] + 1'b1) : (msb_accum_i[0][cnt_decim] - 1'b1);
            msb_accum_q[0][cnt_decim] <= (rx_ch2_q[ADC_DATA_WIDTH-1] == PRBS[pn_curr_addr]) ? (msb_accum_q[0][cnt_decim] + 1'b1) : (msb_accum_q[0][cnt_decim] - 1'b1);
            msb_accum_i[1][cnt_decim] <= (rx_ch4_i[ADC_DATA_WIDTH-1] == PRBS[pn_curr_addr]) ? (msb_accum_i[1][cnt_decim] + 1'b1) : (msb_accum_i[1][cnt_decim] - 1'b1);
            msb_accum_q[1][cnt_decim] <= (rx_ch4_q[ADC_DATA_WIDTH-1] == PRBS[pn_curr_addr]) ? (msb_accum_q[1][cnt_decim] + 1'b1) : (msb_accum_q[1][cnt_decim] - 1'b1);
        end
    end
    else begin
    for (i = 0; i < CHANNEL_NUM; i = i + 1) begin
    for (j = 0; j < INTERP_FACTOR; j = j + 1) begin
        msb_accum_i[i][j] <= 'b0;
        msb_accum_q[i][j] <= 'b0;
    end
    end
    end
end

// flag signal indicating the accumulation within one symbol (i.e. one kind of pn phase) is finished
reg symbol_msb_accum_valid = 'b0;
// preserve pn phase index for approximate moduli module
reg [$clog2(PRBS_LEN)-1 : 0] symbol_msb_accum_index = 'b0;

always @(posedge clk) begin
    if (rst) begin
        symbol_msb_accum_valid <= 'b0;
    end
    else if (cnt_symbol == ACCUM_SYMBOL_NUM-1 && cnt_chip_in == PRBS_LEN-1 && cnt_decim == INTERP_FACTOR-1) begin
        symbol_msb_accum_valid <= 1'b1;
    end
    else begin
        symbol_msb_accum_valid <= 'b0;
    end
end

always @(posedge clk) begin
    if (rst) begin
        symbol_msb_accum_index <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        symbol_msb_accum_index <= 'b0;
    end
    else if (cnt_symbol == ACCUM_SYMBOL_NUM-1 && cnt_chip_in == PRBS_LEN-1 && cnt_decim == INTERP_FACTOR-1) begin
        symbol_msb_accum_index <= cnt_accum;
    end
    else begin
        symbol_msb_accum_index <= symbol_msb_accum_index;
    end
end

// truncate or shift to fit in 26-bit data format & get the absolute value
wire [25 : 0] msb_accum_i_26b [0 : CHANNEL_NUM-1][0 : INTERP_FACTOR-1];
wire [25 : 0] msb_accum_q_26b [0 : CHANNEL_NUM-1][0 : INTERP_FACTOR-1];
wire [25 : 0] msb_accum_abs [0 : CHANNEL_NUM-1][0 : INTERP_FACTOR-1];
wire msb_accum_abs_valid [0 : CHANNEL_NUM-1][0 : INTERP_FACTOR-1];

generate
for (m = 0; m < CHANNEL_NUM; m = m + 1) begin
for (n = 0; n < INTERP_FACTOR; n = n + 1) begin

assign msb_accum_i_26b[m][n] = (MSB_ACCUM_LEN > 26) ? msb_accum_i[m][n][MSB_ACCUM_LEN-1 -: 26] : {{(26-MSB_ACCUM_LEN){msb_accum_i[m][n][MSB_ACCUM_LEN-1]}},msb_accum_i[m][n]};
assign msb_accum_q_26b[m][n] = (MSB_ACCUM_LEN > 26) ? msb_accum_q[m][n][MSB_ACCUM_LEN-1 -: 26] : {{(26-MSB_ACCUM_LEN){msb_accum_q[m][n][MSB_ACCUM_LEN-1]}},msb_accum_q[m][n]};

ApproxModuli_26bit u_msb_accum_abs
(
    .clk        (clk                        ),
    .din_valid  (symbol_msb_accum_valid     ),
    .din_I      (msb_accum_i_26b[m][n]      ),
    .din_Q      (msb_accum_q_26b[m][n]      ),
    .dout_valid (msb_accum_abs_valid[m][n]  ),
    .dout       (msb_accum_abs[m][n]        )
);

end
end
endgenerate


// record the peak index and corresponding value
reg [25 : 0] msb_accum_abs_peak [0 : CHANNEL_NUM-1][0 : INTERP_FACTOR-1];
reg [$clog2(PRBS_LEN)-1 : 0] msb_accum_abs_peak_index [0 : CHANNEL_NUM-1][0 : INTERP_FACTOR-1];

generate
for (m = 0; m < CHANNEL_NUM; m = m + 1) begin
for (n = 0; n < INTERP_FACTOR; n = n + 1) begin

always @(posedge clk) begin
    if (rst) begin
        msb_accum_abs_peak[m][n] <= 'b0;
        msb_accum_abs_peak_index[m][n] <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        msb_accum_abs_peak[m][n] <= 'b0;
        msb_accum_abs_peak_index[m][n] <= 'b0;
    end
    else if (msb_accum_abs_valid[m][n]) begin
        msb_accum_abs_peak[m][n]       <= (msb_accum_abs_peak[m][n] >= msb_accum_abs[m][n]) ? msb_accum_abs_peak[m][n]       : msb_accum_abs[m][n];
        msb_accum_abs_peak_index[m][n] <= (msb_accum_abs_peak[m][n] >= msb_accum_abs[m][n]) ? msb_accum_abs_peak_index[m][n] : symbol_msb_accum_index;
    end
end

end
end
endgenerate


// accumulate input data at the 1st sample position and the 1st and 2nd chip position
// during the last msb accumulation cycle
localparam DATA_ACCUM_LEN = $clog2(ACCUM_SYMBOL_NUM)+ADC_DATA_WIDTH;

reg signed [DATA_ACCUM_LEN-1 : 0] rx_i_accum [0 : CHANNEL_NUM-1][0 : 1];
reg signed [DATA_ACCUM_LEN-1 : 0] rx_q_accum [0 : CHANNEL_NUM-1][0 : 1];

always @(posedge clk) begin
    if (rst) begin
    for(i = 0; i < CHANNEL_NUM; i = i + 1) begin
    for(j = 0; j < 2; j = j + 1) begin
        rx_i_accum[i][j] <= 'b0;
        rx_q_accum[i][j] <= 'b0;
    end
    end
    end
    else if (curr_state == STATE_IDLE) begin
    for(i = 0; i < CHANNEL_NUM; i = i + 1) begin
    for(j = 0; j < 2; j = j + 1) begin
        // reset at IDLE state
        rx_i_accum[i][j] <= 'b0;
        rx_q_accum[i][j] <= 'b0;
    end
    end
    end
    else if (cnt_accum == PRBS_LEN-1 && cnt_decim == 'b0) begin
        case (cnt_chip_in)
            1'b0: begin
                rx_i_accum[0][0] <= rx_i_accum[0][0] + {{(DATA_ACCUM_LEN-ADC_DATA_WIDTH){rx_ch2_i[ADC_DATA_WIDTH-1]}},rx_ch2_i};
                rx_q_accum[0][0] <= rx_q_accum[0][0] + {{(DATA_ACCUM_LEN-ADC_DATA_WIDTH){rx_ch2_q[ADC_DATA_WIDTH-1]}},rx_ch2_q};
                rx_i_accum[1][0] <= rx_i_accum[1][0] + {{(DATA_ACCUM_LEN-ADC_DATA_WIDTH){rx_ch4_i[ADC_DATA_WIDTH-1]}},rx_ch4_i};
                rx_q_accum[1][0] <= rx_q_accum[1][0] + {{(DATA_ACCUM_LEN-ADC_DATA_WIDTH){rx_ch4_q[ADC_DATA_WIDTH-1]}},rx_ch4_q};
            end
            1'b1: begin
                rx_i_accum[0][1] <= rx_i_accum[0][1] + {{(DATA_ACCUM_LEN-ADC_DATA_WIDTH){rx_ch2_i[ADC_DATA_WIDTH-1]}},rx_ch2_i};
                rx_q_accum[0][1] <= rx_q_accum[0][1] + {{(DATA_ACCUM_LEN-ADC_DATA_WIDTH){rx_ch2_q[ADC_DATA_WIDTH-1]}},rx_ch2_q};
                rx_i_accum[1][1] <= rx_i_accum[1][1] + {{(DATA_ACCUM_LEN-ADC_DATA_WIDTH){rx_ch4_i[ADC_DATA_WIDTH-1]}},rx_ch4_i};
                rx_q_accum[1][1] <= rx_q_accum[1][1] + {{(DATA_ACCUM_LEN-ADC_DATA_WIDTH){rx_ch4_q[ADC_DATA_WIDTH-1]}},rx_ch4_q};
            end
            default: begin
            for(i = 0; i < CHANNEL_NUM; i = i + 1) begin
            for(j = 0; j < 2; j = j + 1) begin
                rx_i_accum[i][j] <= rx_i_accum[i][j];
                rx_q_accum[i][j] <= rx_q_accum[i][j];
            end
            end
            end
        endcase
    end
    else begin
    for(i = 0; i < CHANNEL_NUM; i = i + 1) begin
    for(j = 0; j < 2; j = j + 1) begin
        rx_i_accum[i][j] <= rx_i_accum[i][j];
        rx_q_accum[i][j] <= rx_q_accum[i][j];
    end
    end
    end
end

// flag signal indicating the accumulation stage of calculation is finished
reg ad9361_1_cal_done_buf = 'b0;

assign ad9361_1_cal_done = ad9361_1_cal_done_buf;

always @(posedge clk) begin
    if (rst) begin
        ad9361_1_cal_done_buf <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        // reset at IDLE state
        ad9361_1_cal_done_buf <= 'b0;
    end
    else if (cnt_accum == PRBS_LEN-1 && cnt_symbol == ACCUM_SYMBOL_NUM-1 && cnt_chip_in == PRBS_LEN-1 && cnt_decim == INTERP_FACTOR-1) begin
        ad9361_1_cal_done_buf <= 1'b1;
    end
    else begin
        ad9361_1_cal_done_buf <= ad9361_1_cal_done_buf;
    end
end


////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// Accumulation /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// indicating the peak finding process is finished
reg peak_index_valid = 'b0;

always @(posedge clk) begin
    if (rst) begin
        peak_index_valid <= 'b0;
    end
    else if (curr_state == STATE_CAL_2) begin
        peak_index_valid <= msb_accum_abs_valid[0][0] ? 1'b1 : peak_index_valid;
    end
    else begin
        peak_index_valid <= 'b0;
    end
end

// count the number of same peak index
reg [$clog2(INTERP_FACTOR)-1 : 0] peak_index_num [0 : CHANNEL_NUM-1];
reg peak_index_num_valid = 'b0;

reg signed [$clog2(INTERP_FACTOR) : 0] peak_index_num_diff = 'b0; // currently limit channel number to 2
reg peak_index_num_diff_valid = 'b0;

always @(posedge clk) begin
    if (rst) begin
    for (i = 0; i < CHANNEL_NUM; i = i + 1) begin
        peak_index_num[i] <= 'b0;
    end
    end
    else if (curr_state == STATE_CAL_2 && cnt_chip_in == 2'd2) begin
    for (i = 0; i < CHANNEL_NUM; i = i + 1) begin
        if (msb_accum_abs_peak_index[i][cnt_decim] == msb_accum_abs_peak_index[i][0]) begin
            peak_index_num[i] <= cnt_decim;
        end
        else begin
            peak_index_num[i] <= peak_index_num[i];
        end
    end
    end
end

always @(posedge clk) begin
    if (rst) begin
        peak_index_num_valid <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        peak_index_num_valid <= 'b0;
    end
    else if (curr_state == STATE_CAL_2 && cnt_chip_in == 2'd2 && cnt_decim == INTERP_FACTOR-1) begin
        peak_index_num_valid <= 1'b1;
    end
    else begin
        peak_index_num_valid <= 'b0;
    end
end

always @(posedge clk) begin
    if (rst) begin
        peak_index_num_diff <= 'b0;
    end
    else if (peak_index_num_valid) begin
        peak_index_num_diff <= peak_index_num[1] - peak_index_num[0];
    end
end

always @(posedge clk) begin
    if (rst) begin
        peak_index_num_diff_valid <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        peak_index_num_diff_valid <= 'b0;
    end
    else begin
        peak_index_num_diff_valid <= peak_index_num_valid;
    end
end

//
reg [$clog2(PRBS_LEN)-1 : 0] peak_index_plus_minus [0 : 2];

always @(posedge clk) begin
    if (rst) begin
    for (i = 0; i < 3; i = i + 1) begin
        peak_index_plus_minus[i] <= 'b0;
    end
    end
    else if (curr_state == STATE_CAL_2) begin
        peak_index_plus_minus[0] <= msb_accum_abs_peak_index[0][0];
        peak_index_plus_minus[1] <= msb_accum_abs_peak_index[0][0] - 1'b1;
        peak_index_plus_minus[2] <= msb_accum_abs_peak_index[0][0] + 1'b1;
    end
end

// get target downsample position
localparam CORDIC_LATENCY = 20;

reg target_accum_index [0 : CHANNEL_NUM-1];
reg target_accum_index_valid = 'b0;
reg [$clog2(INTERP_FACTOR+CORDIC_LATENCY)-1 : 0] relative_delay = 'b0; // compensate cordic delay
reg ad9361_cal_result_buf = 'b0;

assign ad9361_cal_result = ad9361_cal_result_buf;

always @(posedge clk) begin
    if (rst) begin
    for (i = 0; i < CHANNEL_NUM; i = i + 1) begin
        target_accum_index[i] <= 'b0;
    end
    end
    else if (peak_index_num_diff_valid) begin
        if (msb_accum_abs_peak_index[1][0] == peak_index_plus_minus[0]) begin
            target_accum_index[0] <= 1'b0;
            target_accum_index[1] <= 1'b0;
            relative_delay <= peak_index_num_diff + (CORDIC_LATENCY-1);
            ad9361_cal_result_buf <= 1'b1;
        end
        else if (msb_accum_abs_peak_index[1][0] == peak_index_plus_minus[1]) begin
            target_accum_index[0] <= 1'b0;
            target_accum_index[1] <= 1'b1;
            relative_delay <= peak_index_num_diff + INTERP_FACTOR + (CORDIC_LATENCY-1);
            ad9361_cal_result_buf <= 1'b1;
        end
        else if (msb_accum_abs_peak_index[1][0] == peak_index_plus_minus[2]) begin
            target_accum_index[0] <= 1'b1;
            target_accum_index[1] <= 1'b0;
            relative_delay <= peak_index_num_diff - INTERP_FACTOR + (CORDIC_LATENCY-1);
            ad9361_cal_result_buf <= 1'b1;
        end
        else begin
            target_accum_index[0] <= 1'b0;
            target_accum_index[1] <= 1'b0;
            relative_delay <= peak_index_num_diff + (CORDIC_LATENCY-1);
            ad9361_cal_result_buf <= 1'b0;
        end
    end
    else begin
    for (i = 0; i < CHANNEL_NUM; i = i + 1) begin
        target_accum_index[i] <= target_accum_index[i];
    end
        relative_delay <= relative_delay;
    end
end

always @(posedge clk) begin
    if (rst) begin
        target_accum_index_valid <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        target_accum_index_valid <= 'b0;
    end
    else begin
        target_accum_index_valid <= peak_index_num_diff_valid;
    end
end


// get target data
reg [DATA_ACCUM_LEN-1 : 0] rx_i_accum_target [0 : CHANNEL_NUM-1];
reg [DATA_ACCUM_LEN-1 : 0] rx_q_accum_target [0 : CHANNEL_NUM-1];
reg rx_accum_target_valid = 'b0;

always @(posedge clk) begin
    if (rst) begin
    for (i = 0; i < CHANNEL_NUM; i = i + 1) begin
        rx_i_accum_target[i] <= 'b0;
        rx_q_accum_target[i] <= 'b0;
    end
    end
    else if (target_accum_index_valid) begin
    for (i = 0; i < CHANNEL_NUM; i = i + 1) begin
        rx_i_accum_target[i] <= rx_i_accum[i][target_accum_index[i]];
        rx_q_accum_target[i] <= rx_q_accum[i][target_accum_index[i]];
    end
    end
end

always @(posedge clk) begin
    if (rst) begin
        rx_accum_target_valid <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        rx_accum_target_valid <= 'b0;
    end
    else begin
        rx_accum_target_valid <= target_accum_index_valid;
    end
end

// calculate phase difference
localparam AXIS_CORDIC_WIDTH = 8*((CORDIC_WIDTH-1)/8+1);

wire [AXIS_CORDIC_WIDTH-1 : 0] atan2_data_real [0 : CHANNEL_NUM-1];
wire [AXIS_CORDIC_WIDTH-1 : 0] atan2_data_imag [0 : CHANNEL_NUM-1];

wire [2*AXIS_CORDIC_WIDTH-1:0] atan2_data [0 : CHANNEL_NUM-1];
wire atan2_valid_i [0 : CHANNEL_NUM-1];

wire signed [AXIS_CORDIC_WIDTH-1:0] atan2_phase [0 : CHANNEL_NUM-1];
wire atan2_valid_o [0 : CHANNEL_NUM-1];

generate
for (m = 0; m < CHANNEL_NUM; m = m + 1) begin

assign atan2_data_real[m] = (DATA_ACCUM_LEN > AXIS_CORDIC_WIDTH) ? rx_i_accum_target[m][DATA_ACCUM_LEN-1 -: AXIS_CORDIC_WIDTH] : {{(AXIS_CORDIC_WIDTH-DATA_ACCUM_LEN){rx_i_accum_target[m][DATA_ACCUM_LEN-1]}},rx_i_accum_target[m]};
assign atan2_data_imag[m] = (DATA_ACCUM_LEN > AXIS_CORDIC_WIDTH) ? rx_q_accum_target[m][DATA_ACCUM_LEN-1 -: AXIS_CORDIC_WIDTH] : {{(AXIS_CORDIC_WIDTH-DATA_ACCUM_LEN){rx_q_accum_target[m][DATA_ACCUM_LEN-1]}},rx_q_accum_target[m]};

assign atan2_data[m] = {atan2_data_imag[m],atan2_data_real[m]};
assign atan2_valid_i[m] = rx_accum_target_valid;

atan2_16b u_atan2
(
    .aclk                   (clk                ), // input wire aclk
    .s_axis_cartesian_tvalid(atan2_valid_i[m]   ), // input wire s_axis_cartesian_tvalid
    .s_axis_cartesian_tdata (atan2_data[m]      ), // input wire [31 : 0] s_axis_cartesian_tdata
    .m_axis_dout_tvalid     (atan2_valid_o[m]   ), // output wire m_axis_dout_tvalid
    .m_axis_dout_tdata      (atan2_phase[m]     )  // output wire [15 : 0] m_axis_dout_tdata
);

end
endgenerate

reg signed [AXIS_CORDIC_WIDTH-1:0] phase_diff_raw = 'b0;
reg phase_diff_raw_valid = 'b0;

reg signed [AXIS_CORDIC_WIDTH-1:0] phase_diff = 'b0;
reg phase_diff_valid = 'b0;

always @(posedge clk) begin
    if (rst) begin
        phase_diff_raw <= 'b0;
    end
    else if (atan2_valid_o[0]) begin
        // here calculate the phase difference from target channel to another channel,
        // then rotate another channel to target channel
        phase_diff_raw <= atan2_phase[0] - atan2_phase[1];
    end
    else begin
        phase_diff_raw <= phase_diff_raw;
    end
end

always @(posedge clk) begin
    if (rst) begin
        phase_diff_raw_valid <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        phase_diff_raw_valid <= 'b0;
    end
    else if (atan2_valid_o[0]) begin
        phase_diff_raw_valid <= 1'b1;
    end
    else begin
        phase_diff_raw_valid <= phase_diff_raw_valid;
    end
end

always @(posedge clk) begin
    if (rst) begin
        phase_diff <= 'b0;
    end
    else if (phase_diff_raw_valid) begin
        if (phase_diff_raw > POS_PI_2Q13_SCALED) begin
            phase_diff <= phase_diff_raw - (2*POS_PI_2Q13_SCALED);
        end
        else if (phase_diff_raw < NEG_PI_2Q13_SCALED) begin
            phase_diff <= phase_diff_raw + (2*POS_PI_2Q13_SCALED);
        end
        else begin
            phase_diff <= phase_diff_raw;
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        phase_diff_valid <= 'b0;
    end
    else if (curr_state == STATE_IDLE) begin
        phase_diff_valid <= 'b0;
    end
    else begin
        phase_diff_valid <= phase_diff_raw_valid;
    end
end

// rotate the 3rd and 4th channel
wire rotate_phase_valid;
wire [AXIS_CORDIC_WIDTH-1 : 0] rotate_phase_data;

wire rotate_cart_valid;
wire [AXIS_CORDIC_WIDTH-1 : 0] rotate_cart_ch3_data_real;
wire [AXIS_CORDIC_WIDTH-1 : 0] rotate_cart_ch3_data_imag;
wire [AXIS_CORDIC_WIDTH-1 : 0] rotate_cart_ch4_data_real;
wire [AXIS_CORDIC_WIDTH-1 : 0] rotate_cart_ch4_data_imag;
wire [2*AXIS_CORDIC_WIDTH-1 : 0] rotate_cart_ch3_data;
wire [2*AXIS_CORDIC_WIDTH-1 : 0] rotate_cart_ch4_data;

wire rotate_dout_ch3_valid;
wire rotate_dout_ch4_valid;
wire [2*AXIS_CORDIC_WIDTH-1 : 0] rotate_dout_ch3_data;
wire [2*AXIS_CORDIC_WIDTH-1 : 0] rotate_dout_ch4_data;
wire [AXIS_CORDIC_WIDTH-1 : 0] rx_ch3_rotate_i;
wire [AXIS_CORDIC_WIDTH-1 : 0] rx_ch3_rotate_q;
wire [AXIS_CORDIC_WIDTH-1 : 0] rx_ch4_rotate_i;
wire [AXIS_CORDIC_WIDTH-1 : 0] rx_ch4_rotate_q;

assign rotate_phase_valid = phase_diff_valid;
assign rotate_phase_data = phase_diff;

assign rotate_cart_valid = 1'b1;
assign rotate_cart_ch3_data_real = (ADC_DATA_WIDTH > AXIS_CORDIC_WIDTH) ? rx_ch3_i[ADC_DATA_WIDTH-1 -: AXIS_CORDIC_WIDTH] : {rx_ch3_i,{(AXIS_CORDIC_WIDTH-ADC_DATA_WIDTH){1'b0}}};
assign rotate_cart_ch3_data_imag = (ADC_DATA_WIDTH > AXIS_CORDIC_WIDTH) ? rx_ch3_q[ADC_DATA_WIDTH-1 -: AXIS_CORDIC_WIDTH] : {rx_ch3_q,{(AXIS_CORDIC_WIDTH-ADC_DATA_WIDTH){1'b0}}};
assign rotate_cart_ch4_data_real = (ADC_DATA_WIDTH > AXIS_CORDIC_WIDTH) ? rx_ch4_i[ADC_DATA_WIDTH-1 -: AXIS_CORDIC_WIDTH] : {rx_ch4_i,{(AXIS_CORDIC_WIDTH-ADC_DATA_WIDTH){1'b0}}};
assign rotate_cart_ch4_data_imag = (ADC_DATA_WIDTH > AXIS_CORDIC_WIDTH) ? rx_ch4_q[ADC_DATA_WIDTH-1 -: AXIS_CORDIC_WIDTH] : {rx_ch4_q,{(AXIS_CORDIC_WIDTH-ADC_DATA_WIDTH){1'b0}}};

assign rotate_cart_ch3_data = {rotate_cart_ch3_data_imag,rotate_cart_ch3_data_real};
assign rotate_cart_ch4_data = {rotate_cart_ch4_data_imag,rotate_cart_ch4_data_real};

assign {rx_ch3_rotate_q,rx_ch3_rotate_i} = rotate_dout_ch3_data;
assign {rx_ch4_rotate_q,rx_ch4_rotate_i} = rotate_dout_ch4_data;

rotate_16b u_rotate_16b_ch3
(
    .aclk                   (clk                    ), // input wire aclk
    .s_axis_phase_tvalid    (rotate_phase_valid     ), // input wire s_axis_phase_tvalid
    .s_axis_phase_tdata     (rotate_phase_data      ), // input wire [15 : 0] s_axis_phase_tdata
    .s_axis_cartesian_tvalid(rotate_cart_valid      ), // input wire s_axis_cartesian_tvalid
    .s_axis_cartesian_tdata (rotate_cart_ch3_data   ), // input wire [31 : 0] s_axis_cartesian_tdata
    .m_axis_dout_tvalid     (rotate_dout_ch3_valid  ), // output wire m_axis_dout_tvalid
    .m_axis_dout_tdata      (rotate_dout_ch3_data   )  // output wire [31 : 0] m_axis_dout_tdata
);

rotate_16b u_rotate_16b_ch4
(
    .aclk                   (clk                    ), // input wire aclk
    .s_axis_phase_tvalid    (rotate_phase_valid     ), // input wire s_axis_phase_tvalid
    .s_axis_phase_tdata     (rotate_phase_data      ), // input wire [15 : 0] s_axis_phase_tdata
    .s_axis_cartesian_tvalid(rotate_cart_valid      ), // input wire s_axis_cartesian_tvalid
    .s_axis_cartesian_tdata (rotate_cart_ch4_data   ), // input wire [31 : 0] s_axis_cartesian_tdata
    .m_axis_dout_tvalid     (rotate_dout_ch4_valid  ), // output wire m_axis_dout_tvalid
    .m_axis_dout_tdata      (rotate_dout_ch4_data   )  // output wire [31 : 0] m_axis_dout_tdata
);


localparam TOTAL_LATENCY = CORDIC_LATENCY+INTERP_FACTOR-1;

reg [ADC_DATA_WIDTH-1 : 0] rx_ch1_i_delay [0 : TOTAL_LATENCY-1];
reg [ADC_DATA_WIDTH-1 : 0] rx_ch1_q_delay [0 : TOTAL_LATENCY-1];
reg [ADC_DATA_WIDTH-1 : 0] rx_ch2_i_delay [0 : TOTAL_LATENCY-1];
reg [ADC_DATA_WIDTH-1 : 0] rx_ch2_q_delay [0 : TOTAL_LATENCY-1];

always @(posedge clk) begin
    if (rst) begin
    for (i = 0; i < TOTAL_LATENCY; i = i + 1) begin
        rx_ch1_i_delay[i] <= 'b0;
        rx_ch1_q_delay[i] <= 'b0;
        rx_ch2_i_delay[i] <= 'b0;
        rx_ch2_q_delay[i] <= 'b0;
    end
    end
    else begin
    for (i = 1; i < TOTAL_LATENCY; i = i + 1) begin
        rx_ch1_i_delay[i] <= rx_ch1_i_delay[i-1];
        rx_ch1_q_delay[i] <= rx_ch1_q_delay[i-1];
        rx_ch2_i_delay[i] <= rx_ch2_i_delay[i-1];
        rx_ch2_q_delay[i] <= rx_ch2_q_delay[i-1];
    end
        rx_ch1_i_delay[0] <= rx_ch1_i;
        rx_ch1_q_delay[0] <= rx_ch1_q;
        rx_ch2_i_delay[0] <= rx_ch2_i;
        rx_ch2_q_delay[0] <= rx_ch2_q;
    end
end

reg [ADC_DATA_WIDTH-1 : 0] rx_cal_ch1_i_buf = 'b0;
reg [ADC_DATA_WIDTH-1 : 0] rx_cal_ch1_q_buf = 'b0;
reg [ADC_DATA_WIDTH-1 : 0] rx_cal_ch2_i_buf = 'b0;
reg [ADC_DATA_WIDTH-1 : 0] rx_cal_ch2_q_buf = 'b0;
reg [ADC_DATA_WIDTH-1 : 0] rx_cal_ch3_i_buf = 'b0;
reg [ADC_DATA_WIDTH-1 : 0] rx_cal_ch3_q_buf = 'b0;
reg [ADC_DATA_WIDTH-1 : 0] rx_cal_ch4_i_buf = 'b0;
reg [ADC_DATA_WIDTH-1 : 0] rx_cal_ch4_q_buf = 'b0;

assign rx_cal_ch1_i = rx_cal_ch1_i_buf;
assign rx_cal_ch1_q = rx_cal_ch1_q_buf;
assign rx_cal_ch2_i = rx_cal_ch2_i_buf;
assign rx_cal_ch2_q = rx_cal_ch2_q_buf;
assign rx_cal_ch3_i = rx_cal_ch3_i_buf;
assign rx_cal_ch3_q = rx_cal_ch3_q_buf;
assign rx_cal_ch4_i = rx_cal_ch4_i_buf;
assign rx_cal_ch4_q = rx_cal_ch4_q_buf;

always @(posedge clk) begin
    if (rst) begin
        rx_cal_ch1_i_buf <= 'b0;
        rx_cal_ch1_q_buf <= 'b0;
        rx_cal_ch2_i_buf <= 'b0;
        rx_cal_ch2_q_buf <= 'b0;
        rx_cal_ch3_i_buf <= 'b0;
        rx_cal_ch3_q_buf <= 'b0;
        rx_cal_ch4_i_buf <= 'b0;
        rx_cal_ch4_q_buf <= 'b0;
    end
    else if (rotate_dout_ch3_valid) begin
        rx_cal_ch1_i_buf <=  rx_ch1_i_delay[relative_delay];
        rx_cal_ch1_q_buf <=  rx_ch1_q_delay[relative_delay];
        rx_cal_ch2_i_buf <= -rx_ch2_i_delay[relative_delay];
        rx_cal_ch2_q_buf <= -rx_ch2_q_delay[relative_delay];
        rx_cal_ch3_i_buf <=  rx_ch3_rotate_i[AXIS_CORDIC_WIDTH-1 -: ADC_DATA_WIDTH];
        rx_cal_ch3_q_buf <=  rx_ch3_rotate_q[AXIS_CORDIC_WIDTH-1 -: ADC_DATA_WIDTH];
        rx_cal_ch4_i_buf <= -rx_ch4_rotate_i[AXIS_CORDIC_WIDTH-1 -: ADC_DATA_WIDTH];
        rx_cal_ch4_q_buf <= -rx_ch4_rotate_q[AXIS_CORDIC_WIDTH-1 -: ADC_DATA_WIDTH];
    end
    else begin
        rx_cal_ch1_i_buf <= rx_ch1_i;
        rx_cal_ch1_q_buf <= rx_ch1_q;
        rx_cal_ch2_i_buf <= rx_ch2_i;
        rx_cal_ch2_q_buf <= rx_ch2_q;
        rx_cal_ch3_i_buf <= rx_ch3_i;
        rx_cal_ch3_q_buf <= rx_ch3_q;
        rx_cal_ch4_i_buf <= rx_ch4_i;
        rx_cal_ch4_q_buf <= rx_ch4_q;
    end
end

//
reg ad9361_2_cal_done_buf = 'b0;

assign ad9361_2_cal_done = ad9361_2_cal_done_buf;
assign ad9361_cal_valid = ad9361_2_cal_done_buf;

always @(posedge clk) begin
    if (rst) begin
        ad9361_2_cal_done_buf <= 'b0;
    end
    else begin
        ad9361_2_cal_done_buf <= rotate_dout_ch3_valid;
    end
end

endmodule
