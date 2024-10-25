/*****************************************************************************/
/**
 * @file util.h
 * @author FanHao (hao_fan_bit_ee@163.com)
 * @brief Utility functions header file
 * @version 0.0
 * @date 2023-05-06
 *
 * @copyright Copyright(c) 2024 Beijing Institute of Technology.\n
 * Lab of Communication and Network
 *
 ******************************************************************************/

/**
 * @defgroup Utility
 * @{
 */

#ifndef __UTIL_H_
#define __UTIL_H_

/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>
/******************************************************************************/
/********************** Macros and Constants Definitions **********************/
/******************************************************************************/
// #define __CRC_LSB
#define __BITSWAP_TABLE
#define __CRC_LSB
#define CRC16_INIT 0x0000
#define CRC8_INIT 0x00

#define BIT(x) (1 << (x))

#define ARRAY_SIZE(x) \
	(sizeof(x) / sizeof((x)[0]))

#define DIV_ROUND_UP(x, y) \
	(((x) + (y)-1) / (y))
#define DIV_ROUND_CLOSEST(x, y) \
	(((x) + (y) / 2) / (y))
#define DIV_ROUND_CLOSEST_ULL(x, y) \
	DIV_ROUND_CLOSEST(x, y)

#define min(x, y) \
	(((x) < (y)) ? (x) : (y))
#define min_t(type, x, y) \
	(type) min((type)(x), (type)(y))

#define max(x, y) \
	(((x) > (y)) ? (x) : (y))
#define max_t(type, x, y) \
	(type) max((type)(x), (type)(y))

#define clamp(val, min_val, max_val) \
	(max(min((val), (max_val)), (min_val)))
#define clamp_t(type, val, min_val, max_val) \
	(type) clamp((type)(val), (type)(min_val), (type)(max_val))

#define swap(x, y)             \
	{                          \
		typeof(x) _tmp_ = (x); \
		(x) = (y);             \
		(y) = _tmp_;           \
	}

#define round_up(x, y) \
	(((x) + (y)-1) / (y))

#define BITS_PER_LONG 32

#define GENMASK(h, l) ({                    \
	uint32_t t = (uint32_t)(~0UL);          \
	t = t << (BITS_PER_LONG - (h - l + 1)); \
	t = t >> (BITS_PER_LONG - (h + 1));     \
	t;                                      \
})

#define bswap_constant_32(x)                                  \
	((((x) & 0xff000000) >> 24) | (((x) & 0x00ff0000) >> 8) | \
	 (((x) & 0x0000ff00) << 8) | (((x) & 0x000000ff) << 24))

#define bswap_constant_16(x) ((((x) & (uint16_t)0xff00) >> 8) | \
							  (((x) & (uint16_t)0x00ff) << 8))

#define bit_swap_constant_8(x) \
	((((x) & 0x80) >> 7) |     \
	 (((x) & 0x40) >> 5) |     \
	 (((x) & 0x20) >> 3) |     \
	 (((x) & 0x10) >> 1) |     \
	 (((x) & 0x08) << 1) |     \
	 (((x) & 0x04) << 3) |     \
	 (((x) & 0x02) << 5) |     \
	 (((x) & 0x01) << 7))

#define U16_MAX ((uint16_t)~0U)
#define S16_MAX ((int16_t)(U16_MAX >> 1))

#define DIV_U64(x, y) (x / y)

#define UNUSED_PARAM(x) ((void)x)

#define shift_right(x, s) ((x) < 0 ? -(-(x) >> (s)) : (x) >> (s))

/******************************************************************************/
/************************ Functions Declarations ******************************/
/******************************************************************************/

void IO_Out32(uintptr_t addr, uint32_t value);
uint32_t IO_In32(uintptr_t addr);

/* flip a byte left to right*/
uint8_t byte_bit_swap(uint8_t byte);

/* flip a 32bit word left to right */
uint32_t word_bit_swap(uint32_t word);

/* Returns the number of 1-bits in digit. */
uint32_t count_ones(uint32_t word);

/* convert a fixed number to a double. */
double fix2double(int32_t val, uint8_t frac_bits);

/* Find first set bit in word. */
uint32_t find_first_set_bit(uint32_t word);
/* Find last set bit in word. */
uint32_t find_last_set_bit(uint32_t word);
/* Locate the closest element in an array. */
uint32_t find_closest(int32_t val,
					  const int32_t *array,
					  uint32_t size);
/* Shift the value and apply the specified mask. */
uint32_t field_prep(uint32_t mask, uint32_t val);
/* Get a field specified by a mask from a word. */
uint32_t field_get(uint32_t mask, uint32_t word);
/* Log base 2 of the given number. */
int32_t log_base_2(uint32_t x);
/* Find greatest common divisor of the given two numbers. */
uint32_t greatest_common_divisor(uint32_t a,
								 uint32_t b);
/* Calculate best rational approximation for a given fraction. */
void rational_best_approximation(uint32_t given_numerator,
								 uint32_t given_denominator,
								 uint32_t max_numerator,
								 uint32_t max_denominator,
								 uint32_t *best_numerator,
								 uint32_t *best_denominator);
/* Calculate the number of set bits. */
uint32_t hweight8(uint32_t word);
/* Calculate the quotient and the remainder of an integer division. */
uint64_t do_div(uint64_t *n,
				uint64_t base);
/* Unsigned 64bit divide with 64bit divisor and remainder */
uint64_t div64_u64_rem(uint64_t dividend, uint64_t divisor,
					   uint64_t *remainder);
/* Unsigned 64bit divide with 32bit divisor with remainder */
uint64_t div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder);
int64_t div_s64_rem(int64_t dividend, int32_t divisor, int32_t *remainder);
/* Unsigned 64bit divide with 32bit divisor */
uint64_t div_u64(uint64_t dividend, uint32_t divisor);
int64_t div_s64(int64_t dividend, int32_t divisor);
/* Converts from string to int32_t */
int32_t str_to_int32(const char *str);
/* Converts from string to uint32_t */
uint32_t srt_to_uint32(const char *str);

int crc16_gen(uint8_t *buffPtr, uint32_t dataLen, uint16_t poly, uint16_t *crcVal);
bool crc16_check(uint8_t *buffPtr, uint32_t dataLen, uint32_t crcOffset, uint16_t poly);
int crc8_gen(uint8_t *buffPtr, uint32_t dataLen, uint16_t poly, uint8_t *crcVal);
bool crc8_check(uint8_t *buffPtr, uint32_t dataLen, uint32_t crcOffset, uint16_t poly);
#endif // __UTIL_H_

/** @} */