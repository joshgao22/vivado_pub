`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//      _           _        ____
//     | | ___  ___| |__    / ___| __ _  ___
//  _  | |/ _ \/ __| '_ \  | |  _ / _` |/ _ \
// | |_| | (_) \__ \ | | | | |_| | (_| | (_) |
//  \___/ \___/|___/_| |_|  \____|\__,_|\___/

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


module tb_tx_qpsk;

reg             clk         = 1'b0  ;
reg             rst         = 1'b1  ;
reg             tx_on       = 1'b1  ;
reg     [31:0]  freq_set            ;
reg     [ 1:0]  waveform_sel = 2'd1 ;
reg     [ 1:0]  iq_sel      = 2'b11 ;
wire    [11:0]  tx_data_i           ;
wire    [11:0]  tx_data_q           ;
reg     [ 3:0]  bb_rshift   = 5'b0  ;

tx_qpsk u_tx_qpsk
(
    .clk            (clk            ),
    .rst            (rst            ),
    .tx_data_i      (tx_data_i      ),
    .tx_data_q      (tx_data_q      ),
    .waveform_sel   (waveform_sel   ),
    .sweep_on       (1'b0           ),
    // .freq_set       (32'd447392426  ),
    .freq_set       (32'd0          ),
    .iq_sel         (iq_sel         ),
    .bb_rshift      (bb_rshift      )
);

initial begin
    #102
    rst = 1'b0;
    // freq_set = 32'd873813333;
    // waveform_sel = 2'b00;
    // bb_rshift = 5'd0;
    // #5000
    // bb_rshift = 5'd1;
    // #5000
    // bb_rshift = 5'd2;
    // #5000
    // bb_rshift = 5'd3;
    // #5000
    // bb_rshift = 5'd4;
    // #5000
    // bb_rshift = 5'd5;
    // #5000
    // bb_rshift = 5'd6;
    // #5000
    // bb_rshift = 5'd7;
    // #5000
    // bb_rshift = 5'd8;
    // #5000
    // bb_rshift = 5'd9;
    // #5000
    // bb_rshift = 5'd14;
    // #5000
    // bb_rshift = 5'd15;
    // #5000
    // bb_rshift = 5'd16;
    // freq_set = 32'd0;
    // func_sel = 3'b010;
    // #7777
    // freq_set = 32'd536870912;
    // func_sel = 3'b100;
    // #7777
    // freq_set = 32'd0;
    // func_sel = 3'b100;
    // #7777
    // freq_set = 32'd536870912;
    // func_sel = 3'b010;
    // #7777
    // freq_set = 32'd0;
    // func_sel = 3'b010;
    // freq_set = 32'd536870912;
    // iq_sel = 2'b00;
    // #7777
    // freq_set = 32'd536870912;
    // iq_sel = 2'b01;
    // #7777
    // freq_set = 32'd536870912;
    // iq_sel = 2'b10;
    // #7777
    // freq_set = 32'd536870912;
    // iq_sel = 2'b11;
end

always #5 clk = ~clk;

// integer i;
// integer w_file;

// initial begin
//     w_file = $fopen("D:\\qpsk_josh.txt","w");
//     for (i = 0; i <= 35000; i = i + 1) begin
//         wait(clk);
//         #10;
//         $fdisplay(w_file,"%d    %d",$signed(tx_data_i),
//                 $signed(tx_data_q));
//         if (i == 35000) begin
//             $fclose(w_file);
//             $stop;
//         end
//     end
// end

endmodule
