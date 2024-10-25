/**
 * @addtogroup SystemMonitor
 * @{
 */

/***************************** Include Files *********************************/
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include "common.h"
#include "system_monitor.h"
/************************** Constant Definitions *****************************/
/**
 * @name SystemMonitor_Private_Constants
 * @{
 */
#define BUFF_A 0x00
#define BUFF_B 0x01
#define BUFF_NONE 0xFF

#define SYSINFO_PACK_LEN 54	 // bytes
#define PAYLOAD_PACK_LEN 46	 // bytes
#define SLOTLOG_PACK_LEN 88	 // bytes
#define PRTCLLOG_PACK_ELN 24 // bytes
#define HWSTATE_PACK_ELN 12	 // bytes
/** @} SystemMonitor_Private_Constants*/
/************************** Data Type Definitions ****************************/
/**
 * @struct PINGPONG
 * @brief PingPing Control
 */
typedef struct
{
	uint8_t latest; ///< latest available index
	uint8_t rBusy;	///< current read busy index
	uint8_t wBusy;	///< current write busy index
} PINGPONG;

/**
 * @struct SYSMONITOR
 * @brief System Monitor struct holds all the system log info
 */
typedef struct
{
	PINGPONG recvCtrl;
	PAYLOAD recv[2];
	PINGPONG sendCtrl;
	PAYLOAD send[2];
	PINGPONG sysInfoCtrl;
	SYSINFO sysInfo[2];
	PINGPONG linkLogCtrl;
	LINKLOG linkLog[2];
	PINGPONG phyLogCtrl;
	PHYLOG phyLog[2];
	PINGPONG hwStateCtrl;
	HWSTATE hwState[2];
} SYSMONITOR;

/************************** Function Prototypes ******************************/
static uint8_t GetWritable(PINGPONG ctrllor);
static uint8_t GetReadable(PINGPONG ctrllor);
/************************** Variable Definitions *****************************/
static SYSMONITOR *sysMonitorInst;

/*********************** Function Implementations  ***************************/
inline static uint8_t GetWritable(PINGPONG ctrllor)
{
	// Allow only one write.
	ASSERT(ctrllor.wBusy == BUFF_NONE);
	if (ctrllor.rBusy == BUFF_NONE)
		return ((ctrllor.latest == BUFF_B) ? BUFF_A : BUFF_B);
	else
		return ((ctrllor.rBusy == BUFF_B) ? BUFF_A : BUFF_B);
}

inline static uint8_t GetReadable(PINGPONG ctrllor)
{
	if (ctrllor.wBusy == BUFF_NONE || ctrllor.wBusy != ctrllor.latest)
		return ((ctrllor.latest == BUFF_NONE) ? BUFF_A : BUFF_B);
	else
		return ((ctrllor.wBusy == BUFF_B) ? BUFF_A : BUFF_B);
}

/**
 * @brief Initialize System monitor
 *
 * @return SUCCESS
 */
int32_t SysMonitor_Init(void)
{
	sysMonitorInst = calloc(1, sizeof(SYSMONITOR));
	if (sysMonitorInst == NULL)
	{
		return ENOMEM;
	}
	memset(&(sysMonitorInst->recvCtrl), BUFF_NONE, sizeof(PINGPONG));
	memset(&(sysMonitorInst->sendCtrl), BUFF_NONE, sizeof(PINGPONG));
	memset(&(sysMonitorInst->sysInfoCtrl), BUFF_NONE, sizeof(PINGPONG));
	memset(&(sysMonitorInst->linkLogCtrl), BUFF_NONE, sizeof(PINGPONG));
	memset(&(sysMonitorInst->phyLogCtrl), BUFF_NONE, sizeof(PINGPONG));
	memset(&(sysMonitorInst->hwStateCtrl), BUFF_NONE, sizeof(PINGPONG));

	sysMonitorInst->recv[0].dataId = DATA_ID_NONE;
	sysMonitorInst->recv[1].dataId = DATA_ID_NONE;
	sysMonitorInst->send[0].dataId = DATA_ID_NONE;
	sysMonitorInst->send[1].dataId = DATA_ID_NONE;
	return SUCCESS;
}

/**
 * @brief Destroy system monitor release all allocated memory
 */
void SysMonitor_Destroy(void)
{
	free(sysMonitorInst);
}

/**
 * @name SystemInfo_API
 * @{
 */

/**
 * @brief Update system info.
 *
 * @param info
 */
void SysMonitor_UpdateSysinfo(const SYSINFO *info)
{
	uint8_t buffIndx;
	buffIndx = GetWritable(sysMonitorInst->sysInfoCtrl);
	sysMonitorInst->sysInfoCtrl.wBusy = buffIndx;
	memcpy(&(sysMonitorInst->sysInfo[buffIndx]), info, sizeof(SYSINFO));
	sysMonitorInst->sysInfoCtrl.latest = buffIndx;
	sysMonitorInst->sysInfoCtrl.wBusy = BUFF_NONE;
}

/**
 * @brief Get system info.
 *
 * @param info
 */
void SysMonitor_GetSysinfo(SYSINFO *info)
{
	ASSERT(sysMonitorInst != NULL);
	uint8_t buffIndx, buffIndex_old;
	buffIndex_old = sysMonitorInst->sysInfoCtrl.rBusy;
	if (buffIndex_old != BUFF_NONE)
		buffIndx = buffIndex_old; // Keep it busy
	else
		buffIndx = GetReadable(sysMonitorInst->sysInfoCtrl);
	sysMonitorInst->sysInfoCtrl.rBusy = buffIndx;
	memcpy(info, &(sysMonitorInst->sysInfo[buffIndx]), sizeof(SYSINFO));
	sysMonitorInst->sysInfoCtrl.rBusy = buffIndex_old;
}
/** @} SystemInfo_API*/

/**
 * @name ServicePayload_API
 * @{
 */

/**
 * @brief Update send payload by
 *
 * @param buff
 * @param len
 */
void SysMonitor_UpdateSendPayload(const uint8_t *buff, size_t len)
{
	ASSERT(sysMonitorInst != NULL);
	if (len > PAYLOAD_LEN_MAX)
	{
		return;
	}
	uint8_t buffIndx;
	buffIndx = GetWritable(sysMonitorInst->sendCtrl);
	sysMonitorInst->sendCtrl.wBusy = buffIndx;
	memcpy(sysMonitorInst->send[buffIndx].data, buff, len);
	sysMonitorInst->send[buffIndx].dataId++;
	sysMonitorInst->sendCtrl.latest = buffIndx;
	sysMonitorInst->sendCtrl.wBusy = BUFF_NONE;
}

/**
 * @brief Get the latest send payload.
 *
 * @param buff
 * @param id
 * @param len
 */
void SysMonitor_GetSendPayload(uint8_t *buff, uint32_t *id, size_t len)
{
	ASSERT(sysMonitorInst != NULL);
	ASSERT(buff != NULL);
	ASSERT(id != NULL);
	if (len > PAYLOAD_LEN_MAX)
	{
		return;
	}
	uint8_t buffIndx, buffIndex_old;
	buffIndex_old = sysMonitorInst->sendCtrl.rBusy;
	if (buffIndex_old != BUFF_NONE)
		buffIndx = buffIndex_old; // Keep it busy
	else
		buffIndx = GetReadable(sysMonitorInst->sendCtrl);
	sysMonitorInst->sendCtrl.rBusy = buffIndx;
	if (sysMonitorInst->send[buffIndx].dataId != DATA_ID_NONE)
	{
		memcpy(buff, sysMonitorInst->send[buffIndx].data, len);
	}
	*id = sysMonitorInst->send[buffIndx].dataId;
	sysMonitorInst->sendCtrl.rBusy = buffIndex_old;
}

/**
 * @brief Update receive payload.
 *
 * @param buff
 * @param id
 * @param len
 */
void SysMonitor_UpdateRecvPayload(const uint8_t *buff, uint32_t id, size_t len)
{
	ASSERT(sysMonitorInst != NULL);
	ASSERT(buff != NULL);
	if (id == DATA_ID_NONE || len > PAYLOAD_LEN_MAX)
	{
		return;
	}
	uint8_t buffIndx;
	buffIndx = GetWritable(sysMonitorInst->recvCtrl);
	sysMonitorInst->recvCtrl.wBusy = buffIndx;
	memcpy(sysMonitorInst->recv[buffIndx].data, buff, len);
	sysMonitorInst->recv[buffIndx].dataId = id;
	sysMonitorInst->recvCtrl.latest = buffIndx;
	sysMonitorInst->recvCtrl.wBusy = BUFF_NONE;
}

/**
 * @brief Get the latest receive payload.
 *
 * @param buff
 * @param id
 * @param len
 */
void SysMonitor_GetRecvPayload(uint8_t *buff, uint32_t *id, size_t len)
{
	ASSERT(sysMonitorInst != NULL);
	ASSERT(buff != NULL);
	ASSERT(id != NULL);
	if (len > PAYLOAD_LEN_MAX)
	{
		return;
	}
	uint8_t buffIndx, buffIndex_old;
	buffIndex_old = sysMonitorInst->recvCtrl.rBusy;
	if (buffIndex_old != BUFF_NONE)
		buffIndx = buffIndex_old; // Keep it busy
	else
		buffIndx = GetReadable(sysMonitorInst->recvCtrl);
	sysMonitorInst->recvCtrl.rBusy = buffIndx;
	if (sysMonitorInst->recv[buffIndx].dataId != DATA_ID_NONE)
	{
		memcpy(buff, sysMonitorInst->recv[buffIndx].data, len);
	}
	*id = sysMonitorInst->recv[buffIndx].dataId;
	sysMonitorInst->recvCtrl.rBusy = buffIndex_old;
}
/** @} ServicePayload_API*/

/**
 * @name Linklayer_Log_API
 * @{
 */

/**
 * @brief Update link layer log
 *
 * @param log
 */
void SysMonitor_UpdateLinklayerLog(const LINKLOG *log)
{
	ASSERT(sysMonitorInst != NULL);
	ASSERT(log != NULL);
	uint8_t buffIndx;
	buffIndx = GetWritable(sysMonitorInst->linkLogCtrl);
	sysMonitorInst->linkLogCtrl.wBusy = buffIndx;
	memcpy(&(sysMonitorInst->linkLog[buffIndx]), log, sizeof(LINKLOG));
	sysMonitorInst->linkLogCtrl.latest = buffIndx;
	sysMonitorInst->linkLogCtrl.wBusy = BUFF_NONE;
}

/**
 * @brief Get the latest link layer log
 *
 * @param log
 */
void SysMonitor_GetLinklayerLog(LINKLOG *log)
{
	ASSERT(sysMonitorInst != NULL);
	ASSERT(log != NULL);
	uint8_t buffIndx, buffIndex_old;
	buffIndex_old = sysMonitorInst->linkLogCtrl.rBusy;
	if (buffIndex_old != BUFF_NONE)
		buffIndx = buffIndex_old; // Keep it busy
	else
		buffIndx = GetReadable(sysMonitorInst->linkLogCtrl);
	sysMonitorInst->linkLogCtrl.rBusy = buffIndx;
	memcpy(log, &(sysMonitorInst->linkLog[buffIndx]), sizeof(LINKLOG));
	sysMonitorInst->linkLogCtrl.rBusy = buffIndex_old;
}
/** @} Linklayer_Log_API*/

/**
 * @name PhysicalLayer_Log_API
 * @{
 */

/**
 * @brief Update physical layer log
 *
 * @param log
 */
void SysMonitor_UpdatePhysicalLayerLog(const PHYLOG *log)
{
	ASSERT(sysMonitorInst != NULL);
	ASSERT(log != NULL);
	uint8_t buffIndx;
	buffIndx = GetWritable(sysMonitorInst->phyLogCtrl);
	sysMonitorInst->phyLogCtrl.wBusy = buffIndx;
	memcpy(&(sysMonitorInst->phyLog[buffIndx]), log, sizeof(PHYLOG));
	sysMonitorInst->phyLogCtrl.latest = buffIndx;
	sysMonitorInst->phyLogCtrl.wBusy = BUFF_NONE;
}

/**
 * @brief Get the latest physical layer log
 *
 * @param log
 */
void SysMonitor_GetPhysicalLayerLog(PHYLOG *log)
{
	ASSERT(sysMonitorInst != NULL);
	ASSERT(log != NULL);
	uint8_t buffIndx, buffIndex_old;
	buffIndex_old = sysMonitorInst->phyLogCtrl.rBusy;
	if (buffIndex_old != BUFF_NONE)
		buffIndx = buffIndex_old; // Keep it busy
	else
		buffIndx = GetReadable(sysMonitorInst->phyLogCtrl);
	sysMonitorInst->phyLogCtrl.rBusy = buffIndx;
	memcpy(log, &(sysMonitorInst->phyLog[buffIndx]), sizeof(PHYLOG));
	sysMonitorInst->phyLogCtrl.rBusy = buffIndex_old;
}
/** @} */

/**
 * @name HardwareState_Log_API
 * @{
 */

/**
 * @brief Log hardware running status.
 *
 * @param state
 */
void SysMonitor_UpdateHardwareStatus(const HWSTATE *state)
{
	ASSERT(sysMonitorInst != NULL);
	ASSERT(state != NULL);
	uint8_t buffIndx;
	buffIndx = GetWritable(sysMonitorInst->hwStateCtrl);
	sysMonitorInst->hwStateCtrl.wBusy = buffIndx;
	memcpy(&(sysMonitorInst->hwState[buffIndx]), state, sizeof(HWSTATE));
	sysMonitorInst->hwStateCtrl.latest = buffIndx;
	sysMonitorInst->hwStateCtrl.wBusy = BUFF_NONE;
}

/**
 * @brief Get the latest hardware running status.
 *
 * @param state
 */
void SysMonitor_GetHardwareStatus(HWSTATE *state)
{
	ASSERT(sysMonitorInst != NULL);
	ASSERT(state != NULL);
	uint8_t buffIndx, buffIndex_old;
	buffIndex_old = sysMonitorInst->hwStateCtrl.rBusy;
	if (buffIndex_old != BUFF_NONE)
		buffIndx = buffIndex_old; // Keep it busy
	else
		buffIndx = GetReadable(sysMonitorInst->hwStateCtrl);
	sysMonitorInst->hwStateCtrl.rBusy = buffIndx;
	memcpy(state, &(sysMonitorInst->hwState[buffIndx]), sizeof(HWSTATE));
	sysMonitorInst->hwStateCtrl.rBusy = buffIndex_old;
}

/** @} HardwareState_Log_API */

/** @} SystemMonitor*/