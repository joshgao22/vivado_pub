#include "dev_profile.h"
#include "../config/app_config.h"
#include "../drivers/platform/xilinx_gpio.h"
#include "../drivers/axi_core/spi_engine/spi_engine.h"
#include "../drivers/frequency/hmc7044/hmc7044.h"

#ifdef HMC7044

static struct spi_engine_init_param spi_engine_param = {
	.ref_clk_hz = HMC7044_SPI_ENGINE_REF_CLK,
	.type = SPI_ENGINE,
	.spi_engine_baseaddr = HMC7044_SPI_ENGINE_BASEADDR,
	.cs_delay = HMC7044_SPI_ENGINE_CS_DELAY,
	.data_width = HMC7044_SPI_ENGINE_DATA_WIDTH
};

//static struct xil_gpio_init_param xil_gpio_param = {
//	.type = GPIO_PS,
//	.device_id = AD9361_GPIO_DEVICE_ID
//};

// hmc7044 spi settings
static struct spi_init_param hmc7044_spi_init_param = {
	.device_id = HMC7044_SPI_DEVICE_ID,
    .max_speed_hz = HMC7044_SPI_ENGINE_MAX_SPEED,
	.chip_select = HMC7044_SPI_CS,
	.mode = SPI_MODE_4,
	.platform_ops = &spi_eng_platform_ops,
	.extra = &spi_engine_param
};

// hmc7044 channel specifications
struct hmc7044_chan_spec hmc7044_chan_spec[4] = {
	/* AD9361_XTAL */
	{
		.num = 3,
		.disable = 0,
		.high_performance_mode_dis = true,
		.start_up_mode_dynamic_enable = false,
		.dynamic_driver_enable = false,
		.output_control0_rb4_enable = true,
		.force_mute_enable = false,
		.divider = 100,
		.coarse_delay = 0,
		.fine_delay = 0,
		.driver_mode = HMC7044_CML,
		.driver_impedance = INTERNAL_100OHM_PER_PIN,
		.out_mux_mode = HMC7044_CHANNEL_DIV
	},
	/* FPGA_DAC_LOGIC_CLK */
	{
		.num = 4,
		.disable = 0,
		.high_performance_mode_dis = true,
		.start_up_mode_dynamic_enable = false,
		.dynamic_driver_enable = false,
		.output_control0_rb4_enable = true,
		.force_mute_enable = false,
		.divider = 10,
		.coarse_delay = 0,
		.fine_delay = 0,
		.driver_mode = HMC7044_CML,
		.driver_impedance = INTERNAL_100OHM_PER_PIN,
		.out_mux_mode = HMC7044_CHANNEL_DIV
	},
	/* B_AD9361_XTAL */
	{
		.num = 12,
		.disable = 0,
		.high_performance_mode_dis = false,
		.start_up_mode_dynamic_enable = false,
		.dynamic_driver_enable = false,
		.output_control0_rb4_enable = true,
		.force_mute_enable = false,
		.divider = 100,
		.coarse_delay = 0,
		.fine_delay = 0,
		.driver_mode = HMC7044_CML,
		.driver_impedance = INTERNAL_100OHM_PER_PIN,
		.out_mux_mode = HMC7044_CHANNEL_DIV
	},
	/* AD9361_RX_EXT_LO */
	{
		.num = 13,
		.disable = 0,
		.high_performance_mode_dis = false,
		.start_up_mode_dynamic_enable = false,
		.dynamic_driver_enable = false,
		.output_control0_rb4_enable = true,
		.force_mute_enable = false,
		.divider = 10,
		.coarse_delay = 0,
		.fine_delay = 0,
		.driver_mode = HMC7044_CML,
		.driver_impedance = INTERNAL_100OHM_PER_PIN,
		.out_mux_mode = HMC7044_CHANNEL_DIV
	},
};

// hmc7044 default configurations
struct hmc7044_init_param hmc7044_default_init_param = {
	.spi_init = &hmc7044_spi_init_param,
	.clkin_freq = {0, 100000000, 0, 0},
	.vcxo_freq = 100000000,
	.pll2_freq = 2500000000,
	.pll1_loop_bw = 200,
	.sysref_timer_div = 1536,
	.pll1_ref_prio_ctrl = 0xE4,
	.high_performance_mode_clock_dist_en = false,
	.sync_pin_mode = SYNC_MULTICHIP,
	.pulse_gen_mode = PULSE_ONE,
	.in_buf_mode = {
			BUFFER_DISABLE,
			ENABLE_AC_COUPLE | ENABLE_INTERNAL_TERM | BUFFER_ENABLE,
			BUFFER_DISABLE,
			BUFFER_DISABLE,
			ENABLE_AC_COUPLE | ENABLE_INTERNAL_TERM | BUFFER_ENABLE
	},
	.gpi_ctrl = {
			GPI_DISABLE,
			GPI_DISABLE,
			CHIP_SLEEP_MODE,
			PULSE_GEN_REQUSET
	},
	.gpo_ctrl = {
			PLL1_LOCK_DETECT | GPO_CMOS_MODE,
			PLL2_LOCK_DETECT | GPO_CMOS_MODE,
			GPO_DISABLE,
			GPO_DISABLE
	},
	.num_channels = 4,
	.channels = hmc7044_chan_spec
};

#endif
