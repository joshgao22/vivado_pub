/*****************************************************************************/
/**
 * @file clist.c
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
 * @addtogroup cList
 * @{
 */
#ifndef LIST_MALLOC
#define LIST_MALLOC malloc
#endif

#ifndef LIST_FREE
#define LIST_FREE free
#endif

#include <stdint.h>
#include "clist.h"

/**
 * @brief a new clist_node_t. NULL on failure.
 */
clist_node_t *
clist_node_new(void *val)
{
	clist_node_t *self;
	if (!(self = LIST_MALLOC(sizeof(clist_node_t))))
		return NULL;
	self->prev = NULL;
	self->next = NULL;
	self->val = val;
	return self;
}

/**
 * @brief Allocate a new clist_t. NULL on failure.
 */
clist_t *
clist_new(void)
{
	clist_t *self;
	if (!(self = LIST_MALLOC(sizeof(clist_t))))
		return NULL;
	self->head = NULL;
	self->tail = NULL;
	self->free = NULL;
	self->compare = NULL;
	self->len = 0;
	return self;
}

/**
 * @brief Remove all the node in list.
 * @param self: Pointer to the list
 */
void clist_clear(clist_t *self)
{
	clist_node_t *next;
	clist_node_t *curr = self->head;

	while (curr != NULL)
	{
		next = curr->next;
		if (self->free)
			self->free(curr->val);
		LIST_FREE(curr);
		curr = next;
	}
	self->len = 0;
	self->head = NULL;
}

/**
 * @brief Free the list.
 * @param self: Pointer to the list
 */
void clist_destroy(clist_t *self)
{
	clist_clear(self);
	LIST_FREE(self);
}

/**
 * @brief Append the given node to the list and return the node, NULL on failure.
 * @param self: Pointer to the list for popping node
 * @param node: the node to push
 */
clist_node_t *
clist_rpush(clist_t *self, clist_node_t *node)
{
	if (!node)
		return NULL;

	if (self->len)
	{
		node->prev = self->tail;
		node->next = NULL;
		self->tail->next = node;
		self->tail = node;
	}
	else
	{
		self->head = self->tail = node;
		node->prev = node->next = NULL;
	}

	++self->len;
	return node;
}

/**
 * @brief Return / detach the last node in the list, or NULL.
 * @param self: Pointer to the list for popping node
 */

clist_node_t *
clist_rpop(clist_t *self)
{
	if (!self->len)
		return NULL;

	clist_node_t *node = self->tail;

	if (--self->len)
	{
		(self->tail = node->prev)->next = NULL;
	}
	else
	{
		self->tail = self->head = NULL;
	}

	node->next = node->prev = NULL;
	return node;
}

/**
 * @brief Return / detach the first node in the list, or NULL.
 * @param self: Pointer to the list for popping node
 */

clist_node_t *
clist_lpop(clist_t *self)
{
	if (!self->len)
		return NULL;

	clist_node_t *node = self->head;

	if (--self->len)
	{
		(self->head = node->next)->prev = NULL;
	}
	else
	{
		self->head = self->tail = NULL;
	}

	node->next = node->prev = NULL;
	return node;
}

/**
 * @brief Prepend the given node to the list and return the node, NULL on failure.
 * @param self: Pointer to the list for pushing node
 * @param node: the node to push
 */

clist_node_t *
clist_lpush(clist_t *self, clist_node_t *node)
{
	if (!node)
		return NULL;

	if (self->len)
	{
		node->next = self->head;
		node->prev = NULL;
		self->head->prev = node;
		self->head = node;
	}
	else
	{
		self->head = self->tail = node;
		node->prev = node->next = NULL;
	}

	++self->len;
	return node;
}

/**
 * @brief Return the node associated to val or NULL.
 * @param self: Pointer to the list for finding given value
 * @param val: Value to find
 */

clist_node_t *
clist_find(clist_t *self, void *val)
{
	clist_iterator_t *it = clist_iterator_new(self, LIST_HEAD);
	clist_node_t *node;

	while ((node = clist_iterator_next(it)))
	{
		if (self->compare)
		{
			if (self->compare(val, node->val) == 0)
			{
				clist_iterator_destroy(it);
				return node;
			}
		}
		else
		{
			if (val == node->val)
			{
				clist_iterator_destroy(it);
				return node;
			}
		}
	}

	clist_iterator_destroy(it);
	return NULL;
}

/**
 * @brief Return the node at the given index or NULL.
 * @param self: Pointer to the list for finding given index
 * @param index: the index of node in the list
 */

clist_node_t *
clist_at(clist_t *self, int index)
{
	clist_direction_t direction = LIST_HEAD;

	if (index < 0)
	{
		direction = LIST_TAIL;
		index = ~index;
	}

	if ((unsigned)index < self->len)
	{
		clist_iterator_t *it = clist_iterator_new(self, direction);
		clist_node_t *node = clist_iterator_next(it);
		while (index--)
			node = clist_iterator_next(it);
		clist_iterator_destroy(it);
		return node;
	}

	return NULL;
}

/**
 * @brief Remove the given node from the list, freeing it and it's value.
 * @param self: Pointer to the list to delete a node
 * @param node: Pointer the node to be deleted
 */

void clist_remove(clist_t *self, clist_node_t *node)
{
	node->prev
		? (node->prev->next = node->next)
		: (self->head = node->next);

	node->next
		? (node->next->prev = node->prev)
		: (self->tail = node->prev);

	if (self->free)
		self->free(node->val);

	LIST_FREE(node);
	--self->len;
}

/**
 * @brief Allocate a new clist_iterator_t. NULL on failure.\n
 * Accepts a direction, which may be LIST_HEAD or LIST_TAIL.
 */

clist_iterator_t *
clist_iterator_new(clist_t *list, clist_direction_t direction)
{
	clist_node_t *node = direction == LIST_HEAD
							 ? list->head
							 : list->tail;
	return clist_iterator_new_from_node(node, direction);
}

/**
 * @brief Allocate a new clist_iterator_t with the given start
 * node. NULL on failure.
 */

clist_iterator_t *
clist_iterator_new_from_node(clist_node_t *node, clist_direction_t direction)
{
	clist_iterator_t *self;
	if (!(self = LIST_MALLOC(sizeof(clist_iterator_t))))
		return NULL;
	self->next = node;
	self->direction = direction;
	return self;
}

/**
 * @brief Return the next clist_node_t or NULL when no more
 * nodes remain in the list.
 */

clist_node_t *
clist_iterator_next(clist_iterator_t *self)
{
	clist_node_t *curr = self->next;
	if (curr)
	{
		self->next = self->direction == LIST_HEAD
						 ? curr->next
						 : curr->prev;
	}
	return curr;
}

/**
 * @brief Free the list iterator.
 */

void clist_iterator_destroy(clist_iterator_t *self)
{
	LIST_FREE(self);
	self = NULL;
}
/** @} cList*/
/** @} Utility*/