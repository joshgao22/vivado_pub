set_property  -dict  {PACKAGE_PIN F14   IOSTANDARD LVPECL  }  [get_ports pl_refclk_p            ] ;# PL_CLK_P
set_property  -dict  {PACKAGE_PIN F10   IOSTANDARD LVPECL  }  [get_ports pl_sysref_p            ] ;# PL_SYSREF_P

set_property  -dict  {PACKAGE_PIN B13   IOSTANDARD LVCMOS33}  [get_ports lmk_spi_sck            ] ;# LMK_SPI_SCK
set_property  -dict  {PACKAGE_PIN A13   IOSTANDARD LVCMOS33}  [get_ports lmk_spi_cs             ] ;# LMK_SPI_CS
set_property  -dict  {PACKAGE_PIN C14   IOSTANDARD LVCMOS33}  [get_ports lmk_spi_mosi           ] ;# LMK_SPI_SDI
set_property  -dict  {PACKAGE_PIN A14   IOSTANDARD LVCMOS33}  [get_ports lmk_spi_miso           ] ;# LMK_SPI_SDO

set_property  -dict  {PACKAGE_PIN H13   IOSTANDARD LVCMOS33}  [get_ports lmx_adc_spi_sck        ] ;# LMX_RF_ADC_SCK
set_property  -dict  {PACKAGE_PIN K14   IOSTANDARD LVCMOS33}  [get_ports lmx_adc_spi_cs         ] ;# LMX_RF_ADC_CS
set_property  -dict  {PACKAGE_PIN J13   IOSTANDARD LVCMOS33}  [get_ports lmx_adc_spi_mosi       ] ;# LMX_RF_ADC_SDI
set_property  -dict  {PACKAGE_PIN H14   IOSTANDARD LVCMOS33}  [get_ports lmx_adc_spi_miso       ] ;# LMX_RF_ADC_SDO

set_property  -dict  {PACKAGE_PIN K15   IOSTANDARD LVCMOS33}  [get_ports lmx_dac_spi_sck        ] ;# LMX_RF_DAC_CLK
set_property  -dict  {PACKAGE_PIN G13   IOSTANDARD LVCMOS33}  [get_ports lmx_dac_spi_cs         ] ;# LMX_RF_DAC_CS
set_property  -dict  {PACKAGE_PIN J14   IOSTANDARD LVCMOS33}  [get_ports lmx_dac_spi_mosi       ] ;# LMX_RF_DAC_SDI
set_property  -dict  {PACKAGE_PIN H15   IOSTANDARD LVCMOS33}  [get_ports lmx_dac_spi_miso       ] ;# LMX_RF_DAC_SDO

# Route HDGC clock through BUFG to adjacent CMT
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets u_system_bd_wrapper/system_bd_i/mts_clk_gen/util_ds_buf_pl_clk/U0/USE_IBUFDS.GEN_IBUFDS[0].IBUFDS_I/O]
