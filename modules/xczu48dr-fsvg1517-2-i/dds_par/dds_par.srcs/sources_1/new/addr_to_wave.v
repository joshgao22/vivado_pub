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
// Create Date: 2022/03/23 11:36:49
// Design Name:
// Module Name: addr_to_wave
// Project Name:
// Target Devices:
// Tool Versions:
// Description: This module generates look-up-table-based sine/cosine wave,
//   with 1/4 cycles of cosine wave.
// Parameter:
//   PHASE_WIDTH: Bit width of input phase address.
//   WAVE_WIDTH: Bit width of output sine/cosine wave.
// Total latency: 4 clock cycles, including 1 clock cycle for rom read
//
// Dependencies:
//
// Revision:
//   Revision 0.01 - File Created
//   2024/01/14 - Josh:
//     1. 修改 ROM 的宽度和深度为 16 bit，后续修改 IP 时需要同时修改本文件的 localparam。
//     2. 输入输出改为可调位宽，但是模块内部仍按照 IP 核的位宽进行运算。
// Additional Comments: The code below generates sine and cosine wave by
//   circularly reading 1/4 cycle of cosine data from the LUT based on the phase
//   address.
//
//   --                                  --
//     ---                            ---                  --
//        --                        --                       ---
//          -                      -                            --
//           -                    -                               -
//            -                  -          ---->                  -
//             -                -
//              -              -                  addr(cos): -->, <--, -->, <--
//               --          --                   data(cos):  + ,  - ,  - ,  +
//                 ---    ---                     addr(sin): <--, -->, <--, -->
//                    ----                        data(sin):  + ,  + ,  - ,  -
//
//           one cycle of cosine wave               1/4 cycle of cosine wave
//
//////////////////////////////////////////////////////////////////////////////////

module addr_to_wave
#(
  parameter PHASE_WIDTH = 16,
  parameter WAVE_WIDTH = 16
)
(
  // clock & reset
  input clk                         ,
  input rst                         ,

  input [PHASE_WIDTH-1 : 0] phase   ,

  output [WAVE_WIDTH-1 : 0] cos_wave,
  output [WAVE_WIDTH-1 : 0] sin_wave
);

integer i;

localparam ADDR_WIDTH = 16;
localparam DATA_WIDTH = 16;
localparam ROM_ADDR_WIDTH = ADDR_WIDTH - 2; // 1/4 cycle is stored
localparam ROM_DATA_WIDTH = DATA_WIDTH - 1; // only positive data
localparam ROM_MAX_INDEX = 2**ROM_ADDR_WIDTH-1;
localparam DELAY = 3;

// mapping phase address to local format
wire [ADDR_WIDTH-1 : 0] phase_addr;

if (PHASE_WIDTH >= ADDR_WIDTH) begin
  assign phase_addr = phase[PHASE_WIDTH-1 -: ADDR_WIDTH];
end
else begin
  assign phase_addr = {phase,{(ADDR_WIDTH-PHASE_WIDTH){1'b0}}};
end


// d1: buffer/stabilize input address
// d2: phase segment decision
// d3: wait for lut output data - [cos_lut_dout] & [sin_lut_dout]
reg [ADDR_WIDTH-1 : 0] phase_addr_d [1 : DELAY];

always @(posedge clk) begin
  if (rst) begin
    for (i = 1; i <= DELAY ; i = i + 1) begin
      phase_addr_d[i] <= 'b0;
    end
  end
  else begin
    phase_addr_d[1] <= phase_addr;

    for (i = 2; i <= DELAY ; i = i + 1) begin
      phase_addr_d[i] <= phase_addr_d[i-1];
    end
  end
end


// Generate cosine and sine address based on current phase segment
reg [ROM_ADDR_WIDTH-1 : 0] cos_addr = 'b0;
reg [ROM_ADDR_WIDTH-1 : 0] sin_addr = 'b0;

always @(posedge clk) begin
  if (rst) begin
    cos_addr <= 'b0;
    sin_addr <= 'b0;
  end
  else begin
    case (phase_addr_d[1][ADDR_WIDTH-1 -: 2])
      2'b00, 2'b10: begin
        cos_addr <= phase_addr_d[1];
        sin_addr <= ROM_MAX_INDEX - phase_addr_d[1];
      end
      2'b01, 2'b11: begin
        cos_addr <= ROM_MAX_INDEX - phase_addr_d[1];
        sin_addr <= phase_addr_d[1];
      end
      default: begin
        cos_addr <= 'b0;
        sin_addr <= 'b0;
      end
    endcase
  end
end

// Read 1/4 cycle of cosine data from BRAM. The Primitives Output Register and
// the the Core Output Register are enabled, to provide better delay and latency
// performance, so the output latency of both ports have reached 3 clock cycles.
wire [ROM_DATA_WIDTH-1 : 0] cos_lut_dout;
wire [ROM_DATA_WIDTH-1 : 0] sin_lut_dout;

cos_16384_16b u_cos_16384_16b
(
  .clka   (clk          ), // input wire clka
  .addra  (cos_addr     ), // input wire [13 : 0] addra
  .douta  (cos_lut_dout ), // output wire [14 : 0] douta
  .clkb   (clk          ), // input wire clkb
  .addrb  (sin_addr     ), // input wire [13 : 0] addrb
  .doutb  (sin_lut_dout )  // output wire [14 : 0] doutb
);

// Correct the sign of output data (above or below zero).
reg signed [DATA_WIDTH-1 : 0] cos_dout;
reg signed [DATA_WIDTH-1 : 0] sin_dout;

always @(posedge clk) begin
  if (rst) begin
    cos_dout <= 'b0;
    sin_dout <= 'b0;
  end
  else begin
    case (phase_addr_d[DELAY][ADDR_WIDTH-1 -: 2])
      2'b00: begin
        cos_dout <= cos_lut_dout;
        sin_dout <= sin_lut_dout;
      end
      2'b01: begin
        cos_dout <= -cos_lut_dout;
        sin_dout <= sin_lut_dout;
      end
      2'b10: begin
        cos_dout <= -cos_lut_dout;
        sin_dout <= -sin_lut_dout;
      end
      2'b11: begin
        cos_dout <= cos_lut_dout;
        sin_dout <= -sin_lut_dout;
      end
      default: begin
        cos_dout <= 'b0;
        sin_dout <= 'b0;
      end
    endcase
  end
end

// Output data to port
/* FIXME: The truncation should be done by rounding operation, to avoid extra
 * DC component.
 */
if (WAVE_WIDTH <= DATA_WIDTH) begin
  assign cos_wave = cos_dout[DATA_WIDTH-1 -: WAVE_WIDTH];
  assign sin_wave = sin_dout[DATA_WIDTH-1 -: WAVE_WIDTH];
end
else begin
  assign cos_wave = {cos_dout,{(WAVE_WIDTH-DATA_WIDTH){1'b0}}};
  assign sin_wave = {sin_dout,{(WAVE_WIDTH-DATA_WIDTH){1'b0}}};
end

endmodule
