`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/23/2024 04:37:39 PM
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
    // *************************** CX9261A Interface ***************************
    // *************************************************************************
    input           cx9261a_osc_out     ,
    output          cx9261a_nrst        ,

    output          cx9261a_spi_sclk    ,
    output          cx9261a_spi_csb     ,
    input           cx9261a_spi_miso    ,
    output          cx9261a_spi_mosi    ,

    output          cx9261a_txnrx_trx1  ,
    output          cx9261a_txnrx_trx2  ,
    output          cx9261a_txnrx_rxfb  ,
    output          cx9261a_enable_trx1 ,
    output          cx9261a_enable_trx2 ,
    output          cx9261a_enable_rxfb ,

    output          cx9261a_tx1_fclk    ,
    output          cx9261a_tx2_fclk    ,
    input           cx9261a_rx1_mclk    ,
    input           cx9261a_rx2_mclk    ,
    input           cx9261a_rxfb_mclk   ,

    output          cx9261a_tx1_frame   ,
    output          cx9261a_tx2_frame   ,
    input           cx9261a_rx1_frame   ,
    input           cx9261a_rx2_frame   ,
    input           cx9261a_rxfb_frame  ,

    inout   [ 7:0]  cx9261a_rxfb_rx_data,
    inout   [ 7:0]  cx9261a_rxfb_tx_data,
    inout   [ 7:0]  cx9261a_rx1_fdd_data,
    inout   [ 7:0]  cx9261a_rx2_fdd_data,
    inout   [ 7:0]  cx9261a_tx1_fdd_data,
    inout   [ 7:0]  cx9261a_tx2_fdd_data,
    // *************************************************************************
    // ******************* DDR and Fixed-io (Do NOT Modify) ********************
    // *************************************************************************
    // ddr
    inout   [14:0]  ddr_addr            ,
    inout   [ 2:0]  ddr_ba              ,
    inout           ddr_cas_n           ,
    inout           ddr_ck_n            ,
    inout           ddr_ck_p            ,
    inout           ddr_cke             ,
    inout           ddr_cs_n            ,
    inout   [ 3:0]  ddr_dm              ,
    inout   [31:0]  ddr_dq              ,
    inout   [ 3:0]  ddr_dqs_n           ,
    inout   [ 3:0]  ddr_dqs_p           ,
    inout           ddr_odt             ,
    inout           ddr_ras_n           ,
    inout           ddr_reset_n         ,
    inout           ddr_we_n            ,
    // fixed-io
    inout           fixed_io_ddr_vrn    ,
    inout           fixed_io_ddr_vrp    ,
    inout   [53:0]  fixed_io_mio        ,
    inout           fixed_io_ps_clk     ,
    inout           fixed_io_ps_porb    ,
    inout           fixed_io_ps_srstb
);

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// Block Design Interface ////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// gpio
wire [31:0] gpio_i;
wire [31:0] gpio_o;
wire [31:0] gpio_t;

// cx9261a
wire cx9261a_pl_rst;
wire cx9261a_tr_sel;
wire cx9261a_tdd_fdd_sel;
wire cx9261a_r1t1_r2t2_sel;
wire cx9261a_sp_dp_sel;
wire cx9261a_mclk_delay_ctrl0;
wire cx9261a_mclk_delay_ctrl1;
wire cx9261a_mclk_delay_ctrl2;
wire hop_en;
reg gpio_hop_flag = 'b0;

assign cx9261a_nrst             = gpio_o[ 0]; // cx9261a active-low reset
assign cx9261a_txnrx_trx1       = gpio_o[ 1]; // \------ Pin Control Map --------
assign cx9261a_txnrx_trx2       = gpio_o[ 2]; // \ ENABLE/TXNRX  Status
assign cx9261a_txnrx_rxfb       = gpio_o[ 3]; // \      00       ALERT Mode
assign cx9261a_enable_trx1      = gpio_o[ 4]; // \      10       TDD Rx Mode
assign cx9261a_enable_trx2      = gpio_o[ 5]; // \      11       TDD Tx Mode
assign cx9261a_enable_rxfb      = gpio_o[ 6]; // \      10       FDD Mode
assign cx9261a_pl_rst           = gpio_o[ 7]; // cx9261a pl logic active-high reset
assign cx9261a_tr_sel           = gpio_o[ 8]; // 0: rx, 1: tx
assign cx9261a_tdd_fdd_sel      = gpio_o[ 9]; // 0: fdd, 1: tdd
assign cx9261a_r1t1_r2t2_sel    = gpio_o[10]; // 0: 1t1r, 1: 2t2r
assign cx9261a_sp_dp_sel        = gpio_o[11]; // 0: dial port, 1: single port
assign cx9261a_mclk_delay_ctrl0 = gpio_o[12];
assign cx9261a_mclk_delay_ctrl1 = gpio_o[13];
assign cx9261a_mclk_delay_ctrl2 = gpio_o[14];
assign hop_en                   = gpio_o[15];

assign gpio_i[16] = gpio_hop_flag;

assign gpio_i[31:17] = gpio_o[31:17];

// spi interface
wire            spi_sclk      ;
wire            spi_cs        ;
wire            spi_sdi       ;
wire            spi_sdo       ;
wire            spi_sdo_t     ;
wire            spi_three_wire;
wire            spi_active    ;

// cx9261 - three-wire spi or four-wire spi
assign cx9261a_spi_sclk = spi_sclk;
assign cx9261a_spi_csb = spi_cs;
assign cx9261a_spi_mosi = spi_sdo_t ? 1'bz : spi_sdo;
assign spi_sdi = spi_three_wire ? cx9261a_spi_mosi : cx9261a_spi_miso;

// ps clock
wire            ps_clk_200M;

system_bd_wrapper system_bd
(
    // ddr
    .ddr_addr           (ddr_addr                   ), // inout [14:0]ddr_addr
    .ddr_ba             (ddr_ba                     ), // inout [2:0]ddr_ba
    .ddr_cas_n          (ddr_cas_n                  ), // inout ddr_cas_n
    .ddr_ck_n           (ddr_ck_n                   ), // inout ddr_ck_n
    .ddr_ck_p           (ddr_ck_p                   ), // inout ddr_ck_p
    .ddr_cke            (ddr_cke                    ), // inout ddr_cke
    .ddr_cs_n           (ddr_cs_n                   ), // inout ddr_cs_n
    .ddr_dm             (ddr_dm                     ), // inout [3:0]ddr_dm
    .ddr_dq             (ddr_dq                     ), // inout [31:0]ddr_dq
    .ddr_dqs_n          (ddr_dqs_n                  ), // inout [3:0]ddr_dqs_n
    .ddr_dqs_p          (ddr_dqs_p                  ), // inout [3:0]ddr_dqs_p
    .ddr_odt            (ddr_odt                    ), // inout ddr_odt
    .ddr_ras_n          (ddr_ras_n                  ), // inout ddr_ras_n
    .ddr_reset_n        (ddr_reset_n                ), // inout ddr_reset_n
    .ddr_we_n           (ddr_we_n                   ), // inout ddr_we_n

    // fixed-io
    .fixed_io_ddr_vrn   (fixed_io_ddr_vrn           ), // inout fixed_io_ddr_vrn
    .fixed_io_ddr_vrp   (fixed_io_ddr_vrp           ), // inout fixed_io_ddr_vrp
    .fixed_io_mio       (fixed_io_mio               ), // inout [53:0]fixed_io_mio
    .fixed_io_ps_clk    (fixed_io_ps_clk            ), // inout fixed_io_ps_clk
    .fixed_io_ps_porb   (fixed_io_ps_porb           ), // inout fixed_io_ps_porb
    .fixed_io_ps_srstb  (fixed_io_ps_srstb          ), // inout fixed_io_ps_srstb

    // gpio, for control signals
    .gpio_i             (gpio_i                     ), // input [31:0]gpio_i
    .gpio_o             (gpio_o                     ), // output [31:0]gpio_o
    .gpio_t             (gpio_t                     ), // output [31:0]gpio_t

    // spi interface
    .spi_sclk           (spi_sclk                   ), // output spi_sclk
    .spi_cs             (spi_cs                     ), // output [0:0]spi_cs
    .spi_sdi            (spi_sdi                    ), // input [0:0]spi_sdi
    .spi_sdo            (spi_sdo                    ), // output spi_sdo
    .spi_sdo_t          (spi_sdo_t                  ), // output spi_sdo_t
    .spi_three_wire     (spi_three_wire             ), // output spi_three_wire
    .spi_active         (spi_active                 ), // output spi_active

    // ps clock
    .ps_clk_200M        (ps_clk_200M                )  // output ps_clk_200M
);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////// CX9261A Interface ///////////////////////////////
////////////////////////////////////////////////////////////////////////////////
wire data_clk;
wire data_valid;
wire data_clk2;
wire data_valid2;
wire data_clk3;
wire data_valid3;
wire [15:0] rx1_data_i;
wire [15:0] rx1_data_q;
wire [15:0] rx2_data_i;
wire [15:0] rx2_data_q;
wire [15:0] rx3_data_i;
wire [15:0] rx3_data_q;
wire [15:0] tx1_data_i;
wire [15:0] tx1_data_q;
wire [15:0] tx2_data_i;
wire [15:0] tx2_data_q;
wire tx_data_ready;
wire tx_data_ready2;

wire cx9261a_mclk1;
wire cx9261a_mclk2;
wire cx9261a_mclk3;

mclk_delay u_mclk_delay
(
    .RX1_MCLK_IN_N      (cx9261a_rx1_mclk           ), // input  wire    RX2_MCLK_IN_P
    .RX2_MCLK_IN_P      (cx9261a_rx2_mclk           ), // input  wire    RX1_MCLK_IN_N
    .RX3_MCLK_IN        (cx9261a_rxfb_mclk          ), // input  wire    RX3_MCLK_IN
    .rst                (cx9261a_pl_rst             ), // input  wire    rst
    .MCLK1              (cx9261a_mclk1              ), // output wire    MCLK1
    .MCLK2              (cx9261a_mclk2              ), // output wire    MCLK2
    .MCLK3              (cx9261a_mclk3              ), // output wire    MCLK3
    .MCLK_DELAY_CTRL0   (cx9261a_mclk_delay_ctrl0   ), // input  wire    MCLK_DELAY_CTRL0
    .MCLK_DELAY_CTRL1   (cx9261a_mclk_delay_ctrl1   ), // input  wire    MCLK_DELAY_CTRL1
    .MCLK_DELAY_CTRL2   (cx9261a_mclk_delay_ctrl2   ), // input  wire    MCLK_DELAY_CTRL2
    .CX3E04_CLK_P       (1'b0                       ), // input  wire    CX3E04_CLK_P
    .CX3E04_CLK_N       (1'b0                       ), // input  wire    CX3E04_CLK_N
    .CX3E04_SYNC_P      (1'b0                       ), // input  wire    CX3E04_SYNC_P
    .CX3E04_SYNC_N      (1'b0                       ), // input  wire    CX3E04_SYNC_N
    .ui_clk             (ps_clk_200M                ), // inout  wire    FREF_DIV_MODE
    .sma_clk            (1'b0                       ), // input  wire    ui_clk
    .FREF_DIV_MODE      (1'b0                       ), // input  wire    sma_clk
    .OSC_OUT            (1'b0                       )  // input  wire    OSC_OUT
);

cx9261a_if cx9261a_if_cmos
(
    //复位和驱动接口模式选择
    .rst                (cx9261a_pl_rst         ), // PS GPIO控制 模块复位，高有效。
    .sp_dp_sel          (cx9261a_sp_dp_sel      ), // PS GPIO控制 singleport:1;dualport:0 保持芯片接口模式配置一致;
    .tr_sel             (cx9261a_tr_sel         ), // PS GPIO控制         rx:1;      tx:0 保持芯片接口模式配置一致;
    .tdd_fdd_sel        (cx9261a_tdd_fdd_sel    ), // PS GPIO控制        tdd:1;     fdd:0 保持芯片接口模式配置一致;
    .r1t1_r2t2_sel      (cx9261a_r1t1_r2t2_sel  ), // PS GPIO控制       r2t2:1;    r1t1:0 保持芯片接口模式配置一致;
    //基带数据接口
    .data_clk           (data_clk               ), // f(data_clk) = f(RX1_MCLK_IN_N);
    .data_valid         (data_valid             ), // 任一接口模式下，data_valid可使rx1_i/q_data数据速率和ADC1采样率（无抽取）保持一致
    .data_clk2          (data_clk2              ), // f(data_clk2) = f(RX2_MCLK_IN_P);
    .data_valid2        (data_valid2            ), // 任一接口模式下，data_valid2可使rx2_i/q_data数据速率和ADC2采样率（无抽取）保持一致
    .data_clk3          (data_clk3              ), // f(data_clk3) = f(RXFB_MCLK_IN);
    .data_valid3        (data_valid3            ), // 任一接口模式下，data_valid3可使rx3_i/q_data数据速率和ADC3采样率（无抽取）保持一致
    .rx1_i_data         (rx1_data_i             ), // \----------------------------------------------------------------------------------------
    .rx1_q_data         (rx1_data_q             ), // \eg.：fadc = 64MSPS,fdac = 256MSPS,dac采样率固定是dac采样率的4倍。
    .rx2_i_data         (rx2_data_i             ), // \发射数字插值倍数保持是接收数字抽取倍数4倍,则基带接收数据速率等于发射数据速率。
    .rx2_q_data         (rx2_data_q             ), // \在FDD/singleport/r1t1、TDD/singleport/r2t2、FDD/dualport/r2t2三种数据接口模式下，
    .rx3_i_data         (rx3_data_i             ), // \数据随路时钟MCLK  fmclk = 2 *  fadc，其余接口模式 fmclk = 2 *  fadc。
    .rx3_q_data         (rx3_data_q             ), // \rx1/2/3_i/q_data数据 和 tx1/2_i/q_data数据 对应处于 data_clk/2/3（速率等于MCLK）时钟域
    .tx1_i_data         (tx1_data_i             ), // \为了保证基带接收数据速率等于发射数据速率,在上述三种三种数据接口模式下
    .tx1_q_data         (tx1_data_q             ), // \data_valid/2/3实际是data_clk/2的两分频，其余接口模式 tx_data_ready常高;
    .tx2_i_data         (tx2_data_i             ), // \tx_data_ready实际是data_clk/2的两分频，其余接口模式 tx_data_ready常高。
    .tx2_q_data         (tx2_data_q             ), // \----------------------------------------------------------------------------------------
    .tx_data_ready      (tx_data_ready          ), // 任一接口模式下，tx_data_ready可使tx1_i/q_data数据速率（4倍插值后）和DAC1采样率保持一致
    .tx_data_ready2     (tx_data_ready2         ), // 任一接口模式下，tx_data_ready2可使tx2_i/q_data数据速率（4倍插值后）和DAC2采样率保持一致
    //芯片数据接口                                      \----------------------------------------------------------------------------------------
    .RX1_FRAME_N        (cx9261a_rx1_frame      ), // \争对客户板上数据时序异常情况，可通过IDELAYE2原语对RX1_MCLK_IN_N进行延时调节，其输出为MCLK1；
    .RX1_MCLK_IN_N      (cx9261a_mclk1          ), // \RX2_MCLK_IN_P延时调节，其输出为MCLK2；RXFB_MCLK_IN延时调节，其输出为MCLK3。
    .RX2_FRAME_P        (cx9261a_rx2_frame      ), // \若无数据时序异常情况，可分别将MCLK1/2/3换成RX1_MCLK_IN_N/RX2_MCLK_IN_P/RXFB_MCLK_IN；
    .RX2_MCLK_IN_P      (cx9261a_mclk2          ), // \数据接口调试过程，信号推荐按无数据时序异常情况连接，若出现异常，
    .RX3_FRAME          (cx9261a_rxfb_frame     ), // \先调节芯片内部mclk延迟寄存器（0x783/0x782/0x784），延时不够，再通过IDELAYE2原语调整时序
    .RX3_MCLK_IN        (cx9261a_mclk3          ), // \----------------------------------------------------------------------------------------
    .TX1_FCLK_IN_N      (cx9261a_tx1_fclk       ), // f(TX1_FCLK_IN_N) = f(RX1_MCLK_IN_N)
    .TX2_FCLK_IN_P      (cx9261a_tx2_fclk       ), // f(TX2_FCLK_IN_P) = f(RX2_MCLK_IN_P)
    .TX1_FRAME_IN_N     (cx9261a_tx1_frame      ),
    .TX2_FRAME_IN_P     (cx9261a_tx2_frame      ),
    .RX1_FDD_DATA_IO    (cx9261a_rx1_fdd_data   ), // \----------------------------------------------------------------------------------------
    .RX2_FDD_DATA_IO    (cx9261a_rx2_fdd_data   ), // \
    .TX1_FDD_DATA_IO    (cx9261a_tx1_fdd_data   ), // \针对驱动模块的接口时序设计与芯片数据手册里标准接口时序不一致的问题。
    .TX2_FDD_DATA_IO    (cx9261a_tx2_fdd_data   ), // \该模块按照MCLK/FCLK和RX_FRAME/TX_FRAME对齐去设计，便于代码实现，微调了芯片内部mclk延迟，
    .RX3_FDD_DATA_IO    (cx9261a_rxfb_rx_data   ), // \实现了芯片标准接口时序的数据接收和发送
    .TX3_FDD_DATA_IO    (cx9261a_rxfb_tx_data   ), // \----------------------------------------------------------------------------------------
    //调试接口
    .power_on_flag      ( 1'b1                  )
);

// <--------------------------------------------------------------------------->
// <--------------------- insert transmitter logic below ---------------------->
// <--------------------------------------------------------------------------->
wire    [ 1:0]  waveform_sel_1;
wire            sweep_on_1    ;
wire    [31:0]  freq_set_1    ;
wire    [ 1:0]  iq_sel_1      ;
wire    [ 3:0]  bb_rshift_1   ;

tx_qpsk #(
    .BIT_DATA       (1024'b0000000100100010000011001001101000010010101000011110101110101101101100000000110000011011001100001010110101110001101111110001000111100111101101101000000010100001011010101000111110111100100101100000100110010001010001101101110000001111000111011111110010000110001011011101000011010101100111100101101100100000100010010011000000101100010100111011001110001011111101010001011101101011000011001101101010000011101001111010011010100100111000001111100111001101111010001010101101111100001001110100011101011111011010010000100001010010101100011100111111101100001000110100111001001111000011011101100011000111101111101001001010000001101000110010111010010110100010001011001101001010010001100001110110111100000101110010101110011101110111001100111010101110111101100101000100110110001000011100101111100101001100110010101010011111100110001101011110011010110100110001001011100001011110101010101111111101000001010100101111000101011110111010100110111001000111000111111111100000001110000111111011100010011111000110011111010110010110010010010000000001),
    .BIT_DATA_LEN   (1024),
    .CLK_FREQ       (48000000),
    .DATA_WIDTH     (16)
) u_tx1_qpsk
(
    .clk            (data_clk           ), // input           clk
    .rst            (1'b0               ), // input           rst
    .tx_data_i      (tx1_data_i         ), // output  [11:0]  tx_data_i
    .tx_data_q      (tx1_data_q         ), // output  [11:0]  tx_data_q
    // debug ports
    .waveform_sel   (waveform_sel_1[1:0]), // input   [ 1:0]  waveform_sel
    .sweep_on       (sweep_on_1         ), // input           sweep_on
    .freq_set       (freq_set_1         ), // input   [31:0]  freq_set
    .iq_sel         (iq_sel_1           ), // input   [ 1:0]  iq_sel
    .bb_rshift      (bb_rshift_1        )  // input   [ 3:0]  bb_rshift
);

wire    [ 1:0]  waveform_sel_2;
wire            sweep_on_2    ;
wire    [31:0]  freq_set_2    ;
wire    [ 1:0]  iq_sel_2      ;
wire    [ 3:0]  bb_rshift_2   ;

tx_qpsk #(
    .BIT_DATA       (1024'b0000000100100010000011001001101000010010101000011110101110101101101100000000110000011011001100001010110101110001101111110001000111100111101101101000000010100001011010101000111110111100100101100000100110010001010001101101110000001111000111011111110010000110001011011101000011010101100111100101101100100000100010010011000000101100010100111011001110001011111101010001011101101011000011001101101010000011101001111010011010100100111000001111100111001101111010001010101101111100001001110100011101011111011010010000100001010010101100011100111111101100001000110100111001001111000011011101100011000111101111101001001010000001101000110010111010010110100010001011001101001010010001100001110110111100000101110010101110011101110111001100111010101110111101100101000100110110001000011100101111100101001100110010101010011111100110001101011110011010110100110001001011100001011110101010101111111101000001010100101111000101011110111010100110111001000111000111111111100000001110000111111011100010011111000110011111010110010110010010010000000001),
    .BIT_DATA_LEN   (1024),
    .CLK_FREQ       (48000000),
    .DATA_WIDTH     (16)
) u_tx2_qpsk
(
    .clk            (data_clk2          ), // input           clk
    .rst            (1'b0               ), // input           rst
    .tx_data_i      (tx2_data_i         ), // output  [11:0]  tx_data_i
    .tx_data_q      (tx2_data_q         ), // output  [11:0]  tx_data_q
    // debug ports
    .waveform_sel   (waveform_sel_2[1:0]), // input   [ 1:0]  waveform_sel
    .sweep_on       (sweep_on_2         ), // input           sweep_on
    .freq_set       (freq_set_2         ), // input   [31:0]  freq_set
    .iq_sel         (iq_sel_2           ), // input   [ 1:0]  iq_sel
    .bb_rshift      (bb_rshift_2        )  // input   [ 3:0]  bb_rshift
);

////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// Hop Control //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
reg [31:0] hop_cnt = 'b0;
wire [31:0] hop_int;

always @(posedge data_clk or posedge cx9261a_pl_rst) begin
    if (cx9261a_pl_rst) begin
        hop_cnt <= 'b0;
        gpio_hop_flag <= 'b0;
    end
    else begin
        if (hop_en) begin
            hop_cnt <= (hop_cnt == hop_int) ? 'b0 : hop_cnt + 1'b1;
            gpio_hop_flag <= (hop_cnt == hop_int) ? ~gpio_hop_flag : gpio_hop_flag;
        end
        else begin
            hop_cnt <= 'b0;
            gpio_hop_flag <= gpio_hop_flag;
        end
    end
end

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// ILAs and VIOs /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
ila_trx u_ila_trx1
(
    .clk    (data_clk   ), // input wire clk
    .probe0 (data_valid ), // input wire [0:0]  probe0
    .probe1 (rx1_data_i ), // input wire [11:0]  probe1
    .probe2 (rx1_data_q ), // input wire [11:0]  probe2
    .probe3 (data_ready ), // input wire [0:0]  probe3
    .probe4 (tx1_data_i ), // input wire [11:0]  probe4
    .probe5 (tx1_data_q )  // input wire [11:0]  probe5
);

ila_trx u_ila_trx2
(
    .clk    (data_clk2  ), // input wire clk
    .probe0 (data_valid2), // input wire [0:0]  probe0
    .probe1 (rx2_data_i ), // input wire [11:0]  probe1
    .probe2 (rx2_data_q ), // input wire [11:0]  probe2
    .probe3 (data_ready2), // input wire [0:0]  probe3
    .probe4 (tx2_data_i ), // input wire [11:0]  probe4
    .probe5 (tx2_data_q )  // input wire [11:0]  probe5
);

ila_trx_fb u_ila_trx3
(
    .clk    (data_clk3  ), // input wire clk
    .probe0 (data_valid3), // input wire [0:0]  probe0
    .probe1 (rx3_data_i ), // input wire [11:0]  probe1
    .probe2 (rx3_data_q )  // input wire [11:0]  probe2
);

vio_manual_ctrl u_vio_manual_ctrl_1
(
    .clk        (data_clk       ), // input wire clk
    .probe_out0 (waveform_sel_1 ), // output wire [1 : 0] probe_out0
    .probe_out1 (sweep_on_1     ), // output wire [0 : 0] probe_out1
    .probe_out2 (freq_set_1     ), // output wire [31 : 0] probe_out2
    .probe_out3 (iq_sel_1       ), // output wire [1 : 0] probe_out3
    .probe_out4 (bb_rshift_1    )  // output wire [3 : 0] probe_out4
);

vio_manual_ctrl u_vio_manual_ctrl_2
(
    .clk        (data_clk2      ), // input wire clk
    .probe_out0 (waveform_sel_2 ), // output wire [1 : 0] probe_out0
    .probe_out1 (sweep_on_2     ), // output wire [0 : 0] probe_out1
    .probe_out2 (freq_set_2     ), // output wire [31 : 0] probe_out2
    .probe_out3 (iq_sel_2       ), // output wire [1 : 0] probe_out3
    .probe_out4 (bb_rshift_2    )  // output wire [3 : 0] probe_out4
);

vio_hop_int u_vio_hop_int
(
    .clk        (data_clk       ), // input wire clk
    .probe_out0 (hop_int        )  // output wire [31 : 0] probe_out0
);

endmodule
