`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/03/01 10:44:50
// Design Name:
// Module Name: trunc_32bit_to_12bit
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


module trunc_32bit_to_12bit(
    input clk,
    input rst,
    input [31:0] trunc_32bit_in,
    input [4:0] vio_trunc,

    output reg [11:0] trunc_12bit_out = 12'd0,
    output reg trunc_overflow = 1'd0
    );

    always @ (posedge clk) begin
        if(rst) begin
            trunc_12bit_out[11:0] <= 12'd0;
            trunc_overflow <= 1'd0;
        end else begin
            case(vio_trunc[4:0])
                5'd0:begin
                    if(trunc_32bit_in[31:31] == 1'd1 || trunc_32bit_in[31:31] == 1'd0) begin
                        if(trunc_32bit_in[31:31] == 1'd0 &&trunc_32bit_in[19] == 1'd1 && trunc_32bit_in[31:20] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[31:20] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:31] == 1'd1 && trunc_32bit_in[19:0] > 20'd524288) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[31:20] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[31:20];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd1:begin
                    if(trunc_32bit_in[31:30] == 2'd3 || trunc_32bit_in[31:30] == 2'd0) begin
                        if(trunc_32bit_in[31:30] == 2'd0 &&trunc_32bit_in[18] == 1'd1 && trunc_32bit_in[30:19] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[30:19] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:30] == 2'd3 && trunc_32bit_in[18:0] > 19'd262144) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[30:19] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[30:19];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd2:begin
                    if(trunc_32bit_in[31:29] == 3'd7 || trunc_32bit_in[31:29] == 3'd0) begin
                        if(trunc_32bit_in[31:29] == 3'd0 &&trunc_32bit_in[17] == 1'd1 && trunc_32bit_in[29:18] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[29:18] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:29] == 3'd7 && trunc_32bit_in[17:0] > 18'd131072) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[29:18] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[29:18];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd3:begin
                    if(trunc_32bit_in[31:28] == 4'd15 || trunc_32bit_in[31:28] == 4'd0) begin
                        if(trunc_32bit_in[31:28] == 4'd0 &&trunc_32bit_in[16] == 1'd1 && trunc_32bit_in[28:17] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[28:17] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:28] == 4'd15 && trunc_32bit_in[16:0] > 17'd65536) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[28:17] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[28:17];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd4:begin
                    if(trunc_32bit_in[31:27] == 5'd31 || trunc_32bit_in[31:27] == 5'd0) begin
                        if(trunc_32bit_in[31:27] == 5'd0 &&trunc_32bit_in[15] == 1'd1 && trunc_32bit_in[27:16] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[27:16] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:27] == 5'd31 && trunc_32bit_in[15:0] > 16'd32768) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[27:16] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[27:16];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd5:begin
                    if(trunc_32bit_in[31:26] == 6'd63 || trunc_32bit_in[31:26] == 6'd0) begin
                        if(trunc_32bit_in[31:26] == 6'd0 &&trunc_32bit_in[14] == 1'd1 && trunc_32bit_in[26:15] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[26:15] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:26] == 6'd63 && trunc_32bit_in[14:0] > 15'd16384) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[26:15] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[26:15];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd6:begin
                    if(trunc_32bit_in[31:25] == 7'd127 || trunc_32bit_in[31:25] == 7'd0) begin
                        if(trunc_32bit_in[31:25] == 7'd0 &&trunc_32bit_in[13] == 1'd1 && trunc_32bit_in[25:14] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[25:14] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:25] == 7'd127 && trunc_32bit_in[13:0] > 14'd8192) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[25:14] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[25:14];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd7:begin
                    if(trunc_32bit_in[31:24] == 8'd255 || trunc_32bit_in[31:24] == 8'd0) begin
                        if(trunc_32bit_in[31:24] == 8'd0 &&trunc_32bit_in[12] == 1'd1 && trunc_32bit_in[24:13] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[24:13] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:24] == 8'd255 && trunc_32bit_in[12:0] > 13'd4096) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[24:13] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[24:13];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd8:begin
                    if(trunc_32bit_in[31:23] == 9'd511 || trunc_32bit_in[31:23] == 9'd0) begin
                        if(trunc_32bit_in[31:23] == 9'd0 &&trunc_32bit_in[11] == 1'd1 && trunc_32bit_in[23:12] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[23:12] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:23] == 9'd511 && trunc_32bit_in[11:0] > 12'd2048) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[23:12] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[23:12];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd9:begin
                    if(trunc_32bit_in[31:22] == 10'd1023 || trunc_32bit_in[31:22] == 10'd0) begin
                        if(trunc_32bit_in[31:22] == 10'd0 &&trunc_32bit_in[10] == 1'd1 && trunc_32bit_in[22:11] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[22:11] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:22] == 10'd1023 && trunc_32bit_in[10:0] > 11'd1024) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[22:11] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[22:11];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd10:begin
                    if(trunc_32bit_in[31:21] == 11'd2047 || trunc_32bit_in[31:21] == 11'd0) begin
                        if(trunc_32bit_in[31:21] == 11'd0 &&trunc_32bit_in[9] == 1'd1 && trunc_32bit_in[21:10] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[21:10] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:21] == 11'd2047 && trunc_32bit_in[9:0] > 10'd512) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[21:10] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[21:10];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd11:begin
                    if(trunc_32bit_in[31:20] == 12'd4095 || trunc_32bit_in[31:20] == 12'd0) begin
                        if(trunc_32bit_in[31:20] == 12'd0 &&trunc_32bit_in[8] == 1'd1 && trunc_32bit_in[20:9] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[20:9] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:20] == 12'd4095 && trunc_32bit_in[8:0] > 9'd256) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[20:9] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[20:9];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd12:begin
                    if(trunc_32bit_in[31:19] == 13'd8191 || trunc_32bit_in[31:19] == 13'd0) begin
                        if(trunc_32bit_in[31:19] == 13'd0 &&trunc_32bit_in[7] == 1'd1 && trunc_32bit_in[19:8] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[19:8] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:19] == 13'd8191 && trunc_32bit_in[7:0] > 8'd128) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[19:8] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[19:8];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd13:begin
                    if(trunc_32bit_in[31:18] == 14'd16383 || trunc_32bit_in[31:18] == 14'd0) begin
                        if(trunc_32bit_in[31:18] == 14'd0 &&trunc_32bit_in[6] == 1'd1 && trunc_32bit_in[18:7] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[18:7] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:18] == 14'd16383 && trunc_32bit_in[6:0] > 7'd64) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[18:7] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[18:7];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd14:begin
                    if(trunc_32bit_in[31:17] == 15'd32767 || trunc_32bit_in[31:17] == 15'd0) begin
                        if(trunc_32bit_in[31:17] == 15'd0 &&trunc_32bit_in[5] == 1'd1 && trunc_32bit_in[17:6] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[17:6] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:17] == 15'd32767 && trunc_32bit_in[5:0] > 6'd32) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[17:6] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[17:6];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd15:begin
                    if(trunc_32bit_in[31:16] == 16'd65535 || trunc_32bit_in[31:16] == 16'd0) begin
                        if(trunc_32bit_in[31:16] == 16'd0 &&trunc_32bit_in[4] == 1'd1 && trunc_32bit_in[16:5] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[16:5] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:16] == 16'd65535 && trunc_32bit_in[4:0] > 5'd16) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[16:5] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[16:5];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd16:begin
                    if(trunc_32bit_in[31:15] == 17'd131071 || trunc_32bit_in[31:15] == 17'd0) begin
                        if(trunc_32bit_in[31:15] == 17'd0 &&trunc_32bit_in[3] == 1'd1 && trunc_32bit_in[15:4] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[15:4] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:15] == 17'd131071 && trunc_32bit_in[3:0] > 4'd8) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[15:4] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[15:4];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd17:begin
                    if(trunc_32bit_in[31:14] == 18'd262143 || trunc_32bit_in[31:14] == 18'd0) begin
                        if(trunc_32bit_in[31:14] == 18'd0 &&trunc_32bit_in[2] == 1'd1 && trunc_32bit_in[14:3] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[14:3] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:14] == 18'd262143 && trunc_32bit_in[2:0] > 3'd4) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[14:3] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[14:3];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd18:begin
                    if(trunc_32bit_in[31:13] == 19'd524287 || trunc_32bit_in[31:13] == 19'd0) begin
                        if(trunc_32bit_in[31:13] == 19'd0 &&trunc_32bit_in[1] == 1'd1 && trunc_32bit_in[13:2] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[13:2] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:13] == 19'd524287 && trunc_32bit_in[1:0] > 2'd2) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[13:2] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[13:2];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                5'd19:begin
                    if(trunc_32bit_in[31:12] == 20'd1048575 || trunc_32bit_in[31:12] == 20'd0) begin
                        if(trunc_32bit_in[31:12] == 20'd0 &&trunc_32bit_in[0] == 1'd1 && trunc_32bit_in[12:1] != 12'd2047) begin
                            trunc_12bit_out[11:0] <= trunc_32bit_in[12:1] + 12'd1;
                        end
                        else begin
                            if(trunc_32bit_in[31:12] == 20'd1048575 && trunc_32bit_in[0:0] > 1'd1) begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[12:1] + 12'd1;
                            end
                            else begin
                                trunc_12bit_out[11:0] <= trunc_32bit_in[12:1];
                            end
                        end
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
                default:begin
                    if(trunc_32bit_in[31:11] == 21'd2097151 || trunc_32bit_in[31:11] == 21'd0) begin
                        trunc_12bit_out[11:0] <= trunc_32bit_in[11:0];
                        trunc_overflow <= 1'd0;
                    end else begin
                        if(trunc_32bit_in[31] == 1'd1) begin
                            trunc_12bit_out[11:0] <= -12'd2048;
                        end else begin
                            trunc_12bit_out[11:0] <= 12'd2047;
                        end
                        trunc_overflow <= 1'd1;
                    end
                end
            endcase
        end
    end
endmodule