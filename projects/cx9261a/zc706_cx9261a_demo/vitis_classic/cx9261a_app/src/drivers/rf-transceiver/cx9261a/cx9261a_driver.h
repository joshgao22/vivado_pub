/**
 * @file cx9261adriver.h
 */

#ifndef CX9261A_DRIVER_H
#define CX9261A_DRIVER_H

/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include <stdint.h>
#include "delay.h"
#include "spi.h"
#include "gpio.h"

#include "cx9261a_defs.h"
#include "cx9261a_utils.h"

/******************************************************************************/
/********************** Macros and Constants Definitions **********************/
/******************************************************************************/


/******************************************************************************/
/*************************** Types Declarations *******************************/
/******************************************************************************/
struct cx9261a_dev {
	/* SPI */
	struct spi_desc *spi_desc;
	struct gpio_desc *gpio_desc_nrst;
	struct gpio_desc *gpio_desc_txnrx_trx1;
	struct gpio_desc *gpio_desc_txnrx_trx2;
	struct gpio_desc *gpio_desc_txnrx_rxfb;
	struct gpio_desc *gpio_desc_enable_trx1;
	struct gpio_desc *gpio_desc_enable_trx2;
	struct gpio_desc *gpio_desc_enable_rxfb;
	struct gpio_desc *gpio_desc_pl_rst;
	struct gpio_desc *gpio_desc_tr_sel;
	struct gpio_desc *gpio_desc_tdd_fdd_sel;
	struct gpio_desc *gpio_desc_r1t1_r2t2_sel;
	struct gpio_desc *gpio_desc_sp_dp_sel;
};

struct cx9261a_init_param {
	/* SPI */
	struct spi_init_param *spi_init;
	struct gpio_init_param *gpio_nrst;
	struct gpio_init_param *gpio_txnrx_trx1;
	struct gpio_init_param *gpio_txnrx_trx2;
	struct gpio_init_param *gpio_txnrx_rxfb;
	struct gpio_init_param *gpio_enable_trx1;
	struct gpio_init_param *gpio_enable_trx2;
	struct gpio_init_param *gpio_enable_rxfb;
	struct gpio_init_param *gpio_pl_rst;
	struct gpio_init_param *gpio_tr_sel;
	struct gpio_init_param *gpio_tdd_fdd_sel;
	struct gpio_init_param *gpio_r1t1_r2t2_sel;
	struct gpio_init_param *gpio_sp_dp_sel;
};

int32_t cx9261a_read(struct cx9261a_dev *dev,
			uint16_t reg_addr,
			uint8_t *reg_data);

int32_t cx9261a_write(struct cx9261a_dev *dev,
			 uint16_t reg_addr,
			 uint8_t reg_data);

int32_t cx9261a_reset(struct cx9261a_dev *dev);

namespace CX9261A {
/**
 * @brief 需要实现的函数，实现SPI写入寄存器功能
 * @param address 要写入的寄存器地址
 * @param value 要写入的寄存器值
 */
void writeSpi(int address, int value);
/**
 * @brief 需要实现的函数，实现SPI读取寄存器功能
 * @param address 要读取的寄存器地址
 * @return 返回的寄存器值
 */
int readSpi(int address);
/**
 * @brief 需要实现的函数，实现等待功能
 * @param ms 等待时间，单位毫秒
 */
void pause(double ms);
/**
 * @brief 需要实现的函数，实现配置FPGA对应寄存器功能
 * @param pin 寄存器地址
 * @param value 寄存器值
 */
void setPin(int pin, int value);
/**
 * @brief 初始化电源配置，如果只自定义配置部分模式下的电源管理，在自定义配置之前需要先调用此函数
 */
void initialPowerConfig(const CX9261AConfiguration& config);
/**
 * @brief 初始化芯片状态，写入与具体配置无关的寄存器值
 */
void initialChip();
/**
 * @brief 初始化BBPLL相关寄存器，如果调用了initialChip，则无需单独调用此函数
 */
void initialBBPLL();
/**
 * @brief 初始化PLL1相关寄存器，如果调用了initialChip，则无需单独调用此函数
 */
void initialPLL1();
/**
 * @brief 初始化PLL2相关寄存器，如果调用了initialChip，则无需单独调用此函数
 */
void initialPLL2();
/**
 * @brief 初始化PLL3相关寄存器，如果调用了initialChip，则无需单独调用此函数
 */
void initialPLL3();
/**
 * @brief 初始化PLL4相关寄存器，如果调用了initialChip，则无需单独调用此函数
 */
void initialPLL4();
/**
 * @brief 初始化PLL5相关寄存器，如果调用了initialChip，则无需单独调用此函数
 */
void initialPLL5();
/**
 * @brief 配置AGC模式
 * @param mode 模式0~13
 */
void configAGCMode(int mode);
/**
 * @brief 配置AGC PDT
 * @param pdt AGCPDT结构体
 */
void configAGCPDT(const AGCPDT& pdt);
/**
 * @brief 配置AGC LMT
 * @param lmt AGCLMT结构体
 */
void configAGCLMT(const AGCLMT& lmt);
/**
 * @brief 配置AGC DIG
 * @param dig AGCDIG结构体
 */
void configAGCDIG(const AGCDIG& dig);
/**
 * @brief 配置AGC
 * @param agc AGC结构体
 */
void configAGC(const AGC& agc);
/**
 * @brief 配置时钟相关寄存器，包括ADC和BBPLL
 * @param config CX9261A参数结构体
 */
void configBBPLL(const CX9261AConfiguration& config);
/**
 * @brief BBPLL AFC
 * @return 是否锁定
 */
bool afcBBPll();
/**
 * @brief 配置PLL1频率
 * @param lo 目标频率
 * @param clock 时钟结构体，使用其中的ref和refDoubler属性
 */
void configPll1(double lo, const Clock& clock);
/**
 * @brief Pll1 AFC
 * @return 是否锁定
 */
bool afcPll1();
/**
 * @brief 配置PLL2频率
 * @param lo 目标频率
 * @param clock 时钟结构体，使用其中的ref和refDoubler属性
 */
void configPll2(double lo, const Clock& clock);
/**
 * @brief Pll2 AFC
 * @return 是否锁定
 */
bool afcPll2();
/**
 * @brief 配置PLL3频率
 * @param lo 目标频率
 * @param clock 时钟结构体，使用其中的ref和refDoubler属性
 */
void configPll3(double lo, const Clock& clock);
/**
 * @brief Pll3 AFC
 * @return 是否锁定
 */
bool afcPll3();
/**
 * @brief 配置PLL4频率
 * @param lo 目标频率
 * @param clock 时钟结构体，使用其中的ref和refDoubler属性
 */
void configPll4(double lo, const Clock& clock);
/**
 * @brief Pll4 AFC
 * @return 是否锁定
 */
bool afcPll4();
/**
 * @brief 配置PLL5频率
 * @param lo 目标频率
 * @param clock 时钟结构体，使用其中的ref和refDoubler属性
 */
void configPll5(double lo, const Clock& clock);
/**
 * @brief Pll5 AFC
 * @return 是否锁定
 */
bool afcPll5();
/**
 * @brief ADC校准
 * @param adc ADC速率
 */
void configADCCalib(double adc);
/**
 * @brief Flash校准
 */
void configFlashCalib();
/**
 * @brief 配置片内处理器，仅在使用需要处理器辅助的校准方法时需要开启处理器
 * @param on 开启/关闭
 */
void configRISCV(bool on);
/**
 * @brief QEC校准会改变部分寄存器配置，在进行校准之前需要保存这部分寄存器，校准后恢复
 * @return 包含寄存器地址和值的map
 */
std::map<int, int> beforeQecState();
/**
 * @brief 恢复QEC校准过程中改变的寄存器
 * @param state beforeQecState函数返回的map
 */
void restoreQecState(const std::map<int, int>& state);
/**
 * @brief Rx窄带多点校准
 * @param config CX9261A配置结构体
 * @param points 校准点
 */
void configRxMultiPointsQec(const CX9261AConfiguration& config, const std::vector<double>& points);
/**
 * @brief Qec校准顶层函数，内部根据配置选择使用RX TST窄带方法对接收通道校准，使用二分法对发射通道校准
 * @param config CX9261A配置结构体
 */
void configQecCalib(const CX9261AConfiguration& config);
/**
 * @brief Rx TST窄带校准
 * @param config CX9261A配置结构体
 * @param chan 要进行校准的通道
 */
void rxTSTCalib(const CX9261AConfiguration& config, RxChannel chan);
/**
 * @brief 等待RxTST窄带校准结束，可重写
 * @return 校准是否结束
 */
bool waitRxTSTFinished();
/**
 * @brief Tx通道校准
 * @param config CX9261A配置结构体
 */
void txCalib(const CX9261AConfiguration& config);
/**
  * @brief TX二分法QEC校准
  * @param f0 校准音频率
  * @param fs adc频率
 */
void txBisectionQecCalib(double f0, double fs);
/**
 * @brief TX二分法DC校准
 * @param f0 校准音频率
 * @param fs adc频率
 */
void txBisectionDcCalib(double f0, double fs);
/**
 * @brief DC Tracking
 * @param config CX9261A配置结构体
 */
void configDcCalib(const Calib& config);
/**
 * @brief 配置TX NCO相关寄存器
 * @param nco TX NCO配置结构体
 * @param fs adc速率
 */
void configTxNco(const TxNCO& nco, double fs);
/**
 * @brief 配置TX NCO BIST模式
 * @param bist 开启/关闭BIST
 */
void configTxBIST(bool bist);
/**
 * @brief 配置TX NCO频率
 * @param freq 混频频率
 * @param fs adc抽取后速率
 */
void configTxNcoFreq(double freq, double fs);
/**
 * @brief 配置RX NCO相关寄存器
 * @param nco RX NCO配置结构体
 * @param fs adc速率
 */
void configRxNco(const RxNCO& nco, double fs);
/**
 * @brief 配置Rx NCO模式
 * @param mode NCO模式：Bypass/BIST/Up/Down
 */
void configRxNcoMode(NCOMode mode);
/**
 * @brief 配置Rx NCO模式
 * @param mode NCO模式：Master/Slaver
 */
void configRxNcoMS(NCOMode mode);
/**
 * @brief 配置Rx NCO频率
 * @param freq 混频频率
 * @param fs adc速率
 */
void configRxNcoFreq(double freq, double fs);
/**
 * @brief 配置接口相关寄存器
 * @param interface Interface配置结构体
 */
void configInterface(const Interface& interface);
/**
 * @brief 配置PLL来源
 * @param pllSource PLlSource结构体
 */
void configPllSource(const PllSource& pllSource);
/**
 * @brief 切换电源模式
 * @param pm 电源模式
 */
void configPowerMode(PowerMode pm);
/**
 * @brief 配置电源管理
 * @param power 电源配置结构体
 * @param pm 电源模式
 */
void configPowerPins(const Power& power, PowerMode pm);
/**
 * @brief 配置参考倍频器
 * @param doubler 倍频器开关
 * @param ref 参考时钟频率，单位MHz
 */
void configRefDoubler(bool doubler, double ref);
/**
 * @brief 初始化通道，调用initialChip函数会初始化RX1，RX2，RX3三个通道
 * @param chan 通道 RX1/RX2/RX3
 */
void initialRxChannel(RxChannel chan);
/**
 * @brief 配置Rx带宽
 * @note 只改变Rx带宽会导致通道增益改变，建议使用configRxChannel函数进行带宽调整
 * @param bandwidth 带宽，单位(MHz)
 * @param chan 通道 Rx1/Rx2/Rx3
 */
void configRxBandwidth(double bandwidth, RxChannel chan);
/**
 * @brief 配置Rx TIA
 * @note 只改变TIA会导致通道带宽改变，建议使用configRxChannel函数进行TIA调整
 * @param tia tia档位
 * @param chan 通道 Rx1/Rx2/Rx3
 */
void configRxTIA(int tia, RxChannel chan);
/**
 * @brief 配置Rx Mixer
 * @param mixer mixer档位
 */
void configRxMixer(int mixer);
/**
 * @brief 配置Rx通道，包含TIA，Mixer以及Bandwidth
 * @param config RxConfig结构体
 * @param chan Rx1/Rx2/Rx3
 */
void configRxChannel(const RxConfig& config, RxChannel chan);
/**
 * @brief 配置Rx FIR滤波器抽取倍数
 * @param fir 抽取倍数 0(Bypass)/1/2/3/4/8
 */
void configRxFIR(int fir);
/**
 * @brief 配置Rx FIR滤波器系数
 * @param coe 滤波器系数，长度为16的整倍数，最大128
 */
void configRxFIRCoe(const std::vector<double>& coe);
/**
 * @brief 配置Rx HBF1滤波器抽取倍数
 * @param hbf 抽取倍数 0(Bypass)/2
 */
void configRxHBF1(int hbf);
/**
 * @brief 配置Rx HBF2滤波器抽取倍数
 * @param hbf 抽取倍数 0(Bypass)/2
 */
void configRxHBF2(int hbf);
/**
 * @brief 配置Rx HBF3滤波器抽取倍数
 * @param hbf 抽取倍数 0(Bypass)/2/3
 */
void configRxHBF3(int hbf);
/**
 * @brief 配置Rx CIC滤波器
 * @param cic 抽取倍数 0(Bypass)/20
 */
void configRxCIC(int cic);
/**
 * @brief 配置Rx滤波器
 * @param filters Filters结构体
 */
void configRxFilters(const Filters& filters);
/**
 * @brief 配置Tx带宽
 * @param bandwidth 带宽，单位(MHz)
 * @param chan 通道 TX1/TX2
 */
void configTxBandwidth(double bandwidth, TxChannel chan);
/**
 * @brief 配置Tx Mixer
 * @param mixer 混频器值
 * @param chan TX1/TX2
 */
void configTxMixer(int mixer, TxChannel chan);
/**
 * @brief 初始化Tx通道
 * @param chan 通道 TX1/TX2
 */
void initialTxChannel(TxChannel chan);
/**
 * @brief 根据Tx通道的本振频率，配置对应的参数
 * @param lo 本振频率，单位(MHz)
 * @param chan 通道(Tx1/Tx2)
 */
void configTxChannelFrequency(double lo, TxChannel chan);
/**
 * @brief 配置Tx通道，Mixer以及Bandwidth
 * @param config TxConfig结构体
 * @param chan Tx1/Tx2
 */
void configTxChannel(const TxConfig& config, TxChannel chan);
/**
 * @brief 配置Tx FIR滤波器插值倍数
 * @param fir 插值倍数 0(Bypass)/1/2/3/4/8
 */
void configTxFIR(int fir);
/**
 * @brief 配置Tx FIR滤波器系数
 * @param coe 滤波器系数，长度为16的整倍数，最大128
 */
void configTxFIRCoe(const std::vector<double>& coe);
/**
 * @brief 配置Tx HBF1滤波器插值倍数
 * @param hbf 插值倍数 0(Bypass)/2
 */
void configTxHBF1(int hbf);
/**
 * @brief 配置Tx HBF2滤波器插值倍数
 * @param hbf 插值倍数 0(Bypass)/2
 */
void configTxHBF2(int hbf);
/**
 * @brief 配置Tx HBF3滤波器插值倍数
 * @param hbf 插值倍数 0(Bypass)/2/3
 */
void configTxHBF3(int hbf);
/**
 * @brief 配置Tx CIC滤波器
 * @param cic 插值倍数 0(Bypass)/8/20/32/80
 */
void configTxCIC(int cic);
/**
 * @brief 配置Tx滤波器
 * @param filters Filters结构体
 */
void configTxFilters(const Filters& filters);
/**
 * @brief 读取当前Rx chan通道的校准值
 * @param chan Rx通道
 * @return Rx校准值结构体
 */
CalibPredis readRxCalibPredis(RxChannel chan);
/**
 * @brief 储存校准值
 * @param index 第index组校准值
 * @param chan 接收通道
 * @param predis 校准值
 */
void saveRxCalibPredis(unsigned char index, RxChannel chan, const CalibPredis& predis);
/**
 * @brief 加载保存的校准值
 * @param index 第index组校准值
 */
void loadRxCalibPredis(unsigned char index);
/**
 * @brief 此函数为Demo板配套配置函数，用于配置FPGA接口，用户开发自己的程序时应重写对应功能
 * @param interface Interface结构体
 */
void configFPGA(const Interface& interface);
}  // namespace CX9261A

#endif  // CX9261ADRIVER_CX9261ADRIVER_H
