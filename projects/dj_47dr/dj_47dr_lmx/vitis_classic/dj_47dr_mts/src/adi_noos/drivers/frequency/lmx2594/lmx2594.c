/***************************************************************************//**
 * @file lmx2594.c
 * @brief Implementation of AD9680 Driver.
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

/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include "../lmx2594/lmx2594.h"

#include <stdlib.h>
#include <stdio.h>
#include "../../../include/error.h"

/***************************************************************************//**
 * @brief lmx2594_read
 *******************************************************************************/
int32_t lmx2594_read(struct lmx2594_dev *dev,
			uint8_t reg_addr,
			uint16_t *reg_data)
{
	uint8_t tx_buf[1];
	uint8_t rx_buf[2];
	int32_t ret;

	tx_buf[0] = 0x80 | reg_addr;


	ret = spi_write_and_read_3wire(dev->spi_desc,
			tx_buf, rx_buf, 1, 2);

	*reg_data = rx_buf[1];
	*reg_data |= ((uint16_t)rx_buf[0]) << 8;

	return ret;
}

/***************************************************************************//**
 * @brief lmx2594_write
 *******************************************************************************/
int32_t lmx2594_write(struct lmx2594_dev *dev,
			 uint8_t reg_addr,
			 uint16_t reg_data)
{
	uint8_t buf[3];

	int32_t ret;

	buf[0] = reg_addr;
	buf[1] = reg_data >> 8;
	buf[2] = reg_data & 0xFF;

	ret = spi_write_and_read_3wire(dev->spi_desc,
				 buf, NULL, 3, 0);
	return ret;
}

/***************************************************************************//**
 * @brief lmx2594_init
 *******************************************************************************/
int32_t lmx2594_init(struct lmx2594_dev **device,
		     const struct lmx2594_init_param *init_param)
{
	int ret = SUCCESS;
	struct lmx2594_dev *dev;

	dev = (struct lmx2594_dev *)malloc(sizeof(*dev));
	if (!dev)
		return FAILURE;

	/* SPI */
	ret = spi_init(&dev->spi_desc, init_param->spi_init);

	*device = dev;

	return ret;
}

/***************************************************************************//**
 * @brief Free the resources allocated by lmx2594_setup().
 *
 * @param dev - The device structure.
 *
 * @return SUCCESS in case of success, negative error code otherwise.
*******************************************************************************/
int32_t lmx2594_remove(struct lmx2594_dev *dev)
{
	int32_t ret;

	ret = spi_remove(dev->spi_desc);

	free(dev);

	return ret;
}
