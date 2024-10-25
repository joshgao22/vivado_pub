/***************************************************************************//**
 * @file ad9361_reg.h
 * @brief Header file of ad9361_reg Driver.
 * @author DBogdan (dragos.bogdan@analog.com)
 ********************************************************************************
 * Copyright 2014-2016(c) Analog Devices, Inc.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * - Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in
 * the documentation and/or other materials provided with the
 * distribution.
 * - Neither the name of Analog Devices, Inc. nor the names of its
 * contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 * - The use of this software may or may not infringe the patent rights
 * of one or more patent holders. This license does not release you
 * from the requirement that you obtain separate licenses from these
 * patent holders to use this software.
 * - Use of the software either in source or binary form, must be run
 * on or directly connected to an Analog Devices Inc. component.
 *
 * THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT,
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *******************************************************************************/
#ifndef ad9361_reg_H_
#define ad9361_reg_H_

/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include <stdint.h>
#include "delay.h"
#include "spi.h"
#include "gpio.h"

/******************************************************************************/
/********************** Macros and Constants Definitions **********************/
/******************************************************************************/


/******************************************************************************/
/*************************** Types Declarations *******************************/
/******************************************************************************/
struct ad9361_reg_dev {
	/* SPI */
	struct spi_desc	*spi_desc;
	struct gpio_desc 	*gpio_desc_resetb;
};

struct ad9361_reg_init_param {
	/* SPI */
	struct spi_init_param	*spi_init;
	struct gpio_init_param	*gpio_resetb;
};

enum Operation_Type{
	AD9361_WRITE,
	AD9361_READ,
	AD9361_WAIT,
	AD9361_WHEN
};

struct ad9361_reg_config {
	int operation;
	uint16_t val1;
	uint16_t val2;
};

/******************************************************************************/
/************************ Functions Declarations ******************************/
/******************************************************************************/

int32_t ad9361_reg_read(struct ad9361_reg_dev *dev,
			uint16_t reg_addr,
			uint8_t *reg_data);

int32_t ad9361_reg_write(struct ad9361_reg_dev *dev,
			 uint16_t reg_addr,
			 uint8_t reg_data);

int32_t ad9361_reg_init(struct ad9361_reg_dev **device,
		     const struct ad9361_reg_init_param *init_param);

int32_t ad9361_reg_reset(struct ad9361_reg_dev *dev);

int32_t ad9361_reg_remove(struct ad9361_reg_dev *dev);

#endif
