/*****************************************************************************/
/**
 * Description: Common functions
 *
 * Date: 2021-11-16 00:08
 * LastEditors: Fan Hao
 * LastEditTime: 2022-07-16 17:13
 * Revisions: Rev 0.1
 * History:
 * [2022-07-16]: New branch for Dijian.
 * [2021-11-16]: Initial version.
 *
 * Copyright(c) 2024 Beijing Institute of Technology.
 * Lab of Communication and Networking
 *
 ******************************************************************************/
/**
 * @addtogroup COMMON_MACRO
 * @{
 */
/***************************** Include Files *********************************/
#include "common.h"
#include "error.h"
#include "util.h"

/************************** Constant Definitions *****************************/

/***************** Macros (Inline Functions) Definitions *********************/

/**************************** Type Definitions *******************************/

/************************** Variable Definitions *****************************/

/*****************************************************************************/
/**
 * @brief	Throw an assert.
 *
 * @param	file indicate the filename of the assertion
 * @param	line indicate which line the assertion occurs
 *
 * @return	NONE.
 *
 ******************************************************************************/
void AppAssert(const char *file, int line)
{
	DBG_PRINT("in %s:%d [assert] .\n", file, line);
	while (1)
		;
}

/** @} */