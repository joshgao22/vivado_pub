/*****************************************************************************/
/**
 * @file common.h
 * @author FanHao (hao_fan_bit_ee@163.com)
 * @brief Common macros
 * @version 0.0
 * @date 2022-07-16
 * @copyright Copyright(c) 2024 Beijing Institute of Technology.\n
 * Lab of Communication and Network
 *
 ******************************************************************************/
/**
 * @defgroup COMMON_MACRO
 * @{
 */

/***************************** Include Files *********************************/
#ifndef __COMMON_H_
#define __COMMON_H_
#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <inttypes.h>
#include <assert.h>
#include "util.h"
#include "error.h"

/************************** Constant Definitions *****************************/
/***************** Macros (Inline Functions) Definitions *********************/
#define __PRINT_BLOCK(block) \
    do                       \
    {                        \
        block                \
    } while (0)

#define ASSERT(exp) ((exp) ? (void)0 : AppAssert(__FILE__, __LINE__))
#define _nop_() __asm__("nop")

/* Stringify */
#define STR(x) #x

// #define _DEBUG_LEVEL 3

#if _DEBUG_LEVEL > 0
#define DBG_PRINT(...) printf(__VA_ARGS__)
#endif
#if _DEBUG_LEVEL >= 1
#define DBG_ERROR(...) __PRINT_BLOCK( \
    printf("in "__FILE__              \
           ":%d [error]\t",           \
           __LINE__);                 \
    printf(__VA_ARGS__);)
#endif
#if _DEBUG_LEVEL >= 2
#define DBG_WARNING(...) __PRINT_BLOCK( \
    printf("[warning]\t");              \
    printf(__VA_ARGS__);)
#endif
#if _DEBUG_LEVEL >= 3
#define DBG_INFO(...) __PRINT_BLOCK( \
    printf("[Info]\t");              \
    printf(__VA_ARGS__);)
#endif

#ifndef DBG_ERROR
#define DBG_ERROR(...) \
    {                  \
    }
#endif
#ifndef DBG_WARNING
#define DBG_WARNING(...) \
    {                    \
    }
#endif
#ifndef DBG_INFO
#define DBG_INFO(...) \
    {                 \
    }
#endif
#ifndef DBG_PRINT
#define DBG_PRINT(...) \
    {                  \
    }
#endif
/**************************** Type Definitions *******************************/

/************************** Variable Definitions *****************************/

/************************** Function Prototypes ******************************/
void AppAssert(const char *file, int line);
#endif /* __COMMON_H_ */

/** @} */