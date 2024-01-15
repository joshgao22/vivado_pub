`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/14/2024 03:49:29 PM
// Design Name:
// Module Name: tb_addr_to_wave
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


module tb_addr_to_wave;

localparam PHASE_WIDTH = 12;
localparam WAVE_WIDTH = 12;

// ports
reg clk = 1'b0;
reg rst = 1'b1;

reg [PHASE_WIDTH-1 : 0] phase = 'b0;
wire [WAVE_WIDTH-1 : 0] cos_wave, sin_wave;

// module instantiation
addr_to_wave
#(
  .PHASE_WIDTH  (PHASE_WIDTH),
  .WAVE_WIDTH   (WAVE_WIDTH )
) u_addr_to_wave
(
  // clock & reset
  .clk      (clk      ),
  .rst      (rst      ),

  .phase    (phase    ),

  .cos_wave (cos_wave ),
  .sin_wave (sin_wave )
);

// stimulus
always @(posedge clk) begin
    if (rst) begin
        phase = 'b0;
    end
    else begin
        phase <= phase + 1'b1;
    end
end

initial begin
    rst = 1'b1;
    #102;
    rst = 1'b0;
end

always #5 clk = ~clk;

endmodule
