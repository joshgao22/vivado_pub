/*****************************************************************************/
/**
 * Description: main.c
 *

 * Date: 2023-05-07 13:19
 * Last Edit Time: [2023-05-07 20:32]
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
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
// Xilinx
#include "xscugic.h"
#include "drivers/platform/xilinx_irq.h"
#include "drivers/platform/xilinx_timer.h"
// App
#include "common.h"
#include "error.h"
#include "timer.h"
#include "hwconfig.h"
#include "system_monitor.h"
#include "config/app_config.h"
#include "dev_profile/dev_profile.h"

/************************** Function Prototypes ******************************/
int32_t SetupInterruptSystem(struct irq_ctrl_desc *descPtr);
void Phy_IntrHandler(void *context);
void PeriodicPull_Handler(void *callBackRef);
void ScuTimer_IntrHandler(void *context);
void Systembus_RxIntrHandler(void *context);
void Systembus_TxIntrHandler(void *context);

/************************** Constant Definitions *****************************/

/*********************** Driver Instance Definitions **************************/
static struct timer_desc *logTmPtr;

/*****************************************************************************/
/**
 * @brief	Main function, initialize all the device needed, initialize
 * 			interrupt system, halt in while(1) wait for event interrupt.
 *
 * @param   none.
 *
 * @return
 *
 ******************************************************************************/
int main(void)
{
	int32_t Status;
	DBG_PRINT("Application Version: %2d.%2d.%4d.\n", _APP_VER_MAIN, _APP_VER_MINOR, _APP_VER_PATCH);

	/* System Monitor Initialize */
	Status = SysMonitor_Init();
	if (Status == SUCCESS)
	{
		DBG_PRINT("System monitor Init SUCCESS. \n");
	}
	else
	{
		DBG_PRINT("System monitor Init FAILED. \n");
		return Status;
	}

	/* Hardware Initialize */
	Status = Hardware_Init();
	if (Status == SUCCESS)
	{
		DBG_PRINT("Hardware Init SUCCESS. \n");
	}
	else
	{
		DBG_PRINT("Hardware Init FAILED. \n");
		return Status;
	}

	DBG_PRINT("Done. \n");
}
