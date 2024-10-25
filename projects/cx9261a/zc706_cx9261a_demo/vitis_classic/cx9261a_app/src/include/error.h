/*****************************************************************************/
/**
 * @file common.h
 * @author FanHao (hao_fan_bit_ee@163.com)
 * @brief Common error numbers
 * @version 0.0
 * @date 2022-06-18
 * @copyright Copyright(c) 2024 Beijing Institute of Technology.\n
 * Lab of Communication and Network
 *
 ******************************************************************************/

/**
 * @addtogroup COMMON_MACRO
 * @{
 */

#ifndef SRC_ERROR_H_
#define SRC_ERROR_H_

#include <errno.h>

/******************************************************************************/
/********************** Macros and Constants Definitions **********************/
/******************************************************************************/

/**
 * @name ERRORNO
 * @{
 */

#ifdef SUCCESS
#undef SUCCESS
#endif
#define SUCCESS		0
#ifdef FAILURE
#undef FAILURE
#endif
#define FAILURE		-1

#define EPARAM -2	/*!< Data crc check failed */
#define ECRC -3     /*!< Data crc check failed */
#define EDINVAL -4	/*!< Device is invalid (sleep or power off) */
#define EDCONF -5	/*!< Device confugure error */
#define ETIMEOUT -6 /*!< Timeout error */
#define EIGNORE -7	/*!< Received an unsupported command, and ignore it */
#define EQUEUE  -8	/*!< Queue overflow */
#define EUNEXP  -9	/*!< Encounter an unexpected error */

#define IS_ERR_VALUE(x)	((x) != SUCCESS)

#endif // ERROR_H_

/** @} ERRORNO*/

/** @} COMMON_MACRO*/