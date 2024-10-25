#ifndef _DEV_PROFILE_H_
#define _DEV_PROFILE_H_

#include "irq.h"
#include "error.h"
#include "../drivers/rf-transceiver/ad9361/ad9361_api.h"
#include "../drivers/rf-transceiver/ad9361_reg/ad9361_reg.h"
#include "../drivers/frequency/hmc7044/hmc7044.h"
#include "../drivers/frequency/ad9528/ad9528.h"
#include "../drivers/adc/ad9694/ad9694.h"
#include "../drivers/adc/ad9653/ad9653.h"
#include "../config/app_config.h"

// device parameters
extern struct irq_init_param intc_init_param;
extern struct timer_init_param scutimer_init_param;
extern struct global_timer_init_param globaltimer_init_param;

// HMC7044
extern struct hmc7044_init_param hmc7044_default_init_param;

// AD9528
extern ad9528Init_t ad9528_default_init_param;

// AD9361
extern AD9361_InitParam ad9361_default_init_param;
extern AD9361_RXFIRConfig rx_fir_config;
extern AD9361_TXFIRConfig tx_fir_config;
extern struct ad9361_reg_init_param ad9361_1_reg_default_init_param;
extern struct ad9361_reg_init_param ad9361_2_reg_default_init_param;
uint32_t ad9361_1_reg_config(struct ad9361_reg_dev *dev);
uint32_t ad9361_2_reg_config(struct ad9361_reg_dev *dev);

// CX9261A
int cx9261a_config();

// AD9653
extern struct ad9653_init_param ad9653_default_init_param;
extern const struct ad9653_config ad9653_default_config[];
extern const uint32_t ad9653_default_config_len;

#endif /* SRC_DEV_PROFILE_H_ */
