/*****************************************************************************/
/**
 * @file circ_queue.c
 * @author FanHao (hao_fan_bit_ee@163.com)
 * @brief A simple circular FIFO bounded queue
 * @version 0.1
 * @date 2023-02-23
 * @note Forked from https://github.com/chrismerck/rpa_queue.git
 * @copyright Copyright(c) 2024 Beijing Institute of Technology.\n
 * Lab of Communication and Network
 *
 ******************************************************************************/

/**
 * @addtogroup Utility
 * @{
 */

/**
 * @addtogroup CircularQueue
 * @{
 */
#include "circ_queue.h"
#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

inline bool isCircQueueFull(CIRC_QUEUE *queue)
{
	ASSERT(queue != NULL);
	return ((queue)->nelts == (queue)->bounds);
}

inline bool isCircQueueEmpty(CIRC_QUEUE *queue)
{
	ASSERT(queue != NULL);
	return ((queue)->nelts == 0);
}

void CircQueueFree(CIRC_QUEUE *queue)
{
	ASSERT(queue != NULL);
	if (queue->data)
		free(queue->data);
	free(queue);
}

/**
 * @brief Initialize the CIRC_QUEUE.
 */
bool CircQueueCreate(CIRC_QUEUE **q, uint32_t queueCapacity)
{
	ASSERT(q != NULL);
	CIRC_QUEUE *queue;
	queue = malloc(sizeof(CIRC_QUEUE));
	if (!queue)
	{
		return false;
	}
	*q = queue;
	memset(queue, 0, sizeof(CIRC_QUEUE));

	/* Set all the data in the queue to NULL */
	queue->data = malloc(queueCapacity * sizeof(void *));
	if (queue->data == NULL)
	{
		goto error;
	}
	queue->bounds = queueCapacity;
	queue->nelts = 0;
	queue->in = 0;
	queue->out = 0;
	return true;
error:
	free(queue);
	return false;
}

/**
 * @brief Push new data onto the queue.
 */
bool CircQueuePush(CIRC_QUEUE *queue, void *data)
{
	ASSERT(queue != NULL);

	if (isCircQueueFull(queue))
	{
		return false;
	}

	queue->data[queue->in] = data;
	queue->in++;
	if (queue->in >= queue->bounds)
	{
		queue->in -= queue->bounds;
	}
	queue->nelts++;

	return true;
}

/**
 * @brief Return current number of element in queue.
 */
inline uint32_t CircQueueSize(CIRC_QUEUE *queue)
{
	return queue->nelts;
}

/**
 * @brief Retrieves the next item from the queue.
 */
bool CircQueuePop(CIRC_QUEUE *queue, void **data)
{
	ASSERT(queue != NULL);

	if (isCircQueueEmpty(queue))
	{
		return false;
	}

	*data = queue->data[queue->out];
	queue->nelts--;

	queue->out++;
	if (queue->out >= queue->bounds)
	{
		queue->out -= queue->bounds;
	}
	return true;
}
/** @} CircularQueue*/
/** @} Utility*/