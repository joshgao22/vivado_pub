`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/15/2022 08:34:01 PM
// Design Name:
// Module Name: system_top
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


module system_top
(
    // *************************************************************************
    // *************************** Clocks and SYSREF ***************************
    // *************************************************************************
    // adc clock
    input       adc1_clk_in_p       ,
    input       adc1_clk_in_n       ,
    input       adc2_clk_in_p       ,
    input       adc2_clk_in_n       ,
    // dac clock
    input       dac0_clk_in_p       ,
    input       dac0_clk_in_n       ,
    input       dac2_clk_in_p       ,
    input       dac2_clk_in_n       ,
    // sysref for rf
    input       rf_sysref_p         ,
    input       rf_sysref_n         ,
    // sysref for pl
    input       pl_sysref_p         ,
    input       pl_sysref_n         ,
    // fpga clock
    input       pl_refclk_p         ,
    input       pl_refclk_n         ,
    // *************************************************************************
    // ******************************** RF-DAC *********************************
    // *************************************************************************
    input       adc0_01_in_p        ,
    input       adc0_01_in_n        ,
    input       adc0_23_in_p        ,
    input       adc0_23_in_n        ,
    input       adc1_01_in_p        ,
    input       adc1_01_in_n        ,
    input       adc1_23_in_p        ,
    input       adc1_23_in_n        ,
    input       adc2_01_in_p        ,
    input       adc2_01_in_n        ,
    input       adc2_23_in_p        ,
    input       adc2_23_in_n        ,
    input       adc3_01_in_p        ,
    input       adc3_01_in_n        ,
    input       adc3_23_in_p        ,
    input       adc3_23_in_n        ,
    // *************************************************************************
    // ******************************** RF-DAC *********************************
    // *************************************************************************
    output      dac00_out_p         ,
    output      dac00_out_n         ,
    output      dac02_out_p         ,
    output      dac02_out_n         ,
    output      dac10_out_p         ,
    output      dac10_out_n         ,
    output      dac12_out_p         ,
    output      dac12_out_n         ,
    output      dac20_out_p         ,
    output      dac20_out_n         ,
    output      dac22_out_p         ,
    output      dac22_out_n         ,
    output      dac30_out_p         ,
    output      dac30_out_n         ,
    output      dac32_out_p         ,
    output      dac32_out_n         ,
    // *************************************************************************
    // ***************************** SPI Interface *****************************
    // *************************************************************************
    // lmk04828
    output      lmk_spi_sck         ,
    output      lmk_spi_cs          ,
    inout       lmk_spi_mosi        ,
    input       lmk_spi_miso        ,
    // lmx2594-adc
    output      lmx_adc_spi_sck     ,
    output      lmx_adc_spi_cs      ,
    inout       lmx_adc_spi_mosi    ,
    input       lmx_adc_spi_miso    ,
    // lmx2594-dac
    output      lmx_dac_spi_sck     ,
    output      lmx_dac_spi_cs      ,
    inout       lmx_dac_spi_mosi    ,
    input       lmx_dac_spi_miso
);


////////////////////////////////////////////////////////////////////////////////
//////////////////////////// Block Design Interface ////////////////////////////
////////////////////////////////////////////////////////////////////////////////
wire ps_clk0;
wire sys_clk;
wire sys_rstn;

// spi interface
wire spi_sclk      ;
wire [2:0] spi_cs  ;
reg spi_sdi        ;
wire spi_sdo       ;
wire spi_sdo_t     ;
wire spi_three_wire;
wire spi_active    ;

assign lmk_spi_sck = spi_sclk;
assign lmk_spi_cs = spi_cs[0];
assign lmk_spi_mosi = spi_sdo_t ? 1'bz : spi_sdo;

assign lmx_adc_spi_sck = spi_sclk;
assign lmx_adc_spi_cs = spi_cs[1];
assign lmx_adc_spi_mosi = spi_sdo_t ? 1'bz : spi_sdo;

assign lmx_dac_spi_sck = spi_sclk;
assign lmx_dac_spi_cs = spi_cs[2];
assign lmx_dac_spi_mosi = spi_sdo_t ? 1'bz : spi_sdo;

always @(*) begin
    case (spi_cs)
        3'b110:  spi_sdi = spi_three_wire ? lmk_spi_mosi : lmk_spi_miso;
        3'b101:  spi_sdi = spi_three_wire ? lmx_adc_spi_mosi : lmx_adc_spi_miso;
        3'b011:  spi_sdi = spi_three_wire ? lmx_dac_spi_mosi : lmx_dac_spi_miso;
        default: spi_sdi = 1'bz;
    endcase
end

// -----------------------------------------------------------------------------
// ADC Tile & Channel Mapping (Dual RF-ADC)
// -----------------------------------------------------------------------------
// m00_axis     adc00       adc tile 224 (adc0), channel 0
// m01_axis     adc01       adc tile 224 (adc0), channel 1
// m02_axis     adc02       adc tile 224 (adc0), channel 2
// m03_axis     adc03       adc tile 224 (adc0), channel 3
// -----------------------------------------------------------------------------
// m10_axis     adc10       adc tile 225 (adc1), channel 0
// m11_axis     adc11       adc tile 225 (adc1), channel 1
// m12_axis     adc12       adc tile 225 (adc1), channel 2
// m13_axis     adc13       adc tile 225 (adc1), channel 3
// -----------------------------------------------------------------------------
// m20_axis     adc20       adc tile 226 (adc2), channel 0
// m21_axis     adc21       adc tile 226 (adc2), channel 1
// m22_axis     adc22       adc tile 226 (adc2), channel 2
// m23_axis     adc23       adc tile 226 (adc2), channel 3
// -----------------------------------------------------------------------------
// m30_axis     adc30       adc tile 227 (adc3), channel 0
// m31_axis     adc31       adc tile 227 (adc3), channel 1
// m32_axis     adc32       adc tile 227 (adc3), channel 2
// m33_axis     adc33       adc tile 227 (adc3), channel 3
// -----------------------------------------------------------------------------
// Note:
// 1) If digital output data is set to real, only channel 0/2 is enabled; if
// digital output data is set to i/q, both channel 0/2 and 1/3 are enabled,
// since i/q data are transferred in different channels.
// 2) When modify the following wire definition, **ONLY** change the data width.
// The extra definition will be optimized automatically.
// -----------------------------------------------------------------------------
wire [15:0] adc00_data, adc01_data;
wire adc00_data_ready, adc01_data_ready;
wire adc00_data_valid, adc01_data_valid;

wire [15:0] adc02_data, adc03_data;
wire adc02_data_ready, adc03_data_ready;
wire adc02_data_valid, adc03_data_valid;

wire [15:0] adc10_data, adc11_data;
wire adc10_data_ready, adc11_data_ready;
wire adc10_data_valid, adc11_data_valid;

wire [15:0] adc12_data, adc13_data;
wire adc12_data_ready, adc13_data_ready;
wire adc12_data_valid, adc13_data_valid;

wire [15:0] adc20_data, adc21_data;
wire adc20_data_ready, adc21_data_ready;
wire adc20_data_valid, adc21_data_valid;

wire [15:0] adc22_data, adc23_data;
wire adc22_data_ready, adc23_data_ready;
wire adc22_data_valid, adc23_data_valid;

wire [15:0] adc30_data, adc31_data;
wire adc30_data_ready, adc31_data_ready;
wire adc30_data_valid, adc31_data_valid;

wire [15:0] adc32_data, adc33_data;
wire adc32_data_ready, adc33_data_ready;
wire adc32_data_valid, adc33_data_valid;

// -----------------------------------------------------------------------------
// DAC Tile & Channel Mapping (Dual RF-DAC)
// -----------------------------------------------------------------------------
// s00_axis     dac00       dac tile 228 (dac0), channel 0
// s01_axis     dac00       dac tile 228 (dac0), channel 1
// s02_axis     dac02       dac tile 228 (dac0), channel 2
// s03_axis     dac02       dac tile 228 (dac0), channel 3
// -----------------------------------------------------------------------------
// s10_axis     dac10       dac tile 229 (dac1), channel 0
// s11_axis     dac10       dac tile 229 (dac1), channel 1
// s12_axis     dac12       dac tile 229 (dac1), channel 2
// s13_axis     dac12       dac tile 229 (dac1), channel 3
// -----------------------------------------------------------------------------
// s20_axis     dac20       dac tile 230 (dac2), channel 0
// s21_axis     dac20       dac tile 230 (dac2), channel 1
// s22_axis     dac22       dac tile 230 (dac2), channel 2
// s23_axis     dac22       dac tile 230 (dac2), channel 3
// -----------------------------------------------------------------------------
// s30_axis     dac30       dac tile 231 (dac3), channel 0
// s31_axis     dac30       dac tile 231 (dac3), channel 1
// s32_axis     dac32       dac tile 231 (dac3), channel 2
// s33_axis     dac32       dac tile 231 (dac3), channel 3
// -----------------------------------------------------------------------------
// Note:
// 1) In most single-band cases, only channel 0/2 is enabled since i/q data are
// transferred in one signle channel; when multi-band is used, multiple digital
// channel may be enabled.
// 2) When modify the following wire definition, **ONLY** change the data width.
// The extra definition will be optimized automatically.
// -----------------------------------------------------------------------------
wire [31:0] dac00_data, dac01_data;
wire dac00_data_ready, dac01_data_ready;
wire dac00_data_valid, dac01_data_valid;

wire [31:0] dac02_data, dac03_data;
wire dac02_data_ready, dac03_data_ready;
wire dac02_data_valid, dac03_data_valid;

wire [31:0] dac10_data, dac11_data;
wire dac10_data_ready, dac11_data_ready;
wire dac10_data_valid, dac11_data_valid;

wire [31:0] dac12_data, dac13_data;
wire dac12_data_ready, dac13_data_ready;
wire dac12_data_valid, dac13_data_valid;

wire [31:0] dac20_data, dac21_data;
wire dac20_data_ready, dac21_data_ready;
wire dac20_data_valid, dac21_data_valid;

wire [31:0] dac22_data, dac23_data;
wire dac22_data_ready, dac23_data_ready;
wire dac22_data_valid, dac23_data_valid;

wire [31:0] dac30_data, dac31_data;
wire dac30_data_ready, dac31_data_ready;
wire dac30_data_valid, dac31_data_valid;

wire [31:0] dac32_data, dac33_data;
wire dac32_data_ready, dac33_data_ready;
wire dac32_data_valid, dac33_data_valid;

system_bd_wrapper u_system_bd_wrapper
(
    // *************************************************************************
    // ********************* PL SYSREF & Reference Clocks **********************
    // *************************************************************************
    .ps_clk0            (ps_clk0            ),

    .pl_clk_clk_p       (pl_refclk_p        ),
    .pl_clk_clk_n       (pl_refclk_n        ),

    .pl_sysref_clk_p    (pl_sysref_p        ),
    .pl_sysref_clk_n    (pl_sysref_n        ),

    .sys_clk            (sys_clk            ),
    .sys_rstn           (sys_rstn           ),

    // *************************************************************************
    // ********************* RF SYSREF & Reference Clocks **********************
    // *************************************************************************
    .spi_sclk           (spi_sclk           ),
    .spi_cs             (spi_cs             ),
    .spi_sdi            (spi_sdi            ),
    .spi_sdo            (spi_sdo            ),
    .spi_sdo_t          (spi_sdo_t          ),
    .spi_three_wire     (spi_three_wire     ),
    .spi_active         (spi_active         ),

    // *************************************************************************
    // ********************* RF SYSREF & Reference Clocks **********************
    // *************************************************************************
    // rf sysref
    .sysref_in_diff_p   (rf_sysref_p        ), // input sysref_in_diff_p
    .sysref_in_diff_n   (rf_sysref_n        ), // input sysref_in_diff_n

    // -------------------------------------------------------------------------
    // RF ADC Reference Clocks Mapping
    // -------------------------------------------------------------------------
    // adc0_clk_clk     adc tile 224 (adc0) ref clock input, nc on borad
    // adc1_clk_clk     adc tile 225 (adc1) ref clock input, from lmk04828
    // adc2_clk_clk     adc tile 226 (adc2) ref clock input, from sma
    // adc3_clk_clk     adc tile 227 (adc3) ref clock input, nc on borad
    // clk_adc0         adc tile 224 (adc0) clock output
    // clk_adc1         adc tile 225 (adc1) clock output
    // clk_adc2         adc tile 226 (adc2) clock output
    // clk_adc3         adc tile 227 (adc3) clock output
    // -------------------------------------------------------------------------
    // Note:
    // When modify the following wire connections, **ONLY** uncomment the needed
    // ports and comment the not-needed ones.
    // -------------------------------------------------------------------------
    // .adc1_clk_clk_p     (adc1_clk_in_p      ), // input adc1_clk_clk_p
    // .adc1_clk_clk_n     (adc1_clk_in_n      ), // input adc1_clk_clk_n
    .adc2_clk_clk_p     (adc2_clk_in_p      ), // input adc2_clk_clk_p
    .adc2_clk_clk_n     (adc2_clk_in_n      ), // input adc2_clk_clk_n
    .clk_adc0           (                   ), // output clk_adc0
    .clk_adc1           (                   ), // output clk_adc1
    .clk_adc2           (                   ), // output clk_adc2
    .clk_adc3           (                   ), // output clk_adc3

    // -------------------------------------------------------------------------
    // RF DAC Reference Clocks Mapping
    // -------------------------------------------------------------------------
    // dac0_clk_clk     dac tile 228 (dac0) ref clock input, from lmk04828
    // dac1_clk_clk     dac tile 229 (dac1) ref clock input, none for zu48dr
    // dac2_clk_clk     dac tile 230 (dac2) ref clock input, from sma
    // dac3_clk_clk     dac tile 231 (dac3) ref clock input, none for zu48dr
    // clk_dac0         dac tile 228 (dac0) clock output
    // clk_dac1         dac tile 229 (dac1) clock output
    // clk_dac2         dac tile 230 (dac2) clock output
    // clk_dac3         dac tile 231 (dac3) clock output
    // -------------------------------------------------------------------------
    // Note:
    // When modify the following wire connections, **ONLY** uncomment the needed
    // ports and comment the not-needed ones.
    // -------------------------------------------------------------------------
    // .dac0_clk_clk_p     (dac0_clk_in_p      ), // input dac0_clk_clk_p
    // .dac0_clk_clk_n     (dac0_clk_in_n      ), // input dac0_clk_clk_n
    .dac2_clk_clk_p     (dac2_clk_in_p      ), // input dac2_clk_clk_p
    .dac2_clk_clk_n     (dac2_clk_in_n      ), // input dac2_clk_clk_n
    .clk_dac0           (                   ), // output clk_dac0
    .clk_dac1           (                   ), // output clk_dac1
    .clk_dac2           (                   ), // output clk_dac2
    .clk_dac3           (                   ), // output clk_dac3

    // *************************************************************************
    // *********** RF-ADC Tile 224 (adc0) Digital & Analog Interface ***********
    // *************************************************************************
    // fabric clock (axi4-stream clock)
    .m0_axis_aclk       (sys_clk            ), // input m0_axis_aclk
    .m0_axis_aresetn    (sys_rstn           ), // input m0_axis_aresetn

    // channel 0 data
    .m00_axis_tdata     (adc00_data         ), // output [15:0]m00_axis_tdata
    .m00_axis_tready    (adc00_data_ready   ), // input m00_axis_tready
    .m00_axis_tvalid    (adc00_data_valid   ), // output m00_axis_tvalid
    // channel 1 data
    .m01_axis_tdata     (adc01_data         ), // output [15:0]m01_axis_tdata
    .m01_axis_tready    (adc01_data_ready   ), // input m01_axis_tready
    .m01_axis_tvalid    (adc01_data_valid   ), // output m01_axis_tvalid
    // analog input signal, J3 on board
    .vin0_01_v_p        (adc0_01_in_p       ), // input vin0_01_v_p
    .vin0_01_v_n        (adc0_01_in_n       ), // input vin0_01_v_n

    // channel 2 data
    .m02_axis_tdata     (adc02_data         ), // output [15:0]m02_axis_tdata
    .m02_axis_tready    (adc02_data_ready   ), // input m02_axis_tready
    .m02_axis_tvalid    (adc02_data_valid   ), // output m02_axis_tvalid
    // channel 3 data
    .m03_axis_tdata     (adc03_data         ), // output [15:0]m03_axis_tdata
    .m03_axis_tready    (adc03_data_ready   ), // input m03_axis_tready
    .m03_axis_tvalid    (adc03_data_valid   ), // output m03_axis_tvalid
    // analog input signal, J5 on board
    .vin0_23_v_p        (adc0_23_in_p       ), // input vin0_23_v_p
    .vin0_23_v_n        (adc0_23_in_n       ), // input vin0_23_v_n

    // *************************************************************************
    // *********** RF-ADC Tile 225 (adc1) Digital & Analog Interface ***********
    // *************************************************************************
    // fabric clock (axi4-stream clock)
    .m1_axis_aclk       (sys_clk            ), // input m1_axis_aclk
    .m1_axis_aresetn    (sys_rstn           ), // input m1_axis_aresetn

    // channel 0 data
    .m10_axis_tdata     (adc10_data         ), // output [15:0]m10_axis_tdata
    .m10_axis_tready    (adc10_data_ready   ), // input m10_axis_tready
    .m10_axis_tvalid    (adc10_data_valid   ), // output m10_axis_tvalid
    // channel 1 data
    .m11_axis_tdata     (adc11_data         ), // output [15:0]m11_axis_tdata
    .m11_axis_tready    (adc11_data_ready   ), // input m11_axis_tready
    .m11_axis_tvalid    (adc11_data_valid   ), // output m11_axis_tvalid
    // analog input signal, J6 on board
    .vin1_01_v_p        (adc1_01_in_p       ), // input vin1_01_v_p
    .vin1_01_v_n        (adc1_01_in_n       ), // input vin1_01_v_n

    // channel 2 data
    .m12_axis_tdata     (adc12_data         ), // output [15:0]m12_axis_tdata
    .m12_axis_tready    (adc12_data_ready   ), // input m12_axis_tready
    .m12_axis_tvalid    (adc12_data_valid   ), // output m12_axis_tvalid
    // channel 3 data
    .m13_axis_tdata     (adc13_data         ), // output [15:0]m13_axis_tdata
    .m13_axis_tready    (adc13_data_ready   ), // input m13_axis_tready
    .m13_axis_tvalid    (adc13_data_valid   ), // output m13_axis_tvalid
    // analog input signal, J7 on board
    .vin1_23_v_p        (adc1_23_in_p       ), // input vin1_23_v_p
    .vin1_23_v_n        (adc1_23_in_n       ), // input vin1_23_v_n

    // *************************************************************************
    // *********** RF-ADC Tile 226 (adc2) Digital & Analog Interface ***********
    // *************************************************************************
    // fabric clock (axi4-stream clock)
    .m2_axis_aclk       (sys_clk            ), // input m2_axis_aclk
    .m2_axis_aresetn    (sys_rstn           ), // input m2_axis_aresetn

    // channel 0 data
    .m20_axis_tdata     (adc20_data         ), // output [15:0]m20_axis_tdata
    .m20_axis_tready    (adc20_data_ready   ), // input m20_axis_tready
    .m20_axis_tvalid    (adc20_data_valid   ), // output m20_axis_tvalid
    // channel 1 data
    .m21_axis_tdata     (adc21_data         ), // output [15:0]m21_axis_tdata
    .m21_axis_tready    (adc21_data_ready   ), // input m21_axis_tready
    .m21_axis_tvalid    (adc21_data_valid   ), // output m21_axis_tvalid
    // analog input signal, J8 on board
    .vin2_01_v_p        (adc2_01_in_p       ), // input vin2_01_v_p
    .vin2_01_v_n        (adc2_01_in_n       ), // input vin2_01_v_n

    // channel 2 data
    .m22_axis_tdata     (adc22_data         ), // output [15:0]m22_axis_tdata
    .m22_axis_tready    (adc22_data_ready   ), // input m22_axis_tready
    .m22_axis_tvalid    (adc22_data_valid   ), // output m22_axis_tvalid
    // channel 3 data
    .m23_axis_tdata     (adc23_data         ), // output [15:0]m23_axis_tdata
    .m23_axis_tready    (adc23_data_ready   ), // input m23_axis_tready
    .m23_axis_tvalid    (adc23_data_valid   ), // output m23_axis_tvalid
    // analog input signal, J9 on board
    .vin2_23_v_p        (adc2_23_in_p       ), // input vin2_23_v_p
    .vin2_23_v_n        (adc2_23_in_n       ), // input vin2_23_v_n

    // *************************************************************************
    // *********** RF-ADC Tile 227 (adc3) Digital & Analog Interface ***********
    // *************************************************************************
    // fabric clock (axi4-stream clock)
    .m3_axis_aclk       (sys_clk            ), // input m3_axis_aclk
    .m3_axis_aresetn    (sys_rstn           ), // input m3_axis_aresetn

    // channel 0 data
    .m30_axis_tdata     (adc30_data         ), // output [15:0]m30_axis_tdata
    .m30_axis_tready    (adc30_data_ready   ), // input m30_axis_tready
    .m30_axis_tvalid    (adc30_data_valid   ), // output m30_axis_tvalid
    // channel 1 data
    .m31_axis_tdata     (adc31_data         ), // output [15:0]m31_axis_tdata
    .m31_axis_tready    (adc31_data_ready   ), // input m31_axis_tready
    .m31_axis_tvalid    (adc31_data_valid   ), // output m31_axis_tvalid
    // analog input signal, J10 on board
    .vin3_01_v_p        (adc3_01_in_p       ), // input vin3_01_v_p
    .vin3_01_v_n        (adc3_01_in_n       ), // input vin3_01_v_n

    // channel 2 data
    .m32_axis_tdata     (adc32_data         ), // output [15:0]m32_axis_tdata
    .m32_axis_tready    (adc32_data_ready   ), // input m32_axis_tready
    .m32_axis_tvalid    (adc32_data_valid   ), // output m32_axis_tvalid
    // channel 3 data
    .m33_axis_tdata     (adc33_data         ), // output [15:0]m33_axis_tdata
    .m33_axis_tready    (adc33_data_ready   ), // input m33_axis_tready
    .m33_axis_tvalid    (adc33_data_valid   ), // output m33_axis_tvalid
    // analog input signal, J12 on board
    .vin3_23_v_p        (adc3_23_in_p       ), // input vin3_23_v_p
    .vin3_23_v_n        (adc3_23_in_n       ), // input vin3_23_v_n

    // *************************************************************************
    // *********** RF-DAC Tile 228 (dac0) Digital & Analog Interface ***********
    // *************************************************************************
    // fabric clock (axi4-stream clock)
    .s0_axis_aclk       (sys_clk            ), // input s0_axis_aclk
    .s0_axis_aresetn    (sys_rstn           ), // input s0_axis_aresetn

    // channel 0 data
    .s00_axis_tdata     (dac00_data         ), // input [31:0]s00_axis_tdata
    .s00_axis_tready    (dac00_data_ready   ), // output s00_axis_tready
    .s00_axis_tvalid    (dac00_data_valid   ), // input s00_axis_tvalid
    // channel 1 data
    // .s01_axis_tdata     (dac01_data         ), // input [31:0]s01_axis_tdata
    // .s01_axis_tready    (dac01_data_ready   ), // output s01_axis_tready
    // .s01_axis_tvalid    (dac01_data_valid   ), // input s01_axis_tvalid
    // analog output signal, J14 on board
    .vout00_v_p         (dac00_out_p        ), // output vout00_v_p
    .vout00_v_n         (dac00_out_n        ), // output vout00_v_n

    // channel 2 data
    .s02_axis_tdata     (dac02_data         ), // input [31:0]s02_axis_tdata
    .s02_axis_tready    (dac02_data_ready   ), // output s02_axis_tready
    .s02_axis_tvalid    (dac02_data_valid   ), // input s02_axis_tvalid
    // channel 3 data
    // .s03_axis_tdata     (dac03_data         ), // input [31:0]s03_axis_tdata
    // .s03_axis_tready    (dac03_data_ready   ), // output s03_axis_tready
    // .s03_axis_tvalid    (dac03_data_valid   ), // input s03_axis_tvalid
    // analog output signal, J16 on board
    .vout02_v_p         (dac02_out_p        ), // output vout02_v_p
    .vout02_v_n         (dac02_out_n        ), // output vout02_v_n

    // *************************************************************************
    // *********** RF-DAC Tile 229 (dac1) Digital & Analog Interface ***********
    // *************************************************************************
    // fabric clock (axi4-stream clock)
    .s1_axis_aclk       (sys_clk            ), // input s1_axis_aclk
    .s1_axis_aresetn    (sys_rstn           ), // input s1_axis_aresetn

    // channel 0 data
    .s10_axis_tdata     (dac10_data         ), // input [31:0]s10_axis_tdata
    .s10_axis_tready    (dac10_data_ready   ), // output s10_axis_tready
    .s10_axis_tvalid    (dac10_data_valid   ), // input s10_axis_tvalid
    // channel 1 data
    // .s11_axis_tdata     (dac11_data         ), // input [31:0]s11_axis_tdata
    // .s11_axis_tready    (dac11_data_ready   ), // output s11_axis_tready
    // .s11_axis_tvalid    (dac11_data_valid   ), // input s11_axis_tvalid
    // analog output signal, J17 on board
    .vout10_v_p         (dac10_out_p        ), // output vout10_v_p
    .vout10_v_n         (dac10_out_n        ), // output vout10_v_n

    // channel 2 data
    .s12_axis_tdata     (dac12_data         ), // input [31:0]s12_axis_tdata
    .s12_axis_tready    (dac12_data_ready   ), // output s12_axis_tready
    .s12_axis_tvalid    (dac12_data_valid   ), // input s12_axis_tvalid
    // channel 3 data
    // .s13_axis_tdata     (dac13_data         ), // input [31:0]s13_axis_tdata
    // .s13_axis_tready    (dac13_data_ready   ), // output s13_axis_tready
    // .s13_axis_tvalid    (dac13_data_valid   ), // input s13_axis_tvalid
    // analog output signal, J18 on board
    .vout12_v_p         (dac12_out_p        ), // output vout12_v_p
    .vout12_v_n         (dac12_out_n        ), // output vout12_v_n

    // *************************************************************************
    // *********** RF-DAC Tile 230 (dac2) Digital & Analog Interface ***********
    // *************************************************************************
    // fabric clock (axi4-stream clock)
    .s2_axis_aclk       (sys_clk            ), // input s2_axis_aclk
    .s2_axis_aresetn    (sys_rstn           ), // input s2_axis_aresetn

    // channel 0 data
    .s20_axis_tdata     (dac20_data         ), // input [31:0]s20_axis_tdata
    .s20_axis_tready    (dac20_data_ready   ), // output s20_axis_tready
    .s20_axis_tvalid    (dac20_data_valid   ), // input s20_axis_tvalid
    // channel 1 data
    // .s21_axis_tdata     (dac21_data         ), // input [31:0]s21_axis_tdata
    // .s21_axis_tready    (dac21_data_ready   ), // output s21_axis_tready
    // .s21_axis_tvalid    (dac21_data_valid   ), // input s21_axis_tvalid
    // analog output signal, J19 on board
    .vout20_v_p         (dac20_out_p        ), // output vout20_v_p
    .vout20_v_n         (dac20_out_n        ), // output vout20_v_n

    // channel 2 data
    .s22_axis_tdata     (dac22_data         ), // input [31:0]s22_axis_tdata
    .s22_axis_tready    (dac22_data_ready   ), // output s22_axis_tready
    .s22_axis_tvalid    (dac22_data_valid   ), // input s22_axis_tvalid
    // channel 3 data
    // .s23_axis_tdata     (dac23_data         ), // input [31:0]s23_axis_tdata
    // .s23_axis_tready    (dac23_data_ready   ), // output s23_axis_tready
    // .s23_axis_tvalid    (dac23_data_valid   ), // input s23_axis_tvalid
    // analog output signal, J20 on board
    .vout22_v_p         (dac22_out_p        ), // output vout22_v_p
    .vout22_v_n         (dac22_out_n        ), // output vout22_v_n

    // *************************************************************************
    // *********** RF-DAC Tile 231 (dac3) Digital & Analog Interface ***********
    // *************************************************************************
    // fabric clock (axi4-stream clock)
    .s3_axis_aclk       (sys_clk            ), // input s3_axis_aclk
    .s3_axis_aresetn    (sys_rstn           ), // input s3_axis_aresetn

    // channel 0 data
    .s30_axis_tdata     (dac30_data         ), // input [31:0]s30_axis_tdata
    .s30_axis_tready    (dac30_data_ready   ), // output s30_axis_tready
    .s30_axis_tvalid    (dac30_data_valid   ), // input s30_axis_tvalid
    // channel 1 data
    // .s31_axis_tdata     (dac31_data         ), // input [31:0]s31_axis_tdata
    // .s31_axis_tready    (dac31_data_ready   ), // output s31_axis_tready
    // .s31_axis_tvalid    (dac31_data_valid   ), // input s31_axis_tvalid
    // analog output signal, J21 on board
    .vout30_v_p         (dac30_out_p        ), // output vout30_v_p
    .vout30_v_n         (dac30_out_n        ), // output vout30_v_n

    // channel 2 data
    .s32_axis_tdata     (dac32_data         ), // input [31:0]s32_axis_tdata
    .s32_axis_tready    (dac32_data_ready   ), // output s32_axis_tready
    .s32_axis_tvalid    (dac32_data_valid   ), // input s32_axis_tvalid
    // channel 3 data
    // .s33_axis_tdata     (dac33_data         ), // input [31:0]s33_axis_tdata
    // .s33_axis_tready    (dac33_data_ready   ), // output s33_axis_tready
    // .s33_axis_tvalid    (dac33_data_valid   ), // input s33_axis_tvalid
    // analog output signal, J23 on board
    .vout32_v_p         (dac32_out_p        ), // output vout32_v_p
    .vout32_v_n         (dac32_out_n        )  // output vout32_v_n
);


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// Tx Signal ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// tx signal mapping
wire    [15:0]  tx_data_i, tx_data_q;

assign dac00_data = {tx_data_q, tx_data_i};
assign dac02_data = {tx_data_q, tx_data_i};
assign dac10_data = {tx_data_q, tx_data_i};
assign dac12_data = {tx_data_q, tx_data_i};
assign dac20_data = {tx_data_q, tx_data_i};
assign dac22_data = {tx_data_q, tx_data_i};
assign dac30_data = {tx_data_q, tx_data_i};
assign dac32_data = {tx_data_q, tx_data_i};

// transimitter logic
wire    [ 1:0]  waveform_sel;
wire            sweep_on    ;
wire    [31:0]  freq_set    ;
wire    [ 1:0]  iq_sel      ;
wire    [ 3:0]  bb_rshift   ;

tx_qpsk #(
    .DATA_WIDTH     (16),
    .BIT_DATA       (1024'b0000000100100010000011001001101000010010101000011110101110101101101100000000110000011011001100001010110101110001101111110001000111100111101101101000000010100001011010101000111110111100100101100000100110010001010001101101110000001111000111011111110010000110001011011101000011010101100111100101101100100000100010010011000000101100010100111011001110001011111101010001011101101011000011001101101010000011101001111010011010100100111000001111100111001101111010001010101101111100001001110100011101011111011010010000100001010010101100011100111111101100001000110100111001001111000011011101100011000111101111101001001010000001101000110010111010010110100010001011001101001010010001100001110110111100000101110010101110011101110111001100111010101110111101100101000100110110001000011100101111100101001100110010101010011111100110001101011110011010110100110001001011100001011110101010101111111101000001010100101111000101011110111010100110111001000111000111111111100000001110000111111011100010011111000110011111010110010110010010010000000001),
    .BIT_DATA_LEN   (1024),
    .CLK_FREQ       (245_760_000)
) u_tx_qpsk
(
    .clk            (sys_clk            ), // input           clk
    .rst            (~sys_rstn          ), // input           rst
    .tx_data_i      (tx_data_i          ), // output  [15:0]  tx_data_i
    .tx_data_q      (tx_data_q          ), // output  [15:0]  tx_data_q
    // debug ports
    .waveform_sel   (waveform_sel[1:0]  ), // input   [ 1:0]  waveform_sel
    .sweep_on       (sweep_on           ), // input           sweep_on
    .freq_set       (freq_set           ), // input   [31:0]  freq_set
    .iq_sel         (iq_sel             ), // input   [ 1:0]  iq_sel
    .bb_rshift      (bb_rshift          )  // input   [ 3:0]  bb_rshift
);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// Rx Signal ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// rx signal mapping
wire    [15:0]  rx_ch1_i, rx_ch1_q;
wire    [15:0]  rx_ch2_i, rx_ch2_q;
wire    [15:0]  rx_ch3_i, rx_ch3_q;
wire    [15:0]  rx_ch4_i, rx_ch4_q;
wire    [15:0]  rx_ch5_i, rx_ch5_q;
wire    [15:0]  rx_ch6_i, rx_ch6_q;
wire    [15:0]  rx_ch7_i, rx_ch7_q;
wire    [15:0]  rx_ch8_i, rx_ch8_q;

assign rx_ch1_i = adc00_data;
assign rx_ch1_q = adc01_data;
assign rx_ch2_i = adc02_data;
assign rx_ch2_q = adc03_data;
assign rx_ch3_i = adc10_data;
assign rx_ch3_q = adc11_data;
assign rx_ch4_i = adc12_data;
assign rx_ch4_q = adc13_data;
assign rx_ch5_i = adc20_data;
assign rx_ch5_q = adc21_data;
assign rx_ch6_i = adc22_data;
assign rx_ch6_q = adc23_data;
assign rx_ch7_i = adc30_data;
assign rx_ch7_q = adc31_data;
assign rx_ch8_i = adc32_data;
assign rx_ch8_q = adc33_data;

// receiver logic


////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// ILAs and VIOs /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
ila_adc u_ila_adc
(
    .clk    (sys_clk            ), // input wire clk
    .probe0 (rx_ch1_i           ), // input wire [15:0]  probe0
    .probe1 (rx_ch1_q           ), // input wire [15:0]  probe1
    .probe2 (rx_ch2_i           ), // input wire [15:0]  probe2
    .probe3 (rx_ch2_q           ), // input wire [15:0]  probe3
    .probe4 (rx_ch3_i           ), // input wire [15:0]  probe4
    .probe5 (rx_ch3_q           ), // input wire [15:0]  probe5
    .probe6 (rx_ch4_i           ), // input wire [15:0]  probe6
    .probe7 (rx_ch4_q           ), // input wire [15:0]  probe7
    .probe8 (rx_ch5_i           ), // input wire [15:0]  probe8
    .probe9 (rx_ch5_q           ), // input wire [15:0]  probe9
    .probe10(rx_ch6_i           ), // input wire [15:0]  probe10
    .probe11(rx_ch6_q           ), // input wire [15:0]  probe11
    .probe12(rx_ch7_i           ), // input wire [15:0]  probe12
    .probe13(rx_ch7_q           ), // input wire [15:0]  probe13
    .probe14(rx_ch8_i           ), // input wire [15:0]  probe14
    .probe15(rx_ch8_q           )  // input wire [15:0]  probe15
);

ila_dac u_ila_dac
(
    .clk    (sys_clk            ), // input wire clk
    .probe0 (tx_data_i          ), // input wire [15:0]  probe0
    .probe1 (tx_data_q          )  // input wire [15:0]  probe1
);

vio_manual_ctrl u_vio_manual_ctrl
(
    .clk        (sys_clk            ), // input wire clk
    .probe_out0 (waveform_sel[1:0]  ), // output wire [1 : 0] probe_out0
    .probe_out1 (sweep_on           ), // output wire [0 : 0] probe_out1
    .probe_out2 (freq_set[31:0]     ), // output wire [31 : 0] probe_out2
    .probe_out3 (iq_sel[1:0]        ), // output wire [1 : 0] probe_out3
    .probe_out4 (bb_rshift[3:0]     )  // output wire [3 : 0] probe_out4
);

endmodule
