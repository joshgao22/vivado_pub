/*****************************************************************************/
/**
 * Description: Global configurations.
 *
 * Date: 2021-04-28 13:19
 * Last Edit Time: 2022-05-23 20:32
 *
 * Revisions: Rev 0.0
 * History:
 * [2021-04-28]: Initial edition.
 *
 * Copyright(c) 2021 Beijing Institute of Technology.
 * Lab of Communication and Networking
 *
 ******************************************************************************/

#ifndef CONFIG_H_
#define CONFIG_H_

#define XILINX_PLATFORM

#include "xparameters.h"
#include "xparameters_ps.h"

/************ Hardware Configs ************/
#define FCLK_CLK0_HZ                XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ

/********* Zynq Platform Configs **********/

//Hardware Parameter
#define SPI_INTERFACE_SPI_ENGINE

#define HAVE_SPLIT_GAIN_TABLE	1 /* only set to 0 in case split_gain_table_mode_enable = 0*/
#define HAVE_TDD_SYNTH_TABLE	1 /* only set to 0 in case split_gain_table_mode_enable = 0*/

#define HAVE_VERBOSE_MESSAGES /* Recommended during development prints errors and warnings */
//#define HAVE_DEBUG_MESSAGES /* For Debug purposes only */

// interrupt controller
#define INTC_DEVICE_ID              XPAR_SCUGIC_SINGLE_DEVICE_ID

// gpio
#define GPIO_DEVICE_ID              XPAR_PSU_GPIO_0_DEVICE_ID
#define GPIO_INTR_ID                XPS_GPIO_INT_ID

#define GPIO_OFFSET                 78
#define GPIO_INPUT                  0
#define GPIO_OUTPUT                 1
#define GPIO_DISABLE                0
#define GPIO_ENABLE                 1

// rfdc
#define RFDC_DEVICE_ID              XPAR_XRFDC_0_DEVICE_ID
#define RFDC_INTR_ID                XPAR_FABRIC_RFDC_0_VEC_ID

// spi
#define SPI_DEVICE_ID               0
#define SPI_ENGINE_REF_CLK          FCLK_CLK0_HZ
#define SPI_ENGINE_MAX_SPEED        2500000
#define SPI_ENGINE_BASEADDR         XPAR_AXI_SPI_ENGINE_AXI_SPI_ENGINE_BASEADDR
#define SPI_ENGINE_DATA_WIDTH       8
#define SPI_ENGINE_CS_DELAY         3

#define SPI_CS_LMK04828           	0x00
#define SPI_CS_LMX2594_ADC         	0x01
#define SPI_CS_LMX2594_DAC         	0x02


#endif
