`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/14/2024 08:11:00 PM
// Design Name:
// Module Name: tb_dds_par
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


module tb_dds_par;

localparam PHASE_WIDTH = 16;
localparam WAVE_WIDTH = 16;
localparam PARALLEL_NUM = 7;

// ports
wire clk;
reg clk_fast = 1'b0;
reg rst = 1'b1;
reg rst_fast = 1'b1;

reg [PHASE_WIDTH-1 : 0] phase_inc = 'b0;
wire [WAVE_WIDTH*PARALLEL_NUM-1 : 0] cos_wave, sin_wave;

// module instantiation
dds_par
#(
    .PHASE_WIDTH    (PHASE_WIDTH    ),
    .WAVE_WIDTH     (WAVE_WIDTH     ),
    .PARALLEL_NUM   (PARALLEL_NUM   )
) u_dds_par
(
    // clock & reset
    .clk        (clk        ),
    .rst        (rst        ),

    .phase_inc  (phase_inc  ),

    .cos_wave   (cos_wave   ),
    .sin_wave   (sin_wave   )
);

// stimulus
initial begin
    rst = 1'b1;
    rst_fast = 1'b1;
    #102;
    rst_fast = 1'b0;
    #302;
    rst = 1'b0;
    #1000
    phase_inc = 16'd1029;
end

always #5 clk_fast = ~clk_fast;

if (PARALLEL_NUM > 1) begin
    reg [$clog2(PARALLEL_NUM)-1 : 0] par_cnt = 'b0;

    always @(posedge clk_fast) begin
        if (rst_fast) begin
            par_cnt <= 'b0;
        end
        else begin
            par_cnt <= (par_cnt == PARALLEL_NUM-1) ? 'b0 : par_cnt + 1'b1;
        end
    end

    assign clk = par_cnt[$clog2(PARALLEL_NUM)-1];

    // parallel to serial
    reg [WAVE_WIDTH*PARALLEL_NUM-1 : 0] cos_wave_buf = 'b0;
    reg [WAVE_WIDTH*PARALLEL_NUM-1 : 0] sin_wave_buf = 'b0;
    reg [WAVE_WIDTH-1 : 0] cos_wave_ser = 'b0;
    reg [WAVE_WIDTH-1 : 0] sin_wave_ser = 'b0;

    always @(posedge clk_fast) begin
        if (rst_fast) begin
            cos_wave_buf <= 'b0;
            sin_wave_buf <= 'b0;
            cos_wave_ser <= 'b0;
            sin_wave_ser <= 'b0;
        end
        else begin
            if (par_cnt == PARALLEL_NUM-1) begin
                cos_wave_buf <= cos_wave;
                sin_wave_buf <= sin_wave;
            end
            else begin
                cos_wave_buf <= cos_wave_buf;
                sin_wave_buf <= sin_wave_buf;
            end

            cos_wave_ser <= cos_wave_buf[WAVE_WIDTH*par_cnt +: WAVE_WIDTH];
            sin_wave_ser <= sin_wave_buf[WAVE_WIDTH*par_cnt +: WAVE_WIDTH];
        end
    end
end
else begin
    assign clk = clk_fast;

    wire [WAVE_WIDTH-1 : 0] cos_wave_ser;
    wire [WAVE_WIDTH-1 : 0] sin_wave_ser;

    assign cos_wave_ser = cos_wave;
    assign sin_wave_ser = sin_wave;

end

endmodule
