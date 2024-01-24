/*****************************************************************************/
/**
 * Description: main.c
 *
 * Date: 2021-11-13 13:19
 * Last Edit Time: [2023-04-23 21:32]
 *
 * Revisions: Rev 0.0
 * History:
 * [2021-11-13]: Initial edition.
 * [2022-03-28]: Add bit error test mode.
 * [2023-04-23]: Bug fixed,
 *
 * Copyright(c) 2021 Beijing Institute of Technology.
 * Lab of Communication and Networking
 *
 ******************************************************************************/

/******************************************************************************/
/******************************* Include Files ********************************/
/******************************************************************************/

// Standard
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

// Xilinx
#include "sleep.h"
#include "xspips.h"		/* SPI device driver */
#include "xil_printf.h"

// User
#include "app_config.h"

/******************************************************************************/
/**************************** Function Prototypes *****************************/
/******************************************************************************/

int SetupSpiPs(XSpiPs* SpiPsInstPtr, u32 SpiPsDevId);

/******************************************************************************/
/**************************** Constant Definitions ****************************/
/******************************************************************************/


/******************************************************************************/
/************************ Driver Instance Definitions *************************/
/******************************************************************************/

static XSpiPs SpiPs_0;
static XSpiPs SpiPs_1;

/****************************************************************************/
/**
 * @brief   This function initializes the PS SPI instance. It looks for the
 *          device configuration based on the unique device ID and initializes a
 *          SpiPs instance.
 *
 * @param   SpiPsInstPtr is a reference to the XSpiPs driver Instance.
 * @param   SpiPsDevId is the XPAR_<SPI_instance>_DEVICE_ID value from
 *          "xparameters.h".
 *
 * @return  SUCCESS if initialize successful.
 *          XST_FAILURE if initialization failed.
 *
 *****************************************************************************/
int SetupSpiPs(XSpiPs* SpiPsInstPtr, u32 SpiPsDevId){

    int Status;

    XSpiPs_Config *SpiPsConfigPtr;

    /* Initialize spi driver. */
    SpiPsConfigPtr = XSpiPs_LookupConfig(SpiPsDevId);
    if (SpiPsConfigPtr == NULL) {
        return XST_FAILURE;
    }

    Status = XSpiPs_CfgInitialize(SpiPsInstPtr, SpiPsConfigPtr,
    		SpiPsConfigPtr->BaseAddress);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

	// Perform a self-test to check hardware build
	Status = XSpiPs_SelfTest(SpiPsInstPtr);

    return Status;
} // SetupSpiPs


int main(void) {
	int Status;

	Status = SetupSpiPs(&SpiPs_0, SPI_0_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

	Status = SetupSpiPs(&SpiPs_1, SPI_1_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

	// Set the Spi device 0 as a master.
	XSpiPs_SetOptions(&SpiPs_0, XSPIPS_MASTER_OPTION);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    XSpiPs_SetClkPrescaler(&SpiPs_0, XSPIPS_CLK_PRESCALE_64);
    XSpiPs_SetClkPrescaler(&SpiPs_1, XSPIPS_CLK_PRESCALE_64);

    XSpiPs_SetSlaveSelect(&SpiPs_0, SPI_SS_0);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    u8 SendBuf[3] = {0x80,0x00,0x00};
    u8 RecvBuf[3];

    XSpiPs_PolledTransfer(&SpiPs_0, SendBuf, RecvBuf, 3);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    return Status;
}


