set_property  -dict  {PACKAGE_PIN B8    IOSTANDARD LVPECL  }  [get_ports pl_refclk_p            ] ;# PL_CLK_P
set_property  -dict  {PACKAGE_PIN B10   IOSTANDARD LVPECL  }  [get_ports pl_sysref_p            ] ;# PL_SYSREF_P

set_property  -dict  {PACKAGE_PIN AW5   IOSTANDARD LVCMOS18}  [get_ports lmk_spi_sck            ] ;# LMK_SPI_CS_LS
set_property  -dict  {PACKAGE_PIN AW3   IOSTANDARD LVCMOS18}  [get_ports lmk_spi_cs             ] ;# LMK_SPI_SCK_LS
set_property  -dict  {PACKAGE_PIN AW6   IOSTANDARD LVCMOS18}  [get_ports lmk_spi_mosi_sdio      ] ;# LMK_SPI_SDI_LS
set_property  -dict  {PACKAGE_PIN AW4   IOSTANDARD LVCMOS18}  [get_ports lmk_spi_miso           ] ;# LMK_SPI_SDO_LS

# Route HDGC clock through BUFG to adjacent CMT
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets u_system_bd_wrapper/system_bd_i/mts_clk_gen/util_ds_buf_pl_clk/U0/USE_IBUFDS.GEN_IBUFDS[0].IBUFDS_I/O]
