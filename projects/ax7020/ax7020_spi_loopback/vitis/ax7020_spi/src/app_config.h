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
#define FCLK_CLK0_HZ                XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ

/********* Zynq Platform Configs **********/

#define HAVE_VERBOSE_MESSAGES /* Recommended during development prints errors and warnings */
//#define HAVE_DEBUG_MESSAGES /* For Debug purposes only */

// interrupt controller
#define INTC_DEVICE_ID              XPAR_SCUGIC_SINGLE_DEVICE_ID

// spi
#define SPI_0_DEVICE_ID		XPAR_XSPIPS_0_DEVICE_ID
#define SPI_1_DEVICE_ID		XPAR_XSPIPS_1_DEVICE_ID
#define SPI_SS_0			0x0

#endif
