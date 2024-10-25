/**
 * @file defs.h
 */

#ifndef CX9261A_DEFS_H
#define CX9261A_DEFS_H

#include <bitset>
#include <map>
#include <vector>

namespace CX9261A {
/**
 * @brief 芯片工作模式
 */
enum class WorkMode { Rx, Tx, FDD };
/**
 * @brief 收发数据通道数量
 * @note 此模式并不代表使用几个通道进行收发
 */
enum class TrMode { R1T1, R2T2 };
/**
 * @brief 收发接口通道数量
 */
enum class PortMode { Single, Dual };
/**
 * @brief 接口模式：
 * CMOS CMOS接口模式，
 * LVDS_S LVDS顺序模式，
 * LVDS_E LVDS奇偶模式
 */
enum class IOMode { CMOS, LVDS_S, LVDS_E };
/**
 * @brief 本振来源
 */
enum class LoSource { Pll1, Pll2, Pll3, Pll4, Pll5, Off };
/**
 * @brief 接收通道
 */
enum class RxChannel { Rx1 = 1, Rx2, Rx3 };
/**
 * @brief 发射通道
 */
enum class TxChannel { Tx1 = 1, Tx2 };
/**
 * @brief 电源模式
 */
enum class PowerMode { Shutdown = 0, Sleep, Alert, Calib, Receive, Transmit, Duplex, Obs };
/**
 * @brief NCO模式
 */
enum class NCOMode { Bypass = 0, Up, Down, BIST, Master, Slaver };

/**
 * @brief AFC等待延时，单位ms
 */
constexpr double delay = 100;
constexpr double delay_afc = 0.020;
/**
 * @brief QEC等待延时，单位ms
 */
constexpr double qecDelay = 100;
/**
 * @brief 接收通道本振来源映射表
 */
static const std::map<std::pair<LoSource, LoSource>, std::bitset<7>> rxSrcMap = {
    { { LoSource::Pll2, LoSource::Pll2 }, 0b0010000 }, { { LoSource::Pll1, LoSource::Pll1 }, 0b1101000 },
    { { LoSource::Pll2, LoSource::Pll1 }, 0b0100000 }, { { LoSource::Pll1, LoSource::Pll2 }, 0b1000000 },
    { { LoSource::Off, LoSource::Pll1 }, 0b0101010 },  { { LoSource::Off, LoSource::Pll2 }, 0b1010010 },
    { { LoSource::Pll1, LoSource::Off }, 0b1001001 },  { { LoSource::Pll2, LoSource::Off }, 0b0110001 },
    { { LoSource::Off, LoSource::Off }, 0b0011011 }
};
/**
 * @brief 发射通道本振来源映射表
 */
static const std::map<std::pair<LoSource, LoSource>, std::bitset<11>> txSrcMap = {
    { { LoSource::Pll4, LoSource::Pll4 }, 16 },   { { LoSource::Pll3, LoSource::Pll3 }, 104 },
    { { LoSource::Pll4, LoSource::Pll3 }, 32 },   { { LoSource::Pll3, LoSource::Pll4 }, 64 },
    { { LoSource::Pll2, LoSource::Pll2 }, 1560 }, { { LoSource::Pll1, LoSource::Pll1 }, 1944 },
    { { LoSource::Pll2, LoSource::Pll1 }, 1688 }, { { LoSource::Pll1, LoSource::Pll2 }, 1816 },
    { { LoSource::Off, LoSource::Pll3 }, 42 },    { { LoSource::Off, LoSource::Pll4 }, 82 },
    { { LoSource::Off, LoSource::Pll2 }, 794 },   { { LoSource::Off, LoSource::Pll1 }, 666 },
    { { LoSource::Pll3, LoSource::Off }, 73 },    { { LoSource::Pll4, LoSource::Off }, 49 },
    { { LoSource::Pll2, LoSource::Off }, 1177 },  { { LoSource::Pll1, LoSource::Off }, 1305 },
    { { LoSource::Off, LoSource::Off }, 27 },     { { LoSource::Pll1, LoSource::Pll3 }, 1320 },
    { { LoSource::Pll1, LoSource::Pll4 }, 1360 }, { { LoSource::Pll2, LoSource::Pll3 }, 1064 },
    { { LoSource::Pll2, LoSource::Pll4 }, 1104 }, { { LoSource::Pll3, LoSource::Pll1 }, 712 },
    { { LoSource::Pll4, LoSource::Pll1 }, 688 },  { { LoSource::Pll3, LoSource::Pll2 }, 584 },
    { { LoSource::Pll4, LoSource::Pll2 }, 560 }
};
/**
 * @brief 环路参数选择表
 */
static const std::vector<std::vector<std::vector<int>>> coreTable = {
    { { 0x0C, 0x30, 0x08 }, { 0x0B, 0x30, 0x09 }, { 0x0C, 0x30, 0x05 }, { 0x0D, 0x30, 0x08 } },
    { { 0x0C, 0x30, 0x0C }, { 0x0B, 0x30, 0x0E }, { 0x0C, 0x30, 0x08 }, { 0x0D, 0x30, 0x0B } },
    { { 0x0C, 0x20, 0x10 }, { 0x0B, 0x20, 0x10 }, { 0x0C, 0x20, 0x0A }, { 0x0D, 0x20, 0x0D } },
    { { 0x0C, 0x20, 0x11 }, { 0x0B, 0x20, 0x13 }, { 0x0C, 0x20, 0x0C }, { 0x0D, 0x20, 0x0F } },
    { { 0x0D, 0x30, 0x14 }, { 0x0D, 0x22, 0x14 }, { 0x0D, 0x20, 0x0D }, { 0x0D, 0x15, 0x0C } },
    { { 0x0E, 0x30, 0x18 }, { 0x0E, 0x25, 0x16 }, { 0x0E, 0x25, 0x0F }, { 0x0E, 0x18, 0x0F } },
    { { 0x0F, 0x38, 0x1A }, { 0x0F, 0x32, 0x1C }, { 0x0F, 0x18, 0x12 }, { 0x0F, 0x18, 0x12 } }
};

/**
 * @brief AGC PDT模式的结构体
 */
struct AGCPDT
{
    int pdtN;
    int pdtM;
};

/**
 * @brief AGC LMT模式的结构体
 */
struct AGCLMT
{
    int count; /**< LMT统计次数阈值*/
    int threshold1; /**< LMT阈值第一档*/
    int threshold2; /**< LMT阈值第二档*/
    int threshold3; /**< LMT阈值第三档*/
    int threshold4; /**< LMT阈值第四档*/
};

/**
 * @brief AGC DIG模式的结构体
 */
struct AGCDIG
{
    int count; /**< DIG统计次数阈值*/
    int threshold1; /**< DIG阈值第一档*/
    int threshold2; /**< DIG阈值第二档*/
    int threshold3; /**< DIG阈值第三档*/
    int threshold4; /**< DIG阈值第四档*/
};

/**
 * @brief AGC模式的结构体
 */
struct AGC
{
    int mode; /**< AGC模式选择*/
    AGCPDT pdt; /**< AGC PDT模式的结构体*/
    AGCLMT lmt; /**< AGC LMT模式的结构体*/
    AGCDIG dig; /**< AGC DIG模式的结构体*/
};

/**
 * @brief 时钟相关参数结构体
 */
struct Clock
{
    double ref; /**< 参考时钟频率，单位MHz*/
    double adc; /**< ADC频率，单位MHz*/
    int refDiv; /**< 参考时钟分频比*/
    bool bbUseIntDiv; /**< 是否使用整数分频模式*/
    bool refDoubler; /**< 是否使用参考时钟倍频器*/
};

/**
 * @brief 校准相关参数结构体
 */
struct Calib
{
    bool calibRx1; /**< 是否校准Rx1*/
    bool calibRx2; /**< 是否校准Rx2*/
    bool calibRx3; /**< 是否校准Rx3*/
    bool calibTx1; /**< 是否校准Tx1*/
    bool calibTx2; /**< 是否校准Tx1*/
    bool calibDC; /**< 是否开启DC Tracking*/
    int dcCalibLength; /**< DC Tracking长度*/
    double f0; /**< 校准音频率*/
};

/**
 * @brief 配置PLL来源相关参数结构体
 */
struct PllSource
{
    bool rxUseExt; /**< 接收通道是否使用外本振*/
    bool txUseExt; /**< 发射通道是否使用外本振*/
    LoSource rx1Source; /**< Rx1通道本振来源*/
    LoSource rx2Source; /**< Rx2通道本振来源*/
    LoSource rx3Source; /**< Rx3通道本振来源*/
    LoSource tx1Source; /**< Tx1通道本振来源*/
    LoSource tx2Source; /**< Tx2通道本振来源*/
};

/**
 * @brief 配置PLL频率相关参数结构体
 */
struct PllFreq
{
    double pll1Freq; /**< PLL1本振时钟，单位MHz*/
    double pll2Freq; /**< PLL2本振时钟，单位MHz*/
    double pll3Freq; /**< PLL3本振时钟，单位MHz*/
    double pll4Freq; /**< PLL4本振时钟，单位MHz*/
    double pll5Freq; /**< PLL5本振时钟，单位MHz*/
    double rxExtFreq; /**< 接收通道使用外本振时，外本振频率，单位MHz*/
    double txExtFreq; /**< 发射通道使用外本振时，外本振频率，单位MHz*/
};

/**
 * @brief 配置接口相关参数结构体
 */
struct Interface
{
    WorkMode workMode; /**< 芯片工作模式*/
    TrMode trMode; /**< 收发数据通道模式*/
    PortMode portMode; /**< 收发接口通道模式*/
    IOMode ioMode; /**< 接口电平模式*/
};

/**
 * @brief 配置TX NCO相关参数结构体
 */
struct TxNCO
{
    bool txUseBist; /**< 是否开启BIST模式*/
    double txNCOFreq; /**< NCO频率*/
};

/**
 * @brief 配置RX NCO相关参数结构体
 */
struct RxNCO
{
    bool rxUseBist; /**< 是否开启BIST模式*/
    bool rxNCOBypass; /**< 是否Bypass NCO*/
    bool rxNCOUpward; /**< 开启上/下混频模式*/
    bool rxNCOMaster; /**< 使用Master/Slaver模式*/
    double rxNCOFreq; /**< NCO频率*/
};

/**
 * @brief 配置接收通道相关参数结构体
 */
struct RxConfig
{
    double bandwidth; /**< 接收通道1dB带宽，单位MHz*/
    int tia; /**< 接收通道TIA增益配置，推荐配置6*/
    int mixer; /**< 接收通道Mixer增益配置*/
};

/**
 * @brief 配置发射通道相关参数结构体
 */
struct TxConfig
{
    double bandwidth; /**< 发射通道1dB带宽，单位MHz*/
    int mixer; /**< 发射通道Mixer增益配置*/
};

/**
 * @brief 配置滤波器相关参数结构体，0代表bypass
 */
struct Filters
{
    int fir; /**< FIR滤波器抽取/插值倍数*/
    int hbf1; /**< HBF1滤波器抽取/插值倍数*/
    int hbf2; /**< HBF2滤波器抽取/插值倍数*/
    int hbf3; /**< HBF3滤波器抽取/插值倍数*/
    int cic; /**< CIC滤波器抽取/插值倍数*/
};

/**
 * @brief 配置电源模式结构体，1代表该模块上电
 */
struct Power
{
    bool dig_tx2;
    bool dig_tx1;
    bool dig_rx3;
    bool dig_rx2;
    bool dig_rx1;
    bool fref1_rx;
    bool auxadc2;
    bool auxadc1;
    bool auxdac;
    bool temp_sensor;
    bool bgr;
    bool exlo;
    bool tx2;
    bool tx1;
    bool rx3;
    bool rx2;
    bool rx1;
    bool pll5_ldo;
    bool pll5;
    bool pll4_ldo;
    bool pll4;
    bool pll3_ldo;
    bool pll3;
    bool pll2_ldo;
    bool pll2;
    bool pll1_ldo;
    bool pll1;
    bool bbpll;
};

/**
 * @brief 配置电源模式管理，包含模式选择，断电模式，接收模式，发射模式，FDD模式
 */
struct PowerManagement
{
    PowerMode powerMode;
    Power shutdownPower;
    Power rxPower;
    Power txPower;
    Power fddPower;
};

/**
 * @brief 储存窄带校准结果的结构体
 */
struct CalibPredis {
    int bHigh;
    int bLow;
    int cHigh;
    int cLow;
    int dciHigh;
    int dciLow;
    int dcqHigh;
    int dcqLow;
};

/**
 * @brief CX9261A结构体
 */
struct CX9261AConfiguration
{
    AGC agc; /**< AGC结构体*/
    Interface interface; /**< Interface结构体*/
    Clock clock; /**< Clock结构体*/
    PllSource pllSource; /**< PllSource结构体*/
    Calib calib; /**< Calib结构体*/
    PllFreq pllFreq; /**< PllFreq结构体*/
    TxNCO txNco; /**< TxNCO结构体*/
    RxNCO rxNco; /**< RxNCO结构体*/
    RxConfig rx1Config; /**< RxConfig结构体*/
    RxConfig rx2Config; /**< RxConfig结构体*/
    RxConfig rx3Config; /**< RxConfig结构体*/
    TxConfig tx1Config; /**< TxConfig结构体*/
    TxConfig tx2Config; /**< TxConfig结构体*/
    Filters rxFilters; /**< Filters结构体*/
    Filters txFilters; /**< Filters结构体*/
    PowerManagement powerManagement; /**< PowerManagement结构体*/
    std::vector<double> rxFIRCoe; /**< Rx FIR滤波器系数*/
    std::vector<double> txFIRCoe; /**< Tx FIR滤波器系数*/
};
} // namespace CX9261A
#endif // CX9261ADRIVER_DEFS_H
