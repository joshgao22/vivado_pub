/*****************************************************************************/
/**
 * @file clist.h
 * @author FanHao (hao_fan_bit_ee@163.com)
 * @brief A basic list data structure
 * @version 0.1
 * @date 2023-02-23
 * @note Forked from https://github.com/clibs/list
 * @copyright Copyright(c) 2024 Beijing Institute of Technology.\n
 * Lab of Communication and Network
 *
 ******************************************************************************/

/**
 * @addtogroup Utility
 * @{
 */

/**
 * @defgroup cList
 * @{
 */

#ifndef __CLIST_H__
#define __CLIST_H__

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdlib.h>
#include <stdint.h>

	/**
	 * @enum clist_direction_t
	 * @brief clist_t iterator direction.
	 */
	typedef enum
	{
		LIST_HEAD,
		LIST_TAIL
	} clist_direction_t;

	/**
	 * @struct clist_node_t
	 * @brief clist_t node struct.
	 */
	typedef struct clist_node
	{
		struct clist_node *prev; ///< previous node
		struct clist_node *next; ///< next node
		void *val;
	} clist_node_t;

	/**
	 * @struct clist_t
	 * @brief clist_t struct.
	 */
	typedef struct
	{
		clist_node_t *head;					 ///< first node
		clist_node_t *tail;					 ///< last node
		uint32_t len;						 ///< list length
		void (*free)(void *val);			 ///< node free function handle
		int8_t (*compare)(void *a, void *b); ///< node compare function handle
	} clist_t;

	/**
	 * @struct clist_iterator_t
	 * @brief clist_t iterator struct.
	 */
	typedef struct
	{
		clist_node_t *next;			 ///< next element
		clist_direction_t direction; ///< iter direction
	} clist_iterator_t;

	// Node prototypes.

	clist_node_t *
	clist_node_new(void *val);

	// clist_t prototypes.

	clist_t *
	clist_new(void);

	clist_node_t *
	clist_rpush(clist_t *self, clist_node_t *node);

	clist_node_t *
	clist_lpush(clist_t *self, clist_node_t *node);

	clist_node_t *
	clist_find(clist_t *self, void *val);

	clist_node_t *
	clist_at(clist_t *self, int index);

	clist_node_t *
	clist_rpop(clist_t *self);

	clist_node_t *
	clist_lpop(clist_t *self);

	void
	clist_remove(clist_t *self, clist_node_t *node);

	void
	clist_clear(clist_t *self);

	void
	clist_destroy(clist_t *self);

	// clist_t iterator prototypes.

	clist_iterator_t *
	clist_iterator_new(clist_t *list, clist_direction_t direction);

	clist_iterator_t *
	clist_iterator_new_from_node(clist_node_t *node, clist_direction_t direction);

	clist_node_t *
	clist_iterator_next(clist_iterator_t *self);

	void
	clist_iterator_destroy(clist_iterator_t *self);

#ifdef __cplusplus
}
#endif

#endif /* __CLIBS_LIST_H__ */

/** @} cList*/

/** @} Utility*/