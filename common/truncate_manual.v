`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/21/2023 11:37:14 AM
// Design Name:
// Module Name: truncate_manual
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


module truncate_manual
#(
    DATA_I_WIDTH = 30,
    DATA_O_WIDTH = 12
)
(
    input clk,
    input rst,

    input [DATA_I_WIDTH-1 : 0] data_in,
    input data_in_valid,

    input [$clog2(DATA_I_WIDTH)-1 : 0] trunc_pos,

    output [DATA_O_WIDTH-1 : 0] data_out,
    output data_out_valid
);

assign data_out = data_in[trunc_pos -: DATA_O_WIDTH];

endmodule
