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
 *  - Redistributions of source code must retain the above copyright00
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

//add

/************************** Constant Definitions ****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#ifdef __BAREMETAL__
#define RFDC_DEVICE_ID 	XPAR_XRFDC_0_DEVICE_ID
#define I2CBUS	1
#else
#define RFDC_DEVICE_ID 	0
#define I2CBUS	12
#endif

/**************************** Type Definitions ******************************/
#define DEFAULT_LOGGER_ON
/***************** Macros (Inline Functions) Definitions ********************/
#ifdef __BAREMETAL__
#define printf xil_printf
#endif
/************************** Function Prototypes *****************************/

int RFdcMTS_Example(u16 RFdcDeviceId);  //u16: unsigned short int

//end add


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
struct lmx2594_dev *lmx2594_adc_inst;
struct lmx2594_dev *lmx2594_dac_inst;

XRFdc	RFdc;
XGpioPs Gpio;

void my_log_handler(enum metal_log_level level,
			       const char *format, ...)
{
#ifdef DEFAULT_LOGGER_ON
	char msg[1024];
	va_list args;
	static const char * const level_strs[] = {
		"metal: emergency: ",
		"metal: alert:     ",
		"metal: critical:  ",
		"metal: error:     ",
		"metal: warning:   ",
		"metal: notice:    ",
		"metal: info:      ",
		"metal: debug:     ",
	};

	va_start(args, format);
	vsnprintf(msg, sizeof(msg), format, args);
	va_end(args);

	if (level <= METAL_LOG_EMERGENCY || level > METAL_LOG_DEBUG)
		level = METAL_LOG_EMERGENCY;

	fprintf(stderr, "%s%s", level_strs[level], msg);
#else
	(void)level;
	(void)format;
#endif
}
//add

static XRFdc RFdcInst;      /* RFdc driver instance */
/****************************************************************************/
/**
*
* Main function that invokes the MTS example in this file.
*
* @param	None.
*
* @return
*		- XRFDC_SUCCESS if the example has completed successfully.
*		- XRFDC_FAILURE if the example has failed.
*
* @note		None.
*
//end add


/*******************************************************************************/
/**
 *  @brief main
 *******************************************************************************/
int main(void)
{
	int32_t Status;
	uint8_t Lmk04828Read;
	uint16_t Lmx2594Read;

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
    Status = lmk04828_read(lmk04828_inst, 0x0182, &Lmk04828Read);
	if ((Lmk04828Read & 0x02) == 0x02) {
		xil_printf("LMK04828 PLL1 Locked.\r\n");
	}
	else {
		xil_printf("LMK04828 PLL1 NOT lock!\r\n");
	}

    Status = lmk04828_read(lmk04828_inst, 0x0183, &Lmk04828Read);
    if ((Lmk04828Read & 0x02) == 0x02) {
        xil_printf("LMK04828 PLL2 Locked.\r\n");
    }
    else {
        xil_printf("LMK04828 PLL2 NOT lock!\r\n");
    }

	/**********************************************************/
	/************* LMX2594 for DAC Configuration **************/
	/**********************************************************/
	Status = lmx2594_init(&lmx2594_dac_inst, &lmx2594_dac_init_param);
	for(int i = 0; i < lmx2594_default_config_len; i++)
	{
		Status = lmx2594_write(lmx2594_dac_inst, lmx2594_default_config[i].addr, lmx2594_default_config[i].value);
		if (lmx2594_default_config[i].addr == 0)
		{
			mdelay(500);
		}
	}

    // check vco lock status
    Status = lmx2594_read(lmx2594_dac_inst, 110, &Lmx2594Read);
    if (((Lmx2594Read >> 9) & 0x03) == 0x02) {
        xil_printf("LMX2594 for DAC Config Done.\r\n");
    }
    else {
        xil_printf("LMX2594 for DAC not lock!\r\n");
    }

    Status = lmx2594_write(lmx2594_dac_inst, 0x00, 0x259C);

	/**********************************************************/
	/************* LMX2594 for ADC Configuration **************/
	/**********************************************************/
	Status = lmx2594_init(&lmx2594_adc_inst, &lmx2594_adc_init_param);
	for(int i = 0; i < lmx2594_default_config_len; i++)
	{
		Status = lmx2594_write(lmx2594_adc_inst, lmx2594_default_config[i].addr, lmx2594_default_config[i].value);
		if (lmx2594_default_config[i].addr == 0)
		{
			mdelay(500);
		}
	}

	Status = lmx2594_read(lmx2594_adc_inst, 0, &Lmx2594Read);

    // check vco lock status
    Status = lmx2594_read(lmx2594_adc_inst, 110, &Lmx2594Read);
    if (((Lmx2594Read >> 9) & 0x03) == 0x02) {
        xil_printf("LMX2594 for ADC Config Done.\r\n");
    }
    else {
        xil_printf("LMX2594 for ADC not lock!\r\n");
    }

    Status = lmx2594_write(lmx2594_adc_inst, 0x00, 0x259C);


	//add
	printf("RFdc MTS Example Test\r\n");
	/*
	 * Specify the Device ID that is generated in xparameters.h.
	*/
	Status = RFdcMTS_Example(RFDC_DEVICE_ID);
	if (Status != XRFDC_SUCCESS) {
		printf("MTS Example Test failed\r\n");
		return XRFDC_FAILURE;
	}

	printf("Successfully ran MTS Example\r\n");
	return XRFDC_SUCCESS;


	//end add


	print("Done.\n");

	return 0;
}

//add

/****************************************************************************/
/**
*
* This function runs a MTS test on the RFSoC data converter device using the
* driver APIs.
* This function does the following tasks:
*	- Initialize the RFdc device driver instance
*	- Test MTS feature.
*
* @param	RFdcDeviceId is the XPAR_<XRFDC_instance>_DEVICE_ID value
*		from xparameters.h.
*
* @return
*		- XRFDC_SUCCESS if the example has completed successfully.
*		- XRFDC_FAILURE if the example has failed.
*
* @note   	None
*
****************************************************************************/
int RFdcMTS_Example(u16 RFdcDeviceId)
{
	int status, status_adc, status_dac, i;
	u32 factor;
	XRFdc_Config *ConfigPtr;
	XRFdc *RFdcInstPtr = &RFdcInst;
#ifndef __BAREMETAL__
	struct metal_device *deviceptr;
#endif

	struct metal_init_params init_param = METAL_INIT_DEFAULTS;

	if (metal_init(&init_param)) {
		printf("ERROR: Failed to run metal initialization\n");
		return XRFDC_FAILURE;
	}
	metal_set_log_handler(my_log_handler);
	metal_set_log_level(METAL_LOG_DEBUG);
    ConfigPtr = XRFdc_LookupConfig(RFdcDeviceId);

    if (ConfigPtr == NULL) {
		return XRFDC_FAILURE;
	}

#ifndef __BAREMETAL__
	status = XRFdc_RegisterMetal(RFdcInstPtr, RFdcDeviceId, &deviceptr);

	if (status != XRFDC_SUCCESS) {
		return XRFDC_FAILURE;
	}
#endif

    status = XRFdc_CfgInitialize(RFdcInstPtr, ConfigPtr);
    if (status != XRFDC_SUCCESS) {
        printf("RFdc Init Failure\n\r");
    }

    //add


    //end add

    printf("=== RFdc Initialized - Running Multi-tile Sync ===\n");

    /* ADC MTS Settings */
    XRFdc_MultiConverter_Sync_Config ADC_Sync_Config;

    /* DAC MTS Settings */
    XRFdc_MultiConverter_Sync_Config DAC_Sync_Config;

    //end add


    /* Run MTS for the ADC & DAC */
    printf("\n=== Run DAC Sync ===\n");

    /* Initialize DAC MTS Settings */
    XRFdc_MultiConverter_Init (&DAC_Sync_Config, 0, 0, XRFDC_TILE_ID0);
    DAC_Sync_Config.Tiles = 0xF;	/* Sync DAC tiles 0 and 1 */

    status_dac = XRFdc_MultiConverter_Sync(RFdcInstPtr, XRFDC_DAC_TILE,
					&DAC_Sync_Config);
    if(status_dac == XRFDC_MTS_OK){
	printf("INFO : DAC Multi-Tile-Sync completed successfully\n");
    }else{
	printf("ERROR : DAC Multi-Tile-Sync did not complete successfully. Error code is %u \n",status_dac);
	return status_dac;
    }

    printf("\n=== Run ADC Sync ===\n");

    /* Initialize ADC MTS Settings */
    XRFdc_MultiConverter_Init (&ADC_Sync_Config, 0, 0, XRFDC_TILE_ID0);
    ADC_Sync_Config.Tiles = 0xF;	/* Sync ADC tiles 0, 1, 2, 3 */

    status_adc = XRFdc_MultiConverter_Sync(RFdcInstPtr, XRFDC_ADC_TILE,
					&ADC_Sync_Config);
    if(status_adc == XRFDC_MTS_OK){
	printf("INFO : ADC Multi-Tile-Sync completed successfully\n");
    }else{
		printf("ERROR : ADC Multi-Tile-Sync did not complete successfully. Error code is %u \n",status_adc);
		return status_adc;
    }

    /*
     * Report Overall Latency in T1 (Sample Clocks) and
     * Offsets (in terms of PL words) added to each FIFO
     */
     printf("\n\n=== Multi-Tile Sync Report ===\n");
     for(i=0; i<4; i++) {
         if((1<<i)&DAC_Sync_Config.Tiles) {
                 XRFdc_GetInterpolationFactor(RFdcInstPtr, i, 0, &factor);
                 printf("DAC%d: Latency(T1) =%3d, Adjusted Delay"
				 "Offset(T%d) =%3d\n", i, DAC_Sync_Config.Latency[i],
						 factor, DAC_Sync_Config.Offset[i]);
         }
     }
     for(i=0; i<4; i++) {
         if((1<<i)&ADC_Sync_Config.Tiles) {
                 XRFdc_GetDecimationFactor(RFdcInstPtr, i, 0, &factor);
                 printf("ADC%d: Latency(T1) =%3d, Adjusted Delay"
				 "Offset(T%d) =%3d\n", i, ADC_Sync_Config.Latency[i],
						 factor, ADC_Sync_Config.Offset[i]);
         }
     }

     //add
     int SysRefEnable;
     //Disable the analog SYSREF receiver with the API command
     SysRefEnable = 0;
     status_dac|=XRFdc_MTS_Sysref_Config(RFdcInstPtr, &DAC_Sync_Config,&ADC_Sync_Config, SysRefEnable);
     status_adc|=XRFdc_MTS_Sysref_Config(RFdcInstPtr, &DAC_Sync_Config,&ADC_Sync_Config, SysRefEnable);
     //Arm the mixer settings, NCO phase reset

     //DAC Mixer Settings
      XRFdc_Mixer_Settings DAC_Mixer_Settings;


      DAC_Mixer_Settings.CoarseMixFreq = XRFDC_COARSE_MIX_OFF;
      DAC_Mixer_Settings.MixerType = XRFDC_MIXER_TYPE_FINE;
      DAC_Mixer_Settings.MixerMode = XRFDC_MIXER_MODE_C2R;
      DAC_Mixer_Settings.PhaseOffset = 0;
      DAC_Mixer_Settings.Freq = 1050;
      DAC_Mixer_Settings.FineMixerScale = XRFDC_MIXER_SCALE_AUTO;
      DAC_Mixer_Settings.EventSource = XRFDC_EVNT_SRC_SYSREF;

//      int Tile_Id;
//      //DAC sample rate
//      for(Tile_Id=0; Tile_Id<4; Tile_Id++) {
//      	status = XRFdc_DynamicPLLConfig(RFdcInstPtr, 1, Tile_Id, XRFDC_EXTERNAL_CLK, 3932.16, 3932.16);
//      	    if (status != XRFDC_SUCCESS) {
//      	        printf("XRFdc DAC DynamicPLLConfig Failure\n\r");
//      	    }
//      }

//      for(int i = 0;i < 4;i++)
//      {
//           for(int j = 0;j < 1;j++)
//              {
//        	   status = XRFdc_SetInterpolationFactor(RFdcInstPtr, i, j, XRFDC_INTERP_DECIM_16X);
//         	    if (status != XRFDC_SUCCESS) {
//         	        printf("XRFdc DAC SetInterpolationFactor Failure\n\r");
//         	    }
//              }
//      }


      //DAC NCO reset
      for(int i = 0;i < 4;i++)
      {
           for(int j = 0;j < 1;j++)
              {
              	status = XRFdc_SetMixerSettings(RFdcInstPtr, XRFDC_DAC_TILE, i, j, &DAC_Mixer_Settings);
              	if (status != XRFDC_SUCCESS) {
              	printf("XRFdc_SetMixerSettings FAILED \n\n");
              	//return XRFDC_FAILURE;
              	}
                status = XRFdc_ResetNCOPhase(RFdcInstPtr, XRFDC_DAC_TILE, i, j);
                      	if (status != XRFDC_SUCCESS) {
                      	printf("XRFdc_ResetNCOPhase FAILED \n\n");
                      		//return XRFDC_FAILURE;
                         }
              }
      }

      //ADC Mixer Settings
      XRFdc_Mixer_Settings ADC_Mixer_Settings;


      ADC_Mixer_Settings.CoarseMixFreq = XRFDC_COARSE_MIX_OFF;
      ADC_Mixer_Settings.MixerType = XRFDC_MIXER_TYPE_FINE;
      ADC_Mixer_Settings.MixerMode = XRFDC_MIXER_MODE_R2C;
      ADC_Mixer_Settings.PhaseOffset = 0;
      ADC_Mixer_Settings.Freq = 1050;
      ADC_Mixer_Settings.FineMixerScale = XRFDC_MIXER_SCALE_AUTO;
      ADC_Mixer_Settings.EventSource = XRFDC_EVNT_SRC_SYSREF;

//      //ADC sample rate
//      for(Tile_Id=0; Tile_Id<4; Tile_Id++) {
//      	status = XRFdc_DynamicPLLConfig(RFdcInstPtr, 0, Tile_Id, XRFDC_EXTERNAL_CLK, 3932.16, 3932.16);
//      	    if (status != XRFDC_SUCCESS) {
//      	        printf("XRFdc ADC DynamicPLLConfig Failure\n\r");
//      	    }
//      }

      //ADC NCO reset
      for(int i = 0;i < 4;i++)
      {
          for(int j = 0;j < 2;j++)
              {
              	status = XRFdc_SetMixerSettings(RFdcInstPtr, XRFDC_ADC_TILE, i, j, &ADC_Mixer_Settings);
              	if (status != XRFDC_SUCCESS) {
              	printf("XRFdc_SetMixerSettings FAILED \n\n");
              	//return XRFDC_FAILURE;
              	}
                          		status = XRFdc_ResetNCOPhase(RFdcInstPtr, XRFDC_ADC_TILE, i, j);
                          		if (status != XRFDC_SUCCESS) {
                          		printf("XRFdc_ResetNCOPhase FAILED \n\n");
                          		//return XRFDC_FAILURE;
                          		}
              }
      }


     //Enable the analog SYSREF receiver with the API command
     SysRefEnable = 1;
     status_dac|=XRFdc_MTS_Sysref_Config(RFdcInstPtr, &DAC_Sync_Config,&ADC_Sync_Config, SysRefEnable);
     status_adc|=XRFdc_MTS_Sysref_Config(RFdcInstPtr, &DAC_Sync_Config,&ADC_Sync_Config, SysRefEnable);

     //Wait long enough to ensure a rising edge has been detected, at this point the update would commence
     mdelay(500);

     //Disable the analog SYSREF receiver with the API command
     SysRefEnable = 0;
     status_dac|=XRFdc_MTS_Sysref_Config(RFdcInstPtr, &DAC_Sync_Config,&ADC_Sync_Config, SysRefEnable);
     status_adc|=XRFdc_MTS_Sysref_Config(RFdcInstPtr, &DAC_Sync_Config,&ADC_Sync_Config, SysRefEnable);

    return XRFDC_MTS_OK;


    //end add

}

//end add
