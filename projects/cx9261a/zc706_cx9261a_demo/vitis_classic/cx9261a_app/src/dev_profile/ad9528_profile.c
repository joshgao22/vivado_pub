#include "dev_profile.h"
#include "../config/app_config.h"
#include "../drivers/platform/xilinx_gpio.h"
#include "../drivers/axi_core/spi_engine/spi_engine.h"
#include "../drivers/frequency/ad9528/ad9528.h"

#ifdef AD9528

static struct spi_engine_init_param spi_engine_param = {
	.ref_clk_hz = AD9528_SPI_ENGINE_REF_CLK,
	.type = SPI_ENGINE,
	.spi_engine_baseaddr = AD9528_SPI_ENGINE_BASEADDR,
	.cs_delay = AD9528_SPI_ENGINE_CS_DELAY,
	.data_width = AD9528_SPI_ENGINE_DATA_WIDTH
};

static struct xil_gpio_init_param xil_gpio_param = {
	.type = GPIO_PS,
	.device_id = AD9528_GPIO_DEVICE_ID
};

static struct spi_init_param ad9528_spi_init = {
	.device_id = AD9528_SPI_DEVICE_ID,
    .max_speed_hz = AD9528_SPI_ENGINE_MAX_SPEED,
	.chip_select = AD9528_SPI_CS,
	.mode = SPI_MODE_0,
	.platform_ops = &spi_eng_platform_ops,
	.extra = &spi_engine_param
};

static struct gpio_init_param ad9528_gpio_resetb_init = {
	.number = AD9528_RESETB,
	.platform_ops = &xil_gpio_ops,
	.extra = &xil_gpio_param
};

static struct gpio_init_param ad9528_gpio_sysref_req_init = {
	.number = AD9528_SYSREF_REQ,
	.platform_ops = &xil_gpio_ops,
	.extra = &xil_gpio_param
};

static ad9528pll1Settings_t clockPll1Settings = {
    .refA_Frequency_Hz  = 50000000,
    .refA_Divider       = 1,
    .refA_bufferCtrl    = SINGLE_ENDED,
    .refB_Frequency_Hz  = 0,
    .refB_Divider       = 1,
    .refB_bufferCtrl    = DISABLED,
    .vcxo_Frequency_Hz  = 50000000,
    .vcxoBufferCtrl     = SINGLE_ENDED,
    .nDivider           = 1
};

static ad9528pll2Settings_t clockPll2Settings = {
    .rfDivider = 4,
    .n2Divider = 20,
    .totalNdiv = 80
};

/*******************************************************************
 * Output Distribution Settings
 * 9369CE02A uses the following clock outputs
 * OUT 1: FPGA REFCLK
 * OUT 3: FPGA SYSREF
 * OUT 12: DUT SYSREF
 * OUT 13: DUT REFCLK
 *******************************************************************
 */
static ad9528outputSettings_t clockOutputSettings = {
    .outPowerDown = 0xE001,
    .outSource = {
            AD9528_CHANNEL_DIV, AD9528_CHANNEL_DIV, AD9528_CHANNEL_DIV, AD9528_CHANNEL_DIV, AD9528_CHANNEL_DIV,
			AD9528_CHANNEL_DIV, AD9528_CHANNEL_DIV, AD9528_CHANNEL_DIV, AD9528_CHANNEL_DIV, AD9528_CHANNEL_DIV,
			AD9528_CHANNEL_DIV, AD9528_CHANNEL_DIV, AD9528_CHANNEL_DIV, AD9528_CHANNEL_DIV
    },
    .outBufferCtrl = {
    		0,0,0,0,0,
    		0,0,0,0,0,
			0,0,0,0
    },
    .outAnalogDelay = {
    		0,0,0,0,0,
    		0,0,0,0,0,
			0,0,0,0
    },
    .outDigitalDelay = {
    		0,0,0,0,0,
    		0,0,0,0,0,
			0,0,0,0
    },
    .outChannelDiv = {
    		5,25,25,5,5,
			5,5,5,5,5,
			5,5,10,5
    },
    .outFrequency_Hz    = {
            200e6, 40e6, 40e6, 200e6, 200e6,
			200e6, 200e6, 200e6, 200e6, 200e6,
			200e6, 200e6, 100e6, 200e6
    }
};

static ad9528sysrefSettings_t clockSysrefSettings = {
    .sysrefRequestMethod    = PIN,
    .sysrefSource           = INTERNAL,
    .sysrefPinEdgeMode      = LEVEL_ACTIVE_HIGH,
    .sysrefPinBufferMode    = DISABLED,
    .sysrefPatternMode      = CONTINUOUS,
    .sysrefNshotMode        = FOUR_PULSES,
    .sysrefDivide           = 256
};

static ad9528spiSettings_t clockSpiSettings = {
    .chipSelectIndex        = AD9528_SPI_CS, //chip select Index, not used
    .writeBitPolarity       = 0, //Write bit polarity
    .longInstructionWord    = 1, //16bit instruction word
    .MSBFirst               = 1, //MSB first
    .CPHA                   = 0, //Clock phase
    .CPOL                   = 0, //Clock polarity
    .enSpiStreaming         = 0, //uint8_t enSpiStreaming;
    .autoIncAddrUp          = 1, //uint8_t autoIncAddrUp;
    .fourWireMode           = 1  //uint8_t fourWireMode;
};

ad9528Init_t ad9528_default_init_param = {
	/* SPI */
	.gpio_init_resetb = &ad9528_gpio_resetb_init,
	.gpio_init_sysref_req = &ad9528_gpio_sysref_req_init,
	.spi_init = &ad9528_spi_init,
    .spiSettings = &clockSpiSettings,
    .pll1Settings = &clockPll1Settings,
    .pll2Settings = &clockPll2Settings,
    .outputSettings = &clockOutputSettings,
    .sysrefSettings = &clockSysrefSettings
};

#endif
