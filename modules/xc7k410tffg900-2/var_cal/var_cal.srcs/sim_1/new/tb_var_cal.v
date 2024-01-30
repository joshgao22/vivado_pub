`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 06/11/2023 03:49:38 PM
// Design Name:
// Module Name: tb_var_cal
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


module tb_var_cal;

localparam DATA_I_WIDTH = 30;

reg clk = 1'b1;
reg clk_init = 1'b1;
reg rst = 1'b1;

reg cal_start = 1'b0;
reg cal_auto_en = 1'b0;
wire cal_busy;

reg din_valid = 1'b0;
reg [29:0] din_file_real = 'b0;
reg [29:0] din_file_imag = 'b0;
wire [DATA_I_WIDTH-1:0] din_real;
wire [DATA_I_WIDTH-1:0] din_imag;

assign din_real = din_file_real[29 -: DATA_I_WIDTH];
assign din_imag = din_file_imag[29 -: DATA_I_WIDTH];

wire var_valid;
wire [31:0] var;

var_cal #(
    .ACCUM_NUM      (16384          ),
    .DATA_I_WIDTH   (DATA_I_WIDTH   ),
    .DATA_O_WIDTH   (32             )
) u_var_cal
(
    .clk        (clk        ),
    .rst        (rst        ),

    .cal_start  (cal_start  ),
    .cal_auto_en(cal_auto_en),
    .cal_busy   (cal_busy   ),

    .din_valid  (din_valid  ),
    .din_real   (din_real   ),
    .din_imag   (din_imag   ),

    .var_valid  (var_valid  ),
    .var        (var        )
);

integer i;
integer r_file;

initial begin
    #102
    rst = 1'b0;
    #100
    din_valid = 1'b1;
    // cal_start = 1'b1;
    cal_auto_en = 1'b1;

    r_file = $fopen("./../../../../../testbenches/singletone.csv","r");
    for (i = 0; i <= 32768; i = i + 1) begin
        @(posedge clk)
        $fscanf(r_file,"%d,%d",din_file_real,din_file_imag);
    end
    $fclose(r_file);
    $stop;
end

always #10 clk_init = ~clk_init;

always @(posedge clk_init) begin
    clk <= ~clk;
end

endmodule
