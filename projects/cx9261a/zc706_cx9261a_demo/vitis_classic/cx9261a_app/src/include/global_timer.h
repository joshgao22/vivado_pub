#ifndef SRC_GLOBAL_TIMER_H_
#define SRC_GLOBAL_TIMER_H_

/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/

#include <inttypes.h>

/******************************************************************************/
/*************************** Types Declarations *******************************/
/******************************************************************************/

/**
 * @struct timer_init_param
 * @brief  Structure holding the parameters for timer initialization
 */
struct global_timer_init_param {
	/** timer ID */
	uintptr_t base_addr;
	/** timer ID */
	uint16_t id;
	/** timer count frequency (Hz) */
	uint32_t freq_hz;
	/** counter start value */
	uint64_t load_value;
};

/**
 * @struct timer_desc
 * @brief Structure holding timer descriptor
 */
struct global_timer_desc {
	/** timer ID */
	uintptr_t base_addr;
	/** timer ID */
	uint16_t id;
	/** timer count frequency (Hz) */
	uint32_t freq_hz;
	/** counter start value */
	uint64_t load_value;
};

/******************************************************************************/
/************************ Functions Declarations ******************************/
/******************************************************************************/

/* Initialize hardware timer and the handler structure associated with it. */
int32_t global_timer_init(struct global_timer_desc **desc,
		   struct global_timer_init_param *param);

/* Free the memory allocated by timer_setup(). */
int32_t global_timer_remove(struct global_timer_desc *desc);

/* Start a timer. */
int32_t global_timer_start(struct global_timer_desc *desc);

/* Stop a timer from counting. */
int32_t global_timer_stop(struct global_timer_desc *desc);

/* Get the value of the counter register for the timer. */
int32_t global_timer_counter_get(struct global_timer_desc *desc, uint64_t *counter);

/* Set the timer counter register value. */
int32_t global_timer_counter_set(struct global_timer_desc *desc, uint64_t new_val);

/* Get the timer clock frequency. */
int32_t global_timer_count_clk_get(struct global_timer_desc *desc, uint32_t *freq_hz);

/* Set the timer clock frequency. */
int32_t global_timer_count_clk_set(struct global_timer_desc *desc, uint32_t freq_hz);

/* Enable global timer interrupt. */
int32_t global_timer_irq_enable(struct global_timer_desc *desc);

/* Disable global timer interrupt. */
int32_t global_timer_irq_disable(struct global_timer_desc *desc);

/* Implement a acknowledgment global timer interrupt. */
int32_t global_timer_irq_ack(struct global_timer_desc *desc);

/* Set comparator register. */
int32_t global_timer_compara_set(struct global_timer_desc *desc, uint64_t com_val);

/* Set auto increment register . */
int32_t global_timer_auto_inc_set(struct global_timer_desc *desc, uint32_t inc_val);

/* Enable global timer auto increment mode. */
int32_t global_timer_auto_inc_enable(struct global_timer_desc *desc);

/* Disable global timer auto increment mode. */
int32_t global_timer_auto_inc_disable(struct global_timer_desc *desc);

#endif /* SRC_TIMER_H_ */

