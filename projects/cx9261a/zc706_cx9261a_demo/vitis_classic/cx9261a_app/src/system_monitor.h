/**
 * @defgroup SystemMonitor
 * @{
 */

#ifndef __SYSTEM_MONITOR_H_
#define __SYSTEM_MONITOR_H_

/***************************** Include Files *********************************/
#include <stdint.h>
#include <stdbool.h>
#include "util.h"

/************************* Constant Definitions ******************************/
/**
 * @name SystemMonitor_Constants
 * @{
 */
#define PAYLOAD_LEN_MAX 256
#define PAYLOAD_LEN_FLJ_RX 168
#define PAYLOAD_LEN_FLJ_TX 66
#define PAYLOAD_LEN_LJ_RX 66
#define PAYLOAD_LEN_LJ_TX 168

#define DATA_ID_NONE UINT32_MAX
#define DATA_ID_TEST 0x02030203

#define VOLTAGE_LSB 0.01 // volt
#define VOLTAGE_MAX 2.55 // volt

#define VOLT_PS_STD 1.0
#define VOLT_PSAUX_STD 1.8
#define VOLT_DDR_STD 1.5
#define VOLT_PL_STD 1.0
#define VOLT_PLAUX_STD 1.8
#define VOLT_BRAM_STD 1.0

#define VOLT_PS_OK BIT(0)
#define VOLT_PSAUX_OK BIT(1)
#define VOLT_DDR_OK BIT(2)
#define VOLT_PL_OK BIT(3)
#define VOLT_PLAUX_OK BIT(4)
#define VOLT_BRAM_OK BIT(5)

#define VOLT_ANT_PROC_OK BIT(0)
#define VOLT_ANT_RF_OK BIT(2)
#define VOLT_ANT_NIL_OK BIT(4)
#define ANT_STATE_OK BIT(6)

// Xilinx Recommended
// #define IS_PS_VALID(x) (x <= 1.05 && x >= 0.95)
// #define IS_PSAUX_VALID(x) (x <= 1.89 && x >= 1.71)
// #define IS_DDR_VALID(x) (x <= 1.89 && x >= 1.14)
// #define IS_PL_VALID(x) (x <= 1.03 && x >= 0.97)
// #define IS_PLAUX_VALID(x) (x <= 1.89 && x >= 1.71)
// #define IS_BRAM_VALID(x) (x <= 1.03 && x >= 0.97)
#define IS_PS_VALID(x) (x <= 1.1 && x >= 0.9)
#define IS_PSAUX_VALID(x) (x <= 2.0 && x >= 1.6)
#define IS_DDR_VALID(x) (x <= 1.7 && x >= 1.3)
#define IS_PL_VALID(x) (x <= 1.1 && x >= 0.9)
#define IS_PLAUX_VALID(x) (x <= 2.0 && x >= 1.6)
#define IS_BRAM_VALID(x) (x <= 1.1 && x >= 0.9)

#define CLK_SP_PLL1_LOCK BIT(0)
#define CLK_SP_PLL2_LOCK BIT(2)

#define CLK_AD0_BBPLL_LOCK BIT(0)
#define CLK_AD0_RFPLL_LOCK BIT(2)
#define CLK_AD1_BBPLL_LOCK BIT(4)
#define CLK_AD1_RFPLL_LOCK BIT(6)

#define CLK_ANT_BBPLL_LOCK BIT(0)
#define CLK_ANT_RFPLL0_LOCK BIT(2)
#define CLK_ANT_RFPLL1_LOCK BIT(4)

#define TEMPERATURE_LSB 1.0	   // Celsius degree
#define TEMPERATURE_MAX 127.0  // Celsius degree
#define TEMPERATURE_MIN -128.0 // Celsius degree
/** @} SystemMonitor_Constants */

/************************* Data Type Definitions ****************************/

/**
 * @struct SYSINFO
 * @brief System Infomation log
 */
typedef struct __attribute__((packed))
{
	uint32_t psBDS; ///< -- unit: ms, 0~604799999
	uint16_t pBDS;	///< -- unit: week, 0~0~8191
	uint32_t psGPS; ///< -- unit: ms, 0~604799999
	uint16_t pGPS;	///< -- unit: week, 0~0~8191
	uint8_t tmInd;	///< Time validation indicator \n
					// -- [0] GPS\n
					// -- [1] reserve.\n
					// -- [2] UTC\n
					// -- [3] BDS\n
	float tmFly;	///< Time of flying uint: s
	uint8_t stFly;	///< Status of flying \n
					// [7:6] departure status 11 - departed/00 - not departed \n
					// [5:4] ready status 11 - ready/00 - not ready \n
					// [3:2] attitude status 11 - attitude ok/00 - attitude not ok \n
					// [1:0] attitude adjust status 11 - adjusted/00 - not adjusted
	float posX;		///< coord X Position in launch coordinate system
	float posY;		///< coord Y Position in launch coordinate system
	float posZ;		///< coord Z Position in launch coordinate system
	float vX;		///< Speed X in launch coordinate system
	float vY;		///< Speed Y in launch coordinate system
	float vZ;		///< Speed Z in launch coordinate system
	float pitch;	///< Pitch Attitude in launch inertia coordinate system
	float yaw;		///< Yaw Attitude in launch inertia coordinate system
	float roll;		///< Roll Attitude in launch inertia coordinate system
} SYSINFO;

/**
 * @struct SYSBUSLOG
 * @brief System Info holds the system bus log
 */
typedef struct __attribute__((packed))
{
	// SystemBus log

	uint8_t lastConfig[2]; ///< Last valid config \n
						   //  byte 0: 0x11 FLJ, 0x00 LJ \n
						   //   byte 1: 0x66 Full Power, 0x88 Low Power
	uint32_t pollCnt;	   ///< number of poll commands
	uint32_t svcCnt;	   ///< number of service commands
	uint32_t remoteCnt;	   ///< number of remote check commands
} SYSBUSLOG;

/**
 * @struct LINKLOG
 * @brief Linklayer Log struct holds the Linklayer log
 */
typedef struct __attribute__((packed))
{
	// Network log
	uint32_t tuNum;			///< current time unite number
	uint8_t slotNum;		///< current slot number
	uint8_t nodeType;		///< current node type
	uint8_t cxnStatus;		///< current connection status
	uint8_t linkStage;		///< current linklayer working stage
	uint32_t recxnCnt;		///< reconnect trial count
	uint8_t beamNo;			///< current working beam number
	uint8_t beamWidth;		///< current working beam width
	uint16_t beamAz;		///< current working beam angle Az
	uint16_t beamEl;		///< current working beam angle Ez
	uint16_t advTxCnt;		///< adv frame send count
	uint16_t advRecvCnt;	///< adv frame received count
	uint16_t advCorrectCnt; ///< adv frame received correctly count
	uint32_t cfmTxCnt;		///< cfm frame send count
	uint32_t cfmRecvCnt;	///< cfm frame received count
	uint32_t cfmCorrectCnt; ///< adv frame received correctly count
	uint32_t svcTxCnt;		///< svc frame send count
	uint32_t svcRecvCnt;	///< svc frame received count
	uint32_t svcCorrectCnt; ///< svc frame received correctly count
	int32_t timeDev;		///< last time deviation result
	uint32_t sendId;		///< last send data id
	uint32_t recvId;		///< last received data id
	uint8_t reserve[4];		///< reserved data
} LINKLOG;

/**
 * @struct PHYLOG
 * @brief Physical Layer Log struct holds the Linklayer log
 */
typedef struct __attribute__((packed))
{
	uint32_t acqCnt;		///< aquisition count
	uint32_t fsyncCnt;		///< frame sync count
	uint32_t decodeCnt;		///< decode count
	uint32_t crcCnt;		///< crc valid count
	double doppler;			///< last doppler estimation result
	uint64_t recvStamp;		///< last frame arrival time
	double acqPAPR;			///< last acquisition peak-average ration
	uint8_t acqPhase;		///< last acquisition phase estimation
	uint8_t acqFreqCh;		///< last acquisition frequency deviation estimation
	double fsyncPAPR;		///< last frame sync peak-average ration
	uint8_t fsyncFreqCh;	///< last frame sync frequency estimation
	uint16_t deintlvAmpEst; ///< de-interleave amplitude estimation
	uint8_t antMode;		///< current antenna working mode
	uint8_t reserve[3];		///< reserved data
} PHYLOG;

/**
 * @struct HWSTATE
 * @brief Hardware Status Log struct holds all hardware status
 */
typedef struct __attribute__((packed))
{
	bool isSpOk;  ///< signal processor state
	bool isAntOk; ///< antenna state
	// -- Signal processor status
	uint8_t spFpgaVolt;	   ///< Signal processor voltage state indicator
	uint8_t spClkState;	   ///< Signal processor clock state indicator
	uint8_t spAdLockState; ///< Signal processor adc lock state indicator
	uint8_t spAdTemp_0;	   ///< Signal processor adc0 temperature
	uint8_t spAdTemp_1;	   ///< Signal processor adc1 temperature
	uint8_t spFpgaTemp;	   ///< Signal processor FPGA temperature
	// -- Antenna status
	uint8_t antVolt; ///< Antenna voltage state indicator
	uint8_t antTemp; ///< Antenna rf temperature
	uint8_t antPll;	 ///< Antenna rf lock state indicator
	uint8_t antMgc0; ///< Antenna rf mgc0~1 indicator
	uint8_t antMgc1; ///< Antenna rf mgc2~3 indicator
	uint8_t phyId;
	uint8_t reserve[1];
} HWSTATE;

/**
 * @struct PAYLOAD
 * @brief Payload struct holds the service payload
 */
typedef struct
{
	uint32_t dataId;
	uint8_t data[PAYLOAD_LEN_MAX];
} PAYLOAD;

/************************** Function Prototypes ******************************/
int32_t SysMonitor_Init(void);
void SysMonitor_Destroy(void);

void SysMonitor_UpdateSysinfo(const SYSINFO *info);
void SysMonitor_GetSysinfo(SYSINFO *info);

void SysMonitor_UpdateSendPayload(const uint8_t *buff, size_t len);
void SysMonitor_UpdateRecvPayload(const uint8_t *buff, uint32_t id, size_t len);
void SysMonitor_GetSendPayload(uint8_t *buff, uint32_t *id, size_t len);
void SysMonitor_GetRecvPayload(uint8_t *buff, uint32_t *id, size_t len);

void SysMonitor_UpdateLinklayerLog(const LINKLOG *log);
void SysMonitor_UpdatePhysicalLayerLog(const PHYLOG *log);
void SysMonitor_UpdateHardwareStatus(const HWSTATE *state);
void SysMonitor_GetLinklayerLog(LINKLOG *log);
void SysMonitor_GetPhysicalLayerLog(PHYLOG *log);
void SysMonitor_GetHardwareStatus(HWSTATE *state);

#endif //__SYSTEM_MONITOR_H_

/** @} */
