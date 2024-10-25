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
#include "config/app_config.h"
#include "drivers/rf-transceiver/ad9361_reg/ad9361_reg.h"
#include "drivers/rf-transceiver/ad9361/ad9361_api.h"

/************************** Function Prototypes ******************************/
int32_t Hardware_Init(void);
int32_t Hardware_SwitchFreq(struct ad9361_reg_dev *dev, ad9361TxFreq freq);
int8_t Hardware_GetAD9361Temp_1(void);
int8_t Hardware_GetAD9361Temp_2(void);
uint8_t Hardware_GetAD9361LockStatus(void);
uint8_t Hardware_GetAD9528LockStatus(void);


