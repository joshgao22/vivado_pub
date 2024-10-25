/*****************************************************************************/
/**
 * @file circ_queue.h
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
 * @defgroup CircularQueue
 * @{
 */

#ifndef CIRC_QUEUE_H
#define CIRC_QUEUE_H

#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>

/**
 * @struct CIRC_QUEUE
 * @brief Circular queue Instance
 */
typedef struct
{
    void **data;
    volatile uint32_t nelts; ///< number of elements
    uint32_t in;             ///< next empty location
    uint32_t out;            ///< next filled location
    uint32_t bounds;         ///< max size of queue
} CIRC_QUEUE;

/**
 * @brief create a FIFO queue
 * @param queue The new queue
 * @param queue_capacity maximum size of the queue
 */
bool CircQueueCreate(CIRC_QUEUE **queue, uint32_t queue_capacity);

/**
 * @brief free queue memory -- call after destroy
 */
void CircQueueFree(CIRC_QUEUE *queue);

/**
 * @brief Detects when the CIRC_QUEUE is full. This utility function is expected
 * to be called from within critical sections, and is not threadsafe.
 */
bool isCircQueueFull(CIRC_QUEUE *queue);

/**
 * @brief Detects when the CIRC_QUEUE is empty. This utility function is expected
 * to be called from within critical sections, and is not threadsafe.
 */
bool isCircQueueEmpty(CIRC_QUEUE *queue);

/**
 * @brief push/add an object to the queue, blocking if the queue is already full
 *
 * @param queue the queue
 * @param data the data
 * @return True on a successful push
 * @return False push failed
 */
bool CircQueuePush(CIRC_QUEUE *queue, void *data);

/**
 * @brief pop/get an object from the queue, blocking if the queue is already empty
 *
 * @param queue the queue
 * @param data the data
 * @return false pop failed
 * @return true on a successful pop
 */
bool CircQueuePop(CIRC_QUEUE *queue, void **data);

/**
 * @brief returns the size of the queue.
 *
 * @param queue the queue
 * @return the size of the queue
 */
uint32_t CircQueueSize(CIRC_QUEUE *queue);

#endif /* CIRC_QUEUE_H */

/** @} CircularQueue*/

/** @} Utility*/