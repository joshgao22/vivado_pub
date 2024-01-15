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
// Create Date: 01/14/2024 02:50:34 PM
// Design Name:
// Module Name: dds_par
// Project Name:
// Target Devices:
// Tool Versions:
// Description: This module generates parallel sine/cosine wave with continuous
//   phase, which can be used as polyphase adjustable carrier wave.
// Parameter:
//   PHASE_WIDTH: Bit width of input phase address.
//   WAVE_WIDTH: Bit width of output sine/cosine wave.
//   PARALLEL_NUM: Number of parallel paths. The optimal wave is generated when
//     this number is power of 2, however the module should work fine with any
//     number of parallel paths.
// Data format:
//   cos_wave/sin_wave: Suppose the samples are s = [s0, s1, ..., sN], then
//     cos_wave/sin_wave = {sN, ..., s1, s0}
// Total latency: [PARALLEL_NUM+6] clock cycles, including 4 clock cycles for
//   addr_to_wave
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module dds_par
#(
  parameter PHASE_WIDTH = 16,
  parameter WAVE_WIDTH = 16,
  parameter PARALLEL_NUM = 8
)
(
  input clk,
  input rst,

  input [PHASE_WIDTH-1 : 0] phase_inc,

  output [WAVE_WIDTH*PARALLEL_NUM-1 : 0] cos_wave,
  output [WAVE_WIDTH*PARALLEL_NUM-1 : 0] sin_wave
);

localparam PARALLEL_NUM_LOG = $clog2(PARALLEL_NUM);
localparam PHASE_CONFIG_DELAY = PARALLEL_NUM + 1;

genvar m;
integer i;

// buffer
reg [PHASE_WIDTH-1 : 0] phase_inc_d [1:2];

always @(posedge clk) begin
  if (rst) begin
    for (i = 1; i <= 2 ; i = i + 1) begin
      phase_inc_d[i] <= 'b0;
    end
  end
  else begin
    phase_inc_d[1] <= phase_inc;
    phase_inc_d[2] <= phase_inc_d[1];
  end
end

// phase increment change identification
reg phase_config_flag [0:PHASE_CONFIG_DELAY-1];

always @(posedge clk) begin
  if (rst) begin
    for (i = 0; i < PHASE_CONFIG_DELAY; i = i + 1) begin
      phase_config_flag[i] <= 'b0;
    end
  end
  else begin
    phase_config_flag[0] <= (phase_inc_d[2] != phase_inc_d[1]) ? 1'b1 : 'b0;
    for (i = 1; i < PHASE_CONFIG_DELAY; i = i + 1) begin
      phase_config_flag[i] <= phase_config_flag[i-1];
    end
  end
end

// offset counter
reg [$clog2(PARALLEL_NUM)-1 : 0] phase_config_cnt = 'b0;

always @(posedge clk) begin
  if (rst) begin
    phase_config_cnt <= 'b0;
  end
  else if (phase_config_flag[0]) begin
    phase_config_cnt <= phase_config_cnt + 1'b1;
  end
  else begin
    phase_config_cnt <= (phase_config_cnt == 'b0) ? 'b0 : phase_config_cnt + 1'b1;
  end
end

// phase offset generation based on new phase increment
reg [PHASE_WIDTH-1 : 0] phase_off [0 : PARALLEL_NUM-1];

always @(posedge clk) begin
  if (rst) begin
    for (i = 0; i < PARALLEL_NUM; i = i + 1) begin
      phase_off[i] <= 'b0;
    end
  end
  else if (phase_config_cnt != 'b0) begin
    phase_off[phase_config_cnt] <= phase_off[phase_config_cnt-1] + phase_inc_d[2];
  end
end

// phase generation
reg [PHASE_WIDTH-1 : 0] phase [0 : PARALLEL_NUM-1];

always @(posedge clk) begin
  if (rst) begin
    for (i = 0; i < PARALLEL_NUM; i = i + 1) begin
      phase[i] <= 'b0;
    end
  end
  else if (phase_config_flag[PHASE_CONFIG_DELAY-1]) begin
    for (i = 0; i < PARALLEL_NUM; i = i + 1) begin
      phase[i] <= phase_off[i];
    end
  end
  else begin
    for (i = 0; i < PARALLEL_NUM; i = i + 1) begin
      phase[i] <= phase[i] + (phase_inc << PARALLEL_NUM_LOG);
    end
  end
end

// phase to wave
wire [WAVE_WIDTH-1 : 0] cos_wave_par [0 : PARALLEL_NUM-1];
wire [WAVE_WIDTH-1 : 0] sin_wave_par [0 : PARALLEL_NUM-1];

generate
for (m = 0; m < PARALLEL_NUM; m = m + 1) begin: phase_to_wave

  addr_to_wave
  #(
    .PHASE_WIDTH  (PHASE_WIDTH),
    .WAVE_WIDTH   (WAVE_WIDTH )
  ) u_addr_to_wave
  (
    // clock & reset
    .clk      (clk            ),
    .rst      (rst            ),

    .phase    (phase[m]       ),

    .cos_wave (cos_wave_par[m]),
    .sin_wave (sin_wave_par[m])
  );

  // output to port
  assign cos_wave[WAVE_WIDTH*m +: WAVE_WIDTH] = cos_wave_par[m];
  assign sin_wave[WAVE_WIDTH*m +: WAVE_WIDTH] = sin_wave_par[m];

end

endgenerate

endmodule
