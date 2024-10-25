/*****************************************************************************/
/**
 * @file util.c
 * @author FanHao (hao_fan_bit_ee@163.com)
 * @brief Utility functions implementation file
 * @version 0.0
 * @date 2023-05-06
 *
 * @copyright Copyright(c) 2024 Beijing Institute of Technology.\n
 * Lab of Communication and Network
 *
 ******************************************************************************/

/***************************** Include Files **********************************/

/**
 * @addtogroup Utility
 * @{
 */

#include <string.h>
#include <stdlib.h>
// #include <arm_acle.h>
#include "util.h"
#include "error.h"

/************************** Functions Implementation **************************/
#ifdef __BITSWAP_TABLE
static uint8_t byte_flipLR[256] =
{
	0x00, 0x80, 0x40, 0xC0, 0x20, 0xA0, 0x60, 0xE0,
	0x10, 0x90, 0x50, 0xD0, 0x30, 0xB0, 0x70, 0xF0,
	0x08, 0x88, 0x48, 0xC8, 0x28, 0xA8, 0x68, 0xE8,
	0x18, 0x98, 0x58, 0xD8, 0x38, 0xB8, 0x78, 0xF8,
	0x04, 0x84, 0x44, 0xC4, 0x24, 0xA4, 0x64, 0xE4,
	0x14, 0x94, 0x54, 0xD4, 0x34, 0xB4, 0x74, 0xF4,
	0x0C, 0x8C, 0x4C, 0xCC, 0x2C, 0xAC, 0x6C, 0xEC,
	0x1C, 0x9C, 0x5C, 0xDC, 0x3C, 0xBC, 0x7C, 0xFC,
	0x02, 0x82, 0x42, 0xC2, 0x22, 0xA2, 0x62, 0xE2,
	0x12, 0x92, 0x52, 0xD2, 0x32, 0xB2, 0x72, 0xF2,
	0x0A, 0x8A, 0x4A, 0xCA, 0x2A, 0xAA, 0x6A, 0xEA,
	0x1A, 0x9A, 0x5A, 0xDA, 0x3A, 0xBA, 0x7A, 0xFA,
	0x06, 0x86, 0x46, 0xC6, 0x26, 0xA6, 0x66, 0xE6,
	0x16, 0x96, 0x56, 0xD6, 0x36, 0xB6, 0x76, 0xF6,
	0x0E, 0x8E, 0x4E, 0xCE, 0x2E, 0xAE, 0x6E, 0xEE,
	0x1E, 0x9E, 0x5E, 0xDE, 0x3E, 0xBE, 0x7E, 0xFE,
	0x01, 0x81, 0x41, 0xC1, 0x21, 0xA1, 0x61, 0xE1,
	0x11, 0x91, 0x51, 0xD1, 0x31, 0xB1, 0x71, 0xF1,
	0x09, 0x89, 0x49, 0xC9, 0x29, 0xA9, 0x69, 0xE9,
	0x19, 0x99, 0x59, 0xD9, 0x39, 0xB9, 0x79, 0xF9,
	0x05, 0x85, 0x45, 0xC5, 0x25, 0xA5, 0x65, 0xE5,
	0x15, 0x95, 0x55, 0xD5, 0x35, 0xB5, 0x75, 0xF5,
	0x0D, 0x8D, 0x4D, 0xCD, 0x2D, 0xAD, 0x6D, 0xED,
	0x1D, 0x9D, 0x5D, 0xDD, 0x3D, 0xBD, 0x7D, 0xFD,
	0x03, 0x83, 0x43, 0xC3, 0x23, 0xA3, 0x63, 0xE3,
	0x13, 0x93, 0x53, 0xD3, 0x33, 0xB3, 0x73, 0xF3,
	0x0B, 0x8B, 0x4B, 0xCB, 0x2B, 0xAB, 0x6B, 0xEB,
	0x1B, 0x9B, 0x5B, 0xDB, 0x3B, 0xBB, 0x7B, 0xFB,
	0x07, 0x87, 0x47, 0xC7, 0x27, 0xA7, 0x67, 0xE7,
	0x17, 0x97, 0x57, 0xD7, 0x37, 0xB7, 0x77, 0xF7,
	0x0F, 0x8F, 0x4F, 0xCF, 0x2F, 0xAF, 0x6F, 0xEF,
	0x1F, 0x9F, 0x5F, 0xDF, 0x3F, 0xBF, 0x7F, 0xFF
};
#endif

/**
 * @brief Write a 32bit word to specific memory address
 */
inline void IO_Out32(uintptr_t addr, uint32_t value)
{
	volatile uint32_t *localAddr = (volatile uint32_t *)addr;
	*localAddr = value;
}

/**
 * @brief Read a 32bit word from specific memory address
 */
inline uint32_t IO_In32(uintptr_t addr)
{
	return *(volatile uint32_t *)addr;
}

/**
 * @brief Swap a byte word bit-wise
 */
uint8_t byte_bit_swap(uint8_t byte)
{
#ifdef __BITSWAP_TABLE
	return byte_flipLR[byte];
#else
	return bit_swap_constant_8(byte);
#endif
}

/**
 * @brief Swap 32bit word bit-wise
 */
uint32_t word_bit_swap(uint32_t word)
{
#ifdef __BITSWAP_TABLE
	uint32_t rv_word = (byte_flipLR[word & 0xff] << 24) |
					   (byte_flipLR[(word >> 8) & 0xff] << 16) |
					   (byte_flipLR[(word >> 16) & 0xff] << 8) |
					   (byte_flipLR[(word >> 24) & 0xff]);
	return rv_word;
#else
	word = (((word & 0xaaaaaaaa) >> 1) | ((word & 0x55555555) << 1));
	word = (((word & 0xcccccccc) >> 2) | ((word & 0x33333333) << 2));
	word = (((word & 0xf0f0f0f0) >> 4) | ((word & 0x0f0f0f0f) << 4));
	word = (((word & 0xff00ff00) >> 8) | ((word & 0x00ff00ff) << 8));
	return ((word >> 16) | (word << 16));
#endif
}

/**
 * @brief Count ones in an 32bit word
 */
uint32_t count_ones(uint32_t word)
{
#ifdef __GNUC__
	return __builtin_popcount(word);
#else
	uint32_t one_count = 0;
	while (word)
	{
		if (word & 0x00000001)
			one_count++;
		word >>= 1;
	}
	return one_count;
#endif
}

/**
 * @brief Convert fix ;oint number to float number
 */
double fix2double(int32_t val, uint8_t frac_bits)
{
	return (((double)val) / (BIT(frac_bits)));
}

/**
 * @brief Find first set bit in word.
 */
uint32_t find_first_set_bit(uint32_t word)
{
#ifdef __GNUC__
	if (word != 0)
	{
		return __builtin_ctz(word);
	}
	else
	{
		return 32;
	}
#else
	uint32_t first_set_bit = 0;

	while (word)
	{
		if (word & 0x1)
			return first_set_bit;
		word >>= 1;
		first_set_bit++;
	}

	return 32;
#endif
}

/**
 * @brief Find last set bit in word.
 */
uint32_t find_last_set_bit(uint32_t word)
{
#ifdef __GNUC__
	if (word != 0)
	{
		return (31 - __builtin_clz(word));
	}
	else
	{
		return 32;
	}
#else
	uint32_t bit = 0;
	uint32_t last_set_bit = 32;

	while (word)
	{
		if (word & 0x1)
			last_set_bit = bit;
		word >>= 1;
		bit++;
	}

	return last_set_bit;
#endif
}

/**
 * @brief Locate the closest element in an array.
 */
uint32_t find_closest(int32_t val,
					  const int32_t *array,
					  uint32_t size)
{
	int32_t diff = abs(array[0] - val);
	uint32_t ret = 0;
	uint32_t i;

	for (i = 1; i < size; i++)
	{
		if (abs(array[i] - val) < diff)
		{
			diff = abs(array[i] - val);
			ret = i;
		}
	}

	return ret;
}

/**
 * @brief Shift the value and apply the specified mask.
 */
uint32_t field_prep(uint32_t mask, uint32_t val)
{
	return (val << find_first_set_bit(mask)) & mask;
}

/**
 * @brief Get a field specified by a mask from a word.
 */
uint32_t field_get(uint32_t mask, uint32_t word)
{
	return (word & mask) >> find_first_set_bit(mask);
}

/**
 * @brief Log base 2 of the given number.
 */
int32_t log_base_2(uint32_t x)
{
	return find_last_set_bit(x);
}

/**
 * @brief Find greatest common divisor of the given two numbers.
 */
uint32_t greatest_common_divisor(uint32_t a,
								 uint32_t b)
{
	uint32_t div;
	uint32_t common_div = 1;

	if ((a == 0) || (b == 0))
		return max(a, b);

	for (div = 1; (div <= a) && (div <= b); div++)
		if (!(a % div) && !(b % div))
			common_div = div;

	return common_div;
}

/**
 * @brief Calculate best rational approximation for a given fraction.
 */
void rational_best_approximation(uint32_t given_numerator,
								 uint32_t given_denominator,
								 uint32_t max_numerator,
								 uint32_t max_denominator,
								 uint32_t *best_numerator,
								 uint32_t *best_denominator)
{
	uint32_t gcd;

	gcd = greatest_common_divisor(given_numerator, given_denominator);

	*best_numerator = given_numerator / gcd;
	*best_denominator = given_denominator / gcd;

	if ((*best_numerator > max_numerator) ||
		(*best_denominator > max_denominator))
	{
		*best_numerator = 0;
		*best_denominator = 0;
	}
}

/**
 * @brief Calculate the number of set bits.
 */
uint32_t hweight8(uint32_t word)
{
	uint32_t count = 0;

	while (word)
	{
		if (word & 0x1)
			count++;
		word >>= 1;
	}

	return count;
}

/**
 * @brief Calculate the quotient and the remainder of an integer division.
 */
uint64_t do_div(uint64_t *n,
				uint64_t base)
{
	uint64_t mod = 0;

	mod = *n % base;
	*n = *n / base;

	return mod;
}

/**
 * @brief Unsigned 64bit divide with 64bit divisor and remainder
 */
uint64_t div64_u64_rem(uint64_t dividend, uint64_t divisor, uint64_t *remainder)
{
	*remainder = dividend % divisor;

	return dividend / divisor;
}

/**
 * @brief Unsigned 64bit divide with 32bit divisor with remainder
 */
uint64_t div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
{
	*remainder = do_div(&dividend, divisor);

	return dividend;
}

/**
 * @brief Signed 64bit divide with 32bit divisor with remainder
 */
int64_t div_s64_rem(int64_t dividend, int32_t divisor, int32_t *remainder)
{
	*remainder = dividend % divisor;
	return dividend / divisor;
}

/**
 * @brief Unsigned 64bit divide with 32bit divisor
 */
uint64_t div_u64(uint64_t dividend, uint32_t divisor)
{
	uint32_t remainder;

	return div_u64_rem(dividend, divisor, &remainder);
}

/**
 * @brief Signed 64bit divide with 32bit divisor
 */
int64_t div_s64(int64_t dividend, int32_t divisor)
{
	int32_t remainder;
	return div_s64_rem(dividend, divisor, &remainder);
}

/**
 * @brief Converts from string to int32_t
 * @param *str
 * @return int32_t
 */
int32_t str_to_int32(const char *str)
{
	char *end;
	int32_t value = strtol(str, &end, 0);

	if (end == str)
		return FAILURE;
	else
		return value;
}

/**
 * @brief Converts from string to uint32_t
 * @param *str
 * @return uint32_t
 */
uint32_t srt_to_uint32(const char *str)
{
	char *end;
	uint32_t value = strtoul(str, &end, 0);

	if (end == str)
		return FAILURE;
	else
		return value;
}

/** @} */