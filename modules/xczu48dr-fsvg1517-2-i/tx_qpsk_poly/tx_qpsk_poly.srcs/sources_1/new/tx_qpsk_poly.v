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
// Create Date: 2022/03/23 20:17:56
// Last Modified Date: 2023/03/10 15:41
// Design Name:
// Module Name: tx_qpsk_poly
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
//   Revision 0.01 - File Created
//   20230228-1541 - 修改不扫频、无基带频偏时 [baseband_i/q] 的数据输出，原来从
//     乘法器引出，会导致频率为 0 时输出数据错误，现在直接从基带数据引出。
//   20230310-1542 - 增加输入参数，发送数据更改为直接由参数输入，发送方波改为 8
//     倍过采样，发送双音信号中 1MHz 信号的频率控制字可以根据参数中的时钟频率计
//     算得出。
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module tx_qpsk_poly
#(
  parameter DATA_WIDTH = 12, // need to be <= 16
  parameter BIT_DATA = 128'b00000011000010100011110010001011001110101001111101000011100010010011011010110111101100011010010111011100110010101011111110000001, // inverse pseudorandom bit sequence, [0,flip(PRSB7)]
  parameter BIT_DATA_LEN = 128,
  parameter SQUARE_INTERP = 8,
  parameter CLK_FREQ = 245_760_000*8, // in Hertz
  parameter PARALLEL_NUM = 8
)
(
  input           clk                 ,
  input           rst                 ,
  output [DATA_WIDTH-1:0] tx_data_i   ,
  output [DATA_WIDTH-1:0] tx_data_q   ,
  // debug ports
  input   [ 1:0]  waveform_sel        ,
  input           sweep_on            ,
  input   [31:0]  freq_set            ,
  input   [ 1:0]  iq_sel              ,
  input   [ 3:0]  bb_rshift
);

localparam RCOS_INTERP = 64*PARALLEL_NUM;
localparam INTERP = (RCOS_INTERP > SQUARE_INTERP) ? RCOS_INTERP : SQUARE_INTERP;
localparam FREQ_WORD_1M = (64'd2)**(64'd16)*(64'd1_000_000)/CLK_FREQ;

integer i;
genvar m;

////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// Data Counter /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// symbol & interpolation counter
reg [$clog2(INTERP*BIT_DATA_LEN)-1 : 0]  cnt = 'b0;

always @(posedge clk) begin
    if (rst) begin
        cnt <= 'b0;
    end
    else begin
        cnt <= (cnt == INTERP*BIT_DATA_LEN - 1) ? 'b0 : cnt + 16'b1;
    end
end

// address
reg [$clog2(BIT_DATA_LEN)-1 : 0] bit_data_addr_i = 'b0;
reg [$clog2(BIT_DATA_LEN)-1 : 0] bit_data_addr_q = 'b1;

always @(posedge clk) begin
    if (rst) begin
        bit_data_addr_i <= 'b0;
        bit_data_addr_q <= 'b1;
    end
    else begin
        bit_data_addr_i <= {cnt[$clog2(RCOS_INTERP) +: ($clog2(BIT_DATA_LEN)-1)],1'b0};
        bit_data_addr_q <= {cnt[$clog2(RCOS_INTERP) +: ($clog2(BIT_DATA_LEN)-1)],1'b1};
    end
end

// bit data
reg bit_data_i = 'b0;
reg bit_data_q = 'b0;

always @(posedge clk) begin
    if (rst) begin
        bit_data_i <= 'b0;
        bit_data_q <= 'b0;
    end
    else begin
        bit_data_i <= BIT_DATA[bit_data_addr_i];
        bit_data_q <= BIT_DATA[bit_data_addr_q];
    end
end

////////////////////////////////////////////////////////////////////////////////
////////////////////// Root-Rasied Cosine Shaping Filter ///////////////////////
////////////////////////////////////////////////////////////////////////////////

// polarization
wire [7:0] hrc_data_polar_i;
wire [7:0] hrc_data_polar_q;

assign hrc_data_polar_i = {{7{bit_data_i}},1'b1};
assign hrc_data_polar_q = {{7{bit_data_q}},1'b1};

// root raised cosine shaping-filter
wire [24*PARALLEL_NUM-1 : 0] hrc_wave_i;
wire [24*PARALLEL_NUM-1 : 0] hrc_wave_q;

wire [23:0] hrc_wave_i_par [0 : PARALLEL_NUM-1];
wire [23:0] hrc_wave_q_par [0 : PARALLEL_NUM-1];

generate

for (m = 0; m < PARALLEL_NUM; m = m + 1) begin
  assign hrc_wave_i_par[m] = hrc_wave_i[24*m +: 24];
  assign hrc_wave_q_par[m] = hrc_wave_q[24*m +: 24];
end

case (PARALLEL_NUM)
  1: begin
    hrc_64_12_025 u_hrc_i
    (
      .aclk               (clk              ), // input wire aclk
      .s_axis_data_tvalid (~rst             ), // input wire s_axis_data_tvalid
      .s_axis_data_tready (                 ), // output wire s_axis_data_tready
      .s_axis_data_tdata  (hrc_data_polar_i ), // input wire [7 : 0] s_axis_data_tdata
      .m_axis_data_tvalid (                 ), // output wire m_axis_data_tvalid
      .m_axis_data_tdata  (hrc_wave_i       )  // output wire [23 : 0] m_axis_data_tdata
    );

    hrc_64_12_025 u_hrc_q
    (
      .aclk               (clk              ), // input wire aclk
      .s_axis_data_tvalid (~rst             ), // input wire s_axis_data_tvalid
      .s_axis_data_tready (                 ), // output wire s_axis_data_tready
      .s_axis_data_tdata  (hrc_data_polar_q ), // input wire [7 : 0] s_axis_data_tdata
      .m_axis_data_tvalid (                 ), // output wire m_axis_data_tvalid
      .m_axis_data_tdata  (hrc_wave_q       )  // output wire [23 : 0] m_axis_data_tdata
    );
    end
  4: begin
    hrc_256_12_025 u_hrc_i
    (
      .aclk               (clk              ), // input wire aclk
      .s_axis_data_tvalid (~rst             ), // input wire s_axis_data_tvalid
      .s_axis_data_tready (                 ), // output wire s_axis_data_tready
      .s_axis_data_tdata  (hrc_data_polar_i ), // input wire [7 : 0] s_axis_data_tdata
      .m_axis_data_tvalid (                 ), // output wire m_axis_data_tvalid
      .m_axis_data_tdata  (hrc_wave_i       )  // output wire [95 : 0] m_axis_data_tdata
    );

    hrc_256_12_025 u_hrc_q
    (
      .aclk               (clk              ), // input wire aclk
      .s_axis_data_tvalid (~rst             ), // input wire s_axis_data_tvalid
      .s_axis_data_tready (                 ), // output wire s_axis_data_tready
      .s_axis_data_tdata  (hrc_data_polar_q ), // input wire [7 : 0] s_axis_data_tdata
      .m_axis_data_tvalid (                 ), // output wire m_axis_data_tvalid
      .m_axis_data_tdata  (hrc_wave_q       )  // output wire [95 : 0] m_axis_data_tdata
    );
  end
  8: begin
    hrc_512_12_025 u_hrc_i
    (
      .aclk               (clk              ), // input wire aclk
      .s_axis_data_tvalid (~rst             ), // input wire s_axis_data_tvalid
      .s_axis_data_tready (                 ), // output wire s_axis_data_tready
      .s_axis_data_tdata  (hrc_data_polar_i ), // input wire [7 : 0] s_axis_data_tdata
      .m_axis_data_tvalid (                 ), // output wire m_axis_data_tvalid
      .m_axis_data_tdata  (hrc_wave_i       )  // output wire [191 : 0] m_axis_data_tdata
    );

    hrc_512_12_025 u_hrc_q
    (
      .aclk               (clk              ), // input wire aclk
      .s_axis_data_tvalid (~rst             ), // input wire s_axis_data_tvalid
      .s_axis_data_tready (                 ), // output wire s_axis_data_tready
      .s_axis_data_tdata  (hrc_data_polar_q ), // input wire [7 : 0] s_axis_data_tdata
      .m_axis_data_tvalid (                 ), // output wire m_axis_data_tvalid
      .m_axis_data_tdata  (hrc_wave_q       )  // output wire [191 : 0] m_axis_data_tdata
    );
  end
  default: begin
    hrc_64_12_025 u_hrc_i
    (
      .aclk               (clk              ), // input wire aclk
      .s_axis_data_tvalid (~rst             ), // input wire s_axis_data_tvalid
      .s_axis_data_tready (                 ), // output wire s_axis_data_tready
      .s_axis_data_tdata  (hrc_data_polar_i ), // input wire [7 : 0] s_axis_data_tdata
      .m_axis_data_tvalid (                 ), // output wire m_axis_data_tvalid
      .m_axis_data_tdata  (hrc_wave_i       )  // output wire [23 : 0] m_axis_data_tdata
    );

    hrc_64_12_025 u_hrc_q
    (
      .aclk               (clk              ), // input wire aclk
      .s_axis_data_tvalid (~rst             ), // input wire s_axis_data_tvalid
      .s_axis_data_tready (                 ), // output wire s_axis_data_tready
      .s_axis_data_tdata  (hrc_data_polar_q ), // input wire [7 : 0] s_axis_data_tdata
      .m_axis_data_tvalid (                 ), // output wire m_axis_data_tvalid
      .m_axis_data_tdata  (hrc_wave_q       )  // output wire [23 : 0] m_axis_data_tdata
    );
  end
endcase

endgenerate


////////////////////////////////////////////////////////////////////////////////
//////////////////////////// Square Shaping Filter /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// square shaping-filter
reg [17:0] hsq_wave_i ='b0;
reg [17:0] hsq_wave_q ='b0;

always @(posedge clk) begin
  if (rst) begin
    hsq_wave_i <= 'b0;
    hsq_wave_q <= 'b0;
  end
  else begin
    hsq_wave_i <= bit_data_i ? 18'b01_1111_1111_1111_1111 : 18'b10_0000_0000_0000_0001;
    hsq_wave_q <= bit_data_q ? 18'b10_0000_0000_0000_0001 : 18'b01_1111_1111_1111_1111;
  end
end


////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Two Tone Signal ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// cosine wave with freq of 1 MHz
wire signed [16*PARALLEL_NUM-1 : 0] cos_1m;
wire signed [16*PARALLEL_NUM-1 : 0] sin_1m;

wire signed [15 : 0] cos_1m_par [0 : PARALLEL_NUM-1];
wire signed [15 : 0] sin_1m_par [0 : PARALLEL_NUM-1];

generate
for (m = 0; m < PARALLEL_NUM; m = m + 1) begin
  assign cos_1m_par[m] = cos_1m[16*m +: 16];
  assign sin_1m_par[m] = sin_1m[16*m +: 16];
end
endgenerate

dds_par #(
  .PHASE_WIDTH  (16           ),
  .WAVE_WIDTH   (16           ),
  .PARALLEL_NUM (PARALLEL_NUM )
)
(
  .clk      (clk          ),
  .rst      (rst          ),

  .phase_inc(FREQ_WORD_1M ),

  .cos_wave (cos_1m       ),
  .sin_wave (sin_1m       )
);

// two-tone signal
reg signed [15:0] two_tone_wave_i [0 : PARALLEL_NUM-1];
reg signed [15:0] two_tone_wave_q [0 : PARALLEL_NUM-1];

always @(posedge clk) begin
  if (rst) begin
    for (i = 0; i < PARALLEL_NUM; i = i + 1) begin
      two_tone_wave_i[i] <= 'b0;
      two_tone_wave_q[i] <= 'b0;
    end
  end
  else begin
    for (i = 0; i < PARALLEL_NUM; i = i + 1) begin
      two_tone_wave_i[i] <= (cos_1m[i] >>> 1) + 16'h3fff;
      two_tone_wave_q[i] <= (sin_1m[i] >>> 1) + 16'b0;
    end
  end
end


////////////////////////////////////////////////////////////////////////////////
///////////////////// Waveform Selection & Hopping Control /////////////////////
////////////////////////////////////////////////////////////////////////////////
// baseband signal select
reg [15:0] baseband_sel_i [0 : PARALLEL_NUM-1];
reg [15:0] baseband_sel_q [0 : PARALLEL_NUM-1];

always @(posedge clk) begin
  if (rst) begin
    for (i = 0; i < PARALLEL_NUM; i = i + 1) begin
      baseband_sel_i[i] <= 'b0;
      baseband_sel_q[i] <= 'b0;
    end
  end
  else begin
    for (i = 0; i < PARALLEL_NUM; i = i + 1) begin
      case (waveform_sel[1:0])
        2'd0: begin
          baseband_sel_i[i] <= hrc_wave_i_par[i][0 +: 16];
          baseband_sel_q[i] <= hrc_wave_q_par[i][0 +: 16];
        end
        2'd1: begin
          baseband_sel_i[i] <= hsq_wave_i[17:0];
          baseband_sel_q[i] <= hsq_wave_q[17:0];
        end
        2'd2: begin
          baseband_sel_i[i] <= 16'h7fff;
          baseband_sel_q[i] <= 16'b0;
        end
        2'd3: begin
          baseband_sel_i[i] <= two_tone_wave_i[i];
          baseband_sel_q[i] <= two_tone_wave_q[i];
        end
        default: begin
          baseband_sel_i[i] <= hrc_wave_i_par[i][0 +: 16];
          baseband_sel_q[i] <= hrc_wave_q_par[i][0 +: 16];
        end
      endcase
    end
  end
end

// hopping control, 3750hop/s
reg     [23:0]  sweep_rom_addr = 'b0;
wire    [31:0]  freq_sweep;

always @(posedge clk) begin
  if (rst) begin
    sweep_rom_addr <= 'b0;
  end
  else if (sweep_on) begin
    sweep_rom_addr <= sweep_rom_addr + 24'b1;
  end
  else begin
    sweep_rom_addr <= 'b0;
  end
end

hop_rom u_sweep_rom
(
  .clka       (clk                    ), // input wire clka
  .addra      (sweep_rom_addr[23:16]  ), // input wire [7 : 0] addra
  .douta      (freq_sweep             )  // output wire [31 : 0] douta
);

// choose the actual frequency word
reg     [31:0]  freq_word = 'b0;

always @(posedge clk) begin
  if (rst) begin
    freq_word <= 'b0;
  end
  else if (sweep_on) begin
    // frequency sweep
    freq_word <= freq_sweep;
  end
  else begin
    // normal operation
    freq_word <= freq_set;
  end
end

// baseband frequency shift carrier generation
wire    [ 7:0] cos_dds;
wire    [ 7:0] sin_dds;
reg     [ 7:0] cos = 'b0;
reg     [ 7:0] sin = 'b0;

dds_32b_8b u_dds_bb_shift (
  .aclk                 (clk              ), // input wire aclk
  .s_axis_config_tvalid (~rst             ), // input wire s_axis_config_tvalid
  .s_axis_config_tdata  (freq_word        ), // input wire [31 : 0] s_axis_config_tdata
  .m_axis_data_tvalid   (                 ), // output wire m_axis_data_tvalid
  .m_axis_data_tdata    ({sin_dds,cos_dds})  // output wire [31 : 0] m_axis_data_tdata
);

always @(posedge clk) begin
  if (rst) begin
    cos <= 'b0;
    sin <= 'b0;
  end
  else if (freq_word == 'b0) begin
    // to make sure the carriers stay at the right position when freq = 0
    cos <= 8'b0111_1111;
    sin <= 8'b0111_1111;
  end
  else begin
    cos <= cos_dds;
    sin <= sin_dds;
  end
end

// baseband frequency shift modulation
wire    [47:0]  mod_cmpy_a;
wire    [15:0]  mod_cmpy_b;
wire    [63:0]  mod_cmpy_out;

wire    [26:0]  baseband_mult_i;
wire    [26:0]  baseband_mult_q;

assign mod_cmpy_a = {6'b0,baseband_sel_q,6'b0,baseband_sel_i};
assign mod_cmpy_b = {-sin,cos};

assign baseband_mult_i = mod_cmpy_out[58:32];
assign baseband_mult_q = mod_cmpy_out[26: 0];

cmpy_18x8 u_cmpy_18x8
(
  .aclk               (clk            ), // input wire aclk
  .s_axis_a_tvalid    (1'b1           ), // input wire s_axis_a_tvalid
  .s_axis_a_tdata     (mod_cmpy_a     ), // input wire [47 : 0] s_axis_a_tdata
  .s_axis_b_tvalid    (1'b1           ), // input wire s_axis_b_tvalid
  .s_axis_b_tdata     (mod_cmpy_b     ), // input wire [15 : 0] s_axis_b_tdata
  .m_axis_dout_tvalid (               ), // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata  (mod_cmpy_out   )  // output wire [63 : 0] m_axis_dout_tdata
);

// truncate to 16-bit
reg signed  [15:0]  baseband_i = 'b0;
reg signed  [15:0]  baseband_q = 'b0;

always @(posedge clk) begin
  if (rst) begin
    baseband_i <= 'b0;
    baseband_q <= 'b0;
  end
  else begin
    case (waveform_sel[1:0])
      2'd0: begin
        // scale rasied-cosine-shaped bpsk signal by 1.125 or 1.625
        baseband_i <= (sweep_on == 0 && freq_set == 0) ? (baseband_sel_i[17 -: 16] + {{3{baseband_sel_i[17]}},baseband_sel_i[17 -: 13]}) : (baseband_mult_i[25:10] + {baseband_mult_i[25],baseband_mult_i[25:11]} + {{3{baseband_mult_i[25]}},baseband_mult_i[25:13]});
        baseband_q <= (sweep_on == 0 && freq_set == 0) ? (baseband_sel_q[17 -: 16] + {{3{baseband_sel_q[17]}},baseband_sel_q[17 -: 13]}) : (baseband_mult_q[25:10] + {baseband_mult_q[25],baseband_mult_q[25:11]} + {{3{baseband_mult_q[25]}},baseband_mult_q[25:13]});
      end
      2'd1: begin
        baseband_i <= (sweep_on == 0 && freq_set == 0) ? baseband_sel_i[17 -: 16] : (baseband_mult_i[25:10] + {{2{baseband_mult_i[25]}},baseband_mult_i[25:12]});
        baseband_q <= (sweep_on == 0 && freq_set == 0) ? baseband_sel_q[17 -: 16] : (baseband_mult_q[25:10] + {{2{baseband_mult_q[25]}},baseband_mult_q[25:12]});
      end
      2'd2: begin
        baseband_i <= baseband_mult_i[24:9];
        baseband_q <= baseband_mult_q[24:9];
      end
      2'd3: begin
        baseband_i <= (sweep_on == 0 && freq_set == 0) ? baseband_sel_i[17 -: 16] : baseband_mult_i[24:9];
        baseband_q <= (sweep_on == 0 && freq_set == 0) ? baseband_sel_q[17 -: 16] : baseband_mult_q[24:9];
      end
      default: begin
        // scale rasied-cosine-shaped bpsk signal by 1.125
        baseband_i <= baseband_mult_i[25:10] + {{3{baseband_mult_i[25]}},baseband_mult_i[25:13]};
        baseband_q <= baseband_mult_q[25:10] + {{3{baseband_mult_q[25]}},baseband_mult_q[25:13]};
      end
    endcase
  end
end

// iq selection & baseband right shift
reg signed [15:0] baseband_data_i = 'b0;
reg signed [15:0] baseband_data_q = 'b0;

always @(posedge clk) begin
  if (rst) begin
    baseband_data_i <= 'b0;
    baseband_data_q <= 'b0;
  end
  else begin
    // inphase selection
    if (iq_sel[1]) begin
      baseband_data_i <= baseband_i >>> bb_rshift;
    end
    else begin
      baseband_data_i <= 'b0;
    end
    // quadrature selection
    if (iq_sel[0]) begin
      baseband_data_q <= baseband_q >>> bb_rshift;
    end
    else begin
      baseband_data_q <= 'b0;
    end
  end
end

// output data to ports
assign tx_data_i = baseband_data_i[15 -: DATA_WIDTH];
assign tx_data_q = baseband_data_q[15 -: DATA_WIDTH];

endmodule


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2020/12/08 12:43:46
// Design Name:
// Module Name: tb_tx_qpsk
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


// module tb_tx_qpsk;

// reg             clk         = 1'b0  ;
// reg             rst         = 1'b1  ;
// reg             tx_on       = 1'b1  ;
// reg     [31:0]  freq_set            ;
// reg     [ 1:0]  waveform_sel = 2'b00;
// reg     [ 1:0]  iq_sel      = 2'b11 ;
// wire    [11:0]  tx_data_i           ;
// wire    [11:0]  tx_data_q           ;
// reg     [ 3:0]  bb_rshift   = 5'b0  ;

// tx_qpsk u_tx_qpsk
// (
//     .clk            (clk            ),
//     .rst            (rst            ),
//     .tx_data_i      (tx_data_i      ),
//     .tx_data_q      (tx_data_q      ),
//     .waveform_sel   (waveform_sel   ),
//     .sweep_on       (1'b0           ),
//     // .freq_set       (32'd447392426  ),
//     .freq_set       (32'd0          ),
//     .iq_sel         (iq_sel         ),
//     .bb_rshift      (bb_rshift      )
// );

// initial begin
//     #102
//     rst = 1'b0;
//     // freq_set = 32'd873813333;
//     // waveform_sel = 2'b00;
//     // bb_rshift = 5'd0;
//     // #5000
//     // bb_rshift = 5'd1;
//     // #5000
//     // bb_rshift = 5'd2;
//     // #5000
//     // bb_rshift = 5'd3;
//     // #5000
//     // bb_rshift = 5'd4;
//     // #5000
//     // bb_rshift = 5'd5;
//     // #5000
//     // bb_rshift = 5'd6;
//     // #5000
//     // bb_rshift = 5'd7;
//     // #5000
//     // bb_rshift = 5'd8;
//     // #5000
//     // bb_rshift = 5'd9;
//     // #5000
//     // bb_rshift = 5'd14;
//     // #5000
//     // bb_rshift = 5'd15;
//     // #5000
//     // bb_rshift = 5'd16;
//     // freq_set = 32'd0;
//     // func_sel = 3'b010;
//     // #7777
//     // freq_set = 32'd536870912;
//     // func_sel = 3'b100;
//     // #7777
//     // freq_set = 32'd0;
//     // func_sel = 3'b100;
//     // #7777
//     // freq_set = 32'd536870912;
//     // func_sel = 3'b010;
//     // #7777
//     // freq_set = 32'd0;
//     // func_sel = 3'b010;
//     // freq_set = 32'd536870912;
//     // iq_sel = 2'b00;
//     // #7777
//     // freq_set = 32'd536870912;
//     // iq_sel = 2'b01;
//     // #7777
//     // freq_set = 32'd536870912;
//     // iq_sel = 2'b10;
//     // #7777
//     // freq_set = 32'd536870912;
//     // iq_sel = 2'b11;
// end

// always #5 clk = ~clk;

// // integer i;
// // integer w_file;

// // initial begin
// //     w_file = $fopen("D:\\qpsk_josh.txt","w");
// //     for (i = 0; i <= 35000; i = i + 1) begin
// //         wait(clk);
// //         #10;
// //         $fdisplay(w_file,"%d    %d",$signed(tx_data_i),
// //                 $signed(tx_data_q));
// //         if (i == 35000) begin
// //             $fclose(w_file);
// //             $stop;
// //         end
// //     end
// // end

// endmodule
