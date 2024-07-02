/***************************************************************************//**
 *   @file   ad9361/src/main.c
 *   @brief  Implementation of Main Function.
 *   @author DBogdan (dragos.bogdan@analog.com)
********************************************************************************
 * Copyright 2013(c) Analog Devices, Inc.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  - Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *  - Neither the name of Analog Devices, Inc. nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *  - The use of this software may or may not infringe the patent rights
 *    of one or more patent holders.  This license does not release you
 *    from the requirement that you obtain separate licenses from these
 *    patent holders to use this software.
 *  - Use of the software either in source or binary form, must be run
 *    on or directly connected to an Analog Devices Inc. component.
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
// Platform includes
#include <inttypes.h>
#include <xparameters.h>
#include <xil_mmu.h>
#include "xgpiops.h"
#include "xrfdc.h"
// ADI Drivers
#include "app_config.h"
#include "dev_profile/dev_profile.h"
#include "adi_noos/drivers/axi_core/spi_engine/spi_engine.h"
// AXI-Cores includes
#include "adi_noos/drivers/axi_core/spi_engine/spi_engine.h"
#include "adi_noos/drivers/platform/gpio_extra.h"

/******************************************************************************/
/************************ Variables Definitions *******************************/
/******************************************************************************/

struct spi_engine_init_param spi_engine_param = {
	.ref_clk_hz = SPI_ENGINE_REF_CLK,
	.type = SPI_ENGINE,
	.spi_engine_baseaddr = SPI_ENGINE_BASEADDR,
	.cs_delay = SPI_ENGINE_CS_DELAY,
	.data_width = SPI_ENGINE_DATA_WIDTH
};

struct xil_gpio_init_param xil_gpio_param = {
	.type = GPIO_PS,
	.device_id = GPIO_DEVICE_ID
};

struct lmk04828_dev *lmk04828_inst;

XRFdc	RFdc;
XGpioPs Gpio;

/***************************************************************************//**
 * @brief main
*******************************************************************************/
int main(void)
{
	int32_t Status;

	// gpio initialization
	XGpioPs_Config *ConfigPtr;
	ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
	Status = XGpioPs_CfgInitialize(&Gpio, ConfigPtr, ConfigPtr->BaseAddr);
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	// rf data converter initialization
	XRFdc_Config *RFdc_ConfigPtr;
	RFdc_ConfigPtr = XRFdc_LookupConfig(RFDC_DEVICE_ID);
	Status = XRFdc_CfgInitialize(&RFdc, RFdc_ConfigPtr);
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	/**********************************************************/
	/***************** LMK04828 Configuration *****************/
	/**********************************************************/
	Status = lmk04828_init(&lmk04828_inst, &lmk04828_default_init_param);
	for(int i = 0; i < lmk04828_default_config_len; i++)
	{
		Status = lmk04828_write(lmk04828_inst, lmk04828_default_config[i].addr, lmk04828_default_config[i].value);
		if (lmk04828_default_config[i].addr == 0x0000)
		{
			mdelay(500);
		}
	}

    // check pll2 lock status
    uint8_t reg183;
    Status = lmk04828_read(lmk04828_inst, 0x0183, &reg183);
    if (reg183 & 0x02) {
        xil_printf("LMK04828 Config Done.\n");
    }
    else {
        xil_printf("LMK04828 not lock!\n");
        return XST_FAILURE;
    }

	print("Done.\n");

	return 0;
}
