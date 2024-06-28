#ifndef DEV_PROFILE_H_
#define DEV_PROFILE_H_

#include <inttypes.h>
#include "../app_config.h"
#include "../adi_noos/include/spi.h"
#include "../adi_noos/include/gpio.h"
#include "../adi_noos/include/delay.h"
#include "../adi_noos/include/irq.h"
#include "../adi_noos/include/error.h"
#include "../adi_noos/drivers/frequency/lmk04828/lmk04828.h"

// Platform includes
#include "../adi_noos/drivers/platform/spi_extra.h"
#include "../adi_noos/drivers/platform/gpio_extra.h"
#include "../adi_noos/drivers/platform/irq_extra.h"

// AXI-Cores includes
#include "../adi_noos/drivers/axi_core/spi_engine/spi_engine.h"

// Declare in mian.c
extern struct spi_engine_init_param spi_engine_param;
extern struct xil_gpio_init_param xil_gpio_param;

#define GPIO_PARAM	&xil_gpio_param
#define SPI_PARAM	&spi_engine_param
#define GPIO_OPS	&xil_gpio_ops
#define SPI_OPS		&spi_eng_platform_ops

extern struct lmk04828_init_param lmk04828_default_init_param;
extern const struct lmk04828_config lmk04828_default_config[];
extern const uint32_t lmk04828_default_config_len;

#endif /* SRC_DEV_PROFILE_H_ */
