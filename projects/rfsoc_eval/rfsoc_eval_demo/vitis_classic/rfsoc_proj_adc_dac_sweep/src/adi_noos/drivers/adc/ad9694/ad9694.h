/***************************************************************************//**
 * @file ad9694.h
 * @brief Header file of AD9694 Driver.
 * @author DBogdan (dragos.bogdan@analog.com)
 ********************************************************************************
 * Copyright 2014-2016(c) Analog Devices, Inc.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * - Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in
 * the documentation and/or other materials provided with the
 * distribution.
 * - Neither the name of Analog Devices, Inc. nor the names of its
 * contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 * - The use of this software may or may not infringe the patent rights
 * of one or more patent holders. This license does not release you
 * from the requirement that you obtain separate licenses from these
 * patent holders to use this software.
 * - Use of the software either in source or binary form, must be run
 * on or directly connected to an Analog Devices Inc. component.
 *
 * THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT,
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *******************************************************************************/
#ifndef AD9694_H_
#define AD9694_H_

/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include <stdint.h>
#include "../../../include/delay.h"
#include "../../../include/spi.h"

/******************************************************************************/
/********************** Macros and Constants Definitions **********************/
/******************************************************************************/
#define AD9694_REG_GLOBAL_MAP_SPI_CONF_A						0x0000
#define AD9694_REG_GLOBAL_MAP_SPI_CONF_B						0x0001
#define AD9694_REG_CH_MAP_CHIP_CONF								0x0002
#define AD9694_REG_PAIR_MAP_CHIP_TYPE							0x0003
#define AD9694_REG_PAIR_MAP_CHIP_ID_LSB							0x0004
#define AD9694_REG_PAIR_MAP_CHIP_GRADE							0x0006
#define AD9694_REG_PAIR_MAP_DEV_INDEX							0x0008
#define AD9694_REG_GLOBAL_MAP_PAIR_INDEX						0x0009
#define AD9694_REG_PAIR_MAP_SCRATCH_PAD							0x000A
#define AD9694_REG_PAIR_MAP_SPI_REVISION						0x000B
#define AD9694_REG_PAIR_MAP_VENDOR_ID_LSB						0x000C
#define AD9694_REG_PAIR_MAP_VENDOR_ID_MSB						0x000D
#define AD9694_REG_CH_MAP_CHIP_PD_PIN							0x003F
#define AD9694_REG_PAIR_MAP_CHIP_PIN_CTRL_1						0x0040
#define AD9694_REG_PAIR_MAP_CLK_DIV_CTRL						0x0108
#define AD9694_REG_CH_MAP_CLK_DIV_PHASE							0x0109
#define AD9694_REG_PAIR_MAP_CLK_DIV_SYSREF_CTRL					0x010A
#define AD9694_REG_PAIR_MAP_CLK_DELAY_CTRL						0x0110
#define AD9694_REG_CH_MAP_CLK_SUPER_FINE_DELAY					0x0111
#define AD9694_REG_CH_MAP_CLK_FINE_DELAY						0x0112
#define AD9694_REG_CLK_DETN_CTRL								0x011A
#define AD9694_REG_PAIR_MAP_CLK_STAT							0x011B
#define AD9694_REG_CLK_DCS_CTRL_1								0x011C
#define AD9694_REG_CLK_DCS_CTRL_2								0x011E
#define AD9694_REG_CLK_DCS_CTRL_3								0x011F
#define AD9694_REG_PAIR_MAP_SYSREF_CTRL_1						0x0120
#define AD9694_REG_PAIR_MAP_SYSREF_CTRL_2						0x0121
#define AD9694_REG_PAIR_MAP_SYSREF_CTRL_4						0x0123
#define AD9694_REG_PAIR_MAP_SYSREF_STAT_1						0x0128
#define AD9694_REG_PAIR_MAP_SYSREF_STAT_2						0x0129
#define AD9694_REG_PAIR_MAP_SYSREF_STAT_3						0x012A
#define AD9694_REG_PAIR_MAP_CHIP_SYNC							0x01FF
#define AD9694_REG_PAIR_MAP_CHIP_MODE							0x0200
#define AD9694_REG_PAIR_MAP_CHIP_DEC_RATIO						0x0201
#define AD9694_REG_CH_MAP_CUSTOM_OFFSET							0x0228
#define AD9694_REG_CH_MAP_FD_CTRL								0x0245
#define AD9694_REG_CH_MAP_FD_UT_LSB								0x0247
#define AD9694_REG_CH_MAP_FD_UT_MSB								0x0248
#define AD9694_REG_CH_MAP_FD_LT_LSB								0x0249
#define AD9694_REG_CH_MAP_FD_LT_MSB								0x024A
#define AD9694_REG_CH_MAP_FD_DWELL_TIME_LSB						0x024B
#define AD9694_REG_CH_MAP_FD_DWELL_TIME_MSB						0x024C
#define AD9694_REG_PAIR_MAP_SIG_MON_SYNC_CTRL					0x026F
#define AD9694_REG_CH_MAP_SIG_MON_CTRL							0x0270
#define AD9694_REG_CH_MAP_SIG_MON_PERIOD_0						0x0271
#define AD9694_REG_CH_MAP_SIG_MON_PERIOD_1						0x0272
#define AD9694_REG_CH_MAP_SIG_MON_PERIOD_2						0x0273
#define AD9694_REG_CH_MAP_SIG_MON_STAT_CTRL						0x0274
#define AD9694_REG_CH_MAP_SIG_MON_STAT_0						0x0275
#define AD9694_REG_CH_MAP_SIG_MON_STAT_1						0x0276
#define AD9694_REG_CH_MAP_SIG_MON_STAT_2						0x0277
#define AD9694_REG_CH_MAP_SIG_MON_STAT_FRAME_CNT				0x0278
#define AD9694_REG_CH_MAP_SIG_MON_SERIAL_FRAMER_CTRL			0x0279
#define AD9694_REG_SPORT_OVER_JESD204B_INPUT_SEL				0x027A
#define AD9694_REG_PAIR_MAP_DDC_SYNC_CTRL						0x0300
#define AD9694_REG_PAIR_MAP_DDC_0_CTRL							0x0310
#define AD9694_REG_PAIR_MAP_DDC_0_INPUT_SEL						0x0311
#define AD9694_REG_PAIR_MAP_DDC_0_PHASE_INC_0					0x0314
#define AD9694_REG_PAIR_MAP_DDC_0_PHASE_INC_1					0x0315
#define AD9694_REG_PAIR_MAP_DDC_0_PHASE_INC_2					0x0316
#define AD9694_REG_PAIR_MAP_DDC_0_PHASE_INC_3					0x0317
#define AD9694_REG_PAIR_MAP_DDC_0_PHASE_INC_4					0x0318
#define AD9694_REG_PAIR_MAP_DDC_0_PHASE_INC_5					0x031A
#define AD9694_REG_PAIR_MAP_DDC_0_PHASE_OFFSET_0				0x031D
#define AD9694_REG_PAIR_MAP_DDC_0_PHASE_OFFSET_1				0x031E
#define AD9694_REG_PAIR_MAP_DDC_0_PHASE_OFFSET_2				0x031F
#define AD9694_REG_PAIR_MAP_DDC_0_PHASE_OFFSET_3				0x0320
#define AD9694_REG_PAIR_MAP_DDC_0_PHASE_OFFSET_4				0x0321
#define AD9694_REG_PAIR_MAP_DDC_0_PHASE_OFFSET_5				0x0322
#define AD9694_REG_PAIR_MAP_DDC_0_TEST_ENABLE					0x0327
#define AD9694_REG_PAIR_MAP_DDC_1_CTRL							0x0330
#define AD9694_REG_PAIR_MAP_DDC_1_INPUT_SEL						0x0331
#define AD9694_REG_PAIR_MAP_DDC_1_PHASE_INC_0					0x0334
#define AD9694_REG_PAIR_MAP_DDC_1_PHASE_INC_1					0x0335
#define AD9694_REG_PAIR_MAP_DDC_1_PHASE_INC_2					0x0336
#define AD9694_REG_PAIR_MAP_DDC_1_PHASE_INC_3					0x0337
#define AD9694_REG_PAIR_MAP_DDC_1_PHASE_INC_4					0x0338
#define AD9694_REG_PAIR_MAP_DDC_1_PHASE_INC_5					0x033A
#define AD9694_REG_PAIR_MAP_DDC_1_PHASE_OFFSET_0				0x033D
#define AD9694_REG_PAIR_MAP_DDC_1_PHASE_OFFSET_1				0x033E
#define AD9694_REG_PAIR_MAP_DDC_1_PHASE_OFFSET_2				0x033F
#define AD9694_REG_PAIR_MAP_DDC_1_PHASE_OFFSET_3				0x0340
#define AD9694_REG_PAIR_MAP_DDC_1_PHASE_OFFSET_4				0x0341
#define AD9694_REG_PAIR_MAP_DDC_1_PHASE_OFFSET_5				0x0342
#define AD9694_REG_PAIR_MAP_DDC_1_TEST_ENABLE					0x0347
#define AD9694_REG_CH_MAP_TEST_MODE_CTRL						0x0550
#define AD9694_REG_PAIR_MAP_USER_PATTERN_1_LSB					0x0551
#define AD9694_REG_PAIR_MAP_USER_PATTERN_1_MSB					0x0552
#define AD9694_REG_PAIR_MAP_USER_PATTERN_2_LSB					0x0553
#define AD9694_REG_PAIR_MAP_USER_PATTERN_2_MSB					0x0554
#define AD9694_REG_PAIR_MAP_USER_PATTERN_3_LSB					0x0555
#define AD9694_REG_PAIR_MAP_USER_PATTERN_3_MSB					0x0556
#define AD9694_REG_PAIR_MAP_USER_PATTERN_4_LSB					0x0557
#define AD9694_REG_PAIR_MAP_USER_PATTERN_4_MSB					0x0558
#define AD9694_REG_PAIR_MAP_OUTPUT_CTRL_MODE_0					0x0559
#define AD9694_REG_PAIR_MAP_OUTPUT_CTRL_MODE_1					0x055A
#define AD9694_REG_PAIR_MAP_OUTPUT_SAMPLE_MODE					0x0561
#define AD9694_REG_PAIR_MAP_OUTPUT_CH_SEL						0x0564
#define AD9694_REG_JESD204B_MAP_PLL_CTRL						0x056E
#define AD9694_REG_JESD204B_MAP_PLL_STAT						0x056F
#define AD9694_REG_JESD204B_MAP_JTX_QUICK_CONF					0x0570
#define AD9694_REG_JESD204B_MAP_JTX_LINK_CTRL_1					0x0571
#define AD9694_REG_JESD204B_MAP_JTX_LINK_CTRL_2					0x0572
#define AD9694_REG_JESD204B_MAP_JTX_LINK_CTRL_3					0x0573
#define AD9694_REG_JESD204B_MAP_JTX_LINK_CTRL_4					0x0574
#define AD9694_REG_JESD204B_MAP_JTX_LMFC_OFFSET					0x0578
#define AD9694_REG_JESD204B_MAP_JTX_DID_CONF					0x0580
#define AD9694_REG_JESD204B_MAP_JTX_BID_CONF					0x0581
#define AD9694_REG_JESD204B_MAP_JTX_LID_0_CONF					0x0583
#define AD9694_REG_JESD204B_MAP_JTX_LID_1_CONF					0x0585
#define AD9694_REG_JESD204B_MAP_JTX_SCR_L_CONF					0x058B
#define AD9694_REG_JESD204B_MAP_JTX_F_CONF						0x058C
#define AD9694_REG_JESD204B_MAP_JTX_K_CONF						0x058D
#define AD9694_REG_JESD204B_MAP_JTX_M_CONF						0x058E
#define AD9694_REG_JESD204B_MAP_JTX_CS_N_CONF					0x058F
#define AD9694_REG_JESD204B_MAP_JTX_SUBCLASS_CONF				0x0590
#define AD9694_REG_JESD204B_MAP_JTX_S_CONF						0x0591
#define AD9694_REG_JESD204B_MAP_JTX_HD_CF_CONF					0x0592
#define AD9694_REG_JESD204B_MAP_JTX_CHECKSUM_0_CONF				0x05A0
#define AD9694_REG_JESD204B_MAP_JTX_CHECKSUM_1_CONF				0x05A1
#define AD9694_REG_SERDOUTX0_SERDOUTX1_LANE_PD					0x05B0
#define AD9694_REG_JESD204B_MAP_JTX_LANE_ASSIGN_1				0x05B2
#define AD9694_REG_JESD204B_MAP_JTX_LANE_ASSIGN_2				0x05B3
#define AD9694_REG_JESD204B_MAP_SERD_ADJUST_0					0x05C0
#define AD9694_REG_JESD204B_MAP_SERD_ADJUST_1					0x05C1
#define AD9694_REG_JESD204B_SER_PE_SEL_LANE_0					0x05C4
#define AD9694_REG_JESD204B_SER_PE_SEL_LANE_1					0x05C6
#define AD9694_REG_LARGE_DITHER_CTRL							0x0922
#define AD9694_REG_PLL_CAL										0x1222
#define AD9694_REG_JESD204B_STARTUP_CIRCUIT_RST					0x1228
#define AD9694_REG_PLL_LOSS_OF_LOCK_CTRL						0x1262
#define AD9694_REG_DC_OFFSET_CAL_CTRL							0x0701
#define AD9694_REG_DC_OFFSET_CAL_CTRL_2							0x073B
#define AD9694_REG_PAIR_MAP_VREF_CTRL							0x18A6
#define AD9694_REG_EXT_VCM_BUF_CTRL_1							0x18E0
#define AD9694_REG_EXT_VCM_BUF_CTRL_2							0x18E1
#define AD9694_REG_EXT_VCM_BUF_CTRL_3							0x18E2
#define AD9694_REG_EXT_VCM_BUF_CTRL								0x18E3
#define AD9694_REG_TEMP_DIODE_EXPORT							0x18E6
#define AD9694_REG_CH_MAP_ANALOG_INPUT_CTRL						0x1908
#define AD9694_REG_CH_MAP_INPUT_FULLSCALE_RANGE					0x1910
#define AD9694_REG_CH_MAP_BUF_CTRL_1							0x1A4C
#define AD9694_REG_CH_MAP_BUF_CTRL_2							0x1A4D

/******************************************************************************/
/*************************** Types Declarations *******************************/
/******************************************************************************/
struct ad9694_dev {
	/* SPI */
	spi_desc	*spi_desc;
};

struct ad9694_init_param {
	/* SPI */
	spi_init_param	*spi_init;
};

struct ad9694_config {
	uint16_t addr;
	uint8_t value;
};

/******************************************************************************/
/************************ Functions Declarations ******************************/
/******************************************************************************/

int32_t ad9694_read(struct ad9694_dev *dev,
			uint16_t reg_addr,
			uint8_t *reg_data);

int32_t ad9694_write(struct ad9694_dev *dev,
			 uint16_t reg_addr,
			 uint8_t reg_data);

int32_t ad9694_init(struct ad9694_dev **device,
		     const struct ad9694_init_param *init_param);

int32_t ad9694_remove(struct ad9694_dev *dev);

#endif
