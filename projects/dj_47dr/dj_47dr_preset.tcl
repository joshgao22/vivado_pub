proc getPresetInfo {} {
  return [dict create name {dj_47dr_preset} description {dj_47dr_preset}  vlnv xilinx.com:ip:zynq_ultra_ps_e:3.5 display_name {dj_47dr_preset} ]
}

proc validate_preset {IPINST} { return true }


proc apply_preset {IPINST} {
  return [dict create \
    CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {0}  \
    CONFIG.PSU__ACT_DDR_FREQ_MHZ {1066.656006}  \
    CONFIG.PSU__GEM__TSU__ENABLE {0}  \
    CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {0}  \
    CONFIG.PSU__ENET0__FIFO__ENABLE {0}  \
    CONFIG.PSU__ENET0__PTP__ENABLE {0}  \
    CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {0}  \
    CONFIG.PSU__ENET1__FIFO__ENABLE {0}  \
    CONFIG.PSU__ENET1__PTP__ENABLE {0}  \
    CONFIG.PSU__ENET1__GRP_MDIO__ENABLE {0}  \
    CONFIG.PSU__ENET2__PERIPHERAL__ENABLE {0}  \
    CONFIG.PSU__ENET2__FIFO__ENABLE {0}  \
    CONFIG.PSU__ENET2__PTP__ENABLE {0}  \
    CONFIG.PSU__ENET2__GRP_MDIO__ENABLE {0}  \
    CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1}  \
    CONFIG.PSU__ENET3__FIFO__ENABLE {0}  \
    CONFIG.PSU__ENET3__PTP__ENABLE {0}  \
    CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75}  \
    CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1}  \
    CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77}  \
    CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1}  \
    CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15}  \
    CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1}  \
    CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17}  \
    CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;0|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;0|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;0|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;0|SD0:NonSecure;0|SATA1:NonSecure;0|SATA0:NonSecure;0|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;0|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1}  \
    CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;0|LPD;USB3_0;FF9D0000;FF9DFFFF;0|LPD;UART1;FF010000;FF01FFFF;0|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;0|LPD;TTC2;FF130000;FF13FFFF;0|LPD;TTC1;FF120000;FF12FFFF;0|LPD;TTC0;FF110000;FF11FFFF;0|FPD;SWDT1;FD4D0000;FD4DFFFF;0|LPD;SWDT0;FF150000;FF15FFFF;0|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;0|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;0|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;0|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;0|FPD;DPDMA;FD4C0000;FD4CFFFF;0|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1}  \
    CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash##Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash##I2C 0#I2C 0#I2C 1#I2C 1#UART 0#UART 0#######PMU GPI 0######################################Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#MDIO 3#MDIO 3}  \
    CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out##n_ss_out_upper#mo_upper[0]#mo_upper[1]#mo_upper[2]#mo_upper[3]#sclk_out_upper##scl_out#sda_out#scl_out#sda_out#rxd#txd#######gpi[0]######################################rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out}  \
    CONFIG.PSU__PMU__AIBACK__ENABLE {0}  \
    CONFIG.PSU__PMU__PLERROR__ENABLE {0}  \
    CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1}  \
    CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0}  \
    CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0}  \
    CONFIG.PSU__PMU__GPI0__ENABLE {1}  \
    CONFIG.PSU__PMU__GPI1__ENABLE {0}  \
    CONFIG.PSU__PMU__GPI2__ENABLE {0}  \
    CONFIG.PSU__PMU__GPI3__ENABLE {0}  \
    CONFIG.PSU__PMU__GPI4__ENABLE {0}  \
    CONFIG.PSU__PMU__GPI5__ENABLE {0}  \
    CONFIG.PSU__PMU__GPO0__ENABLE {0}  \
    CONFIG.PSU__PMU__GPO1__ENABLE {0}  \
    CONFIG.PSU__PMU__GPO2__ENABLE {0}  \
    CONFIG.PSU__PMU__GPO3__ENABLE {0}  \
    CONFIG.PSU__PMU__GPO4__ENABLE {0}  \
    CONFIG.PSU__PMU__GPO5__ENABLE {0}  \
    CONFIG.PSU__PMU__GPI0__IO {MIO 26}  \
    CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1}  \
    CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12}  \
    CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel}  \
    CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4}  \
    CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {0}  \
    CONFIG.PSU__UART0__BAUD_RATE {115200}  \
    CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {1}  \
    CONFIG.PSU__DDRC__CL {16}  \
    CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {1}  \
    CONFIG.PSU__DDRC__CWL {11}  \
    CONFIG.PSU__DDRC__BG_ADDR_COUNT {1}  \
    CONFIG.PSU__DDRC__DEVICE_CAPACITY {8192 MBits}  \
    CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits}  \
    CONFIG.PSU__DDRC__ROW_ADDR_COUNT {16}  \
    CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2400P}  \
    CONFIG.PSU__DDRC__T_FAW {30.0}  \
    CONFIG.PSU__DDRC__T_RAS_MIN {33}  \
    CONFIG.PSU__DDRC__T_RC {46.5}  \
    CONFIG.PSU__DDRC__T_RCD {16}  \
    CONFIG.PSU__DDRC__T_RP {16}  \
    CONFIG.PSU__DDRC__COMPONENTS {UDIMM}  \
    CONFIG.PSU__DDRC__SB_TARGET {15-15-15}  \
    CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF}  \
    CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000}  \
    CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000}  \
    CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1}  \
    CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19}  \
    CONFIG.PSU__UART0__MODEM__ENABLE {0}  \
    CONFIG.PSU__USE__IRQ0 {1}  \
    CONFIG.PSU__HIGH_ADDRESS__ENABLE {1}  \
    CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1}  \
    CONFIG.PSU_MIO_0_POLARITY {Default}  \
    CONFIG.PSU_MIO_0_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_0_DIRECTION {out}  \
    CONFIG.PSU_MIO_1_DRIVE_STRENGTH {12}  \
    CONFIG.PSU_MIO_1_POLARITY {Default}  \
    CONFIG.PSU_MIO_1_SLEW {fast}  \
    CONFIG.PSU_MIO_1_DIRECTION {inout}  \
    CONFIG.PSU_MIO_2_POLARITY {Default}  \
    CONFIG.PSU_MIO_2_DIRECTION {inout}  \
    CONFIG.PSU_MIO_3_POLARITY {Default}  \
    CONFIG.PSU_MIO_3_DIRECTION {inout}  \
    CONFIG.PSU_MIO_4_POLARITY {Default}  \
    CONFIG.PSU_MIO_4_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_4_DIRECTION {inout}  \
    CONFIG.PSU_MIO_5_POLARITY {Default}  \
    CONFIG.PSU_MIO_5_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_5_DIRECTION {out}  \
    CONFIG.PSU_MIO_7_POLARITY {Default}  \
    CONFIG.PSU_MIO_7_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_7_DIRECTION {out}  \
    CONFIG.PSU_MIO_8_POLARITY {Default}  \
    CONFIG.PSU_MIO_8_DIRECTION {inout}  \
    CONFIG.PSU_MIO_9_POLARITY {Default}  \
    CONFIG.PSU_MIO_9_DIRECTION {inout}  \
    CONFIG.PSU_MIO_10_POLARITY {Default}  \
    CONFIG.PSU_MIO_10_DIRECTION {inout}  \
    CONFIG.PSU_MIO_11_POLARITY {Default}  \
    CONFIG.PSU_MIO_11_DIRECTION {inout}  \
    CONFIG.PSU_MIO_12_POLARITY {Default}  \
    CONFIG.PSU_MIO_12_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_12_DIRECTION {out}  \
    CONFIG.PSU_MIO_14_POLARITY {Default}  \
    CONFIG.PSU_MIO_14_DIRECTION {inout}  \
    CONFIG.PSU_MIO_15_POLARITY {Default}  \
    CONFIG.PSU_MIO_15_DIRECTION {inout}  \
    CONFIG.PSU_MIO_16_POLARITY {Default}  \
    CONFIG.PSU_MIO_16_DIRECTION {inout}  \
    CONFIG.PSU_MIO_17_POLARITY {Default}  \
    CONFIG.PSU_MIO_17_DIRECTION {inout}  \
    CONFIG.PSU_MIO_18_DRIVE_STRENGTH {12}  \
    CONFIG.PSU_MIO_18_POLARITY {Default}  \
    CONFIG.PSU_MIO_18_SLEW {fast}  \
    CONFIG.PSU_MIO_18_DIRECTION {in}  \
    CONFIG.PSU_MIO_19_POLARITY {Default}  \
    CONFIG.PSU_MIO_19_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_19_DIRECTION {out}  \
    CONFIG.PSU_MIO_26_DRIVE_STRENGTH {12}  \
    CONFIG.PSU_MIO_26_POLARITY {Default}  \
    CONFIG.PSU_MIO_26_SLEW {fast}  \
    CONFIG.PSU_MIO_26_DIRECTION {in}  \
    CONFIG.PSU_MIO_64_POLARITY {Default}  \
    CONFIG.PSU_MIO_64_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_64_DIRECTION {out}  \
    CONFIG.PSU_MIO_65_POLARITY {Default}  \
    CONFIG.PSU_MIO_65_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_65_DIRECTION {out}  \
    CONFIG.PSU_MIO_66_POLARITY {Default}  \
    CONFIG.PSU_MIO_66_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_66_DIRECTION {out}  \
    CONFIG.PSU_MIO_67_POLARITY {Default}  \
    CONFIG.PSU_MIO_67_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_67_DIRECTION {out}  \
    CONFIG.PSU_MIO_68_POLARITY {Default}  \
    CONFIG.PSU_MIO_68_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_68_DIRECTION {out}  \
    CONFIG.PSU_MIO_69_POLARITY {Default}  \
    CONFIG.PSU_MIO_69_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_69_DIRECTION {out}  \
    CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12}  \
    CONFIG.PSU_MIO_70_POLARITY {Default}  \
    CONFIG.PSU_MIO_70_SLEW {fast}  \
    CONFIG.PSU_MIO_70_DIRECTION {in}  \
    CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12}  \
    CONFIG.PSU_MIO_71_POLARITY {Default}  \
    CONFIG.PSU_MIO_71_SLEW {fast}  \
    CONFIG.PSU_MIO_71_DIRECTION {in}  \
    CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12}  \
    CONFIG.PSU_MIO_72_POLARITY {Default}  \
    CONFIG.PSU_MIO_72_SLEW {fast}  \
    CONFIG.PSU_MIO_72_DIRECTION {in}  \
    CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12}  \
    CONFIG.PSU_MIO_73_POLARITY {Default}  \
    CONFIG.PSU_MIO_73_SLEW {fast}  \
    CONFIG.PSU_MIO_73_DIRECTION {in}  \
    CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12}  \
    CONFIG.PSU_MIO_74_POLARITY {Default}  \
    CONFIG.PSU_MIO_74_SLEW {fast}  \
    CONFIG.PSU_MIO_74_DIRECTION {in}  \
    CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12}  \
    CONFIG.PSU_MIO_75_POLARITY {Default}  \
    CONFIG.PSU_MIO_75_SLEW {fast}  \
    CONFIG.PSU_MIO_75_DIRECTION {in}  \
    CONFIG.PSU_MIO_76_POLARITY {Default}  \
    CONFIG.PSU_MIO_76_INPUT_TYPE {cmos}  \
    CONFIG.PSU_MIO_76_DIRECTION {out}  \
    CONFIG.PSU_MIO_77_POLARITY {Default}  \
    CONFIG.PSU_MIO_77_DIRECTION {inout}  \
    CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18}  \
    CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18}  \
    CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18}  \
    CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS18}  \
    CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000}  \
    CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000}  \
    CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000}  \
    CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000}  \
    CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000}  \
    CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1}  \
    CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1}  \
    CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1}  \
    CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1}  \
    CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1}  \
    CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {80}  \
    CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {64}  \
    CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {64}  \
    CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3}  \
    CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {2}  \
    CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {2}  \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1}  \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5}  \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2}  \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5}  \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {63}  \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {6}  \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {10}  \
    CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2}  \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {3}  \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {5}  \
    CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {6}  \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {11}  \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {4}  \
    CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {4}  \
    CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {4}  \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30}  \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {1}  \
    CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3}  \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {5}  \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {15}  \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2}  \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2}  \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {2}  \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5}  \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2}  \
    CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90}  \
    CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {64}  \
    CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3}  \
    CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {2}  \
    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12}  \
    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12}  \
    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12}  \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12}  \
    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {6}  \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6}  \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6}  \
    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {5}  \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {7}  \
    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {7}  \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15}  \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15}  \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15}  \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15}  \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {7}  \
    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {7}  \
    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15}  \
    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15}  \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {2}  \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {4}  \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8}  \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15}  \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {2}  \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6}  \
    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15}  \
    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1}  \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {2}  \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL}  \
    CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100.000000}  \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1333.320068}  \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.997498}  \
    CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {533.328003}  \
    CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500}  \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {96.968727}  \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {533.328003}  \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {533.328003}  \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {533.328003}  \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.999001}  \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.997498}  \
    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__ACT_FREQMHZ {124.998749}  \
    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__ACT_FREQMHZ {124.998749}  \
    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__ACT_FREQMHZ {124.998749}  \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {124.998749}  \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {249.997498}  \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {299.997009}  \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.999001}  \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.999001}  \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.999001}  \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {533.328003}  \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {266.664001}  \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.498123}  \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.999001}  \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {533.328003}  \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.997498}  \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {533.328003}  \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.984985}  \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.999500}  \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {33.333000}  \
    CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067}  \
    CONFIG.PSU__LPD_SLCR__CSUPMU__FREQMHZ {100.000000}  \
    CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0}  \
    CONFIG.PSU__GEM0_ROUTE_THROUGH_FPD {0}  \
    CONFIG.PSU__GEM1_ROUTE_THROUGH_FPD {0}  \
    CONFIG.PSU__GEM2_ROUTE_THROUGH_FPD {0}  \
    CONFIG.PSU__GEM3_ROUTE_THROUGH_FPD {0}  \
    CONFIG.PSU__PMU_COHERENCY {0}  \
    CONFIG.PSU__QSPI_COHERENCY {0}  \
    CONFIG.PSU__ENET0__TSU__ENABLE {0}  \
    CONFIG.PSU__ENET1__TSU__ENABLE {0}  \
    CONFIG.PSU__ENET2__TSU__ENABLE {0}  \
    CONFIG.PSU__ENET3__TSU__ENABLE {0}  \
    CONFIG.PSU__TSU__BUFG_PORT_PAIR {0}  \
    CONFIG.PSU__GEM0_COHERENCY {0}  \
    CONFIG.PSU__GEM1_COHERENCY {0}  \
    CONFIG.PSU__GEM2_COHERENCY {0}  \
    CONFIG.PSU__GEM3_COHERENCY {0}  \
  ]
}


