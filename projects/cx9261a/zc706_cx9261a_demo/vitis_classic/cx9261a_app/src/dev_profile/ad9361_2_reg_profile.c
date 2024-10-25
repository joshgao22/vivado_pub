#include "dev_profile.h"
#include "spi.h"
#include "../config/app_config.h"
#include "../drivers/rf-transceiver/ad9361_reg/ad9361_reg.h"
#include "../drivers/axi_core/spi_engine/spi_engine.h"
#include "../drivers/platform/xilinx_gpio.h"

#ifdef AD9361_REG

#define TIMEOUT_TH AD9361_TIMEOUT_TH

static struct spi_engine_init_param spi_engine_param = {
	.ref_clk_hz = AD9361_SPI_ENGINE_REF_CLK,
	.type = SPI_ENGINE,
	.spi_engine_baseaddr = AD9361_SPI_ENGINE_BASEADDR,
	.cs_delay = AD9361_SPI_ENGINE_CS_DELAY,
	.data_width = AD9361_SPI_ENGINE_DATA_WIDTH
};

static struct xil_gpio_init_param xil_gpio_param = {
	.type = GPIO_PS,
	.device_id = AD9361_GPIO_DEVICE_ID
};

// ad9361-2
static struct spi_init_param ad9361_2_reg_spi_init = {
	.device_id = AD9361_SPI_DEVICE_ID,
    .max_speed_hz = AD9361_SPI_ENGINE_MAX_SPEED,
	.chip_select = AD9361_2_SPI_CS,
	.mode = SPI_MODE_1,
	.platform_ops = &spi_eng_platform_ops,
	.extra = &spi_engine_param
};

static struct gpio_init_param ad9361_2_reg_gpio_resetb_init = {
	.number = AD9361_2_RESET_B,
	.platform_ops = &xil_gpio_ops,
	.extra = &xil_gpio_param
};

struct ad9361_reg_init_param ad9361_2_reg_default_init_param = {
	/* SPI */
	.spi_init = &ad9361_2_reg_spi_init,
	.gpio_resetb = &ad9361_2_reg_gpio_resetb_init
};

uint32_t ad9361_2_reg_config(struct ad9361_reg_dev *dev){
    int32_t status = 0;
    uint8_t value = 0;
    int32_t time_out_cnt = 0;

//************************************************************
// AD9361 R2 Auto Generated Initialization Script:  This script was
// generated using the AD9361 Customer software Version 2.1.3
//************************************************************
// Profile: Custom
// REFCLK_IN: 40.000 MHz


    status = ad9361_reg_write(dev, 0x03DF, 0x01);	// Required for proper operation
    status = ad9361_reg_write(dev, 0x02A6, 0x0E);	// Enable Master Bias
    status = ad9361_reg_write(dev, 0x02A8, 0x0E);	// Set Bandgap Trim
    status = ad9361_reg_write(dev, 0x02AB, 0x07);	// Set RF PLL reflclk scale to REFCLK * 2
    status = ad9361_reg_write(dev, 0x02AC, 0xFF);	// Set RF PLL reflclk scale to REFCLK * 2
    status = ad9361_reg_write(dev, 0x0009, 0x17);	// Enable Clocks
    mdelay(20)	;// waits 20 ms

//************************************************************
// Set BBPLL Frequency: 1152.000000
//************************************************************
    status = ad9361_reg_write(dev, 0x0045, 0x03);	// Set BBPLL reflclk scale to REFCLK * 2
    status = ad9361_reg_write(dev, 0x0046, 0x02);	// Set BBPLL Loop Filter Charge Pump current
    status = ad9361_reg_write(dev, 0x0048, 0xE8);	// Set BBPLL Loop Filter C1, R1
    status = ad9361_reg_write(dev, 0x0049, 0x5B);	// Set BBPLL Loop Filter R2, C2, C1
    status = ad9361_reg_write(dev, 0x004A, 0x35);	// Set BBPLL Loop Filter C3,R2
    status = ad9361_reg_write(dev, 0x004B, 0xE0);	// Allow calibration to occur and set cal count to 1024 for max accuracy
    status = ad9361_reg_write(dev, 0x004E, 0x10);	// Set calibration clock to REFCLK/4 for more accuracy
    status = ad9361_reg_write(dev, 0x0043, 0x00);	// BBPLL Freq Word (Fractional[7:0])
    status = ad9361_reg_write(dev, 0x0042, 0xC0);	// BBPLL Freq Word (Fractional[15:8])
    status = ad9361_reg_write(dev, 0x0041, 0x0C);	// BBPLL Freq Word (Fractional[23:16])
    status = ad9361_reg_write(dev, 0x0044, 0x0E);	// BBPLL Freq Word (Integer[7:0])
    status = ad9361_reg_write(dev, 0x003F, 0x05);	// Start BBPLL Calibration
    status = ad9361_reg_write(dev, 0x003F, 0x01);	// Clear BBPLL start calibration bit
    status = ad9361_reg_write(dev, 0x004C, 0x86);	// Increase BBPLL KV and phase margin
    status = ad9361_reg_write(dev, 0x004D, 0x01);	// Increase BBPLL KV and phase margin
    status = ad9361_reg_write(dev, 0x004D, 0x05);	// Increase BBPLL KV and phase margin

    // Wait for BBPLL to lock, Timeout 2sec, Max BBPLL VCO Cal Time: 172.800 us (Done when 0x05E[7]==1)
    time_out_cnt = 0;
    do{
        status |= ad9361_reg_read(dev, 0x005E, &value);
        mdelay(1);// Wait 1ms
        time_out_cnt++;
    } while((value & 0x80) != 0x80 && time_out_cnt <= TIMEOUT_TH);


    status = ad9361_reg_write(dev, 0x0002, 0x24);	// Setup Tx Digital Filters/ Channels
    status = ad9361_reg_write(dev, 0x0003, 0xE4);	// Setup Rx Digital Filters/ Channels
    status = ad9361_reg_write(dev, 0x0004, 0x03);	// Select Rx input pin(A,B,C)/ Tx out pin (A,B)
    status = ad9361_reg_write(dev, 0x000A, 0x12);	// Set BBPLL post divide rate

//************************************************************
// Setup the Parallel Port (Digital Data Interface)
//************************************************************
    status = ad9361_reg_write(dev, 0x0010, 0xCC);	// I/O Config.  Tx Swap IQ; Rx Swap IQ; Tx CH Swap, Rx CH Swap; Rx Frame Mode; 2R2T bit; Invert data bus; Invert DATA_CLK
    status = ad9361_reg_write(dev, 0x0011, 0x00);	// I/O Config.  Alt Word Order; -Rx1; -Rx2; -Tx1; -Tx2; Invert Rx Frame; Delay Rx Data
    status = ad9361_reg_write(dev, 0x0012, 0x02);	// I/O Config.  Rx=2*Tx; Swap Ports; SDR; LVDS; Half Duplex; Single Port; Full Port; Swap Bits
    status = ad9361_reg_write(dev, 0x0006, 0x00);	// PPORT Rx Delay (adjusts Tco Dataclk->Data)
    status = ad9361_reg_write(dev, 0x0007, 0x0F);	// PPORT TX Delay (adjusts setup/hold FBCLK->Data)

//************************************************************
// Setup AuxDAC
//************************************************************
    status = ad9361_reg_write(dev, 0x0018, 0x00);	// AuxDAC1 Word[9:2]
    status = ad9361_reg_write(dev, 0x0019, 0x00);	// AuxDAC2 Word[9:2]
    status = ad9361_reg_write(dev, 0x001A, 0x00);	// AuxDAC1 Config and Word[1:0]
    status = ad9361_reg_write(dev, 0x001B, 0x00);	// AuxDAC2 Config and Word[1:0]
    status = ad9361_reg_write(dev, 0x0023, 0xFF);	// AuxDAC Manaul/Auto Control
    status = ad9361_reg_write(dev, 0x0026, 0x00);	// AuxDAC Manual Select Bit/GPO Manual Select
    status = ad9361_reg_write(dev, 0x0030, 0x00);	// AuxDAC1 Rx Delay
    status = ad9361_reg_write(dev, 0x0031, 0x00);	// AuxDAC1 Tx Delay
    status = ad9361_reg_write(dev, 0x0032, 0x00);	// AuxDAC2 Rx Delay
    status = ad9361_reg_write(dev, 0x0033, 0x00);	// AuxDAC2 Tx Delay

//************************************************************
// Setup AuxADC
//************************************************************
    status = ad9361_reg_write(dev, 0x000B, 0x00);	// Temp Sensor Setup (Offset)
    status = ad9361_reg_write(dev, 0x000C, 0x00);	// Temp Sensor Setup (Temp Window)
    status = ad9361_reg_write(dev, 0x000D, 0x03);	// Temp Sensor Setup (Periodic Measure)
    status = ad9361_reg_write(dev, 0x000F, 0x04);	// Temp Sensor Setup (Decimation)
    status = ad9361_reg_write(dev, 0x001C, 0x00);	// AuxADC Setup (Clock Div)
    status = ad9361_reg_write(dev, 0x001D, 0x01);	// AuxADC Setup (Decimation/Enable)

//************************************************************
// Setup Control Outs
//************************************************************
    status = ad9361_reg_write(dev, 0x0035, 0x00);	// Ctrl Out index
    status = ad9361_reg_write(dev, 0x0036, 0xFF);	// Ctrl Out [7:0] output enable

//************************************************************
// Setup GPO
//************************************************************
    status = ad9361_reg_write(dev, 0x003A, 0x27);	// Set number of REFCLK cycles for 1us delay timer
    status = ad9361_reg_write(dev, 0x0020, 0x00);	// GPO Auto Enable Setup in RX and TX
    status = ad9361_reg_write(dev, 0x0027, 0x00);	// GPO Manual and GPO auto value in ALERT
    status = ad9361_reg_write(dev, 0x0028, 0x00);	// GPO_0 RX Delay
    status = ad9361_reg_write(dev, 0x0029, 0x00);	// GPO_1 RX Delay
    status = ad9361_reg_write(dev, 0x002A, 0x00);	// GPO_2 RX Delay
    status = ad9361_reg_write(dev, 0x002B, 0x00);	// GPO_3 RX Delay
    status = ad9361_reg_write(dev, 0x002C, 0x00);	// GPO_0 TX Delay
    status = ad9361_reg_write(dev, 0x002D, 0x00);	// GPO_1 TX Delay
    status = ad9361_reg_write(dev, 0x002E, 0x00);	// GPO_2 TX Delay
    status = ad9361_reg_write(dev, 0x002F, 0x00);	// GPO_3 TX Delay

//************************************************************
// Setup RF PLL non-frequency-dependent registers
//************************************************************
    status = ad9361_reg_write(dev, 0x0261, 0x00);	// Set Rx LO Power mode
    status = ad9361_reg_write(dev, 0x02A1, 0x00);	// Set Tx LO Power mode
    status = ad9361_reg_write(dev, 0x0248, 0x0B);	// Enable Rx VCO LDO
    status = ad9361_reg_write(dev, 0x0288, 0x0B);	// Enable Tx VCO LDO
    status = ad9361_reg_write(dev, 0x0246, 0x02);	// Set VCO Power down TCF bits
    status = ad9361_reg_write(dev, 0x0286, 0x02);	// Set VCO Power down TCF bits
    status = ad9361_reg_write(dev, 0x0249, 0x8E);	// Set VCO cal length
    status = ad9361_reg_write(dev, 0x0289, 0x8E);	// Set VCO cal length
    status = ad9361_reg_write(dev, 0x023B, 0x80);	// Enable Rx VCO cal
    status = ad9361_reg_write(dev, 0x027B, 0x80);	// Enable Tx VCO cal
    status = ad9361_reg_write(dev, 0x0243, 0x0D);	// Set Rx prescaler bias
    status = ad9361_reg_write(dev, 0x0283, 0x0D);	// Set Tx prescaler bias
    status = ad9361_reg_write(dev, 0x023D, 0x00);	// Clear Half VCO cal clock setting
    status = ad9361_reg_write(dev, 0x027D, 0x00);	// Clear Half VCO cal clock setting

    status = ad9361_reg_write(dev, 0x0015, 0x0C);	// Set Dual Synth mode bit
    status = ad9361_reg_write(dev, 0x0014, 0x1D);	// Set Force ALERT State bit
    status = ad9361_reg_write(dev, 0x0013, 0x01);	// Set ENSM FDD mode
    mdelay(1);	// waits 1 ms

    status = ad9361_reg_write(dev, 0x023D, 0x04);	// Start RX CP cal

    // Wait for CP cal to complete, Max RXCP Cal time: 460.800 (us)(Done when 0x244[7]==1)
    time_out_cnt = 0;
    do{
        status |= ad9361_reg_read(dev, 0x0244, &value);
        mdelay(1);// Wait 1ms
        time_out_cnt++;
    } while((value & 0x80) != 0x80 && time_out_cnt <= TIMEOUT_TH);

    status = ad9361_reg_write(dev, 0x027D, 0x04);	// Start TX CP cal

    // Wait for CP cal to complete, Max TXCP Cal time: 460.800 (us)(Done when 0x284[7]==1)
	time_out_cnt = 0;
	do{
		status |= ad9361_reg_read(dev, 0x0284, &value);
		mdelay(1);// Wait 1ms
		time_out_cnt++;
	} while((value & 0x80) != 0x80 && time_out_cnt <= TIMEOUT_TH);

    status = ad9361_reg_write(dev, 0x023D, 0x00);	// Disable RX CP Calibration since the CP Cal start bit is not self-clearing.  Only important if the script is run again without restting the DUT
    status = ad9361_reg_write(dev, 0x027D, 0x00);	// Disable TX CP Calibration since the CP Cal start bit is not self-clearing.  Only important if the script is run again without restting the DUT
//************************************************************
// FDD RX,TX Synth Frequency: 1525.000000,1525.000000 MHz
//************************************************************
//************************************************************
// Setup Rx Frequency-Dependent Syntheisizer Registers
//************************************************************
    status = ad9361_reg_write(dev, 0x023A, 0x4A);	// Set VCO Output level[3:0]
    status = ad9361_reg_write(dev, 0x0239, 0xC3);	// Set Init ALC Value[3:0] and VCO Varactor[3:0]
    status = ad9361_reg_write(dev, 0x0242, 0x1F);	// Set VCO Bias Tcf[1:0] and VCO Bias Ref[2:0]
    status = ad9361_reg_write(dev, 0x0238, 0x78);	// Set VCO Cal Offset[3:0]
    status = ad9361_reg_write(dev, 0x0245, 0x00);	// Set VCO Cal Ref Tcf[2:0]
    status = ad9361_reg_write(dev, 0x0251, 0x0C);	// Set VCO Varactor Reference[3:0]
    status = ad9361_reg_write(dev, 0x0250, 0x70);	// Set VCO Varactor Ref Tcf[2:0] and VCO Varactor Offset[3:0]
    status = ad9361_reg_write(dev, 0x023B, 0x93);	// Set Synth Loop Filter charge pump current (Icp)
    status = ad9361_reg_write(dev, 0x023E, 0xD4);	// Set Synth Loop Filter C2 and C1
    status = ad9361_reg_write(dev, 0x023F, 0xDF);	// Set Synth Loop Filter  R1 and C3
    status = ad9361_reg_write(dev, 0x0240, 0x09);	// Set Synth Loop Filter R3

//************************************************************
// Setup Tx Frequency-Dependent Syntheisizer Registers
//************************************************************
    status = ad9361_reg_write(dev, 0x027A, 0x4A);	// Set VCO Output level[3:0]
    status = ad9361_reg_write(dev, 0x0279, 0xC3);	// Set Init ALC Value[3:0] and VCO Varactor[3:0]
    status = ad9361_reg_write(dev, 0x0282, 0x1F);	// Set VCO Bias Tcf[1:0] and VCO Bias Ref[2:0]
    status = ad9361_reg_write(dev, 0x0278, 0x78);	// Set VCO Cal Offset[3:0]
    status = ad9361_reg_write(dev, 0x0285, 0x00);	// Set VCO Cal Ref Tcf[2:0]
    status = ad9361_reg_write(dev, 0x0291, 0x0C);	// Set VCO Varactor Reference[3:0]
    status = ad9361_reg_write(dev, 0x0290, 0x70);	// Set VCO Varactor Ref Tcf[2:0] and VCO Varactor Offset[3:0]
    status = ad9361_reg_write(dev, 0x027B, 0x93);	// Set Synth Loop Filter charge pump current (Icp)
    status = ad9361_reg_write(dev, 0x027E, 0xD4);	// Set Synth Loop Filter C2 and C1
    status = ad9361_reg_write(dev, 0x027F, 0xDF);	// Set Synth Loop Filter  R1 and C3
    status = ad9361_reg_write(dev, 0x0280, 0x09);	// Set Synth Loop Filter R3

//************************************************************
// Write Rx and Tx Frequency Words
//************************************************************
    status = ad9361_reg_write(dev, 0x0233, 0xFC);	// Write Rx Synth Fractional Freq Word[7:0]
    status = ad9361_reg_write(dev, 0x0234, 0xFF);	// Write Rx Synth Fractional Freq Word[15:8]
    status = ad9361_reg_write(dev, 0x0235, 0x1F);	// Write Rx Synth Fractional Freq Word[22:16]
    status = ad9361_reg_write(dev, 0x0232, 0x00);	// Write Rx Synth Integer Freq Word[10:8]
    status = ad9361_reg_write(dev, 0x0231, 0x4C);	// Write Rx Synth Integer Freq Word[7:0]
    status = ad9361_reg_write(dev, 0x0005, 0x11);	// Set LO divider setting
    status = ad9361_reg_write(dev, 0x0273, 0xFC);	// Write Tx Synth Fractional Freq Word[7:0]
    status = ad9361_reg_write(dev, 0x0274, 0xFF);	// Write Tx Synth Fractional Freq Word[15:8]
    status = ad9361_reg_write(dev, 0x0275, 0x1F);	// Write Tx Synth Fractional Freq Word[22:16]
    status = ad9361_reg_write(dev, 0x0272, 0x00);	// Write Tx Synth Integer Freq Word[10:8]
    status = ad9361_reg_write(dev, 0x0271, 0x4C);	// Write Tx Synth Integer Freq Word[7:0] (starts VCO cal)
    status = ad9361_reg_write(dev, 0x0005, 0x11);	// Set LO divider setting

//************************************************************
// Program Mixer GM Sub-table
//************************************************************
    status = ad9361_reg_write(dev, 0x013F, 0x02);	// Start Clock
    status = ad9361_reg_write(dev, 0x0138, 0x0F);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x78);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x00);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x0E);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x74);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x0D);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x0D);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x70);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x15);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x0C);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x6C);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x1B);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x0B);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x68);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x21);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x0A);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x64);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x25);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x09);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x60);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x29);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x08);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x5C);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x2C);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x07);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x58);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x2F);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x06);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x54);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x31);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x05);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x50);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x33);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x04);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x4C);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x34);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x03);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x48);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x35);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x02);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x30);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x3A);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x01);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x18);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x3D);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x0138, 0x00);	// Addr Table Index
    status = ad9361_reg_write(dev, 0x0139, 0x00);	// Gain
    status = ad9361_reg_write(dev, 0x013A, 0x00);	// Bias
    status = ad9361_reg_write(dev, 0x013B, 0x3E);	// GM
    status = ad9361_reg_write(dev, 0x013F, 0x06);	// Write Words
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x013F, 0x02);	// Clear Write Bit
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
    status = ad9361_reg_write(dev, 0x013C, 0x00);	// Delay ~1us (Dummy Write)
    status = ad9361_reg_write(dev, 0x013F, 0x00);	// Stop Clock

//************************************************************
// Program Rx Gain Tables with GainTable800MHz.csv
//************************************************************

    status = ad9361_reg_write(dev, 0x0137, 0x1A);	// Start Gain Table Clock
    status = ad9361_reg_write(dev, 0x0130, 0x00);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x01);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x02);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x03);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x01);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x04);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x02);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x05);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x03);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x06);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x04);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x07);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x05);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x08);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x01);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x03);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x09);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x01);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x04);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x0A);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x01);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x05);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x0B);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x01);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x06);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x0C);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x01);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x07);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x0D);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x01);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x08);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x0E);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x01);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x09);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x0F);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x01);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x0A);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x10);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x01);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x0B);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x11);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x01);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x0C);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x12);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x01);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x0D);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x13);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x01);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x0E);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x14);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x02);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x09);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x15);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x02);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x0A);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x16);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x02);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x0B);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x17);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x02);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x0C);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x18);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x02);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x0D);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x19);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x02);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x0E);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x1A);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x02);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x0F);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x1B);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x02);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x10);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x1C);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x02);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x2B);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x1D);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x02);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x2C);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x1E);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x04);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x28);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x1F);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x04);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x29);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x20);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x04);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x2A);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x21);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x04);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x2B);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x22);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x24);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x20);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x23);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x24);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x21);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x24);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x20);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x25);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x21);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x26);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x22);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x27);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x23);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x28);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x24);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x29);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x25);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x2A);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x26);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x2B);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x27);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x2C);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x28);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x2D);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x29);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x2E);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x2A);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x2F);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x2B);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x30);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x2C);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x31);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x2D);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x32);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x2E);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x33);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x2F);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x34);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x30);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x35);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x31);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x36);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x44);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x32);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x37);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x64);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x2E);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x38);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x64);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x2F);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x39);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x64);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x30);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x3A);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x64);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x31);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x3B);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x64);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x32);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x3C);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x64);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x33);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x3D);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x64);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x34);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x3E);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x64);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x35);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x3F);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x64);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x36);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x40);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x64);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x37);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x41);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x64);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x38);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x42);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x65);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x38);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x43);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x66);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x38);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x44);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x67);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x38);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x45);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x68);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x38);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x46);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x69);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x38);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x47);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x6A);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x38);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x48);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x6B);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x38);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x49);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x6C);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x38);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x4A);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x6D);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x38);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x4B);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x6E);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x38);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x4C);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x6F);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x38);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x20);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x4D);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x4E);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x4F);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x50);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x51);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x52);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x53);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x54);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x55);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x56);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x57);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x58);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x59);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0130, 0x5A);	// Gain Table Index
    status = ad9361_reg_write(dev, 0x0131, 0x00);	// Ext LNA, Int LNA, & Mixer Gain Word
    status = ad9361_reg_write(dev, 0x0132, 0x00);	// TIA & LPF Word
    status = ad9361_reg_write(dev, 0x0133, 0x00);	// DC Cal bit & Dig Gain Word
    status = ad9361_reg_write(dev, 0x0137, 0x1E);	// Write Words
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay 3 ADCCLK/16 cycles
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0137, 0x1A);	// Clear Write Bit
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0134, 0x00);	// Dummy Write to delay ~1us
    status = ad9361_reg_write(dev, 0x0137, 0x00);	// Stop Gain Table Clock
//************************************************************
// Setup Rx Manual Gain Registers
//************************************************************
    status = ad9361_reg_write(dev, 0x00FA, 0xE0);	// Gain Control Mode Select
    status = ad9361_reg_write(dev, 0x00FB, 0x08);	// Table, Digital Gain, Man Gain Ctrl
    status = ad9361_reg_write(dev, 0x00FC, 0x23);	// Incr Step Size, ADC Overrange Size
    status = ad9361_reg_write(dev, 0x00FD, 0x4C);	// Max Full/LMT Gain Table Index
    status = ad9361_reg_write(dev, 0x00FE, 0x44);	// Decr Step Size, Peak Overload Time
    status = ad9361_reg_write(dev, 0x0100, 0x6F);	// Max Digital Gain
    status = ad9361_reg_write(dev, 0x0104, 0x2F);	// ADC Small Overload Threshold
    status = ad9361_reg_write(dev, 0x0105, 0x3A);	// ADC Large Overload Threshold
    status = ad9361_reg_write(dev, 0x0107, 0x2B);	// Small LMT Overload Threshold
    status = ad9361_reg_write(dev, 0x0108, 0x31);	// Large LMT Overload Threshold
    status = ad9361_reg_write(dev, 0x0109, 0x00);	// Rx1 Full/LMT Gain Index
    status = ad9361_reg_write(dev, 0x010A, 0x58);	// Rx1 LPF Gain Index
    status = ad9361_reg_write(dev, 0x010B, 0x00);	// Rx1 Digital Gain Index
    status = ad9361_reg_write(dev, 0x010C, 0x00);	// Rx2 Full/LMT Gain Index
    status = ad9361_reg_write(dev, 0x010D, 0x18);	// Rx2 LPF Gain Index
    status = ad9361_reg_write(dev, 0x010E, 0x00);	// Rx2 Digital Gain Index
    status = ad9361_reg_write(dev, 0x0114, 0x30);	// Low Power Threshold
    status = ad9361_reg_write(dev, 0x011A, 0x27);	// Initial LMT Gain Limit
    status = ad9361_reg_write(dev, 0x0081, 0x00);	// Tx Symbol Gain Control
//************************************************************
// RX Baseband Filter Tuning (Real BW: 20.000000 MHz) 3dB Filter
// Corner @ 28.000000 MHz)
//************************************************************
    status = ad9361_reg_write(dev, 0x01FB, 0x14);	// RX Freq Corner (MHz)
    status = ad9361_reg_write(dev, 0x01FC, 0x00);	// RX Freq Corner (Khz)
    status = ad9361_reg_write(dev, 0x01F8, 0x05);	// Rx BBF Tune Divider[7:0]
    status = ad9361_reg_write(dev, 0x01F9, 0x1E);	// RX BBF Tune Divider[8]

    status = ad9361_reg_write(dev, 0x01D5, 0x3F);	// Set Rx Mix LO CM
    status = ad9361_reg_write(dev, 0x01C0, 0x03);	// Set GM common mode
    status = ad9361_reg_write(dev, 0x01E2, 0x02);	// Enable Rx1 Filter Tuner
    status = ad9361_reg_write(dev, 0x01E3, 0x02);	// Enable Rx2 Filter Tuner
    status = ad9361_reg_write(dev, 0x0016, 0x80);	// Start RX Filter Tune

    // Wait for RX filter to tune, Max Cal Time: 2.648 us (Done when 0x016[7]==0)
	time_out_cnt = 0;
	do{
		status |= ad9361_reg_read(dev, 0x0016, &value);
		mdelay(1);// Wait 1ms
		time_out_cnt++;
	} while((value & 0x80) != 0x00 && time_out_cnt <= TIMEOUT_TH);

    status = ad9361_reg_write(dev, 0x01E2, 0x03);	// Disable Rx Filter Tuner (Rx1)
    status = ad9361_reg_write(dev, 0x01E3, 0x03);	// Disable Rx Filter Tuner (Rx2)
//************************************************************
// TX Baseband Filter Tuning (Real BW: 20.000000 MHz) 3dB Filter
// Corner @ 32.000000 MHz)
//************************************************************
    status = ad9361_reg_write(dev, 0x00D6, 0x04);	// TX BBF Tune Divider[7:0]
    status = ad9361_reg_write(dev, 0x00D7, 0x1E);	// TX BBF Tune Divider[8]

    status = ad9361_reg_write(dev, 0x00CA, 0x22);	// Enable Tx Filter Tuner
    status = ad9361_reg_write(dev, 0x0016, 0x40);	// Start Tx Filter Tune

    // Wait for TX filter to tune, Max Cal Time: 1.233 us (Done when 0x016[6]==0)
	time_out_cnt = 0;
	do{
		status |= ad9361_reg_read(dev, 0x0016, &value);
		mdelay(1);// Wait 1ms
		time_out_cnt++;
	} while((value & 0x40) != 0x00 && time_out_cnt <= TIMEOUT_TH);

    status = ad9361_reg_write(dev, 0x00CA, 0x26);	// Disable Tx Filter Tuner (Both Channels)
//************************************************************
// RX TIA Setup:  Setup values scale based on RxBBF calibration
// results.  See information in Calibration Guide.
//************************************************************
    status = ad9361_reg_write(dev, 0x01DB, 0x20);	// Set TIA selcc[2:0]
    status = ad9361_reg_write(dev, 0x01DD, 0x00);	// Set RX TIA1 C MSB[6:0]
    status = ad9361_reg_write(dev, 0x01DF, 0x00);	// Set RX TIA2 C MSB[6:0]
    status = ad9361_reg_write(dev, 0x01DC, 0x47);	// Set RX TIA1 C LSB[5:0]
    status = ad9361_reg_write(dev, 0x01DE, 0x47);	// Set RX TIA2 C LSB[5:0]

//************************************************************
// TX Secondary Filter Calibration Setup:  Real Bandwidth
// 20.000000MHz, 3dB Corner @ 100.000000MHz
//************************************************************
    status = ad9361_reg_write(dev, 0x00D2, 0x04);	// TX Secondary Filter PDF Cap cal[5:0]
    status = ad9361_reg_write(dev, 0x00D1, 0x0C);	// TX Secondary Filter PDF Res cal[3:0]
    status = ad9361_reg_write(dev, 0x00D0, 0x57);	// Pdampbias

//************************************************************
// ADC Setup:  Tune ADC Performance based on RX analog filter tune
// corner.  Real Bandwidth: 18.155158 MHz, ADC Clock Frequency:
// 288.000000 MHz.  The values in registers 0x200 - 0x227 need to be
// calculated using the equations in the Calibration Guide.
//************************************************************

    status = ad9361_reg_write(dev, 0x0200, 0x00);
    status = ad9361_reg_write(dev, 0x0201, 0x00);
    status = ad9361_reg_write(dev, 0x0202, 0x00);
    status = ad9361_reg_write(dev, 0x0203, 0x24);
    status = ad9361_reg_write(dev, 0x0204, 0x24);
    status = ad9361_reg_write(dev, 0x0205, 0x00);
    status = ad9361_reg_write(dev, 0x0206, 0x00);
    status = ad9361_reg_write(dev, 0x0207, 0x67);
    status = ad9361_reg_write(dev, 0x0208, 0x55);
    status = ad9361_reg_write(dev, 0x0209, 0x31);
    status = ad9361_reg_write(dev, 0x020A, 0x3E);
    status = ad9361_reg_write(dev, 0x020B, 0x35);
    status = ad9361_reg_write(dev, 0x020C, 0x41);
    status = ad9361_reg_write(dev, 0x020D, 0x34);
    status = ad9361_reg_write(dev, 0x020E, 0x00);
    status = ad9361_reg_write(dev, 0x020F, 0x6A);
    status = ad9361_reg_write(dev, 0x0210, 0x6A);
    status = ad9361_reg_write(dev, 0x0211, 0x6A);
    status = ad9361_reg_write(dev, 0x0212, 0x3C);
    status = ad9361_reg_write(dev, 0x0213, 0x3C);
    status = ad9361_reg_write(dev, 0x0214, 0x3C);
    status = ad9361_reg_write(dev, 0x0215, 0x3F);
    status = ad9361_reg_write(dev, 0x0216, 0x3F);
    status = ad9361_reg_write(dev, 0x0217, 0x3F);
    status = ad9361_reg_write(dev, 0x0218, 0x2E);
    status = ad9361_reg_write(dev, 0x0219, 0x9C);
    status = ad9361_reg_write(dev, 0x021A, 0x1F);
    status = ad9361_reg_write(dev, 0x021B, 0x15);
    status = ad9361_reg_write(dev, 0x021C, 0x9C);
    status = ad9361_reg_write(dev, 0x021D, 0x1F);
    status = ad9361_reg_write(dev, 0x021E, 0x15);
    status = ad9361_reg_write(dev, 0x021F, 0x9C);
    status = ad9361_reg_write(dev, 0x0220, 0x1F);
    status = ad9361_reg_write(dev, 0x0221, 0x2A);
    status = ad9361_reg_write(dev, 0x0222, 0x2A);
    status = ad9361_reg_write(dev, 0x0223, 0x40);
    status = ad9361_reg_write(dev, 0x0224, 0x40);
    status = ad9361_reg_write(dev, 0x0225, 0x2C);
    status = ad9361_reg_write(dev, 0x0226, 0x00);
    status = ad9361_reg_write(dev, 0x0227, 0x00);
//************************************************************
// Setup and Run BB DC and RF DC Offset Calibrations
//************************************************************
    status = ad9361_reg_write(dev, 0x0193, 0x3F);
    status = ad9361_reg_write(dev, 0x0190, 0x0F);	// Set BBDC tracking shift M value, only applies when BB DC tracking enabled
    status = ad9361_reg_write(dev, 0x0194, 0x01);	// BBDC Cal setting
    status = ad9361_reg_write(dev, 0x0016, 0x01);	// Start BBDC offset cal

    // BBDC Max Cal Time: 8416.667 us. Cal done when 0x016[0]==0
	time_out_cnt = 0;
	do{
		status |= ad9361_reg_read(dev, 0x0016, &value);
		mdelay(1);// Wait 1ms
		time_out_cnt++;
	} while((value & 0x01) != 0x00 && time_out_cnt <= TIMEOUT_TH);

    status = ad9361_reg_write(dev, 0x0185, 0x20);	// Set RF DC offset Wait Count
    status = ad9361_reg_write(dev, 0x0186, 0x32);	// Set RF DC Offset Count[7:0]
    status = ad9361_reg_write(dev, 0x0187, 0x24);	// Settings for RF DC cal
    status = ad9361_reg_write(dev, 0x018B, 0x83);	// Settings for RF DC cal
    status = ad9361_reg_write(dev, 0x0188, 0x05);	// Settings for RF DC cal
    status = ad9361_reg_write(dev, 0x0189, 0x30);	// Settings for RF DC cal
    status = ad9361_reg_write(dev, 0x0016, 0x02);	// Start RFDC offset cal

    // RFDC Max Cal Time: 114511.250 us
	time_out_cnt = 0;
	do{
		status |= ad9361_reg_read(dev, 0x0016, &value);
		mdelay(1);// Wait 1ms
		time_out_cnt++;
	} while((value & 0x01) != 0x00 && time_out_cnt <= TIMEOUT_TH);

//************************************************************
// Tx Quadrature Calibration Settings
//************************************************************
    status = ad9361_reg_write(dev, 0x00A0, 0x5F);	// Set TxQuadcal NCO frequency
    status = ad9361_reg_write(dev, 0x00A3, 0x80);	// Set TxQuadcal NCO frequency (Only update bits [7:6])
    status = ad9361_reg_write(dev, 0x00A1, 0x7B);	// Tx Quad Cal Configuration, Phase and Gain Cal Enable
    status = ad9361_reg_write(dev, 0x00A9, 0xFF);	// Set Tx Quad Cal Count
    status = ad9361_reg_write(dev, 0x00A2, 0x7F);	// Set Tx Quad Cal Kexp
    status = ad9361_reg_write(dev, 0x00A5, 0x01);	// Set Tx Quad Cal Magnitude Threshhold
    status = ad9361_reg_write(dev, 0x00A6, 0x01);	// Set Tx Quad Cal Magnitude Threshhold
    status = ad9361_reg_write(dev, 0x00AA, 0x22);	// Set Tx Quad Cal Gain Table index
    status = ad9361_reg_write(dev, 0x00A4, 0xF0);	// Set Tx Quad Cal Settle Count
    status = ad9361_reg_write(dev, 0x00AE, 0x00);	// Set Tx Quad Cal LPF Gain index incase Split table mode used

    status = ad9361_reg_write(dev, 0x0169, 0xC0);	// Disable Rx Quadrature Calibration before Running Tx Quadrature Calibration
    status = ad9361_reg_write(dev, 0x0016, 0x10);	// Start Tx Quad cal

    // Wait for cal to complete (Done when 0x016[4]==0)
	time_out_cnt = 0;
	do{
		status |= ad9361_reg_read(dev, 0x0016, &value);
		mdelay(1);// Wait 1ms
		time_out_cnt++;
	} while((value & 0x10) != 0x00 && time_out_cnt <= TIMEOUT_TH);

    status = ad9361_reg_write(dev, 0x016A, 0x75);	// Set Kexp Phase
    status = ad9361_reg_write(dev, 0x016B, 0x95);	// Set Kexp Amplitude & Prevent Positive Gain Bit
    status = ad9361_reg_write(dev, 0x0169, 0xCF);	// Enable Rx Quadrature Calibration Tracking
    status = ad9361_reg_write(dev, 0x018B, 0xAD);	// Enable BB and RF DC Tracking Calibrations
    status = ad9361_reg_write(dev, 0x0012, 0x02);	// Cals done, Set PPORT Config
    status = ad9361_reg_write(dev, 0x0013, 0x01);	// Set ENSM FDD/TDD bit
    status = ad9361_reg_write(dev, 0x0015, 0x0C);	// Set Dual Synth Mode, FDD External Control bits properly

//************************************************************
// Set Tx Attenuation: Tx1: 0.00 dB,  Tx2: 0.00 dB
//************************************************************
    status = ad9361_reg_write(dev, 0x0073, 0x00);
    status = ad9361_reg_write(dev, 0x0074, 0x00);
    status = ad9361_reg_write(dev, 0x0075, 0x00);
    status = ad9361_reg_write(dev, 0x0076, 0x00);
//************************************************************
// Setup RSSI and Power Measurement Duration Registers
//************************************************************
    status = ad9361_reg_write(dev, 0x0150, 0x0E);	// RSSI Measurement Duration 0, 1
    status = ad9361_reg_write(dev, 0x0151, 0x00);	// RSSI Measurement Duration 2, 3
    status = ad9361_reg_write(dev, 0x0152, 0xFF);	// RSSI Weighted Multiplier 0
    status = ad9361_reg_write(dev, 0x0153, 0x00);	// RSSI Weighted Multiplier 1
    status = ad9361_reg_write(dev, 0x0154, 0x00);	// RSSI Weighted Multiplier 2
    status = ad9361_reg_write(dev, 0x0155, 0x00);	// RSSI Weighted Multiplier 3
    status = ad9361_reg_write(dev, 0x0156, 0x00);	// RSSI Delay
    status = ad9361_reg_write(dev, 0x0157, 0x00);	// RSSI Wait
    status = ad9361_reg_write(dev, 0x0158, 0x0D);	// RSSI Mode Select
    status = ad9361_reg_write(dev, 0x015C, 0x67);	// Power Measurement Duration

    return status;
}

#endif
