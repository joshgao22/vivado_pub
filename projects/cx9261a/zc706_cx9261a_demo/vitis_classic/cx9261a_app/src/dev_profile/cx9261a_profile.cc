#include "dev_profile.h"
#include "spi.h"
#include "../config/app_config.h"
#include "../drivers/rf-transceiver/cx9261a/cx9261a_driver.h"
#include "../drivers/axi_core/spi_engine/spi_engine.h"
#include "../drivers/platform/xilinx_gpio.h"

#include "common.h"
#include "xtime_l.h"

#undef max

CX9261A::Clock* ref_clock;
extern struct cx9261a_dev *cx9261a_inst;

void trx_ch_pll_config(uint8_t pll_index)
{
	uint8_t rx_data;
	uint8_t recv_buf[3]={0};
	uint32_t trx_ch_pll_data;

	if(pll_index==1){
		trx_ch_pll_data = 0x00077DCF;
	}else if(pll_index==2){
		trx_ch_pll_data = 0x00077D0C;
	}

//	recv_buf[0] =(trx_ch_pll_data>>16 & 0xff)|0x80 ;
//	recv_buf[1] = trx_ch_pll_data>>8 & 0xff;
//	recv_buf[2] = trx_ch_pll_data  & 0xff;
//	SpiPs_write_read(recv_buf,&rx_data);

	cx9261a_write(cx9261a_inst, trx_ch_pll_data>>16 & 0xff, trx_ch_pll_data & 0xff);
}

//void frqhop_config(int hop_flag,CX9261A::Clock& clock){
void frqhop_config(int hop_flag){
	static XTime tCur;
    XTime_GetTime(&tCur);
    srand(tCur);
    static double hop_freq ;
    hop_freq = (rand()%(800-30))+30+(rand()%(101))/(double)100;//随机产生[30,800)double类型的数
//    double hop_freq = 400.52;
	static double hop_freq1 = 800.25;
	static int pll_index=1;
	static int unlock_pll1_cnt=0,unlock_pll2_cnt=0;
	if(hop_freq == hop_freq1){
		if(pll_index == 2){
			pll_index = 4;
		}
		else if(pll_index == 1){
			pll_index = 3;
		}
	}
	if(hop_flag == 1){
		if(pll_index == 1 || pll_index == 3){
				//切换至pll2来源
				trx_ch_pll_config(2);
				//配置pll1参数
				CX9261A::configPll1(hop_freq,*ref_clock);
//				unlock_pll1_cnt=PLL_config(1,hop_freq,ref)-1;
			    while (!CX9261A::afcPll1()) {
				    	unlock_pll1_cnt++;
				}
				pll_index = 2;
		}
	else if(pll_index == 2 || pll_index == 4){
				//切换至pll1来源
				trx_ch_pll_config(1);
				//配置pll2参数
				CX9261A::configPll2(hop_freq,*ref_clock);
//				unlock_pll2_cnt=PLL_config(2,hop_freq,ref)-1;
			    while (!CX9261A::afcPll2()) {
				    	unlock_pll2_cnt++;
				}
				pll_index = 1;
		}
	}
	hop_freq1 = hop_freq;
	if(unlock_pll2_cnt!=0 || unlock_pll1_cnt !=0){
//		DBG_PRINT("pll1 unlock num: %d; pll2 unlock num: %d;.\n", unlock_pll1_cnt, unlock_pll2_cnt);
	}
}

int cx9261a_config() {

	/***********************配置参数定义*****************************/
    // 芯片配置结构体
    CX9261A::CX9261AConfiguration configuration;
    // 电源管理 (与评估软件电源管理自定义电源里面勾选项相对应，先左再右，从上往下)
    // 断电模式电源管理
    configuration.powerManagement.shutdownPower = {
    		0, 0, 0, 0, 0, // digital trx
			0, 0, 0, 0, 0, 0, 0, // aux
			0, 0, 0, 0, 0, // analog trx
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 // plls
    };
    // 接收模式电源管理
    configuration.powerManagement.rxPower = {
    		0, 0, 0, 1, 1, // digital trx
			1, 0, 0, 0, 0, 1, 0, // aux
			0, 0, 0, 1, 1, // analog trx
			0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1 // plls
    };
    // 发射模式电源管理
    configuration.powerManagement.txPower = {
    		1, 1, 0, 0, 0, // digital trx
			1, 0, 0, 0, 0, 1, 0, // aux
			1, 1, 0, 0, 0, // analog trx
			0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1 // plls
    };
    // FDD模式电源管理
    configuration.powerManagement.fddPower = {
    		1, 1, 0, 1, 1, // digital trx
			1, 0, 0, 0, 0, 1, 0, // aux
			1, 1, 0, 1, 1, // analog trx
			0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1 // plls
    };
    // 电源模式 即初始化配置结束后的电源模式
    configuration.powerManagement.powerMode = CX9261A::PowerMode::Duplex;
    // 接口模式
    configuration.interface = {
    		.workMode = CX9261A::WorkMode::Tx,
		   .trMode = CX9261A::TrMode::R1T1,
		   .portMode = CX9261A::PortMode::Single,
		   .ioMode = CX9261A::IOMode::CMOS
    };
    // 时钟相关  (与评估软件参考配置和基带配置相对应)
    configuration.clock = {
    		.ref = 200, .adc = 25.6, .refDiv = 2, .bbUseIntDiv = false, .refDoubler = false
    };
    // 本振相关
    using LoSource = CX9261A::LoSource;
    // 本振来源
    configuration.pllSource = {
    		.rxUseExt = false,
			.txUseExt = false,
			.rx2Source = LoSource::Pll2,
			.rx3Source = LoSource::Off,
			.tx1Source = LoSource::Pll1,
			.tx2Source = LoSource::Pll2
    };
    // 本振频率 注意：使用的所有PLL，频率必须设为正数
    configuration.pllFreq = {
        .pll1Freq = 200,
		.pll2Freq = 500,
		.pll3Freq = 800,
		.pll4Freq = 900,
		.pll5Freq = 1000
    };
    // Rx通道 注意：tia推荐配置为6 Mixer为三个通道共用同一个寄存器
    configuration.rx1Config = {.bandwidth = 32, .tia = 6, .mixer = 31};
    configuration.rx2Config = {.bandwidth = 32, .tia = 6, .mixer = 31};
    configuration.rx3Config = {.bandwidth = 32, .tia = 6, .mixer = 31};
    // Tx通道
    configuration.tx1Config = {.bandwidth = 20, .mixer = 63};
    configuration.tx2Config = {.bandwidth = 20, .mixer = 63};
    // 接收滤波器
    configuration.rxFilters = {.fir = 0, .hbf1 = 0, .hbf2 = 0, .hbf3 = 0, .cic = 0};
    // 发射滤波器
    configuration.txFilters = {.fir = 0, .hbf1 = 2, .hbf2 = 2, .hbf3 = 0, .cic = 0};
    // Rx NCO
    configuration.rxNco = {
        .rxUseBist = false, .rxNCOBypass = true, .rxNCOUpward = true, .rxNCOMaster = true, .rxNCOFreq = 0};
    // Tx NCO
    configuration.txNco = {.txUseBist = true, .txNCOFreq = 1};
    // AGC 注意：mode = 0表示关闭AGC，此时其他的参数可以不配置
    configuration.agc = {.mode = 0};
    configuration.agc.pdt = {.pdtN = 0,.pdtM = 2};
    configuration.agc.lmt = {.count = 15,.threshold1 =  2,.threshold2 =  2,.threshold3 =  2,.threshold4 =  2};
    configuration.agc.dig = {.count = 15,.threshold1 =-10,.threshold2 =-14,.threshold3 =-30,.threshold4 =-40};
    // 校准
    configuration.calib = {.calibRx1 = true,
                           .calibRx2 = true,
                           .calibRx3 = false,
                           .calibTx1 = true,
                           .calibTx2 = true,
                           .calibDC = true,
                           .dcCalibLength = 16384,
                           .f0 = 1.6};

    ref_clock = &configuration.clock;
	/***********************配置参数执行*****************************/
    // 开始配置芯片
    CX9261A::initialChip();  // 最开始需要调用此函数
    CX9261A::initialPowerConfig(configuration);
    using PowerMode = CX9261A::PowerMode;
    // 不需要自定义电源管理时，这部分代码可以省略
    CX9261A::configPowerPins(configuration.powerManagement.shutdownPower, PowerMode::Shutdown);
    CX9261A::configPowerPins(configuration.powerManagement.rxPower, PowerMode::Receive);
    CX9261A::configPowerPins(configuration.powerManagement.txPower, PowerMode::Transmit);
    CX9261A::configPowerPins(configuration.powerManagement.fddPower, PowerMode::Duplex);
    // 配置pll
    CX9261A::configBBPLL(configuration);
    CX9261A::configPllSource(configuration.pllSource);
    CX9261A::configPll1(configuration.pllFreq.pll1Freq, configuration.clock);
    CX9261A::configPll2(configuration.pllFreq.pll2Freq, configuration.clock);
    // 配置Rx通道
    CX9261A::configRxChannel(configuration.rx1Config, CX9261A::RxChannel::Rx1);
    CX9261A::configRxChannel(configuration.rx2Config, CX9261A::RxChannel::Rx2);
    CX9261A::configRxChannel(configuration.rx3Config, CX9261A::RxChannel::Rx3);
    // 配置Tx通道
    using TxChannel = CX9261A::TxChannel;
    CX9261A::configTxChannelFrequency(configuration.pllFreq.pll1Freq, TxChannel::Tx1);
    CX9261A::configTxChannelFrequency(configuration.pllFreq.pll2Freq, TxChannel::Tx2);
    CX9261A::configTxChannel(configuration.tx1Config, TxChannel::Tx1);
    CX9261A::configTxChannel(configuration.tx2Config, TxChannel::Tx2);
    // 配置滤波器
    CX9261A::configRxFilters(configuration.rxFilters);
    CX9261A::configTxFilters(configuration.txFilters);
    // 配置NCO
    CX9261A::configRxNco(configuration.rxNco, configuration.clock.adc);
    const int filters = std::max(configuration.rxFilters.fir, 1) * std::max(configuration.rxFilters.hbf3, 1) *
                        std::max(configuration.rxFilters.hbf2, 1) *
                        std::max(configuration.rxFilters.hbf1, 1) * std::max(configuration.rxFilters.cic, 1);
    CX9261A::configTxNco(configuration.txNco, configuration.clock.adc / filters);
    // 配置AGC
    CX9261A::configAGC(configuration.agc);
    // 切换到休眠模式
    CX9261A::configPowerMode(PowerMode::Sleep);
    CX9261A::pause(1000);
    // 切换到校准模式
    CX9261A::configPowerMode(PowerMode::Calib);
    CX9261A::pause(100);
//    // 锁定BBPLL
//    while (!CX9261A::afcBBPll()) {
//    }
//    // 锁定PLL1 根据本振来源确定是否需要AFC
//    while (!CX9261A::afcPll1()) {
//    }
//    // 锁定PLL2 根据本振来源确定是否需要AFC
//    while (!CX9261A::afcPll2()) {
//    }
//    // 配置接口
//    CX9261A::configInterface(configuration.interface);
//    // 配置FPGA接口相关 此为示例，仅适用于Demo工程，用户应根据实际情况进行配置
//    CX9261A::configFPGA(configuration.interface);
//    // 配置校准
//    CX9261A::configDcCalib(configuration.calib);
//    CX9261A::configADCCalib(configuration.clock.adc);
//    CX9261A::configFlashCalib();
//    CX9261A::configQecCalib(configuration);
//    // 切换到工作模式
//    CX9261A::configPowerMode(configuration.powerManagement.powerMode);

	//消除杂散信号
//	CX9261A::writeSpi(0x75C, 0x83);
//	CX9261A::writeSpi(0x766, 0x83);
/***********************多点校准*****************************/
/*
    //跳频qec校准频点预设，最多256个频点。其中包含初始频点则加载初始频点校准值给三个通道
    const std::vector<double> points = {200,300,400,500,600,700};
    CX9261A::configRxMultiPointsQec(configuration, points);
    CX9261A::setPin(43, 0);
    CX9261A::setPin(43, 1);

    // 加载第1组校准系数（300MHz)
    configuration.pllFreq.pll1Freq = 300;
    CX9261A::configPll1(configuration.pllFreq.pll1Freq, configuration.clock.ref);
    CX9261A::afcPll1();
    CX9261A::pause(10);
    CX9261A::loadRxCalibPredis(1);
    // 加载第2组校准系数（400MHz)
    configuration.pllFreq.pll1Freq = 400;
    CX9261A::configPll1(configuration.pllFreq.pll1Freq, configuration.clock.ref);
    CX9261A::afcPll1();
    CX9261A::pause(10);
    CX9261A::loadRxCalibPredis(2);
    // 加载第5组校准系数（700MHz)
    configuration.pllFreq.pll1Freq = 700;
    CX9261A::configPll1(configuration.pllFreq.pll1Freq, configuration.clock.ref);
    CX9261A::afcPll1();
    CX9261A::pause(10);
    CX9261A::loadRxCalibPredis(5);
    */
/***********************PLL锁定和跳频测试*****************************/
//    for(int i=0;i<20000;i++){
//     PLL_scan(0);
//     PLL_scan(1);
//    }
//    frqhop_flag(1);
//    while(1);
	return 0;
}
