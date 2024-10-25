#include "dev_profile.h"
#include "spi.h"
#include "../config/app_config.h"
#include "../drivers/adc/ad9653/ad9653.h"
#include "../drivers/axi_core/spi_engine/spi_engine.h"
#include "../drivers/platform/xilinx_gpio.h"

#ifdef AD9653

static struct spi_engine_init_param spi_engine_param = {
	.ref_clk_hz = AD9653_SPI_ENGINE_REF_CLK,
	.type = SPI_ENGINE,
	.spi_engine_baseaddr = AD9653_SPI_ENGINE_BASEADDR,
	.cs_delay = AD9653_SPI_ENGINE_CS_DELAY,
	.data_width = AD9653_SPI_ENGINE_DATA_WIDTH
};

static struct xil_gpio_init_param xil_gpio_param = {
	.type = GPIO_PS,
	.device_id = AD9653_GPIO_DEVICE_ID
};

static struct spi_init_param ad9653_spi_init = {
	.device_id = AD9653_SPI_DEVICE_ID,
    .max_speed_hz = AD9653_SPI_ENGINE_MAX_SPEED,
	.chip_select = AD9653_SPI_CS,
	.mode = SPI_MODE_4,
	.platform_ops = &spi_eng_platform_ops,
	.extra = &spi_engine_param
};

static struct gpio_init_param ad9653_gpio_resetb_init = {
	.number = AD9653_POWR_DOWN,
	.platform_ops = &xil_gpio_ops,
	.extra = &xil_gpio_param
};

struct ad9653_init_param ad9653_default_init_param = {
	/* SPI */
	.spi_init = &ad9653_spi_init,
	.gpio_pdwn = &ad9653_gpio_resetb_init
};

const uint32_t ad9653_default_config_len = 36;
const struct ad9653_config ad9653_default_config[] = {
	// configuration

};

#endif
