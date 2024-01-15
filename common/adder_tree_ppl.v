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
// Create Date: 2022/11/13 16:05:53
// Design Name:
// Module Name: adder_tree_ppl
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
//   REF: https://blog.csdn.net/jiang1960034308/article/details/118078073
//        https://github.com/raiker/tarsier/tree/master/src/
//
//////////////////////////////////////////////////////////////////////////////////


module adder_tree_ppl
#(
    parameter DATA_I_WIDTH = 8,
    parameter DATA_NUM = 5,
    parameter DELAY_STAGE = $clog2(DATA_NUM), // necessary for pipeline delay stage

    localparam DATA_O_WIDTH = DATA_I_WIDTH + $clog2(DATA_NUM),
    localparam DATA_NUM_A = DATA_NUM / 2,
    localparam DATA_NUM_B = DATA_NUM - DATA_NUM_A,
    localparam DATA_O_WIDTH_A = DATA_I_WIDTH + $clog2(DATA_NUM_A),
    localparam DATA_O_WIDTH_B = DATA_I_WIDTH + $clog2(DATA_NUM_B)
)
(
    // clock & reset
    input clk,
    input rst,

    // input data
    input din_valid,
    input signed [DATA_NUM*DATA_I_WIDTH-1 : 0] din_data,

    // output data
    output dout_valid,
    output signed [DATA_O_WIDTH-1 : 0] dout_data
);

if (DATA_NUM == 1) begin
    if (DELAY_STAGE == 1) begin
        // buffer when an extra delay stage is needed
        reg dout_valid_buf = 'b0;
        reg signed [DATA_O_WIDTH-1 : 0] dout_data_buf = 'b0;

        always@(posedge clk) begin
            dout_valid_buf <= (rst) ? 'b0 : din_valid;
            dout_data_buf <= (rst) ? 'b0 : din_data;
        end

        assign dout_valid = dout_valid_buf;
        assign dout_data = dout_data_buf;
    end
    else begin
        assign dout_valid = din_valid;
        assign dout_data = din_data;
    end
end
else begin
    reg dout_valid_buf = 'b0;
    reg signed [DATA_O_WIDTH-1 : 0] dout_data_buf = 'b0;

    wire din_valid_a;
    wire din_valid_b;
    wire signed [DATA_I_WIDTH * DATA_NUM_A - 1:0] din_data_a;
    wire signed [DATA_I_WIDTH * DATA_NUM_B - 1:0] din_data_b;

    wire dout_valid_a;
    wire dout_valid_b;
    wire signed [DATA_O_WIDTH_A-1:0] dout_data_a;
    wire signed [DATA_O_WIDTH_B-1:0] dout_data_b;

    assign din_valid_a = din_valid;
    assign din_valid_b = din_valid;
    assign din_data_a = din_data[DATA_I_WIDTH * DATA_NUM_A - 1: 0];
    assign din_data_b = din_data[DATA_NUM * DATA_I_WIDTH - 1: DATA_I_WIDTH * DATA_NUM_A];

    //divide set into two chunks, conquer
    adder_tree_ppl #(
        .DATA_I_WIDTH   (DATA_I_WIDTH   ),
        .DATA_NUM       (DATA_NUM_A     ),
        .DELAY_STAGE    (DELAY_STAGE - 1)
    ) subtree_a (
        // clock & reset
        .clk            (clk            ),
        .rst            (rst            ),

        // input data
        .din_valid      (din_valid_a    ),
        .din_data       (din_data_a     ),

        // output data
        .dout_valid     (dout_valid_a   ),
        .dout_data      (dout_data_a    )
    );

    adder_tree_ppl #(
        .DATA_I_WIDTH   (DATA_I_WIDTH   ),
        .DATA_NUM       (DATA_NUM_B     ),
        .DELAY_STAGE    (DELAY_STAGE - 1)
    ) subtree_b (
        // clock & reset
        .clk            (clk            ),
        .rst            (rst            ),

        // input data
        .din_valid      (din_valid_b    ),
        .din_data       (din_data_b     ),

        // output data
        .dout_valid     (dout_valid_b   ),
        .dout_data      (dout_data_b    )
    );

    always@(posedge clk) begin
        if (rst) begin
            dout_valid_buf <= 'b0;
            dout_data_buf <= 'b0;
        end
        else begin
        dout_valid_buf <= dout_valid_a & dout_valid_b;
        dout_data_buf <= dout_data_a + dout_data_b;
        end
    end

    assign dout_valid = dout_valid_buf;
    assign dout_data = dout_data_buf;
end

endmodule


//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//      _           _        ____
//     | | ___  ___| |__    / ___| __ _  ___
//  _  | |/ _ \/ __| '_ \  | |  _ / _` |/ _ \
// | |_| | (_) \__ \ | | | | |_| | (_| | (_) |
//  \___/ \___/|___/_| |_|  \____|\__,_|\___/
//
// Create Date: 2022/11/13 16:40:15
// Last Modified Data: 2022/11/02
// Design Name:
// Module Name: tb_adder_tree_pip
// Project Name:
// Target Devices:
// Tool Versions:
// Description: testbench for [adder_tree_ppl]
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


// module tb_adder_tree_ppl;

// localparam DATA_I_WIDTH = 16;
// localparam DATA_NUM = 9;

// reg clk = 1'b1;
// reg rst = 1'b1;
// reg din_valid = 1'b0;
// reg [DATA_NUM*DATA_I_WIDTH-1 : 0] din_data = 'b0;
// wire dout_valid;
// wire [DATA_I_WIDTH+$clog2(DATA_NUM)-1 : 0] dout_data;

// adder_tree_ppl #(
//     .DATA_I_WIDTH   (DATA_I_WIDTH   ),
//     .DATA_NUM       (DATA_NUM       )
// ) u_adder_tree_ppl
// (
//     // clock & reset
//     .clk        (clk        ),
//     .rst        (rst        ),

//     // input data
//     .din_valid  (din_valid  ),
//     .din_data   (din_data   ),

//     // output data
//     .dout_valid (dout_valid ),
//     .dout_data  (dout_data  )
// );

// initial begin
//     #102
//     rst = 1'b0;
//     #200
//     @(posedge clk) begin
//         din_valid = 1'b1;
//         din_data = {
//             16'd1,
//             16'd2,
//             16'd3,
//             16'd4,
//             16'd5,
//             16'd6,
//             16'd7,
//             16'd8,
//             16'd9
//         };
//     end

//     @(posedge clk) begin
//         din_valid = 1'b1;
//         din_data = {
//             16'd1230,
//             16'd1231,
//             16'd1232,
//             16'd1233,
//             16'd1234,
//             16'd1235,
//             16'd1236,
//             16'd1237,
//             16'd1238
//         };
//     end


//     @(posedge clk) din_valid = 1'b0;
// end

// always #5 clk = ~clk;

// endmodule
