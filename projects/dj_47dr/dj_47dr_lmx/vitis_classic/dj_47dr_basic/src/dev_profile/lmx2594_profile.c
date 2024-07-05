#include "dev_profile.h"
#include "../app_config.h"
#include "../adi_noos/drivers/frequency/lmx2594/lmx2594.h"


static spi_init_param lmx2594_adc_spi_init = {
	.device_id = SPI_DEVICE_ID,
    .max_speed_hz = SPI_ENGINE_MAX_SPEED,
	.mode = SPI_MODE_0,
	.chip_select = SPI_CS_LMX2594_ADC,
	.platform_ops = SPI_OPS,
	.extra = SPI_PARAM
};

static spi_init_param lmx2594_dac_spi_init = {
	.device_id = SPI_DEVICE_ID,
    .max_speed_hz = SPI_ENGINE_MAX_SPEED,
	.mode = SPI_MODE_0,
	.chip_select = SPI_CS_LMX2594_DAC,
	.platform_ops = SPI_OPS,
	.extra = SPI_PARAM
};

struct lmx2594_init_param lmx2594_adc_init_param = {
	/* SPI */
	.spi_init = &lmx2594_adc_spi_init
};

struct lmx2594_init_param lmx2594_dac_init_param = {
	/* SPI */
	.spi_init = &lmx2594_dac_spi_init
};

const uint32_t lmx2594_default_config_len = 82;
const struct lmx2594_config lmx2594_default_config[] = {
	// 0 ~ 78: General configuration
	// 79 ~ 106: Ramping configuration
	// 107 ~ 112: Readback registers

	// Recommended Initial Power-Up Sequence
	// For the most reliable programming, TI recommends this procedure::
	// 1. Apply power to device.
	// 2. Program RESET = 1 to reset registers.
	// 3. Program RESET = 0 to remove reset.
	// 4. Program registers as shown in the register map in REVERSE order from highest to lowest.
	// 5. Wait 10 ms.
	// 6. Program register R0 one additional time with FCAL_EN = 1 to ensure that the VCO calibration runs from a stable state.

	// Reset
	{  0, 0x0002},

	// Remove Reset
	{  0, 0x0000},

	// Reverse order programming
//	{106, 0x0000},
//	{105, 0x0021},
//	{104, 0x0000},
//	{103, 0xD555},
//	{102, 0x3F97},
//	{101, 0x0011},
//	{100, 0x0000},
//	{ 99, 0x2AAB},
//	{ 98, 0x01A0},
//	{ 97, 0x0888},
//	{ 96, 0x0000},
//	{ 95, 0x0000}, // fixed
//	{ 94, 0x0000}, // fixed
//	{ 93, 0x0000}, // fixed
//	{ 92, 0x0000}, // fixed
//	{ 91, 0x0000}, // fixed
//	{ 90, 0x0000}, // fixed
//	{ 89, 0x0000}, // fixed
//	{ 88, 0x0000}, // fixed
//	{ 87, 0x0000}, // fixed
//	{ 86, 0x5879},
//	{ 85, 0xEC58},
//	{ 84, 0x0001},
//	{ 83, 0x54C9},
//	{ 82, 0x2961},
//	{ 81, 0x0000},
//	{ 80, 0x4000},
//	{ 79, 0x001F},
	{ 78, 0x0003}, // [8:1] VCO_CAPCTRL_STRT
	{ 77, 0x0000}, // fixed
	{ 76, 0x000C}, // fixed
	{ 75, 0x0800}, // [10:6] CHDIV
	{ 74, 0x0000}, // [11:6] JESD_DAC4_CTRL; [5:0] JESD_DAC3_CTRL
	{ 73, 0x003F}, // [11:6] JESD_DAC2_CTRL; [5:0] JESD_DAC1_CTRL
	{ 72, 0x0001}, // [10:0] SYSREF_DIV
	{ 71, 0x0081}, // [7:5] SYSREF_DIV_PRE; [4] SYSREF_PULSE; [3] SYSREF_EN; [2] SYSREF_REPEAT
	{ 70, 0xC350}, // [15:0] MASH_RST_COUNT
	{ 69, 0x0000}, // [15:0] MASH_RST_COUNT
	{ 68, 0x03E8}, // fixed
	{ 67, 0x0000}, // fixed
	{ 66, 0x01F4}, // fixed
	{ 65, 0x0000}, // fixed
	{ 64, 0x1388}, // fixed
	{ 63, 0x0000}, // fixed
	{ 62, 0x0322}, // fixed
	{ 61, 0x00A8}, // fixed
	{ 60, 0x0000}, // [15:0] LD_DLY
	{ 59, 0x0001}, // [0] LD_TYPE
	{ 58, 0x9001}, // [15] INPIN_IGNORE; [14] INPIN_HYST; [13:12] INPIN_LVL; [11:9] INPIN_FMT
	{ 57, 0x0020}, // fixed
	{ 56, 0x0000}, // fixed
	{ 55, 0x0000}, // fixed
	{ 54, 0x0000}, // fixed
	{ 53, 0x0000}, // fixed
	{ 52, 0x0820}, // fixed
	{ 51, 0x0080}, // fixed
	{ 50, 0x0000}, // fixed
	{ 49, 0x4180}, // fixed
	{ 48, 0x0300}, // fixed
	{ 47, 0x0300}, // fixed
	{ 46, 0x07FC}, // [1:0] OUTB_MUX
	{ 45, 0xC0DF}, // [12:11] OUTA_MUX; [10:9] OUT_ISET; [5:0] OUTB_PWR
	{ 44, 0x1AA3}, // [13:8] OUTA_PWR; [7] OUTB_PD; [6] OUTA_PD; [5] MASH_RESET_N; [2:0] MASH_ORDER
	{ 43, 0x0000}, // [15:0] PLL_NUM
	{ 42, 0x0000}, // [15:0] PLL_NUM
	{ 41, 0x0000}, // [15:0] MASH_SEE
	{ 40, 0x0000}, // [15:0] MASH_SEE
	{ 39, 0x03E8}, // [15:0] PLL_DEN
	{ 38, 0x0000}, // [15:0] PLL_DEN
	{ 37, 0x0304}, // [37] MASH_SEED_EN; [13:8] PFD_DLY_SEL
	{ 36, 0x0028}, // [15:0] PLL_N
	{ 35, 0x0004}, // fixed
	{ 34, 0x0000}, // [2:0] PLL_N
	{ 33, 0x1E21}, // fixed
	{ 32, 0x0393}, // fixed
	{ 31, 0x43EC}, // [14] SEG1_EN
	{ 30, 0x318C}, // fixed
	{ 29, 0x318C}, // fixed
	{ 28, 0x0488}, // fixed
	{ 27, 0x0002}, // fixed
	{ 26, 0x0DB0}, // fixed
	{ 25, 0x0C2B}, // fixed
	{ 24, 0x071A}, // fixed
	{ 23, 0x007C}, // fixed
	{ 22, 0x0001}, // fixed
	{ 21, 0x0401}, // fixed
	{ 20, 0xE048}, // [13:11] VCO_SEL. [10] VCO_SEL_FORCE
	{ 19, 0x27B7}, // [7:0] VCO_CAPCTRL
	{ 18, 0x0064}, // fixed
	{ 17, 0x012C}, // [8:0] VCO_DACISET_STRT
	{ 16, 0x0080}, // [8:0] VCO_DACISET
	{ 15, 0x064F}, // fixed
	{ 14, 0x1E70}, // [6:4] CPG
	{ 13, 0x4000}, // fixed
	{ 12, 0x5001}, // [11:0] PLL_R_PR
	{ 11, 0x0018}, // [11:4] PLL_R
	{ 10, 0x10D8}, // [11:7] MULT
	{  9, 0x0604}, // [12] OSC_2X
	{  8, 0x2000}, // [14] VCO_DACISET_FORCE; [11] VCO_CAPCTRL_FORCE
	{  7, 0x40B2}, // [14] OUT_FORCE
	{  6, 0xC802}, // fixed
	{  5, 0x00C8}, // fixed
	{  4, 0x0C43}, // [15:8] ACAL_CMP_DLY
	{  3, 0x0642}, // fixed
	{  2, 0x0500}, // fixed
	{  1, 0x0809}, // [2:0] CAL_CLK_DIV
	{  0, 0x2598}, // [15] RAMP_EN; [14] VCO_PHASE_SYNC; [9] OUT_MUTE; [8:7] FCAL_HPFD_ADJ; [6:5] FCAL_LPFD_ADJ; [3] FCAL_EN; [2] MUXOUT_LD_SEL; [1] RESET; [0] POWERDOWN

	// one more time
	{  0, 0x2598}
};
