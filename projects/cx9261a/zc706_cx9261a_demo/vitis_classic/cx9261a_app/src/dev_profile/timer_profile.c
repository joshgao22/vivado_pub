#include "dev_profile.h"
#include "timer.h"
#include "../config/app_config.h"
#include "../drivers/platform/xilinx_timer.h"

struct xil_timer_init_param xil_scutimer_init_param = {
	.active_tmr = 0,
	.type = TIMER_PS
};

struct timer_init_param scutimer_init_param = {
	.id = SCUTIMER_DEVICE_ID,
	.freq_hz = SCU_TIMER_CLK_HZ,
	.ticks_count = (SCU_TIMER_CLK_HZ/10), //update log every 100ms
	.platform_ops = &xil_timer_ops,
	.extra = &xil_scutimer_init_param
};
