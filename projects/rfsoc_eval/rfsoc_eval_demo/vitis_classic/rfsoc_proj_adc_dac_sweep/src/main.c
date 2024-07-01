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
#include "xscugic.h"        // The generic interrupt controller driver component
#include "xil_exception.h"  // ARM Cortex A9 specific exception related APIs
#include "sleep.h"
#include "xgpiops.h"
#include "xrfdc.h"

// ADI Drivers
#include "dev_profile/dev_profile.h"
#include "adi_noos/drivers/axi_core/spi_engine/spi_engine.h"
#include "adi_noos/drivers/platform/gpio_extra.h"

// User
#include "app_config.h"

/******************************************************************************/
/**************************** Function Prototypes *****************************/
/******************************************************************************/

int SetupInterruptSystem(XScuGic* GicInstPtr, u32 IntcDevId);
int SetupGpioPs(XGpioPs* GpioPsInstPtr, u32 GpioPsDevId);
int SetupRFdc(XRFdc* RFdcInstPtr, u32 RFdcDevId, XScuGic* GicInstPtr,
        u32 IntcDevId);
void XRFdc_IntrHandlerWrapper(void* callbackRef);
void RFdcHandler(void* CallBackRef, u32 Type, u32 Tile_Id, u32 Block_Id,
        u32 Event);
int RFdc_DisableInvSyncFIR(XRFdc* RFdcInstPtr);
int RFdc_DacTestCase(XRFdc* RFdcInstPtr, u32 Tile_Id, u32 Block_Id,
        u32 NyquistZone, u32 DataPathMode, u32 DecoderMode);

/******************************************************************************/
/**************************** Constant Definitions ****************************/
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

/******************************************************************************/
/************************ Driver Instance Definitions *************************/
/******************************************************************************/

static XScuGic Intc; // General interrupt controller instance
static XRFdc RFdc;
static XGpioPs GpioPs;


//static uint64_t my_io_read(struct metal_io_region *io,
//                   unsigned long offset,
//                   memory_order order,
//                   int width){
//    metal_assert(offset <= io->size);
//    unsigned long addr = offset + *(io->physmap);
//    switch (width) {
//    case 1:
//        return Xil_In8(addr);
//    case 2:
//        return Xil_In16(addr);
//    case 4:
//        return Xil_In32(addr);
//    case 8:
//        return Xil_In64(addr);
//    default:
//        metal_assert(0);
//        return -1;
//    }
//}
//
//
//static void my_io_write(struct metal_io_region *io,
//                unsigned long offset,
//                uint64_t value,
//                memory_order order,
//                int width){
//    metal_assert(offset <= io->size);
//    unsigned long addr = offset + *(io->physmap);
//    switch (width) {
//    case 1:
//        return Xil_Out8(addr, value);
//    case 2:
//        return Xil_Out16(addr, value);
//    case 4:
//        return Xil_Out32(addr, value);
//    case 8:
//        return Xil_Out64(addr, value);
//    default:
//        metal_assert(0);
//    }
//
//}

/****************************************************************************/
/**
 * @brief   This function initializes the SCUGIC instance. It looks for the
 *          device configuration based on the unique device ID, initializes a
 *          SCUGIC and enables system interrupts.
 *
 * @param   GicInstPtr is a reference to the XScuGic driver Instance.
 * @param   IntcDevId is the XPAR_<SCUGIC_instance>_DEVICE_ID value from
 *          "xparameters.h".
 *
 * @return  SUCCESS if initialization succeed.
 *          XST_FAILURE if initialization failed.
 *
 *****************************************************************************/
int SetupInterruptSystem(XScuGic* GicInstPtr, u32 IntcDevId){

	int Status;

	XScuGic_Config* IntcConfig; /* Instance of the interrupt controller */

	Xil_ExceptionInit();

	/*
     * Initialize the interrupt controller driver so that it is ready to
     * use.
     */
	IntcConfig = XScuGic_LookupConfig(IntcDevId);
    if (NULL == IntcConfig) {
        return XST_FAILURE;
    }

    Status = XScuGic_CfgInitialize(GicInstPtr, IntcConfig,
            IntcConfig->CpuBaseAddress);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    /*
     * Connect the interrupt controller interrupt handler to the hardware
     * interrupt handling logic in the processor.
     */
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
                     (Xil_ExceptionHandler)XScuGic_InterruptHandler,
                     GicInstPtr);

    /* Enable interrupts in the Processor. */
    Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);

	return SUCCESS;
} // SetupInterruptSystem


/****************************************************************************/
/**
 * @brief   This function initializes the PS GPIO instance. It looks for the
 *          device configuration based on the unique device ID and initializes a
 *          GpioPs instance.
 *
 * @param   GpioPsInstPtr is a reference to the XGpioPs driver Instance.
 * @param   GpioPsDevId is the XPAR_<GPIO_instance>_DEVICE_ID value from
 *          "xparameters.h".
 *
 * @return  SUCCESS if initialize successful.
 *          XST_FAILURE if initialization failed.
 *
 *****************************************************************************/
int SetupGpioPs(XGpioPs* GpioPsInstPtr, u32 GpioPsDevId){

    int Status;

    XGpioPs_Config *ConfigPtr;

    /* Initialize the Gpio driver. */
    ConfigPtr = XGpioPs_LookupConfig(GpioPsDevId);
    if (ConfigPtr == NULL) {
        return XST_FAILURE;
    }

    Status = XGpioPs_CfgInitialize(GpioPsInstPtr, ConfigPtr,
            ConfigPtr->BaseAddr);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    /* Run a self-test on the GPIO device. */
    Status = XGpioPs_SelfTest(GpioPsInstPtr);

    return Status;
} // SetupGpioPs


/****************************************************************************/
/**
 * @brief   This function initializes the PS GPIO instance. It looks for the
 *          device configuration based on the unique device ID and initializes a
 *          GpioPs instance.
 *
 * @param   RFdcInstPtr is a reference to the XRFdc driver Instance.
 * @param   RFdcDevId is the XPAR_<RFdc_instance>_DEVICE_ID value from
 *          "xparameters.h".
 * @param   GicInstPtr is a reference to the XScuGic driver Instance.
 * @param   IntcDevId is the XPAR_<SCUGIC_instance>_DEVICE_ID value from
 *          "xparameters.h".
 *
 * @return  SUCCESS if initialize successful.
 *          XST_FAILURE if initialization failed.
 *
 *****************************************************************************/
int SetupRFdc(XRFdc* RFdcInstPtr, u32 RFdcDevId, XScuGic* GicInstPtr,
        u32 RFdcIntrId) {

    int Status;

    XRFdc_Config *RFdcConfigPtr;

    RFdcConfigPtr = XRFdc_LookupConfig(RFdcDevId);

    Status = XRFdc_CfgInitialize(RFdcInstPtr, RFdcConfigPtr);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

//    RFdc.io->ops.read = my_io_read;
//    RFdc.io->ops.write = my_io_write;

    // interrupt
    /*
     * Connect the device driver handler that will be called when an
     * interrupt for the device occurs, the handler defined above performs
     * the specific interrupt processing for the device.
     */
    Status = XScuGic_Connect(GicInstPtr, RFdcIntrId, XRFdc_IntrHandlerWrapper,
            RFdcInstPtr);
    if (Status != XST_SUCCESS) {
        return Status;
    }

    /* Set the handler for RFdc interrupts. */
    XRFdc_SetStatusHandler(RFdcInstPtr, RFdcInstPtr, RFdcHandler);

    /* Enable the interrupt for the RFdc device. */
    XScuGic_Enable(GicInstPtr, RFdcIntrId);

    return Status;
} // SetupRFdc

/****************************************************************************/
/**
 * This function is wrapper for XRFdc_IntrHandler() when libmetal is not used,
 * to fit the Xil_InterruptHandler() type in ScuGic.
 *
 * @param   CallBackRef is a pointer to the upper layer callback reference.
 *
 * @return  None.
 *
 * @note    None.
 *
 ******************************************************************************/
void XRFdc_IntrHandlerWrapper(void* callbackRef) {
    XRFdc_IntrHandler(RFDC_INTR_ID, callbackRef);
}


/****************************************************************************/
/**
 * This function is the user layer callback function for rfdc interrupts. It
 * prints information about the interrupts then clear them.
 *
 * @param   CallBackRef is a pointer to the upper layer callback reference.
 * @param   Type is ADC or DAC. 0 for ADC and 1 for DAC, and can be
 *          XRFDC_<Type>_TILE value from "xrfdc.h".
 * @param   Tile_Id Valid values are 0-3 and can be the XRFDC_TILE_<Tile_Id>
 *          value from "xrfdc.h".
 * @param   Block_Id is DAC block number inside the tile. Valid values are 0-3.
 * @param   NyquistZone Valid values are 1 (Odd), 2 (Even) and can be the
 *          XRFDC_<NyquistZone>_NYQUIST_ZONE value from "xrfdc.h".
 *
 * @return  None.
 *
 * @note    None.
 *
 ******************************************************************************/
void RFdcHandler(void* CallBackRef, u32 Type, u32 Tile_Id, u32 Block_Id,
        u32 Event) {

    XRFdc* RFdc = (XRFdc *)CallBackRef;

    // Check the type of interrupt event
    if (Type == XRFDC_DAC_TILE) {
        xil_printf("\nInterrupt occurred for ADC%d,%d :", Tile_Id, Block_Id);
        if (Event & (XRFDC_IXR_FIFOUSRDAT_OF_MASK |
                XRFDC_IXR_FIFOUSRDAT_UF_MASK)) {
            xil_printf("FIFO Actual Overflow\r\n");
            XRFdc_IntrClr(RFdc, Type, Tile_Id, Block_Id,
                    XRFDC_IXR_FIFOUSRDAT_OF_MASK |
                    XRFDC_IXR_FIFOUSRDAT_UF_MASK);
        }
        if (Event & (XRFDC_IXR_FIFOMRGNIND_OF_MASK |
                XRFDC_IXR_FIFOMRGNIND_UF_MASK)) {
            xil_printf("FIFO Marginal Overflow\r\n");
        }
        if(Event & XRFDC_DAC_IXR_INTP_STG_MASK) {
            xil_printf("Interpolation Stages Overflow\r\n");
        }
    // ... Other handling code ...
    } else {
        xil_printf("\nInterrupt occurred for ADC%d,%d :\r\n", Tile_Id, Block_Id);
        if (Event & XRFDC_ADC_OVR_RANGE_MASK) {
            xil_printf("ADC Over range for ADC%d,%d :\r\n", Tile_Id, Block_Id);
            XRFdc_IntrClr(RFdc, Type, Tile_Id, Block_Id,
                    XRFDC_ADC_OVR_RANGE_MASK);
        }
        if (Event & XRFDC_ADC_OVR_VOLTAGE_MASK) {
            xil_printf("ADC Over voltage for ADC%d,%d :\r\n", Tile_Id, Block_Id);
            XRFdc_IntrClr(RFdc, Type, Tile_Id, Block_Id,
                    XRFDC_ADC_OVR_VOLTAGE_MASK);
        }
        if (Event & XRFDC_ADC_DAT_OVR_MASK) {
            xil_printf("ADC data path interrupt for ADC%d,%d :\r\n", Tile_Id,
                    Block_Id);
            XRFdc_IntrClr(RFdc, Type, Tile_Id, Block_Id,
                    XRFDC_ADC_DAT_OVR_MASK);
        }
    }
}

/****************************************************************************/
/**
 * @brief   This function disables inverse sync filter for all RF-DACs.
 *
 * @param   RFdcInstPtr is a reference to the XRFdc driver Instance.
 *
 * @return  XRFDC_SUCCESS if successful.
*           XRFDC_FAILURE if block not enabled/invalid mode.
 *
 *****************************************************************************/
int RFdc_DisableInvSyncFIR(XRFdc* RFdcInstPtr){

    int Status;
    uint16_t InvSyncFirMode;

    for (uint32_t Tile_Id = 0; Tile_Id <= XRFDC_TILE_ID3; Tile_Id++) {
        for (uint32_t Block_Id = 0; Block_Id <= XRFDC_BLK_ID3; Block_Id += 2) {
            Status = XRFdc_GetInvSincFIR(RFdcInstPtr, Tile_Id, Block_Id,
                    &InvSyncFirMode);
            if (Status != XST_SUCCESS) {
                return XST_FAILURE;
            }

            if (InvSyncFirMode != 0) {
                Status = XRFdc_SetInvSincFIR(RFdcInstPtr, Tile_Id, Block_Id,
                        XRFDC_DISABLED);
                if (Status != XST_SUCCESS) {
                    return XST_FAILURE;
                }
            }
        }
    }

    return Status;
} // RFdc_DisableInvSyncFIR


/****************************************************************************/
/**
 * @brief   This function performs sweep frequency tests for specific RF-DAC
 *          with certain nyquist zone, data path mode and decoder mode.
 *
 * @param   RFdcInstPtr is a reference to the XRFdc driver Instance.
 * @param   Tile_Id Valid values are 0-3 and can be the XRFDC_TILE_<Tile_Id>
 *          value from "xrfdc.h".
 * @param   Block_Id is DAC block number inside the tile. Valid values are 0-3.
 * @param   NyquistZone Valid values are 1 (Odd), 2 (Even) and can be the
 *          XRFDC_<NyquistZone>_NYQUIST_ZONE value from "xrfdc.h".
 * @param   DataPathMode Valid values are 1-4, and can be
 *          XRFDC_DATAPATH_MODE_<DataPathMode> value from "xrfdc.h".
 * @param   DecoderMode Valid values are 1 (Maximum SNR, for non-
 *          randomized decoder), 2 (Maximum Linearity, for randomized decoder),
 *          and can be XRFDC_DECODER_<DecoderMode> value from "xrfdc.h".
 *
 * @return  SUCCESS if test succeed.
 *          XST_FAILURE if test failed.
 *
 *****************************************************************************/
int RFdc_DacTestCase(XRFdc* RFdcInstPtr, u32 Tile_Id, u32 Block_Id,
        u32 NyquistZone, u32 DataPathMode, u32 DecoderMode){

    int Status;

    // set nyquist zone
    Status = XRFdc_SetNyquistZone(RFdcInstPtr, XRFDC_DAC_TILE, Tile_Id,
            Block_Id, NyquistZone);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // set data path mode
    Status = XRFdc_SetDataPathMode(RFdcInstPtr, Tile_Id, Block_Id,
            DataPathMode);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // set decoder mode
    Status = XRFdc_SetDecoderMode(RFdcInstPtr, Tile_Id, Block_Id,
            DecoderMode);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // get & set mixer settings
    XRFdc_Mixer_Settings Mixer_Settings_DAC;

    Status = XRFdc_GetMixerSettings(RFdcInstPtr, XRFDC_DAC_TILE, Tile_Id,
            Block_Id, &Mixer_Settings_DAC);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

//    for (double freq = 5;freq <= 9600; freq += 1) {
//        Mixer_Settings_DAC.Freq = freq;
//
//        Status = XRFdc_SetMixerSettings(RFdcInstPtr, XRFDC_DAC_TILE, Tile_Id,
//                Block_Id,  &Mixer_Settings_DAC);
//        if (Status != XST_SUCCESS) {
//            return XST_FAILURE;
//        }
//
//        XRFdc_UpdateEvent(&RFdc, XRFDC_DAC_TILE, Tile_Id, Block_Id,
//                XRFDC_EVENT_MIXER);
//
//        mdelay(10);
//    }

    mdelay(10);

    // target frequency range sweep
    for (double freq = 3700;freq <= 4300; freq += 1) {
        Mixer_Settings_DAC.Freq = freq;

        Status = XRFdc_SetMixerSettings(RFdcInstPtr, XRFDC_DAC_TILE, Tile_Id,
                Block_Id,  &Mixer_Settings_DAC);
        if (Status != XST_SUCCESS) {
            return XST_FAILURE;
        }

        XRFdc_UpdateEvent(&RFdc, XRFDC_DAC_TILE, Tile_Id, Block_Id,
                XRFDC_EVENT_MIXER);

        mdelay(25);
    }

    return Status;
} // RFdc_DacTestCase


/****************************************************************************/
/**
 * @brief   This function performs sweep frequency tests for specific RF-DAC
 *          with certain nyquist zone, calibration mode and dither mode.
 *
 * @param   RFdcInstPtr is a reference to the XRFdc driver Instance.
 * @param   Tile_Id Valid values are 0-3 and can be the XRFDC_TILE_<Tile_Id>
 *          value from "xrfdc.h".
 * @param   Block_Id is DAC block number inside the tile. Valid values are 0-3.
 * @param   NyquistZone Valid values are 1 (Odd), 2 (Even) and can be the
 *          XRFDC_<NyquistZone>_NYQUIST_ZONE value from "xrfdc.h".
 * @param   DataPathMode Valid values are 1-4, and can be
 *          XRFDC_DATAPATH_MODE_<DataPathMode> value from "xrfdc.h".
 * @param   DecoderMode Valid values are 1 (Maximum SNR, for non-
 *          randomized decoder), 2 (Maximum Linearity, for randomized decoder),
 *          and can be XRFDC_DECODER_<DecoderMode> value from "xrfdc.h".
 *
 * @return  SUCCESS if test succeed.
 *          XST_FAILURE if test failed.
 *
 *****************************************************************************/
int RFdc_AdcTestCase(XRFdc* RFdcInstPtr, u32 Tile_Id, u32 Block_Id,
        u32 NyquistZone, u32 CalibMode, u32 DitherMode){

    int Status;

    // set nyquist zone
    Status = XRFdc_SetNyquistZone(RFdcInstPtr, XRFDC_ADC_TILE, Tile_Id,
            Block_Id, NyquistZone);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // set calibration mode
    XRFdc_SetCalibrationMode(RFdcInstPtr, Tile_Id, Block_Id, CalibMode);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // set dither mode; Dither should be enabled unless the sample rate is
    // under 0.75 times the maximum sampling rate for the RF-ADC.
    Status = XRFdc_SetDither(RFdcInstPtr, Tile_Id, Block_Id, DitherMode);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // get & set mixer settings
    XRFdc_Mixer_Settings Mixer_Settings_ADC;

    Status = XRFdc_GetMixerSettings(RFdcInstPtr, XRFDC_ADC_TILE, Tile_Id,
            Block_Id, &Mixer_Settings_ADC);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // target frequency range sweep
    for (double freq = 4000;freq <= 4000; freq += 100) {
        Mixer_Settings_ADC.Freq = freq;
        Mixer_Settings_ADC.EventSource = XRFDC_EVNT_SRC_TILE;

        Status = XRFdc_SetMixerSettings(RFdcInstPtr, XRFDC_ADC_TILE, Tile_Id,
                Block_Id, &Mixer_Settings_ADC);
        if (Status != XST_SUCCESS) {
            return XST_FAILURE;
        }

        Status = XRFdc_UpdateEvent(&RFdc, XRFDC_ADC_TILE, Tile_Id, Block_Id,
                XRFDC_EVENT_MIXER);
        if (Status != XST_SUCCESS) {
            return XST_FAILURE;
        }

        mdelay(25);
    }

    return Status;
} // RFdc_AdcTestCase


/***************************************************************************//**
 * @brief main
*******************************************************************************/
int main(void) {
    int32_t Status;

    struct metal_init_params params = METAL_INIT_DEFAULTS;

    params.log_level = METAL_LOG_DEBUG;
    Status = metal_init(&params);
    if (Status != XST_SUCCESS)
        return Status;


    /**********************************************************/
    /***************** Xilinx Initialization ******************/
    /**********************************************************/
    // gic
    Status = SetupInterruptSystem(&Intc, INTC_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // gpio
    Status = SetupGpioPs(&GpioPs, GPIO_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // rf data converter initialization
    Status = SetupRFdc(&RFdc, RFDC_DEVICE_ID, &Intc, RFDC_INTR_ID);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    /**********************************************************/
    /***************** LMK04828 Configuration *****************/
    /**********************************************************/
    // configuration
    Status = lmk04828_init(&lmk04828_inst, &lmk04828_default_init_param);
    for(uint32_t i = 0; i < lmk04828_default_config_len; i++) {
        Status = lmk04828_write(lmk04828_inst, lmk04828_default_config[i].addr, lmk04828_default_config[i].value);
        if (lmk04828_default_config[i].addr == 0x0000) {
            // wait for reset
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

    /**********************************************************/
    /***************** RF DAC Reconfiguration *****************/
    /**********************************************************/

//#define DAC_TEST

    /*
     * The following DAC and sampling rate are used to measure performance:
     *   Number       Tile                  Block                        Sample Rate
     *   1 (VOUT_00)  228 (XRFDC_TILE_ID0)  DAC 0/DUC 0 (XRFDC_BLK_ID0)  4.9152 Gsps
     *   8 (VOUT_32)  231 (XRFDC_TILE_ID3)  DAC 1/DUC 2 (XRFDC_BLK_ID2)  9.8304 Gsps
     *
     */

#ifdef DAC_TEST
    // turn off inverse sinc filter
    Status = RFdc_DisableInvSyncFIR(&RFdc);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // turn on inverse sinc filter
//    Status = XRFdc_SetInvSincFIR(&RFdc, XRFDC_TILE_ID0, XRFDC_BLK_ID0,
//            XRFDC_ODD_NYQUIST_ZONE);
//    if (Status != XST_SUCCESS) {
//        return XST_FAILURE;
//    }

//    Status = RFdc_DacTestCase(&RFdc, XRFDC_TILE_ID3, XRFDC_BLK_ID2,
//            XRFDC_ODD_NYQUIST_ZONE, XRFDC_DATAPATH_MODE_DUC_0_FSDIVFOUR,
//            XRFDC_DECODER_MAX_SNR_MODE);
//    if (Status != XST_SUCCESS) {
//        return XST_FAILURE;
//    }

    Status = RFdc_DacTestCase(&RFdc, XRFDC_TILE_ID0, XRFDC_BLK_ID0,
            XRFDC_EVEN_NYQUIST_ZONE, XRFDC_DATAPATH_MODE_DUC_0_FSDIVTWO,
            XRFDC_DECODER_MAX_SNR_MODE);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }
#endif

    /**********************************************************/
    /***************** RF ADC Reconfiguration *****************/
    /**********************************************************/

#define ADC_TEST

    /*
     * The following ADC and sampling rate are used to measure performance:
     *   Number       Tile                  Block                  Sample Rate
     *   1 (VIN0_01)  224 (XRFDC_TILE_ID0)  ADC 0 (XRFDC_BLK_ID0)  4.9152 Gsps
     *   8 (VIN3_23)  227 (XRFDC_TILE_ID3)  ADC 1 (XRFDC_BLK_ID1)  4.9152 Gsps
     *
     */

#ifdef ADC_TEST
    /* Enable the RFdc interrupts. */
    Status = XRFdc_IntrEnable(&RFdc, XRFDC_ADC_TILE, XRFDC_TILE_ID0,
            XRFDC_BLK_ID0, XRFDC_ADC_OVR_VOLTAGE_MASK |
            XRFDC_ADC_OVR_RANGE_MASK |
            XRFDC_ADC_DAT_OVR_MASK);

    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    Status = RFdc_AdcTestCase(&RFdc, XRFDC_TILE_ID0, XRFDC_BLK_ID0,
            XRFDC_EVEN_NYQUIST_ZONE, XRFDC_CALIB_MODE2,
            XRFDC_DITH_ENABLE);

    while(1);
#endif

    return XST_SUCCESS;
}
