/***************************************************************************//**
 *   @file   hmc7044.h
 *   @brief  Header file of HMC7044, HMC7043 Driver.
 *   @author DBogdan (dragos.bogdan@analog.com)
********************************************************************************
 * Copyright 2018-2020(c) Analog Devices, Inc.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  - Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *  - Neither the name of Analog Devices, Inc. nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *  - The use of this software may or may not infringe the patent rights
 *    of one or more patent holders.  This license does not release you
 *    from the requirement that you obtain separate licenses from these
 *    patent holders to use this software.
 *  - Use of the software either in source or binary form, must be run
 *    on or directly connected to an Analog Devices Inc. component.
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
#ifndef HMC7044_H_
#define HMC7044_H_

/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include <stdbool.h>
#include <stdint.h>
#include "delay.h"
#include "spi.h"

/******************************************************************************/
/*************************** Types Declarations *******************************/
/******************************************************************************/
// Enum to select SYNC pin configuration with respect to PLL2 (0x0005)
typedef enum
{
    SYNC_DISABLED = 0,
	SYNC_MULTICHIP = 1,
	SYNC_PULSE_GEN = 2,
	SYNC_ALARM = 3
} hmc7044SyncPinModeSelect_t;

// Enum to select input buffer mode (0x000A, 0x000B, 0x000C, 0x000D, 0x000E)
typedef enum
{
	BUFFER_ENABLE 			= (1) << 0,
	BUFFER_DISABLE			= (0) << 0,
    ENABLE_INTERNAL_TERM 	= (1) << 1,
	ENABLE_AC_COUPLE 		= (1) << 2,
	ENABLE_LVPECL 			= (1) << 3,
	ENABLE_HIGH_Z 			= (1) << 4
} hmc7044InputBufferMode_t;

// Enum to select output driver mode (0x003A, 0x003B, 0x00D0, 0x00DA, 0x00E4,
// 0x00EE, 0x00F8, 0x0102, 0x010C, 0x0116, 0x0120, 0x012A, 0x0134, 0x013E,
// 0x0148, 0x0152)
typedef enum
{
    HMC7044_CML = 0,
	HMC7044_LVPECL = 1,
	HMC7044_LVDS = 2,
	HMC7044_CMOS = 3
} hmc7044DriverMode_t;

// Enum to select the GPIx functionality. (0x0046, 0x0047, 0x0048, 0x0049)
typedef enum
{
	GPI_ENABLE 					= (1) << 0,
	GPI_DISABLE 				= (0) << 0,
    FORCE_PLL1_HOLDOVER 		= (0x01) << 1 | GPI_ENABLE,
	SELECT_PLL1_REF_BIT1 		= (0x02) << 1 | GPI_ENABLE,
	SELECT_PLL1_REF_BIT2 		= (0x03) << 1 | GPI_ENABLE,
	CHIP_SLEEP_MODE 			= (0x04) << 1 | GPI_ENABLE,
	MUTE_REQUSET				= (0x05) << 1 | GPI_ENABLE,
	SELECT_INTERNAL_VCO_TYPE	= (0x06) << 1 | GPI_ENABLE,
	SELECT_HI_PERF_MODE			= (0x07) << 1 | GPI_ENABLE,
	PULSE_GEN_REQUSET			= (0x08) << 1 | GPI_ENABLE,
	RESEED_REQUEST				= (0x09) << 1 | GPI_ENABLE,
	RESTART_REQUSET				= (0x0A) << 1 | GPI_ENABLE,
	FORCE_FANOUT_MODE			= (0x0B) << 1 | GPI_ENABLE,
	SLIP_REQUEST				= (0x0D) << 1 | GPI_ENABLE,
} hmc7044GPIControl_t;

// Enum to select the GPOx functionality. (0x0050, 0x0051, 0x0052, 0x0053)
typedef enum
{
	GPO_ENABLE 						= (1) << 0,
	GPO_DISABLE 					= (0) << 0,
	GPO_CMOS_MODE 					= (1) << 1,
	GPO_OPEN_DRAIN_MODE 			= (0) << 1,
    ALARM_SIGNAL 					= (0x00) << 3 | GPO_ENABLE,
    SPI_SDATA 						= (0x01) << 3 | GPO_ENABLE,
	CLKIN3_SIGNAL_LOSS 				= (0x02) << 3 | GPO_ENABLE,
	CLKIN2_SIGNAL_LOSS 				= (0x03) << 3 | GPO_ENABLE,
	CLKIN1_SIGNAL_LOSS 				= (0x04) << 3 | GPO_ENABLE,
	CLKIN0_SIGNAL_LOSS				= (0x05) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_ENABLE			= (0x06) << 3 | GPO_ENABLE,
	PLL1_LOCK_DETECT				= (0x07) << 3 | GPO_ENABLE,
	PLL1_ACQUIRING_LOCK				= (0x08) << 3 | GPO_ENABLE,
	PLL1_NEAR_CLOCK_ACQ_STAT		= (0x09) << 3 | GPO_ENABLE,
	PLL2_LOCK_DETECT				= (0x0A) << 3 | GPO_ENABLE,
	PLL2_SYSREF_SYNC				= (0x0B) << 3 | GPO_ENABLE,
	CLOCK_OUTPUT_PHASE_STAT			= (0x0C) << 3 | GPO_ENABLE,
	PLL1_PLL2_LOCKED				= (0x0D) << 3 | GPO_ENABLE,
	SYNC_REQUSRT_STAT				= (0x0E) << 3 | GPO_ENABLE,
	PLL1_ACTIVE_CLKIN0				= (0x0F) << 3 | GPO_ENABLE,
	PLL1_ACTIVE_CLKIN1				= (0x10) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_IN_RANGE_STAT		= (0x11) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_IN_STAT			= (0x12) << 3 | GPO_ENABLE,
	PLL1_VCXO_STAT					= (0x13) << 3 | GPO_ENABLE,
	PLL1_ACTIVE_CLKINx_STAT			= (0x14) << 3 | GPO_ENABLE,
	PLL1_FSM_BIT0					= (0x15) << 3 | GPO_ENABLE,
	PLL1_FSM_BIT1					= (0x16) << 3 | GPO_ENABLE,
	PLL1_FSM_BIT2					= (0x17) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_EXIT_PHASE_BIT0	= (0x18) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_EXIT_PHASE_BIT1	= (0x19) << 3 | GPO_ENABLE,
	CHANNEL_OUTPUT_FSM_BUSY			= (0x1A) << 3 | GPO_ENABLE,
	SYSREF_FSM_STAT_BIT0			= (0x1B) << 3 | GPO_ENABLE,
	SYSREF_FSM_STAT_BIT1			= (0x1C) << 3 | GPO_ENABLE,
	SYSREF_FSM_STAT_BIT2			= (0x1D) << 3 | GPO_ENABLE,
	SYSREF_FSM_STAT_BIT3			= (0x1E) << 3 | GPO_ENABLE,
	FORCE_LOGIC_1					= (0x1F) << 3 | GPO_ENABLE,
	FORCE_LOGIC_0					= (0x20) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_AVG_VALUE_BIT0	= (0x27) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_AVG_VALUE_BIT1	= (0x28) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_AVG_VALUE_BIT2	= (0x29) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_AVG_VALUE_BIT3	= (0x2A) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_CURR_VALUE_BIT0	= (0x2B) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_CURR_VALUE_BIT1	= (0x2C) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_CURR_VALUE_BIT2	= (0x2D) << 3 | GPO_ENABLE,
	PLL1_HOLDOVER_CURR_VALUE_BIT3	= (0x2E) << 3 | GPO_ENABLE
} hmc7044GPOControl_t;

// Enum to select output channel (0x00CF, 0x00D9, 0x00E3, 0x00ED, 0x00F7,
// 0x0101, 0x010B, 0x0115, 0x011F, 0x0129, 0x0133, 0x013D, 0x0147, 0x0151
typedef enum
{
    HMC7044_CHANNEL_DIV = 0,
	ANALOG_DELAY = 1,
	OTHER_CHANNEL = 2,
	VCO_CLOCK = 3
} hmc7044OutputMuxSelect_t;

// Enum to select output driver impedance selection for CML mode (0x00D0,
// 0x00DA, 0x00E4, 0x00EE, 0x00F8, 0x0102, 0x010C, 0x0116, 0x0120, 0x012A,
// 0x0134, 0x013E, 0x0148, 0x0152)
typedef enum
{
    INTERNAL_RES_DISABLE = 0,
	INTERNAL_100OHM_PER_PIN = 1,
//	INTERNAL_RES_RESERVED = 2,
	INTERNAL_50OHM_PER_PIN = 3
} hmc7044DriverImpedance_t;

// Enum to select pulse generator mode (0x005A)
typedef enum
{
    PULSE_LEVEL_SENSITIVE = 0,
	PULSE_ONE = 1,
	PULSE_TWO = 2,
	PULSE_FOUR = 3,
	PULSE_EIGHT = 4,
	PULSE_SIXTEEN = 5,
//	PULSE_SIXTEEN = 6,
	PULSE_CONTINOUS = 7
} hmc7044SyncPulseGenControl_t;

struct hmc7044_chan_spec {
	unsigned int	num;
	bool		disable;
	bool		high_performance_mode_dis;
	bool		start_up_mode_dynamic_enable;
	bool		dynamic_driver_enable;
	bool		output_control0_rb4_enable;
	bool		force_mute_enable;
	unsigned int	divider;
	unsigned int	coarse_delay;
	unsigned int	fine_delay;
	hmc7044DriverMode_t driver_mode;
	hmc7044DriverImpedance_t driver_impedance;
	hmc7044OutputMuxSelect_t out_mux_mode;
};

struct hmc7044_config {
	uint16_t addr;
	uint8_t value;
};

struct hmc7044_dev {
	struct spi_desc	*spi_desc;
	bool		is_hmc7043;
	uint32_t	clkin_freq[4];
	uint32_t	clkin_freq_ccf[4];
	uint32_t	vcxo_freq;
	uint32_t	pll1_pfd;
	uint32_t	pll2_freq;
	uint32_t	pll1_loop_bw;
	uint32_t	sysref_timer_div;
	unsigned int	pll1_ref_prio_ctrl;
	bool		clkin0_rfsync_en;
	bool		clkin1_vcoin_en;
	bool		high_performance_mode_clock_dist_en;
	bool		rf_reseeder_en;
	hmc7044SyncPinModeSelect_t sync_pin_mode;
	hmc7044SyncPulseGenControl_t pulse_gen_mode;
	uint32_t	in_buf_mode[5];
	uint32_t	gpi_ctrl[4];
	uint32_t	gpo_ctrl[4];
	uint32_t	num_channels;
	struct hmc7044_chan_spec	*channels;
};

struct hmc7044_init_param {
	struct spi_init_param	*spi_init;
	bool		is_hmc7043;
	uint32_t	clkin_freq[4];
	uint32_t	clkin_freq_ccf[4];
	uint32_t	vcxo_freq;
	uint32_t	pll1_pfd;
	uint32_t	pll2_freq;
	uint32_t	pll1_loop_bw;
	uint32_t	sysref_timer_div;
	unsigned int	pll1_ref_prio_ctrl;
	bool		clkin0_rfsync_en;
	bool		clkin1_vcoin_en;
	bool		high_performance_mode_clock_dist_en;
	bool		rf_reseeder_disable;
	hmc7044SyncPinModeSelect_t sync_pin_mode;
	hmc7044SyncPulseGenControl_t pulse_gen_mode;
	uint32_t	in_buf_mode[5];
	uint32_t	gpi_ctrl[4];
	uint32_t	gpo_ctrl[4];
	uint32_t	num_channels;
	struct hmc7044_chan_spec	*channels;
};

/******************************************************************************/
/************************ Functions Declarations ******************************/
/******************************************************************************/
/* Initialize the device. */
int32_t hmc7044_reg_init(struct hmc7044_dev **device,
		     const struct hmc7044_init_param *init_param);
int32_t hmc7044_init(struct hmc7044_dev **device,
		     const struct hmc7044_init_param *init_param);
/* Remove the device. */
int32_t hmc7044_remove(struct hmc7044_dev *device);
int32_t hmc7044_write(struct hmc7044_dev *dev,
			 uint16_t reg, uint8_t val);
int32_t hmc7044_read(struct hmc7044_dev *dev, uint16_t reg, uint8_t *val);
int32_t hmc7044_clk_recalc_rate(struct hmc7044_dev *dev, uint32_t chan_num,
				uint64_t *rate);
int32_t hmc7044_clk_round_rate(struct hmc7044_dev *dev, uint32_t rate,
			       uint64_t *rounded_rate);
int32_t hmc7044_clk_set_rate(struct hmc7044_dev *dev, uint32_t chan_num,
			     uint64_t rate);

#endif // HMC7044_H_
