/*****************************************************************************/
/**
 * Description: hwconfig.h
 *

 * Date: 2024-02-20 13:19
 * Last Edit Time: [2024-02-20 13:19]
 *
 * Revisions: Rev 0.0
 * History:
 * [2023-05-07]: Initial edition.
 *
 * Copyright(c) 2024 Beijing Institute of Technology.
 *
 ******************************************************************************/

/***************************** Include Files *********************************/
// Standard
#include <stdint.h>
#include <stdbool.h>
// Xilinx
#include "xgpiops.h"
#include "drivers/rf-transceiver/ad9361_reg/ad9361_reg.h"
#include "drivers/rf-transceiver/ad9361/ad9361_api.h"
#include "drivers/axi_core/spi_engine/spi_engine.h"
// App
#include "common.h"
#include "error.h"
#include "delay.h"
#include "system_monitor.h"
#include "hwconfig.h"
#include "config/app_config.h"
#include "dev_profile/dev_profile.h"

/************************** Function Prototypes ******************************/
/*********************** Driver Instance Definitions **************************/
ad9528Device_t *ad9528_inst;
static struct ad9361_reg_dev *ad9361_1_reg_inst;
static struct ad9361_reg_dev *ad9361_2_reg_inst;
static struct ad9653_dev *ad9653_inst;
struct cx9261a_dev *cx9261a_inst;
// static struct ad9361_rf_phy *ad9361_phy;
// static struct ad9361_rf_phy *ad9361_2_phy;

/*****************************************************************************/
/**
 * @brief   Hardware_Init
 *
 * @param   none.
 *
 * @return  None.
 *
 ******************************************************************************/
int32_t Hardware_Init(void)
{
	int32_t Status;
	XGpioPs Gpio;
	XGpioPs_Config *ConfigPtr;
	ConfigPtr = XGpioPs_LookupConfig(AD9528_GPIO_DEVICE_ID);
	Status = XGpioPs_CfgInitialize(&Gpio, ConfigPtr, ConfigPtr->BaseAddr);
	if (Status != SUCCESS)
	{
		return FAILURE;
	}

	/**********************************************************/
	/****************** AD9528 Configuration ******************/
	/**********************************************************/
	Status = AD9528_init(&ad9528_inst, &ad9528_default_init_param);
	if (Status != SUCCESS) {
		DBG_ERROR("AD9528_init() error: %" PRId32 "\n", Status);
		return FAILURE;
	}

	Status = AD9528_config(ad9528_inst);
	if (Status != SUCCESS) {
		return FAILURE;
		DBG_ERROR("AD9528_config() error: %" PRId32 "\n", Status);
	}

	/**********************************************************/
	/***************** AD9361-1 Configuration *****************/
	/**********************************************************/
	XGpioPs_SetDirectionPin(&Gpio, AD9361_1_TXNRX, AD9361_GPIO_OUTPUT);
	XGpioPs_SetDirectionPin(&Gpio, AD9361_1_ENABLE, AD9361_GPIO_OUTPUT);
	XGpioPs_SetDirectionPin(&Gpio, AD9361_1_EN_AGC, AD9361_GPIO_OUTPUT);
	XGpioPs_SetDirectionPin(&Gpio, AD9361_1_RESET_B, AD9361_GPIO_OUTPUT);

	ad9361_reg_init(&ad9361_1_reg_inst, &ad9361_1_reg_default_init_param);
	XGpioPs_WritePin(&Gpio, AD9361_1_ENABLE, 0);
	ad9361_1_reg_config(ad9361_1_reg_inst);
	XGpioPs_WritePin(&Gpio, AD9361_1_ENABLE, 1);

	//	Status = ad9361_init(&ad9361_phy, &ad9361_default_init_param);
	//	if (Status != XST_SUCCESS){
	//		return XST_FAILURE;
	//	}else{
	//		printf("Configurate AD9361 Completely!\n");
	//	}
	//	ad9361_set_tx_fir_config(ad9361_phy, tx_fir_config);
	//	ad9361_set_rx_fir_config(ad9361_phy, rx_fir_config);

	/**********************************************************/
	/***************** AD9361-2 Configuration *****************/
	/**********************************************************/
	XGpioPs_SetDirectionPin(&Gpio, AD9361_2_TXNRX, AD9361_GPIO_OUTPUT);
	XGpioPs_SetDirectionPin(&Gpio, AD9361_2_ENABLE, AD9361_GPIO_OUTPUT);
	XGpioPs_SetDirectionPin(&Gpio, AD9361_2_EN_AGC, AD9361_GPIO_OUTPUT);
	XGpioPs_SetDirectionPin(&Gpio, AD9361_2_RESET_B, AD9361_GPIO_OUTPUT);

	ad9361_reg_init(&ad9361_2_reg_inst, &ad9361_2_reg_default_init_param);
	XGpioPs_WritePin(&Gpio, AD9361_2_ENABLE, 0);
	ad9361_2_reg_config(ad9361_2_reg_inst);
	XGpioPs_WritePin(&Gpio, AD9361_2_ENABLE, 1);

	//	uint8_t rd_back;
	//	Status = ad9361_reg_read(ad9361_1_reg_inst, 0x0002, &rd_back);
	//	Status = ad9361_reg_read(ad9361_2_reg_inst, 0x0002, &rd_back);

	Status = ad9361_reg_write(ad9361_1_reg_inst, 0x0109, 0x00); // Rx Gain
	Status = ad9361_reg_write(ad9361_1_reg_inst, 0x010C, 0x00); // Rx Gain
	Status = ad9361_reg_write(ad9361_2_reg_inst, 0x0109, 0x00); // Rx Gain
	Status = ad9361_reg_write(ad9361_2_reg_inst, 0x010C, 0x00); // Rx Gain

//	Status = ad9361_reg_write(ad9361_1_reg_inst, 0x03F5, 0x01); // BIST Data Port Loop
//	Status = ad9361_reg_write(ad9361_2_reg_inst, 0x03F5, 0x01); // BIST Data Port Loop

	/**********************************************************/
	/****************** AD9653 Configuration ******************/
	/**********************************************************/
	Status = ad9653_init(&ad9653_inst, &ad9653_default_init_param);
	for(int i = 0; i < ad9653_default_config_len; i++){
		Status = ad9653_write(ad9653_inst, ad9653_default_config[i].addr,
				ad9653_default_config[i].value);
		if (ad9653_default_config[i].addr == 0x0000){
			mdelay(500);
		}
	}

	DBG_PRINT("Done.\n");

	return SUCCESS;
}

// @ Get AD9361 - 1 temperature (Celsius Degree)
/**
 * Read corresponding register to get AD9361 - 1 current temperature.
 */
int8_t Hardware_GetAD9361Temp_1(void)
{
	int8_t scaleTemp;
	double temp;

	ad9361_reg_write(ad9361_1_reg_inst, 0x000B, -64);
	ad9361_reg_write(ad9361_1_reg_inst, 0x001D, 0x01); // disable aux adc
	ad9361_reg_read(ad9361_1_reg_inst, 0x000E, (uint8_t*)&scaleTemp);
	ad9361_reg_write(ad9361_1_reg_inst, 0x001D, 0x00); // enable aux adc

	temp = ((double)scaleTemp + 64)/1.16;
	return ((temp > INT8_MAX) ? INT8_MAX : (int8_t)temp);
}

// @ Get AD9361 - 2 temperature (Celsius Degree)
/**
 * Read corresponding register to get AD9361 - 2 current temperature.
 */
int8_t Hardware_GetAD9361Temp_2(void)
{
	int8_t scaleTemp;
	double temp;

	ad9361_reg_write(ad9361_2_reg_inst, 0x000B, -64);
	ad9361_reg_write(ad9361_2_reg_inst, 0x001D, 0x01); // disable aux adc
	ad9361_reg_read(ad9361_2_reg_inst, 0x000E, (uint8_t*)&scaleTemp);
	ad9361_reg_write(ad9361_2_reg_inst, 0x001D, 0x00); // enable aux adc
	temp = ((double)scaleTemp + 64)/1.16;
	return ((temp > INT8_MAX) ? INT8_MAX : (int8_t)temp);
}

// @ Determine AD9361 lock state
/**
 * Read corresponding register to determine AD9361(both) lock state.
 */
uint8_t Hardware_GetAD9361LockStatus(void)
{
	uint8_t ret = 0;
	uint8_t regVal;

	// bbpll
	ad9361_reg_read(ad9361_1_reg_inst, 0x005E, &regVal); // [D7] is lock indicator
	ret |= ((regVal & 0x80) == 0x80) ? CLK_AD0_BBPLL_LOCK : 0;
	ad9361_reg_read(ad9361_2_reg_inst, 0x005E, &regVal); // [D7] is lock indicator
	ret |= ((regVal & 0x80) == 0x80) ? CLK_AD1_BBPLL_LOCK : 0;

	// rfpll
	ad9361_reg_read(ad9361_1_reg_inst, 0x0287, &regVal); // [D1] is lock indicator
	ret |= ((regVal & 0x02) == 0x02) ? CLK_AD0_RFPLL_LOCK : 0;
	ad9361_reg_read(ad9361_2_reg_inst, 0x0287, &regVal); // [D1] is lock indicator
	ret |= ((regVal & 0x02) == 0x02) ? CLK_AD1_RFPLL_LOCK : 0;

	return ret;
}

// @ Determine AD9528 lock state
/**
 * Read corresponding register to determine clock lock state.
 */
uint8_t Hardware_GetAD9528LockStatus(void)
{
	uint8_t ret = 0;
	uint8_t regVal;

	// pll1
	AD9528_spiReadByte(ad9528_inst, AD9528_ADDR_STATUS_READBACK0, &regVal); // [D0] is lock indicator
	ret |= ((regVal & 0x01) == 0x01) ? CLK_SP_PLL1_LOCK : 0;

	// pll2
	AD9528_spiReadByte(ad9528_inst, AD9528_ADDR_STATUS_READBACK0, &regVal); // [D1] is lock indicator
	ret |= ((regVal & 0x02) == 0x02) ? CLK_SP_PLL2_LOCK : 0;

	return ret;
}
