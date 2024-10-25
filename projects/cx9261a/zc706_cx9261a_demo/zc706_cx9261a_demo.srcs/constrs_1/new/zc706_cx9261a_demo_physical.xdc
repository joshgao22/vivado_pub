# zc706_cx9261a_demo

## Physical Constraints Section

# CX9261A Interface
set_property  -dict  {PACKAGE_PIN U26   IOSTANDARD LVCMOS25}  [get_ports cx9261a_osc_out        ]
set_property  -dict  {PACKAGE_PIN N27   IOSTANDARD LVCMOS25}  [get_ports cx9261a_nrst           ]

set_property  -dict  {PACKAGE_PIN V28   IOSTANDARD LVCMOS25}  [get_ports cx9261a_spi_sclk       ]
set_property  -dict  {PACKAGE_PIN V29   IOSTANDARD LVCMOS25}  [get_ports cx9261a_spi_csb        ]
set_property  -dict  {PACKAGE_PIN T28   IOSTANDARD LVCMOS25}  [get_ports cx9261a_spi_miso       ]
set_property  -dict  {PACKAGE_PIN R28   IOSTANDARD LVCMOS25}  [get_ports cx9261a_spi_mosi       ]

set_property  -dict  {PACKAGE_PIN P29   IOSTANDARD LVCMOS25}  [get_ports cx9261a_txnrx_trx1     ]
set_property  -dict  {PACKAGE_PIN N29   IOSTANDARD LVCMOS25}  [get_ports cx9261a_txnrx_trx2     ]
set_property  -dict  {PACKAGE_PIN U27   IOSTANDARD LVCMOS25}  [get_ports cx9261a_txnrx_rxfb     ]
set_property  -dict  {PACKAGE_PIN P25   IOSTANDARD LVCMOS25}  [get_ports cx9261a_enable_trx1    ]
set_property  -dict  {PACKAGE_PIN P26   IOSTANDARD LVCMOS25}  [get_ports cx9261a_enable_trx2    ]
set_property  -dict  {PACKAGE_PIN N26   IOSTANDARD LVCMOS25}  [get_ports cx9261a_enable_rxfb    ]

set_property  -dict  {PACKAGE_PIN R26   IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx1_fclk       ]
set_property  -dict  {PACKAGE_PIN R25   IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx2_fclk       ]
set_property  -dict  {PACKAGE_PIN AF22  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx1_mclk       ]
set_property  -dict  {PACKAGE_PIN AE22  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx2_mclk       ]
set_property  -dict  {PACKAGE_PIN W25   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_mclk      ]

set_property  -dict  {PACKAGE_PIN T25   IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx1_frame      ]
set_property  -dict  {PACKAGE_PIN T24   IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx2_frame      ]
set_property  -dict  {PACKAGE_PIN AH24  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx1_frame      ]
set_property  -dict  {PACKAGE_PIN AH23  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx2_frame      ]
set_property  -dict  {PACKAGE_PIN W26   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_frame     ]

set_property  -dict  {PACKAGE_PIN P30   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_rx_data[7]]
set_property  -dict  {PACKAGE_PIN R30   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_rx_data[6]]
set_property  -dict  {PACKAGE_PIN P23   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_rx_data[5]]
set_property  -dict  {PACKAGE_PIN P24   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_rx_data[4]]
set_property  -dict  {PACKAGE_PIN P21   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_rx_data[3]]
set_property  -dict  {PACKAGE_PIN R21   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_rx_data[2]]
set_property  -dict  {PACKAGE_PIN W29   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_rx_data[1]]
set_property  -dict  {PACKAGE_PIN W30   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_rx_data[0]]

set_property  -dict  {PACKAGE_PIN U25   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_tx_data[7]]
set_property  -dict  {PACKAGE_PIN V26   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_tx_data[6]]
set_property  -dict  {PACKAGE_PIN V27   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_tx_data[5]]
set_property  -dict  {PACKAGE_PIN W28   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_tx_data[4]]
set_property  -dict  {PACKAGE_PIN T29   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_tx_data[3]]
set_property  -dict  {PACKAGE_PIN U29   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_tx_data[2]]
set_property  -dict  {PACKAGE_PIN T30   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_tx_data[1]]
set_property  -dict  {PACKAGE_PIN U30   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rxfb_tx_data[0]]

set_property  -dict  {PACKAGE_PIN AH19  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx1_fdd_data[7]]
set_property  -dict  {PACKAGE_PIN AJ19  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx1_fdd_data[6]]
set_property  -dict  {PACKAGE_PIN AF19  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx1_fdd_data[5]]
set_property  -dict  {PACKAGE_PIN AG19  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx1_fdd_data[4]]
set_property  -dict  {PACKAGE_PIN AF23  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx1_fdd_data[3]]
set_property  -dict  {PACKAGE_PIN AF24  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx1_fdd_data[2]]
set_property  -dict  {PACKAGE_PIN AA24  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx1_fdd_data[1]]
set_property  -dict  {PACKAGE_PIN AB24  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx1_fdd_data[0]]

set_property  -dict  {PACKAGE_PIN Y22   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx2_fdd_data[7]]
set_property  -dict  {PACKAGE_PIN Y23   IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx2_fdd_data[6]]
set_property  -dict  {PACKAGE_PIN AC24  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx2_fdd_data[5]]
set_property  -dict  {PACKAGE_PIN AD24  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx2_fdd_data[4]]
set_property  -dict  {PACKAGE_PIN AG24  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx2_fdd_data[3]]
set_property  -dict  {PACKAGE_PIN AG25  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx2_fdd_data[2]]
set_property  -dict  {PACKAGE_PIN AF20  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx2_fdd_data[1]]
set_property  -dict  {PACKAGE_PIN AG20  IOSTANDARD LVCMOS25}  [get_ports cx9261a_rx2_fdd_data[0]]

set_property  -dict  {PACKAGE_PIN AG22  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx1_fdd_data[7]]
set_property  -dict  {PACKAGE_PIN AH22  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx1_fdd_data[6]]
set_property  -dict  {PACKAGE_PIN AA22  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx1_fdd_data[5]]
set_property  -dict  {PACKAGE_PIN AA23  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx1_fdd_data[4]]
set_property  -dict  {PACKAGE_PIN AG21  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx1_fdd_data[3]]
set_property  -dict  {PACKAGE_PIN AH21  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx1_fdd_data[2]]
set_property  -dict  {PACKAGE_PIN AD21  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx1_fdd_data[1]]
set_property  -dict  {PACKAGE_PIN AE21  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx1_fdd_data[0]]

set_property  -dict  {PACKAGE_PIN AK17  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx2_fdd_data[7]]
set_property  -dict  {PACKAGE_PIN AK18  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx2_fdd_data[6]]
set_property  -dict  {PACKAGE_PIN AJ20  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx2_fdd_data[5]]
set_property  -dict  {PACKAGE_PIN AK20  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx2_fdd_data[4]]
set_property  -dict  {PACKAGE_PIN AJ23  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx2_fdd_data[3]]
set_property  -dict  {PACKAGE_PIN AJ24  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx2_fdd_data[2]]
set_property  -dict  {PACKAGE_PIN AD23  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx2_fdd_data[1]]
set_property  -dict  {PACKAGE_PIN AE23  IOSTANDARD LVCMOS25}  [get_ports cx9261a_tx2_fdd_data[0]]


## Timing Assertions Section
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets u_mclk_delay/MCLK1]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets u_mclk_delay/MCLK2]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets u_mclk_delay/MCLK3]

create_clock -period 6.25 -name RX1_MCLK_IN_N -waveform {0.000 3.125} [get_ports cx9261a_rx1_mclk ]
create_clock -period 6.25 -name RX2_MCLK_IN_P -waveform {0.000 3.125} [get_ports cx9261a_rx2_mclk ]
create_clock -period 6.25 -name RXFB_MCLK_IN  -waveform {0.000 3.125} [get_ports cx9261a_rxfb_mclk]

set_clock_groups -asynchronous -group [get_clocks RX1_MCLK_IN_N] -group [get_clocks RX2_MCLK_IN_P] -group [get_clocks RXFB_MCLK_IN] -group [get_clocks [list clk_fpga_0 clk_fpga_1 ]]