#include "cx9261a_driver.h"

#include <stdlib.h>
#include <stdio.h>
#include "../../../include/error.h"

extern struct cx9261a_dev *cx9261a_inst;

/***************************************************************************//**
 * @brief cx9261a_read
 *******************************************************************************/
int32_t cx9261a_read(struct cx9261a_dev *dev,
			uint16_t reg_addr,
			uint8_t *reg_data)
{
	uint8_t tx_buf[2];
	uint8_t rx_buf[1];
	int32_t ret;

	tx_buf[0] = reg_addr >> 8;
	tx_buf[1] = reg_addr & 0xFF;


	ret = spi_write_and_read_3wire(dev->spi_desc,
			tx_buf, rx_buf, 2, 1);

	*reg_data = rx_buf[0];

	return ret;
}

/***************************************************************************//**
 * @brief cx9261a_write
 *******************************************************************************/
int32_t cx9261a_write(struct cx9261a_dev *dev,
			 uint16_t reg_addr,
			 uint8_t reg_data)
{
	uint8_t buf[3];

	int32_t ret;

	buf[0] = 0x80 | reg_addr >> 8;
	buf[1] = reg_addr & 0xFF;
	buf[2] = reg_data;

	ret = spi_write_and_read_3wire(dev->spi_desc,
				 buf, NULL, 3, 0);
	return ret;
}

/***************************************************************************//**
 * @brief cx9261a_init
 *******************************************************************************/
int32_t cx9261a_init(struct cx9261a_dev **device,
		     const struct cx9261a_init_param *init_param)
{
	int ret = SUCCESS;
	struct cx9261a_dev *dev;

	dev = (struct cx9261a_dev *)malloc(sizeof(*dev));
	if (!dev)
		return FAILURE;

	/* SPI */
	ret = spi_init(&dev->spi_desc, init_param->spi_init);
	ret |= gpio_get(&dev->gpio_desc_nrst, init_param->gpio_nrst);
	ret |= gpio_get(&dev->gpio_desc_nrst, init_param->gpio_txnrx_trx1);
	ret |= gpio_get(&dev->gpio_desc_nrst, init_param->gpio_txnrx_trx2);
	ret |= gpio_get(&dev->gpio_desc_nrst, init_param->gpio_txnrx_rxfb);
	ret |= gpio_get(&dev->gpio_desc_nrst, init_param->gpio_enable_trx1);
	ret |= gpio_get(&dev->gpio_desc_nrst, init_param->gpio_enable_trx2);
	ret |= gpio_get(&dev->gpio_desc_nrst, init_param->gpio_enable_rxfb);
	ret |= gpio_get(&dev->gpio_desc_nrst, init_param->gpio_pl_rst);
	ret |= gpio_get(&dev->gpio_desc_nrst, init_param->gpio_tr_sel);
	ret |= gpio_get(&dev->gpio_desc_nrst, init_param->gpio_tdd_fdd_sel);
	ret |= gpio_get(&dev->gpio_desc_nrst, init_param->gpio_r1t1_r2t2_sel);
	ret |= gpio_get(&dev->gpio_desc_nrst, init_param->gpio_sp_dp_sel);

	gpio_direction_output(dev->gpio_desc_nrst, 0);

	cx9261a_reset(dev);

	*device = dev;

	return ret;
}

/**
 * AD9361 Device Reset
 * @param phy The AD9361 state structure.
 * @return 0 in case of success, negative error code otherwise.
 */
int32_t cx9261a_reset(struct cx9261a_dev *dev)
{
	if (dev->gpio_desc_nrst) {
		gpio_set_value(dev->gpio_desc_nrst, 0);
		mdelay(10);
		gpio_set_value(dev->gpio_desc_nrst, 1);
		mdelay(10);
		return 0;
	}
	return 0;
}


namespace CX9261A {

void writeSpi(const int address, const int value) {
	cx9261a_write(cx9261a_inst, address, value);
}

int readSpi(const int address) {
	uint8_t rx_data;
	cx9261a_read(cx9261a_inst,address,&rx_data);
	return rx_data;
}

void pause(const double ms) {
	mdelay(ms);
}

void setPin(const int pin, const int value) {
//	GpioSetPinDir(pin,GPIO_DIR_OUTPUT);
//	GpioWritePin(pin,value);
}

void initialChip()
{
    writeSpi(0x000, 0x02);
    writeSpi(0x773, 0x53);
    writeSpi(0x774, 0x86);
    writeSpi(0x781, 0x6F);
    initialBBPLL();
    initialPLL1();
    initialPLL2();
    initialPLL3();
    initialPLL4();
    initialPLL5();
    initialRxChannel(RxChannel::Rx1);
    initialRxChannel(RxChannel::Rx2);
    initialRxChannel(RxChannel::Rx3);
    initialTxChannel(TxChannel::Tx1);
    initialTxChannel(TxChannel::Tx2);
}

void initialBBPLL()
{
    writeSpi(0x70B, 0x0E);
    writeSpi(0x727, 0x0E);
    writeSpi(0x743, 0x0E);
}

void initialPLL1()
{
    writeSpi(0x624, 0x11);
    writeSpi(0x625, 0x11);
    writeSpi(0x61E, 0x30);
    writeSpi(0x61F, 0x08);
    writeSpi(0x621, 0x4D);//根据参考频率做调整，以调节AFC所需时间
    writeSpi(0x622, 0x3F);
    writeSpi(0x627, 0x30);
//	writeSpi(0x621, 0x49);
//	writeSpi(0x622, 0x30);
//    writeSpi(0x627, 0x33);
}

void initialPLL2()
{
    writeSpi(0x646, 0x11);
    writeSpi(0x647, 0x11);
    writeSpi(0x640, 0x30);
    writeSpi(0x641, 0x08);
    writeSpi(0x643, 0x4D);
    writeSpi(0x644, 0x3F);
    writeSpi(0x649, 0x30);
//	writeSpi(0x643, 0x49);
//	writeSpi(0x644, 0x30);
//    writeSpi(0x649, 0x33);
}

void initialPLL3()
{
    writeSpi(0x668, 0x11);
    writeSpi(0x669, 0x11);
    writeSpi(0x662, 0x30);
    writeSpi(0x663, 0x08);
    writeSpi(0x665, 0x4D);
    writeSpi(0x666, 0x19);
    writeSpi(0x66B, 0x10);
}

void initialPLL4()
{
    writeSpi(0x68A, 0x11);
    writeSpi(0x68B, 0x11);
    writeSpi(0x684, 0x30);
    writeSpi(0x685, 0x08);
    writeSpi(0x687, 0x4D);
    writeSpi(0x688, 0x19);
    writeSpi(0x68D, 0x10);
}

void initialPLL5()
{
    writeSpi(0x6AC, 0x11);
    writeSpi(0x6AD, 0x11);
    writeSpi(0x6A6, 0x30);
    writeSpi(0x6A7, 0x08);
    writeSpi(0x6A9, 0x4D);
    writeSpi(0x6AA, 0x19);
    writeSpi(0x6AF, 0x10);
}

void configBBPLL(const CX9261AConfiguration& config)
{
    const auto& clock = config.clock;
    configRefDoubler(clock.refDoubler, clock.ref);
    // fclk div
    const int fclkDiv = clock.adc > 64 ? 4 : 5;
    Register r0C0{ 0x50 };
    r0C0[1] = fclkDiv != 5;
    writeSpi(0x0C0, r0C0);
    writeSpi(0x0C1, r0C0);
    writeSpi(0x0C2, r0C0);
    // clock
    double bblo = clock.adc * fclkDiv * 4;
    int bbloDiv = 1;
    while (bblo <= 1350) {
        bblo *= 2;
        bbloDiv *= 2;
    }
    Register r602;
    r602.replace(1, 0, std::log2(bbloDiv));
    r602[5] = fclkDiv == 5;
    // ref div
    Register r601{ 0x0F };
    r601.replace(1, 0, clock.refDiv == 2 ? 0b00 : clock.refDiv == 4 ? 0b01 : clock.refDiv == 8 ? 0b10 : 0b11);
    writeSpi(0x601, r601);
    // nf
    const auto nf = bblo * clock.refDiv / (clock.ref * (clock.refDoubler ? 2 : 1));
    int n = floor(nf);
    const auto f = nf - n;
    r602[6] = clock.bbUseIntDiv;
    writeSpi(0x602, r602);
    // 整数模式
    if (clock.bbUseIntDiv)
        n = round(2.0 * n / bbloDiv + 1);
    const auto fBin = frac2bin<25>(f);
    Register r60D{ 0x0C };
    r60D[0] = fBin[0] == '1';
    r60D[4] = clock.bbUseIntDiv;
    std::size_t pos;
    const Register r60E = std::stoi(fBin.substr(1, 8), &pos, 2);
    const Register r60F = std::stoi(fBin.substr(9, 8), &pos, 2);
    const Register r610 = std::stoi(fBin.substr(17, 8), &pos, 2);
    writeSpi(0x60D, r60D);
    writeSpi(0x60E, r60E);
    writeSpi(0x60F, r60F);
    writeSpi(0x610, r610);
    writeSpi(0x611, n);
    // Dither
    Register r612;
    r612[4] = clock.bbUseIntDiv;
    writeSpi(0x612, r612);
    // ADC
    const auto adcClock = clock.adc * fclkDiv * 4;
    Register r70E{ 0x6B };
    Register r70F{ 0xE0 };
    double adjAdc;
    if (adcClock < 450) {
        r70E.replace(6, 5, 0b00);
        r70E.replace(4, 0, 0b00010);
        r70F.replace(7, 6, 0b00);
        adjAdc = 300;
    } else if (adcClock < 750) {
        r70E.replace(6, 5, 0b01);
        r70E.replace(4, 0, 0b00101);
        r70F.replace(7, 6, 0b01);
        adjAdc = 600;
    } else if (adcClock < 1050) {
        r70E.replace(6, 5, 0b10);
        r70E.replace(4, 0, 0b01000);
        r70F.replace(7, 6, 0b10);
        adjAdc = 900;
    } else {
        r70E.replace(6, 5, 0b11);
        r70E.replace(4, 0, 0b01011);
        r70F.replace(7, 6, 0b11);
        adjAdc = 1200;
    }
    writeSpi(0x70E, r70E);
    writeSpi(0x72A, r70E);
    writeSpi(0x746, r70E);
    writeSpi(0x70F, r70F);
    writeSpi(0x72B, r70F);
    writeSpi(0x747, r70F);
    auto c = 8600 * adjAdc / adcClock;
    c = (c - 3000) / 80;
    const Register r70D = round(c);
    writeSpi(0x70D, r70D);
    writeSpi(0x729, r70D);
    writeSpi(0x745, r70D);
    // 时序配置
    if (config.interface.ioMode != IOMode::CMOS) {
        writeSpi(0x782, 0x00);
        writeSpi(0x783, 0x00);
    } else if (clock.adc <= 45) {
        writeSpi(0x782, 0x01);
        writeSpi(0x783, 0x01);
    } else {
        writeSpi(0x782, 0x76);
        writeSpi(0x783, 0x76);
    }
    writeSpi(0x784, clock.adc <= 35 ? 0x01 : 0x06);
}

bool afcBBPll()
{
    writeSpi(0x600, 0x00);
    writeSpi(0x600, 0x11);
    pause(delay);
    return readSpi(0x615) & 0b00100000;
}

void configPllSource(const PllSource& pllSource)
{
    // PLL Source
    Register r77D;
    r77D[7] = rxSrcMap.at({ pllSource.rx1Source, pllSource.rx2Source })[6];
    r77D[6] = rxSrcMap.at({ pllSource.rx1Source, pllSource.rx2Source })[5];
    r77D[5] = txSrcMap.at({ pllSource.tx1Source, pllSource.tx2Source })[6];
    r77D[4] = txSrcMap.at({ pllSource.tx1Source, pllSource.tx2Source })[5];
    r77D[3] = !pllSource.txUseExt && txSrcMap.at({ pllSource.tx1Source, pllSource.tx2Source })[10];
    r77D[2] = !pllSource.txUseExt && txSrcMap.at({ pllSource.tx1Source, pllSource.tx2Source })[9];
    r77D[1] = txSrcMap.at({ pllSource.tx1Source, pllSource.tx2Source })[8];
    r77D[0] = txSrcMap.at({ pllSource.tx1Source, pllSource.tx2Source })[7];

    // MUX
    Register r6C3;
    r6C3[3] = !pllSource.rxUseExt && pllSource.rx1Source == LoSource::Off;
    r6C3[2] = !pllSource.rxUseExt && pllSource.rx2Source == LoSource::Off;
    r6C3[1] = !pllSource.txUseExt && pllSource.tx1Source == LoSource::Off;
    r6C3[0] = !pllSource.txUseExt && pllSource.tx2Source == LoSource::Off;

    // External
    Register r775{ 0x24 };
    r775[7] = pllSource.rxUseExt;
    r775[6] = pllSource.txUseExt;

    writeSpi(0x77D, r77D);
    writeSpi(0x775, r775);
    writeSpi(0x6C3, r6C3);
}

std::vector<int> configPllImpl(const double lo, const double ref)
{
    auto vco = lo;
    auto div = 1;
    while (vco <= 6700) {
        vco *= 2;
        div *= 2;
    }
    int row{};
    if (ref >= 28 && ref < 40)
        row = 0;
    if (ref >= 40 && ref < 60)
        row = 1;
    if (ref >= 60 && ref < 90)
        row = 2;
    if (ref >= 90 && ref < 110)
        row = 3;
    if (ref >= 110 && ref < 140)
        row = 4;
    if (ref >= 140 && ref < 180)
        row = 5;
    if (ref >= 180 && ref <= 240)
        row = 6;
    int column{};
    if (vco < 8400)
        column = 0;
    if (vco >= 8400 && vco < 10150)
        column = 1;
    if (vco >= 10150 && vco < 12000)
        column = 2;
    if (vco >= 12000)
        column = 3;

    std::vector<int> ret(11);
    const Register core = vco > 10150 ? 0x91 : 0x81;
    ret[0] = core;
    const Register cp{ coreTable[row][column][0] };
    ret[7] = cp;
    const Register c1r3{ coreTable[row][column][1] };
    ret[8] = c1r3;
    const Register r1{ coreTable[row][column][2] };
    ret[9] = r1;
    const Register outputDiv = [div]() {
        switch (div) {
        case 2:
            return 0x07;
        case 4:
            return 0x27;
        case 8:
            return 0x37;
        case 16:
            return 0x36;
        case 32:
            return 0x35;
        case 64:
            return 0x34;
        case 128:
            return 0x33;
        case 256:
            return 0x32;
        default:
            return 0;
        }
    }();
    ret[1] = outputDiv;
    const auto nf = vco / ref;
    const auto n = floor(nf);
    const auto f = nf - n;
    const Register nHigh = n >= 256;
    ret[2] = nHigh;
    const Register nLow = n & 0xFF;
    ret[3] = nLow;
    const int fint = static_cast<int>(std::round(std::pow(2, 24) * f));
    ret[4] = fint >> 16 & 0xFF;
    ret[5] = fint >> 8 & 0xFF;
    ret[6] = fint & 0xFF;
    const Register dither = f < 1e-10 ? 0x00 : 0x0B;
    ret[10] = dither;
    return ret;
}

void configRISCV(const bool on)
{
    if (on) {
        writeSpi(0x071, 0x00);
        writeSpi(0x071, 0x29);
        writeSpi(0x236, 0x0F);
        writeSpi(0x20A, 0x01);
        writeSpi(0x071, 0x26);
    } else {
        writeSpi(0x071, 0x00);
    }
}

void rxCalibImpl(const CX9261AConfiguration& config, const RxChannel chan)
{
    writeSpi(0x000, chan == RxChannel::Rx1 ? 0x12 : chan == RxChannel::Rx2 ? 0x22 : 0x32);
    writeSpi(0x77E, chan == RxChannel::Rx1 ? 0x50 : chan == RxChannel::Rx2 ? 0x0A : 0x03);
    writeSpi(0x11B, 0x01);
    writeSpi(0x11E, 0x01);
    configTxNcoFreq(0, config.clock.adc);
    writeSpi(0x161, 0x00);
    writeSpi(0x162, 0x00);
    writeSpi(0x162, 0x01);
    writeSpi(0x161, 0x01);
    writeSpi(chan == RxChannel::Rx1 ? 0x706 : chan == RxChannel::Rx2 ? 0x722 : 0x73E, 0x6D);
    writeSpi(0x6C3, 0x00);
//    writeSpi(0x75F, 0x7D);
    writeSpi(0x11F, 0x73);
    writeSpi(0x153, 0x00);
    writeSpi(chan == RxChannel::Rx2 ? 0x724 : 0x708, 0x24);
    writeSpi(0x196, 0x01);
    const auto qecAddr = chan == RxChannel::Rx1 ? 0x02A : chan == RxChannel::Rx2 ? 0x02B : 0x02C;
    writeSpi(qecAddr, chan == RxChannel::Rx3 ? 0x11 : 0x12);
    waitRxTSTFinished();
    writeSpi(qecAddr, 0x00);
    writeSpi(0x196, 0x11);
    const auto r13D = readSpi(0x13D);
    const auto r13E = readSpi(0x13E);
    const auto B = r13D * std::pow(2, 8) + r13E;
    const auto B_s = B >= 32768 ? B - 65536 : B;
    const auto B_abs = static_cast<int>(std::abs(B_s));
    const auto B_delay = (B_abs & 0b0111111110000000) >> 7;
    if (B_s > 0) {
        writeSpi(0x199, B_delay >> 8);
        writeSpi(0x19A, B_delay & 0xFF);
        writeSpi(0x19B, 0);
        writeSpi(0x19C, 0);
    } else {
        writeSpi(0x199, 0);
        writeSpi(0x19A, 0);
        writeSpi(0x19B, B_delay >> 8);
        writeSpi(0x19C, B_delay & 0xFF);
    }
    writeSpi(0x196, 0x10);
    writeSpi(0x153, 0x00);
    writeSpi(qecAddr, chan == RxChannel::Rx3 ? 0x11 : 0x12);
    waitRxTSTFinished();
    writeSpi(qecAddr, 0x00);
    writeSpi(0x77E, 0x00);
    writeSpi(0x000, 0x02);
}

bool waitRxTSTFinished()
{
    int cnt = 0;
    while (cnt <= 10) {
        pause(qecDelay);
        if ((readSpi(0x14D) & 16) == 16)
            return true;
        cnt++;
    }
    return false;
}

void rxTSTCalib(const CX9261AConfiguration& config, const RxChannel chan)
{
    writeSpi(0x02E, 0x03);
    Register r03F = readSpi(0x03F);
    r03F[2] = config.pllSource.rx3Source != LoSource::Pll5;
    r03F[1] = config.pllSource.rx3Source != LoSource::Pll5;
    r03F[0] = 0;
    Register r040 = readSpi(0x040);
    r040[7] = 0;
    r040[6] = 1;
    r040[5] = 1;
    r040[4] = !(config.pllSource.rx1Source == LoSource::Pll2 || config.pllSource.rx2Source == LoSource::Pll2);
    r040[3] = !(config.pllSource.rx1Source == LoSource::Pll2 || config.pllSource.rx2Source == LoSource::Pll2);
    r040[2] = !(config.pllSource.rx1Source == LoSource::Pll1 || config.pllSource.rx2Source == LoSource::Pll1);
    r040[1] = !(config.pllSource.rx1Source == LoSource::Pll1 || config.pllSource.rx2Source == LoSource::Pll1);
    writeSpi(0x03F, r03F);
    writeSpi(0x040, r040);
    auto pllSource = config.pllSource;
    if (chan == RxChannel::Rx1) {
        pllSource.rx2Source = LoSource::Off;
        pllSource.tx1Source = LoSource::Pll4;
        pllSource.tx2Source = LoSource::Off;
        pllSource.txUseExt = false;
        configPllSource(pllSource);
        const auto rx1Freq = config.pllSource.rxUseExt         ? config.pllFreq.rxExtFreq
                : config.pllSource.rx1Source == LoSource::Pll1 ? config.pllFreq.pll1Freq
                                                               : config.pllFreq.pll2Freq;
        if (config.pllSource.rx1Source == LoSource::Pll1)
            afcPll1();
        if (config.pllSource.rx1Source == LoSource::Pll2)
            afcPll2();
        configPll4((rx1Freq - config.calib.f0) / 3, config.clock);
    }
    if (chan == RxChannel::Rx2) {
        pllSource.rx1Source = LoSource::Off;
        pllSource.tx1Source = LoSource::Off;
        pllSource.tx2Source = LoSource::Pll4;
        pllSource.txUseExt = false;
        configPllSource(pllSource);
        const auto rx2Freq = config.pllSource.rxUseExt         ? config.pllFreq.rxExtFreq
                : config.pllSource.rx2Source == LoSource::Pll1 ? config.pllFreq.pll1Freq
                                                               : config.pllFreq.pll2Freq;
        if (config.pllSource.rx2Source == LoSource::Pll1)
            afcPll1();
        if (config.pllSource.rx2Source == LoSource::Pll2)
            afcPll2();
        configPll4((rx2Freq - config.calib.f0) / 3, config.clock);
    }
    if (chan == RxChannel::Rx3) {
        pllSource.tx1Source = LoSource::Off;
        pllSource.tx2Source = LoSource::Pll4;
        pllSource.txUseExt = false;
        configPllSource(pllSource);
        afcPll5();
        configPll4((config.pllFreq.pll5Freq - config.calib.f0) / 3, config.clock);
    }
    afcPll4();
    //    rxTSTCalibImpl(chan);
    rxCalibImpl(config, chan);
}

void rxFFTCalib(const double lo, const double fs, const int firLength, const CX9261AConfiguration& config,
                RxChannel chan)
{
    writeSpi(0x000, chan == RxChannel::Rx1 ? 0x12 : 0x22);
    writeSpi(0x128, 0x00);
    writeSpi(0x11B, 0x01);
    writeSpi(0x11E, 0x01);
    configTxNcoFreq(0, fs);
    writeSpi(0x161, 0x00);
    writeSpi(0x162, 0x00);
    writeSpi(0x162, 0x01);
    writeSpi(0x161, 0x01);
    writeSpi(0x000, chan == RxChannel::Rx1 ? 0x12 : chan == RxChannel::Rx2 ? 0x22 : 0x32);
    writeSpi(0x102, 0x03);
    writeSpi(0x102, 0xFF);
    writeSpi(0x15C, 0x00);
    writeSpi(0x160, 0x01);
    writeSpi(0x77E, chan == RxChannel::Rx1 ? 0x50 : chan == RxChannel::Rx2 ? 0x0A : 0x03);
    writeSpi(0x09B, 0x01); // TXPLL4
    writeSpi(0x09D, firLength);
    writeSpi(0x096, (round(lo) >> 8) & 0xFF);
    writeSpi(0x097, round(lo) & 0xFF);
    const double ref = config.clock.ref * (config.clock.refDoubler ? 2 : 1);
    writeSpi(0x098, (round(ref * 10) >> 8) & 0xFF);
    writeSpi(0x099, round(ref * 10) & 0xFF);
    writeSpi(0x09E, (round(fs * 100) >> 8) & 0xFF);
    writeSpi(0x09F, round(fs * 100) & 0xFF);
    writeSpi(0x09C, static_cast<int>(chan));
    pause(qecDelay);
    while (true) {
        if (readSpi(0x0B3) == 5)
            break;
        pause(qecDelay);
    }
    writeSpi(0x09C, 0x00);
    writeSpi(0x15C, 0x01);
    writeSpi(0x77E, 0x00);
    configPllSource(config.pllSource);
}

void txCalib(const CX9261AConfiguration& config)
{
    Register r03F = readSpi(0x03F);
    r03F[2] = 1;
    r03F[1] = 1;
    r03F[0] = !(config.pllSource.tx1Source == LoSource::Pll4 || config.pllSource.tx2Source == LoSource::Pll4);
    Register r040 = readSpi(0x040);
    r040[7] = !(config.pllSource.tx1Source == LoSource::Pll4 || config.pllSource.tx2Source == LoSource::Pll4);
    r040[6] = !(config.pllSource.tx1Source == LoSource::Pll3 || config.pllSource.tx2Source == LoSource::Pll3);
    r040[5] = !(config.pllSource.tx1Source == LoSource::Pll3 || config.pllSource.tx2Source == LoSource::Pll3);
    r040[4] = !(config.pllSource.tx1Source == LoSource::Pll2 || config.pllSource.tx2Source == LoSource::Pll2);
    r040[3] = !(config.pllSource.tx1Source == LoSource::Pll2 || config.pllSource.tx2Source == LoSource::Pll2);
    r040[2] = !(config.pllSource.tx1Source == LoSource::Pll1 || config.pllSource.tx2Source == LoSource::Pll1);
    r040[1] = !(config.pllSource.tx1Source == LoSource::Pll1 || config.pllSource.tx2Source == LoSource::Pll1);
    writeSpi(0x03F, r03F);
    writeSpi(0x040, r040);
    if (config.pllSource.tx1Source == LoSource::Pll4 || config.pllSource.tx2Source == LoSource::Pll4)
        afcPll4();
    if (config.pllSource.tx1Source == LoSource::Pll3 || config.pllSource.tx2Source == LoSource::Pll3)
        afcPll3();
    if (config.pllSource.tx1Source == LoSource::Pll2 || config.pllSource.tx2Source == LoSource::Pll2)
        afcPll2();
    if (config.pllSource.tx1Source == LoSource::Pll1 || config.pllSource.tx2Source == LoSource::Pll1)
        afcPll1();
    txBisectionQecCalib(config.calib.f0, config.clock.adc);
    txBisectionDcCalib(config.calib.f0, config.clock.adc);
}

void txTSTCalib(const Clock& clock, const double lo, const double fs, const double f0, const TxChannel chan)
{
    writeSpi(chan == TxChannel::Tx1 ? 0x763 : 0x76D, 0x04);
    writeSpi(0x109, 0x00);
    writeSpi(0x120, 0x10);
    writeSpi(0x122, 0x03);
    writeSpi(0x124, 0xFF);
    writeSpi(0x11B, 0x01);
    writeSpi(0x128, 0x11);
    configPll4(lo + 200, clock);
    configTxNcoFreq(f0, fs * 4);
    writeSpi(0x161, 0x00);
    writeSpi(0x162, 0x00);
    writeSpi(0x162, 0x01);
    writeSpi(0x161, 0x01);
    writeSpi(0x11F, 0x73);
    writeSpi(0x121, 0x00);
    writeSpi(0x14E, 0x00);
    writeSpi(0x126, 0x03);
    writeSpi(0x77E, chan == TxChannel::Tx1 ? 0x40 : 0x08);
    writeSpi(chan == TxChannel::Tx1 ? 0x02A : 0x02B, 0x11);
    pause(qecDelay);
    while (true) {
        if (readSpi(0x14D) == 0x30)
            break;
        pause(qecDelay);
    }
    writeSpi(0x77E, 0x00);
    writeSpi(0x128, 0x00);
}

void txTSTPhaseDelay(const Clock& clock, const double lo, const double fs, const double f0, const TxChannel chan)
{
    writeSpi(0x000, chan == TxChannel::Tx1 ? 0x12 : 0x22);
    writeSpi(0x02E, 0x03);
    writeSpi(0x109, 0x00);
    writeSpi(0x120, 0x10);
    writeSpi(0x122, 0x03);
    writeSpi(0x124, 0xFF);
    writeSpi(0x11B, 0x01);
    writeSpi(0x128, 0x11);
    configPll4(lo + 200, clock);
    configTxNcoFreq(f0, fs * 4);
    writeSpi(0x161, 0x00);
    writeSpi(0x162, 0x00);
    writeSpi(0x162, 0x01);
    writeSpi(0x161, 0x01);
    writeSpi(0x11F, 0x73);
    writeSpi(0x121, 0x80);
    writeSpi(0x126, 0x03);
    writeSpi(0x77E, chan == TxChannel::Tx1 ? 0x40 : 0x08);
    writeSpi(0x186, 0x10);
    writeSpi(0x189, 0x00);
    writeSpi(0x18A, 0x00);
    writeSpi(0x18B, 0x00);
    writeSpi(0x18C, 0x00);
    writeSpi(chan == TxChannel::Tx1 ? 0x763 : 0x76D, 0x14);
    writeSpi(0x095, 0x00);
    writeSpi(0x096, (round(lo) >> 8) & 0xFF);
    writeSpi(0x097, round(lo) & 0xFF);
    writeSpi(0x09C, chan == TxChannel::Tx1 ? 6 : 7);
    pause(qecDelay);
    while (true) {
        if (readSpi(0x0B3) == 7)
            break;
        pause(qecDelay);
    }
    writeSpi(0x09C, 0x00);
    writeSpi(0x77E, 0x00);
    writeSpi(0x128, 0x00);
}

void txBisectionQecCalib(const double f0, const double fs)
{
    writeSpi(0x02E, 0x03);
    writeSpi(0x128, 0x11);
    writeSpi(0x11E, 0x01);
    writeSpi(0x77E, 0x24);
    writeSpi(0x11F, 0x01);
    writeSpi(0x121, 0x02);
    writeSpi(0x11B, 0x01);
    writeSpi(0x161, 0x01);
    writeSpi(0x162, 0x01);
    writeSpi(0x163, 0x00);
    configTxNcoFreq(f0, fs * 4);
    writeSpi(0xA2D, 0x02);
    writeSpi(0xA07, 0x00);
    writeSpi(0xA08, 0x0F);
    writeSpi(0xA1C, 0x01);
    configRxNcoFreq(f0 * 2, fs);
    writeSpi(0x102, 0x0F);
    writeSpi(0x102, 0xFF);
    writeSpi(0x186, 0x00);
    writeSpi(0x186, 0x01);
    writeSpi(0x763, 0x34);
    writeSpi(0x76D, 0x34);
    writeSpi(0x101, 0xEF);
    writeSpi(0x101, 0xFF);
    writeSpi(0x800, 0x00);
    writeSpi(0x81A, 0xF7);
    writeSpi(0x81B, 0x34);
    writeSpi(0x81C, 0x33);
    writeSpi(0x81D, 0x12);
    writeSpi(0x81E, 0x00);
    writeSpi(0x81F, 0xFF);
    writeSpi(0x820, 0x00);
    writeSpi(0x821, 0xFF);
    writeSpi(0x800, 0x80);
    pause(qecDelay);
    writeSpi(0x800, 0x81);
    pause(qecDelay);
    writeSpi(0x77E, 0x00);
}

void txBisectionDcCalib(const double f0, const double fs)
{
    writeSpi(0x77E, 0x24);
    writeSpi(0x11F, 0x03);
    writeSpi(0x121, 0x02);
    writeSpi(0x11B, 0x01);
    writeSpi(0x11E, 0x01);
    writeSpi(0x161, 0x01);
    writeSpi(0x162, 0x01);
    configTxNcoFreq(f0, fs * 4);
    writeSpi(0xA2D, 0x02);
    writeSpi(0xA07, 0x00);
    writeSpi(0xA08, 0x0F);
    writeSpi(0xA1C, 0x01);
    configRxNcoFreq(f0, fs);
    writeSpi(0x81A, 0xF7);
    writeSpi(0x81B, 0x44);
    writeSpi(0x81C, 0x33);
    writeSpi(0x81D, 0x14);
    writeSpi(0x800, 0x80);
    writeSpi(0x800, 0x82);
    pause(qecDelay);
    writeSpi(0x77E, 0x00);
}

std::map<int, int> beforeQecState()
{
    std::map<int, int> state;
    // SPI模式
    state[0x000] = 0x02;
    // 电源模式
    state[0x02E] = readSpi(0x02E);
    // DC Tracking
    state[0x109] = readSpi(0x109);
    state[0x10A] = readSpi(0x10A);
    state[0x11F] = readSpi(0x11F);
    // RX NCO
    state[0xA07] = readSpi(0xA07);
    state[0xA08] = readSpi(0xA08);
    state[0xA16] = readSpi(0xA16);
    state[0xA17] = readSpi(0xA17);
    state[0xA18] = readSpi(0xA18);
    state[0xA19] = readSpi(0xA19);
    state[0xA1A] = readSpi(0xA1A);
    state[0xA1B] = readSpi(0xA1B);
    // TX NCO
    state[0x11B] = readSpi(0x11B);
    state[0x11E] = readSpi(0x11E);
    state[0x128] = readSpi(0x128);
    state[0x161] = readSpi(0x161);
    state[0x162] = readSpi(0x162);
    state[0x164] = readSpi(0x164);
    state[0x165] = readSpi(0x165);
    state[0x166] = readSpi(0x166);
    state[0x167] = readSpi(0x167);
    state[0x168] = readSpi(0x168);
    state[0x169] = readSpi(0x169);
    // PLL Source
    state[0x775] = readSpi(0x775);
    state[0x77D] = readSpi(0x77D);
    state[0x6C3] = readSpi(0x6C3);

    return state;
}

void restoreQecState(const std::map<int, int>& state)
{
    for (auto i : state) {
        writeSpi(i.first, i.second);
    }
}

void configQecCalib(const CX9261AConfiguration& config)
{
    const auto regsState = beforeQecState();
    if (config.calib.calibRx1) {
        rxTSTCalib(config, RxChannel::Rx1);
    }
    if (config.calib.calibRx2) {
        rxTSTCalib(config, RxChannel::Rx2);
    }
    if (config.calib.calibRx3) {
        rxTSTCalib(config, RxChannel::Rx3);
    }
    if (config.calib.calibRx1 || config.calib.calibRx2 || config.calib.calibRx3) {
        restoreQecState(regsState);
        configPll4(config.pllFreq.pll4Freq, config.clock);
        if ((config.pllSource.tx1Source == LoSource::Pll4 || config.pllSource.tx2Source == LoSource::Pll4)
            && config.interface.workMode != WorkMode::Rx)
            afcPll4();
    }
    if (config.calib.calibTx1 || config.calib.calibTx2) {
        txCalib(config);
        restoreQecState(regsState);
    }
}

void configRxMultiPointsQec(const CX9261AConfiguration& config, const std::vector<double>& points)
{
    configRISCV(true);
    auto mutConfig = config;
    const auto regsState = beforeQecState();
    configPowerMode(PowerMode::Calib);
    for (auto i = 0; i < points.size(); ++i) {
        if (config.pllSource.rx1Source == LoSource::Pll1) {
            mutConfig.pllFreq.pll1Freq = points[i];
            configPll1(mutConfig.pllFreq.pll1Freq, mutConfig.clock);
            afcPll1();
        }
        if (config.pllSource.rx1Source == LoSource::Pll2) {
            mutConfig.pllFreq.pll2Freq = points[i];
            configPll2(mutConfig.pllFreq.pll2Freq, mutConfig.clock);
            afcPll2();
        }
        if (config.calib.calibRx1) {
            rxTSTCalib(mutConfig, RxChannel::Rx1);
            const auto predis = readRxCalibPredis(RxChannel::Rx1);
            saveRxCalibPredis(i, RxChannel::Rx1, predis);
        }
        if (config.calib.calibRx2) {
            rxTSTCalib(mutConfig, RxChannel::Rx2);
            const auto predis = readRxCalibPredis(RxChannel::Rx2);
            saveRxCalibPredis(i, RxChannel::Rx2, predis);
        }
        if (config.calib.calibRx3) {
            rxTSTCalib(mutConfig, RxChannel::Rx3);
            const auto predis = readRxCalibPredis(RxChannel::Rx3);
            saveRxCalibPredis(i, RxChannel::Rx3, predis);
        }
    }
    restoreQecState(regsState);
    configPll4(config.pllFreq.pll4Freq, config.clock);
    if ((config.pllSource.tx1Source == LoSource::Pll4 || config.pllSource.tx2Source == LoSource::Pll4)
        && config.interface.workMode != WorkMode::Rx)
        afcPll4();
    // 切换到初始化频点
    if (config.pllSource.rx1Source == LoSource::Pll1 || config.pllSource.rx2Source == LoSource::Pll1) {
        configPll1(config.pllFreq.pll1Freq, config.clock);
        afcPll1();
    }
    if (config.pllSource.rx1Source == LoSource::Pll2 || config.pllSource.rx2Source == LoSource::Pll2) {
        configPll2(config.pllFreq.pll2Freq, config.clock);
        afcPll2();
    }
    const auto rx1Freq = config.pllSource.rxUseExt         ? config.pllFreq.rxExtFreq
            : config.pllSource.rx1Source == LoSource::Pll1 ? config.pllFreq.pll1Freq
                                                           : config.pllFreq.pll2Freq;
    auto it = std::find(points.begin(), points.end(), rx1Freq);
    if (it != points.end()) {
        loadRxCalibPredis(it - points.begin());
    }
    writeSpi(0x121, 0x20);
}

void configPll1(const double lo, const Clock& clock)
{
    const auto pllMap = configPllImpl(lo, clock.ref * (clock.refDoubler ? 2 : 1));
    writeSpi(0x620, pllMap[0]);
    writeSpi(0x61D, pllMap[1]);
    writeSpi(0xB06, pllMap[2]);
    writeSpi(0xB07, pllMap[3]);
    writeSpi(0xB08, pllMap[4]);
    writeSpi(0xB09, pllMap[5]);
    writeSpi(0xB0A, pllMap[6]);
    writeSpi(0x61A, pllMap[7]);
    writeSpi(0x61B, pllMap[8]);
    writeSpi(0x61C, pllMap[9]);
    writeSpi(0x62A, pllMap[10]);
}

void configPll2(const double lo, const Clock& clock)
{
    const auto pllMap = configPllImpl(lo, clock.ref * (clock.refDoubler ? 2 : 1));
    writeSpi(0x642, pllMap[0]);
    writeSpi(0x63F, pllMap[1]);
    writeSpi(0xB14, pllMap[2]);
    writeSpi(0xB15, pllMap[3]);
    writeSpi(0xB16, pllMap[4]);
    writeSpi(0xB17, pllMap[5]);
    writeSpi(0xB18, pllMap[6]);
    writeSpi(0x63C, pllMap[7]);
    writeSpi(0x63D, pllMap[8]);
    writeSpi(0x63E, pllMap[9]);
    writeSpi(0x64C, pllMap[10]);
}

void configPll3(const double lo, const Clock& clock)
{
    const auto pllMap = configPllImpl(lo, clock.ref * (clock.refDoubler ? 2 : 1));
    writeSpi(0x664, pllMap[0]);
    writeSpi(0x661, pllMap[1]);
    writeSpi(0xB22, pllMap[2]);
    writeSpi(0xB23, pllMap[3]);
    writeSpi(0xB24, pllMap[4]);
    writeSpi(0xB25, pllMap[5]);
    writeSpi(0xB26, pllMap[6]);
    writeSpi(0x65E, pllMap[7]);
    writeSpi(0x65F, pllMap[8]);
    writeSpi(0x660, pllMap[9]);
    writeSpi(0x66E, pllMap[10]);
}

void configPll4(const double lo, const Clock& clock)
{
    const auto pllMap = configPllImpl(lo, clock.ref * (clock.refDoubler ? 2 : 1));
    writeSpi(0x686, pllMap[0]);
    writeSpi(0x683, pllMap[1]);
    writeSpi(0xB30, pllMap[2]);
    writeSpi(0xB31, pllMap[3]);
    writeSpi(0xB32, pllMap[4]);
    writeSpi(0xB33, pllMap[5]);
    writeSpi(0xB34, pllMap[6]);
    writeSpi(0x680, pllMap[7]);
    writeSpi(0x681, pllMap[8]);
    writeSpi(0x682, pllMap[9]);
    writeSpi(0x690, pllMap[10]);
}

void configPll5(const double lo, const Clock& clock)
{
    const auto pllMap = configPllImpl(lo, clock.ref * (clock.refDoubler ? 2 : 1));
    writeSpi(0x6A8, pllMap[0]);
    writeSpi(0x6A5, pllMap[1]);
    writeSpi(0xB3E, pllMap[2]);
    writeSpi(0xB3F, pllMap[3]);
    writeSpi(0xB40, pllMap[4]);
    writeSpi(0xB41, pllMap[5]);
    writeSpi(0xB42, pllMap[6]);
    writeSpi(0x6A2, pllMap[7]);
    writeSpi(0x6A3, pllMap[8]);
    writeSpi(0x6A4, pllMap[9]);
    writeSpi(0x6B2, pllMap[10]);
}

bool afcPll1()
{
    Register r61D = readSpi(0x61D);
    const auto saved = r61D;
    r61D.replace(5, 4, 0b10);
    writeSpi(0x61D, r61D);
    writeSpi(0x617, 0x00);
    writeSpi(0x617, 0x03);
    pause(delay_afc);
    writeSpi(0x61D, saved);
    const auto lock = readSpi(0x635);
//    const auto lock1 = readSpi(0x635);
//    const auto lock2 = readSpi(0x635);
//    const auto lock3 = readSpi(0x635);
//    return 0x10 & lock & lock1 & lock2 & lock3 ;
    return 0x10 & lock  ;
}

bool afcPll2()
{
    Register r63F = readSpi(0x63F);
    const auto saved = r63F;
    r63F.replace(5, 4, 0b10);
    writeSpi(0x63F, r63F);
    writeSpi(0x639, 0x00);
    writeSpi(0x639, 0x03);
    pause(delay_afc);
    writeSpi(0x63F, saved);
    const auto lock = readSpi(0x657);
//    const auto lock1 = readSpi(0x657);
//    const auto lock2 = readSpi(0x657);
//    const auto lock3 = readSpi(0x657);
//    return 0x10 & lock & lock1 & lock2 & lock3 ;
    return 0x10 & lock  ;
}

bool afcPll3()
{
    Register r661 = readSpi(0x661);
    const auto saved = r661;
    r661.replace(5, 4, 0b10);
    writeSpi(0x661, r661);
    writeSpi(0x65B, 0x00);
    writeSpi(0x65B, 0x03);
    pause(delay);
    writeSpi(0x661, saved);
    const auto lock = readSpi(0x679);
    return 0x10 & lock;
}

bool afcPll4()
{
    Register r683 = readSpi(0x683);
    const auto saved = r683;
    r683.replace(5, 4, 0b10);
    writeSpi(0x683, r683);
    writeSpi(0x67D, 0x00);
    writeSpi(0x67D, 0x03);
    pause(delay);
    writeSpi(0x683, saved);
    const auto lock = readSpi(0x69B);
    return 0x10 & lock;
}

bool afcPll5()
{
    Register r6A5 = readSpi(0x6A5);
    const auto saved = r6A5;
    r6A5.replace(5, 4, 0b10);
    writeSpi(0x6A5, r6A5);
    writeSpi(0x69F, 0x00);
    writeSpi(0x69F, 0x03);
    pause(delay);
    writeSpi(0x6A5, saved);
    const auto lock = readSpi(0x6BD);
    return 0x10 & lock;
}

void configADCCalib(const double adc)
{
    writeSpi(0x70B, 0x1E);
    writeSpi(0x727, 0x1E);
    writeSpi(0x743, 0x1E);
    const auto adcClk = adc <= 64 ? adc * 20 : adc * 16;
    if (adcClk < 450) {
        writeSpi(0x70F, 0x08);
        writeSpi(0x710, 0x23);
        writeSpi(0x711, 0x10);

        writeSpi(0x72B, 0x08);
        writeSpi(0x72C, 0x23);
        writeSpi(0x72D, 0x10);

        writeSpi(0x747, 0x08);
        writeSpi(0x748, 0x23);
        writeSpi(0x749, 0x10);
    } else if (adcClk < 750) {
        writeSpi(0x70F, 0x50);
        writeSpi(0x710, 0x43);
        writeSpi(0x711, 0x30);

        writeSpi(0x72B, 0x50);
        writeSpi(0x72C, 0x43);
        writeSpi(0x72D, 0x30);

        writeSpi(0x747, 0x50);
        writeSpi(0x748, 0x43);
        writeSpi(0x749, 0x30);
    } else if (adcClk < 1050) {
        writeSpi(0x70F, 0xA0);
        writeSpi(0x710, 0x83);
        writeSpi(0x711, 0xF0);

        writeSpi(0x72B, 0xA0);
        writeSpi(0x72C, 0x83);
        writeSpi(0x72D, 0xF0);

        writeSpi(0x747, 0xA0);
        writeSpi(0x748, 0x83);
        writeSpi(0x749, 0xF0);
    } else {
        writeSpi(0x70F, 0xE0);
        writeSpi(0x710, 0x83);
        writeSpi(0x711, 0xF0);

        writeSpi(0x72B, 0xE0);
        writeSpi(0x72C, 0x83);
        writeSpi(0x72D, 0xF0);

        writeSpi(0x747, 0xE0);
        writeSpi(0x748, 0x83);
        writeSpi(0x749, 0xF0);
    }
    writeSpi(0x713, 0x80);
    writeSpi(0x72F, 0x80);
    writeSpi(0x74B, 0x80);
    writeSpi(0x70B, 0x9E);
    writeSpi(0x727, 0x9E);
    writeSpi(0x743, 0x9E);
    writeSpi(0x70B, 0x9A);
    writeSpi(0x727, 0x9A);
    writeSpi(0x743, 0x9A);
    writeSpi(0x70B, 0x9E);
    writeSpi(0x727, 0x9E);
    writeSpi(0x743, 0x9E);
    pause(delay);
    writeSpi(0x70B, 0x1E);
    writeSpi(0x727, 0x1E);
    writeSpi(0x743, 0x1E);
    writeSpi(0x713, 0xC0);
    writeSpi(0x72F, 0xC0);
    writeSpi(0x74B, 0xC0);
}

void configFlashCalib()
{
    writeSpi(0x70B, 0x1E);
    writeSpi(0x727, 0x1E);
    writeSpi(0x743, 0x1E);
    writeSpi(0x715, 0x80);
    writeSpi(0x731, 0x80);
    writeSpi(0x74D, 0x80);
    writeSpi(0x715, 0xC0);
    writeSpi(0x731, 0xC0);
    writeSpi(0x74D, 0xC0);
    writeSpi(0x716, 0x40);
    writeSpi(0x732, 0x40);
    writeSpi(0x74E, 0x40);
    writeSpi(0x70B, 0x16);
    writeSpi(0x727, 0x16);
    writeSpi(0x743, 0x16);
    pause(delay);
    writeSpi(0x70B, 0x1E);
    writeSpi(0x727, 0x1E);
    writeSpi(0x743, 0x1E);
    writeSpi(0x715, 0x80);
    writeSpi(0x731, 0x80);
    writeSpi(0x74D, 0x80);
    writeSpi(0x716, 0x00);
    writeSpi(0x732, 0x00);
    writeSpi(0x74E, 0x00);
}

void configTxNco(const TxNCO& nco, const double fs)
{
    configTxBIST(nco.txUseBist);
    configTxNcoFreq(nco.txNCOFreq, fs);
}

void configTxBIST(const bool bist)
{
    writeSpi(0x128, 0x10);
    writeSpi(0x11B, bist);
    writeSpi(0x11E, bist);
    writeSpi(0x161, bist);
    writeSpi(0x162, bist);
}

void configTxNcoFreq(const double freq, const double fs)
{
    const auto ratio = freq < 0 ? (freq + fs) / fs : freq / fs;
    const auto bin = frac2bin<48>(ratio);
    std::size_t pos;
    writeSpi(0x164, std::stoi(bin.substr(0, 8), &pos, 2));
    writeSpi(0x165, std::stoi(bin.substr(8, 8), &pos, 2));
    writeSpi(0x166, std::stoi(bin.substr(16, 8), &pos, 2));
    writeSpi(0x167, std::stoi(bin.substr(24, 8), &pos, 2));
    writeSpi(0x168, std::stoi(bin.substr(32, 8), &pos, 2));
    writeSpi(0x169, std::stoi(bin.substr(40, 8), &pos, 2));
}

void configRxNco(const RxNCO& nco, const double fs)
{
    configRxNcoMode(nco.rxUseBist             ? NCOMode::BIST
                            : nco.rxNCOBypass ? NCOMode::Bypass
                            : nco.rxNCOUpward ? NCOMode::Up
                                              : NCOMode::Down);
    configRxNcoMS(nco.rxNCOMaster ? NCOMode::Master : NCOMode::Slaver);
    configRxNcoFreq(nco.rxNCOFreq, fs);
}

void configRxNcoMode(const NCOMode mode)
{
    writeSpi(0x11C, mode == NCOMode::BIST ? 0x3F : 0x00);
    writeSpi(0xA07, mode == NCOMode::BIST ? 0x01 : 0x00);
    writeSpi(0xA08, mode == NCOMode::Bypass ? 0x00 : mode == NCOMode::Up ? 0X07 : 0X87);
}

void configRxNcoMS(const NCOMode mode)
{
    writeSpi(0xA09, mode != NCOMode::Master);
}

void configRxNcoFreq(const double freq, const double fs)
{
    const auto ratio = freq < 0 ? (freq + fs) / fs : freq / fs;
    const auto bin = frac2bin<48>(ratio);
    std::size_t pos;
    writeSpi(0xA16, std::stoi(bin.substr(0, 8), &pos, 2));
    writeSpi(0xA17, std::stoi(bin.substr(8, 8), &pos, 2));
    writeSpi(0xA18, std::stoi(bin.substr(16, 8), &pos, 2));
    writeSpi(0xA19, std::stoi(bin.substr(24, 8), &pos, 2));
    writeSpi(0xA1A, std::stoi(bin.substr(32, 8), &pos, 2));
    writeSpi(0xA1B, std::stoi(bin.substr(40, 8), &pos, 2));
}

void configDcCalib(const Calib& config)
{
    writeSpi(0x109, config.calibDC ? 0x11 : 0x00);
    writeSpi(0x10A, static_cast<int>(std::log2(std::max(1, config.dcCalibLength / 128))) << 4);
    writeSpi(0x11F, config.calibDC ? 0x33 : 0x73);
}

void configInterface(const Interface& interface)
{
    writeSpi(0x02E, interface.workMode == WorkMode::Rx ? 0x04 : interface.workMode == WorkMode::Tx ? 0x05 : 0x06);
    writeSpi(0x003, 0x33);
    Register r200{ 0x00 };
    // 0x200
    if (interface.ioMode != IOMode::CMOS)
        r200 = 0x0F;
    else if (interface.trMode == TrMode::R1T1 && interface.portMode == PortMode::Single)
        r200 = 0x00;
    else
        r200 = 0x01;
    writeSpi(0x200, r200);
    // 0x201
    if (interface.workMode == WorkMode::FDD)
        writeSpi(0x201, 0x00);
    else if (interface.portMode == PortMode::Single && interface.trMode == TrMode::R2T2)
        writeSpi(0x201, 0x3F);
    else
        writeSpi(0x201, 0x15);
    // 0x202
    writeSpi(0x202, interface.portMode == PortMode::Single ? 0x03 : 0x00);
    // 0x206
    Register r206{ 0x00 };
    if (interface.ioMode == IOMode::LVDS_S)
        r206 = 0x1F;
    if (interface.ioMode == IOMode::LVDS_E)
        r206 = 0x0F;
    writeSpi(0x206, r206);
    // 0x208
    if (interface.trMode == TrMode::R1T1
        && ((interface.workMode == WorkMode::FDD && interface.portMode == PortMode::Dual)
            || (interface.workMode != WorkMode::FDD && interface.portMode == PortMode::Single)))
        writeSpi(0x208, 0x0F);
    else
        writeSpi(0x208, 0x00);
    // 0x209
    if (interface.portMode == PortMode::Dual && interface.trMode == TrMode::R1T1)
        writeSpi(0x209, 0x80);
    else
        writeSpi(0x209, 0x00);
    // 0x77F
    if (interface.ioMode != IOMode::CMOS)
        writeSpi(0x77F, 0x0F);
    else
        writeSpi(0x77F, 0x00);
    // 0x780
    if (interface.portMode == PortMode::Dual && interface.workMode == WorkMode::FDD)
        writeSpi(0x780, 0x30);
    else
        writeSpi(0x780, interface.workMode == WorkMode::FDD ? 0x11 : interface.workMode == WorkMode::Rx ? 0x00 : 0x33);
    // 0x781
    writeSpi(0x781, interface.ioMode == IOMode::CMOS ? 0x6F : 0x01);
}

void configPowerMode(const PowerMode pm)
{
    writeSpi(0x02E, static_cast<int>(pm));
}

void configPowerPins(const Power& power, const PowerMode pm)
{
    Register reg1 = 0x00;
    reg1[0] = power.dig_rx1;
    reg1[1] = power.dig_rx2;
    reg1[2] = power.dig_rx3;
    reg1[3] = power.dig_tx1;
    reg1[4] = power.dig_tx2;
    Register reg2 = 0x00;
    reg2[0] = !power.exlo;
    reg2[1] = !power.bgr;
    reg2[2] = !power.temp_sensor;
    reg2[3] = !power.auxdac;
    reg2[4] = !power.auxadc1;
    reg2[5] = !power.auxadc2;
    reg2[6] = !power.fref1_rx;
    Register reg3 = 0x00;
    reg3[0] = !power.pll4_ldo;
    reg3[1] = !power.pll5;
    reg3[2] = !power.pll5_ldo;
    reg3[3] = !power.rx1;
    reg3[4] = !power.rx2;
    reg3[5] = !power.rx3;
    reg3[6] = !power.tx1;
    reg3[7] = !power.tx2;
    Register reg4 = 0x00;
    reg4[0] = !power.bbpll;
    reg4[1] = !power.pll1;
    reg4[2] = !power.pll1_ldo;
    reg4[3] = !power.pll2;
    reg4[4] = !power.pll2_ldo;
    reg4[5] = !power.pll3;
    reg4[6] = !power.pll3_ldo;
    reg4[7] = !power.pll4;
    const int initAddr = 0x031 + static_cast<int>(pm) * 4;
    writeSpi(initAddr, reg1);
    writeSpi(initAddr + 1, reg2);
    writeSpi(initAddr + 2, reg3);
    writeSpi(initAddr + 3, reg4);
}

void configRefDoubler(const bool doubler, const double ref)
{
    writeSpi(0x789, ref <= 75 ? 0x10 : 0x00);
    writeSpi(0x785, doubler ? 0xC9 : 0x49);
    writeSpi(0x788, 0x24);
    pause(1);
    writeSpi(0x788, 0xA4);
}

void initialRxChannel(const RxChannel chan)
{
    writeSpi(chan == RxChannel::Rx1 ? 0x705 : chan == RxChannel::Rx2 ? 0x721 : 0x73D, 0xFC);
    writeSpi(chan == RxChannel::Rx1 ? 0x706 : chan == RxChannel::Rx2 ? 0x722 : 0x73E, 0x6D);
    writeSpi(chan == RxChannel::Rx1 ? 0x707 : chan == RxChannel::Rx2 ? 0x723 : 0x73F, 0x91);
    writeSpi(chan == RxChannel::Rx1 ? 0x708 : chan == RxChannel::Rx2 ? 0x724 : 0x740, 0x04);
    writeSpi(chan == RxChannel::Rx1 ? 0x709 : chan == RxChannel::Rx2 ? 0x725 : 0x741, 0x94);
    writeSpi(chan == RxChannel::Rx1 ? 0x70A : chan == RxChannel::Rx2 ? 0x726 : 0x742, 0xFC);
    writeSpi(chan == RxChannel::Rx1 ? 0x70C : chan == RxChannel::Rx2 ? 0x728 : 0x744, 0xC0);
}

std::pair<int, int> configBandwidthImpl(const double bandwidth)
{
    const auto x = bandwidth / 172.8;
    auto c = 255;
    auto r = 0;
    for (; c > 0; --c) {
        r = floor(c * x + 128 * x - 1);
        if (r <= 31 && r >= 0)
            break;
    }
    r = clamp(r, 0, 31);
    c = round((r + 1) / x) - 128;
    return { r, c };
}

void configRxBandwidth(const double bandwidth, const RxChannel chan)
{
    const auto rc = configBandwidthImpl(bandwidth);
    const auto r = rc.first;
    const auto c = rc.second;
    Register rReg = 0xF8;
    rReg.replace(7, 3, r);
    writeSpi(chan == RxChannel::Rx1 ? 0x703 : chan == RxChannel::Rx2 ? 0x71F : 0x73B, c);
    writeSpi(chan == RxChannel::Rx1 ? 0x704 : chan == RxChannel::Rx2 ? 0x720 : 0x73C, rReg);
}

void configRxTIA(const int tia, const RxChannel chan)
{
    Register tiaReg = 0x50;
    tiaReg.replace(2, 0, tia);
    writeSpi(chan == RxChannel::Rx1 ? 0x700 : chan == RxChannel::Rx2 ? 0x71C : 0x738, tiaReg);
}

void configRxMixer(const int mixer)
{
    writeSpi(0x907, mixer);
}

void configRxChannel(const RxConfig& config, const RxChannel chan)
{
    configRxTIA(config.tia, chan);
    int tiaCSel = round(1036.4364 * (config.tia + 1) / config.bandwidth - 40);
    tiaCSel = clamp(tiaCSel, 0, 8191);
    const Register c1 = tiaCSel >> 8;
    const Register c2 = tiaCSel & 0xFF;
    writeSpi(chan == RxChannel::Rx1 ? 0x701 : chan == RxChannel::Rx2 ? 0x71D : 0x739, c1);
    writeSpi(chan == RxChannel::Rx1 ? 0x702 : chan == RxChannel::Rx2 ? 0x71E : 0x73A, c2);
    configRxBandwidth(config.bandwidth, chan);
    configRxMixer(config.mixer);
}

void configRxFIR(const int fir)
{
    Register firReg = readSpi(0x106);
    firReg.replace(7, 5, fir == 8 ? 5 : fir);
    writeSpi(0x106, firReg);
}

void configRxHBF1(const int hbf)
{
    Register hbfReg = readSpi(0x106);
    hbfReg[4] = hbf == 2;
    writeSpi(0x106, hbfReg);
}

void configRxHBF2(const int hbf)
{
    Register hbfReg = readSpi(0x106);
    hbfReg[3] = hbf == 2;
    writeSpi(0x106, hbfReg);
}

void configRxHBF3(const int hbf)
{
    Register hbfReg = readSpi(0x106);
    hbfReg.replace(2, 1, hbf == 0 ? 1 : hbf);
    writeSpi(0x106, hbfReg);
}

void configRxCIC(const int cic)
{
    Register cicReg = readSpi(0x106);
    cicReg[0] = cic == 20;
    writeSpi(0x106, cicReg);
}

void configRxFilters(const Filters& filters)
{
    Register filtersReg;
    filtersReg.replace(7, 5, filters.fir == 8 ? 5 : filters.fir);
    filtersReg[4] = filters.hbf1 == 2;
    filtersReg[3] = filters.hbf2 == 2;
    filtersReg.replace(2, 1, filters.hbf3 == 0 ? 1 : filters.hbf3);
    filtersReg[0] = filters.cic == 20;
    writeSpi(0x106, filtersReg);
}

std::pair<int, int> configTxBandwidthImpl(const double bandwidth)
{
    const auto x = bandwidth / 144;
    auto c = 127;
    auto r = 0;
    for (; c > 0; --c) {
        r = floor(c * x + 128 * x - 1);
        if (r <= 31 && r >= 0)
            break;
    }
    r = clamp(r, 0, 31);
    c = round((r + 1) / x) - 128;
    return { r, c };
}

void configTxBandwidth(const double bandwidth, const TxChannel chan)
{
    const auto rc = configTxBandwidthImpl(bandwidth);
    const auto r = rc.first;
    const auto c = rc.second;
    Register rReg = 0xAF;
    rReg.replace(7, 3, r);
    writeSpi(chan == TxChannel::Tx1 ? 0x75E : 0x768, rReg);
    const Register cReg = c << 1;
    writeSpi(chan == TxChannel::Tx1 ? 0x75D : 0x767, cReg);
    Register lpfReg = readSpi(chan == TxChannel::Tx1 ? 0x75F : 0x769);
    lpfReg.replace(7, 2, r);
    writeSpi(chan == TxChannel::Tx1 ? 0x75F : 0x769, lpfReg);
}

void configTxMixer(const int mixer, const TxChannel chan)
{
    Register mixerReg = 0xFF;
    mixerReg.replace(7, 2, mixer);
    writeSpi(chan == TxChannel::Tx1 ? 0x760 : 0x76A, mixerReg);
}

void initialTxChannel(const TxChannel chan)
{
    writeSpi(chan == TxChannel::Tx1 ? 0x75A : 0x764, 0x83);
    writeSpi(chan == TxChannel::Tx1 ? 0x75B : 0x765, 0xDA);
    pause(delay);
    writeSpi(chan == TxChannel::Tx1 ? 0x75B : 0x765, 0x9A);
    writeSpi(chan == TxChannel::Tx1 ? 0x75C : 0x766, 0x81);
    writeSpi(chan == TxChannel::Tx1 ? 0x763 : 0x76D, 0x04);
}

void configTxChannelFrequency(const double lo, const TxChannel chan)
{
    Register r75F = 0x56;
    r75F.replace(1, 0, lo <= 3500 ? 0x01 : 0x00);
    writeSpi(chan == TxChannel::Tx1 ? 0x75F : 0x769, r75F);
    writeSpi(chan == TxChannel::Tx1 ? 0x761 : 0x76B, lo <= 3500 ? 0x04 : 0x07);
    writeSpi(chan == TxChannel::Tx1 ? 0x762 : 0x76C, lo <= 3500 ? 0x70 : 0x6C);
}

void configTxChannel(const TxConfig& config, const TxChannel chan)
{
    configTxBandwidth(config.bandwidth, chan);
    configTxMixer(config.mixer, chan);
}

void configTxFIR(const int fir)
{
    const Register firReg = fir == 8 ? 5 : fir;
    writeSpi(0x107, firReg);
}

void configTxHBF1(const int hbf)
{
    Register hbfReg = readSpi(0x108);
    hbfReg[7] = hbf == 2;
    writeSpi(0x108, hbfReg);
}

void configTxHBF2(const int hbf)
{
    Register hbfReg = readSpi(0x108);
    hbfReg[6] = hbf == 2;
    writeSpi(0x108, hbfReg);
}

void configTxHBF3(const int hbf)
{
    Register hbfReg = readSpi(0x108);
    hbfReg.replace(5, 4, hbf == 0 ? 1 : hbf);
    writeSpi(0x108, hbfReg);
}

void configTxCIC(const int cic)
{
    Register cicReg = readSpi(0x108);
    cicReg.replace(2, 0, cic == 20 ? 4 : cic == 8 ? 3 : cic == 80 ? 2 : cic == 32 ? 1 : 0);
    writeSpi(0x108, cicReg);
}

void configTxFilters(const Filters& filters)
{
    const Register firReg = filters.fir == 8 ? 5 : filters.fir;
    Register filtersReg;
    filtersReg[7] = filters.hbf1 == 2;
    filtersReg[6] = filters.hbf2 == 2;
    filtersReg.replace(5, 4, filters.hbf3 == 0 ? 1 : filters.hbf3);
    filtersReg.replace(2, 0,
                       filters.cic == 20           ? 4
                               : filters.cic == 8  ? 3
                               : filters.cic == 80 ? 2
                               : filters.cic == 32 ? 1
                                                   : 0);
    writeSpi(0x107, firReg);
    writeSpi(0x108, filtersReg);
}

void initialPowerConfig(const CX9261AConfiguration& config)
{
    // 断电模式
    writeSpi(0x031, 0x00);
    writeSpi(0x032, 0x7F);
    writeSpi(0x033, 0xFF);
    writeSpi(0x034, 0xFF);
    // 休眠模式
    writeSpi(0x035, 0x00);
    writeSpi(0x036, config.pllSource.rxUseExt || config.pllSource.txUseExt ? 0x3C : 0x3D);
    const bool usePll4 = !config.pllSource.txUseExt
            && (config.pllSource.tx1Source == LoSource::Pll4 || config.pllSource.tx2Source == LoSource::Pll4);
    const bool usePll5 = config.pllSource.rx3Source == LoSource::Pll5;
    Register reg037(0xFF);
    reg037[2] = !usePll5;
    reg037[0] = !usePll4;
    writeSpi(0x037, reg037);
    const bool usePll3 = !config.pllSource.txUseExt
            && (config.pllSource.tx1Source == LoSource::Pll3 || config.pllSource.tx2Source == LoSource::Pll3);
    const bool usePll2 = !config.pllSource.rxUseExt
            && (config.pllSource.rx1Source == LoSource::Pll2 || config.pllSource.rx2Source == LoSource::Pll2);
    const bool usePll1 = !config.pllSource.rxUseExt
            && (config.pllSource.rx1Source == LoSource::Pll1 || config.pllSource.rx2Source == LoSource::Pll1);
    Register reg038(0xFF);
    reg038[6] = !usePll3;
    reg038[4] = !usePll2;
    reg038[2] = !usePll1;
    writeSpi(0x038, reg038);
    // 警戒模式
    writeSpi(0x039, 0x00);
    writeSpi(0x03A, config.pllSource.rxUseExt || config.pllSource.txUseExt ? 0x3C : 0x3D);
    Register reg03B(0xFF);
    reg03B[2] = !usePll5;
    reg03B[1] = !usePll5;
    reg03B[0] = !usePll4;
    writeSpi(0x03B, reg03B);
    Register reg03C(0xFE);
    reg03C[7] = !usePll4;
    reg03C[6] = !usePll3;
    reg03C[5] = !usePll3;
    reg03C[4] = !usePll2;
    reg03C[3] = !usePll2;
    reg03C[2] = !usePll1;
    reg03C[1] = !usePll1;
    writeSpi(0x03C, reg03C);
    // 校准模式
    Register reg03D(0x00);
    reg03D[4] = config.calib.calibTx2 || config.calib.calibRx3 || config.calib.calibRx2;
    reg03D[3] = config.calib.calibTx1 || config.calib.calibRx1;
    reg03D[2] = config.calib.calibRx3;
    reg03D[1] = config.calib.calibTx2 || config.calib.calibRx2;
    reg03D[0] = config.calib.calibTx1 || config.calib.calibRx1;
    writeSpi(0x03D, reg03D);
    writeSpi(0x03E, config.pllSource.rxUseExt || config.pllSource.txUseExt ? 0x38 : 0x39);
    Register reg03F(0xFF);
    reg03F[7] = !(config.calib.calibTx2 || config.calib.calibRx3 || config.calib.calibRx2);
    reg03F[6] = !(config.calib.calibTx1 || config.calib.calibRx1);
    reg03F[5] = !(config.calib.calibRx3);
    reg03F[4] = !(config.calib.calibTx2 || config.calib.calibRx2);
    reg03F[3] = !(config.calib.calibTx1 || config.calib.calibRx1);
    reg03F[2] = !usePll5;
    reg03F[1] = !usePll5;
    reg03F[0] = !(usePll4 || config.calib.calibRx3 || config.calib.calibRx2 || config.calib.calibRx1);
    writeSpi(0x03F, reg03F);
    Register reg040(0xFE);
    reg040[7] = !(usePll4 || config.calib.calibRx3 || config.calib.calibRx2 || config.calib.calibRx1);
    reg040[6] = !usePll3;
    reg040[5] = !usePll3;
    reg040[4] = !usePll2;
    reg040[3] = !usePll2;
    reg040[2] = !usePll1;
    reg040[1] = !usePll1;
    writeSpi(0x040, reg040);
    // 接收模式
    Register reg041(0x00);
    reg041[2] = config.pllSource.rx3Source != LoSource::Off;
    reg041[1] = config.pllSource.rxUseExt || config.pllSource.rx2Source != LoSource::Off;
    reg041[0] = config.pllSource.rxUseExt || config.pllSource.rx1Source != LoSource::Off;
    writeSpi(0x041, reg041);
    writeSpi(0x042, config.pllSource.rxUseExt ? 0x3C : 0x3D);
    Register reg043(0xFF);
    reg043[5] = !reg041[2];
    reg043[4] = !reg041[1];
    reg043[3] = !reg041[0];
    reg043[2] = config.pllSource.rx3Source == LoSource::Off;
    reg043[1] = config.pllSource.rx3Source == LoSource::Off;
    writeSpi(0x043, reg043);
    Register reg044(0xFE);
    reg044[4] = !usePll2;
    reg044[3] = !usePll2;
    reg044[2] = !usePll1;
    reg044[1] = !usePll1;
    writeSpi(0x044, reg044);
    // 发射模式
    Register reg045(0x00);
    reg045[4] = config.pllSource.txUseExt || config.pllSource.tx2Source != LoSource::Off;
    reg045[3] = config.pllSource.txUseExt || config.pllSource.tx1Source != LoSource::Off;
    writeSpi(0x045, reg045);
    writeSpi(0x046, config.pllSource.txUseExt ? 0x3C : 0x3D);
    Register reg047(0xFF);
    reg047[7] = !reg045[4];
    reg047[6] = !reg045[3];
    reg047[0] = !usePll4;
    writeSpi(0x047, reg047);
    Register reg048(0xFE);
    reg048[7] = !usePll4;
    reg048[6] = !usePll3;
    reg048[5] = !usePll3;
    reg048[4] = !usePll2;
    reg048[3] = !usePll2;
    reg048[2] = !usePll1;
    reg048[1] = !usePll1;
    writeSpi(0x048, reg048);
    // FDD模式
    Register reg049(0x00);
    reg049[4] = config.pllSource.txUseExt || config.pllSource.tx2Source != LoSource::Off;
    reg049[3] = config.pllSource.txUseExt || config.pllSource.tx1Source != LoSource::Off;
    reg049[2] = config.pllSource.rx3Source == LoSource::Off;
    reg049[1] = config.pllSource.rxUseExt || config.pllSource.rx2Source != LoSource::Off;
    reg049[0] = config.pllSource.rxUseExt || config.pllSource.rx1Source != LoSource::Off;
    writeSpi(0x049, reg049);
    writeSpi(0x04A, config.pllSource.txUseExt || config.pllSource.rxUseExt ? 0x3C : 0x3D);
    Register reg04B(0xFF);
    reg04B[7] = !reg049[4];
    reg04B[6] = !reg049[3];
    reg04B[5] = !reg049[2];
    reg04B[4] = !reg049[1];
    reg04B[3] = !reg049[0];
    reg04B[2] = !usePll5;
    reg04B[1] = !usePll5;
    reg04B[0] = !usePll4;
    writeSpi(0x04B, reg04B);
    Register reg04C(0xFE);
    reg04C[7] = !usePll4;
    reg04C[6] = !usePll3;
    reg04C[5] = !usePll3;
    reg04C[4] = !usePll2;
    reg04C[3] = !usePll2;
    reg04C[2] = !usePll1;
    reg04C[1] = !usePll1;
    writeSpi(0x04C, reg04C);
    // 观测模式
    writeSpi(0x04D, 0x04);
    writeSpi(0x04E, 0x3D);
    writeSpi(0x04F, 0xD9);
    writeSpi(0x050, 0xFE);
}

void configAGCMode(const int mode)
{
    writeSpi(0x900, mode == 0 ? 0x00 : 0x11);
    writeSpi(0x901, mode == 3 || mode == 4 ? mode + 0x80 : mode);
}

void configAGCPDT(const AGCPDT& pdt)
{
    writeSpi(0x908, (pdt.pdtN << 4) + pdt.pdtM);
    writeSpi(0x909, pdt.pdtN < 3 && pdt.pdtM < 4 ? 0x00 : 0x03);
    writeSpi(0x90A, pdt.pdtN < 3 && pdt.pdtM < 4 ? 0x02 : 0x32);
}

void configAGCLMT(const AGCLMT& lmt)
{
    writeSpi(0x90D, lmt.count >> 8);
    writeSpi(0x90E, lmt.count & 0xFF);
    writeSpi(0x90F, (lmt.threshold1 << 4) + lmt.threshold2);
    writeSpi(0x910, (lmt.threshold3 << 4) + lmt.threshold4);
}

void configAGCDIG(const AGCDIG& dig)
{
    writeSpi(0x911, dig.count >> 8);
    writeSpi(0x912, dig.count & 0xFF);
    writeSpi(0x913, dig.threshold1 + 60);
    writeSpi(0x914, dig.threshold2 + 60);
    writeSpi(0x915, dig.threshold3 + 60);
    writeSpi(0x916, dig.threshold4 + 60);
}

void configAGC(const AGC& agc)
{
    writeSpi(0x903, 0x11);
    configAGCMode(agc.mode);
    configAGCPDT(agc.pdt);
    configAGCLMT(agc.lmt);
    configAGCDIG(agc.dig);
}

void configRxFIRCoe(const std::vector<double>& coe)
{
    for (auto i = 0; i < coe.size(); ++i) {
        const auto value = round(coe[i] * std::pow(2, 15)) + (coe[i] < 0 ? 65536 : 0);
        writeSpi(0x401, i);
        writeSpi(0x402, value >> 8 & 0xFF);
        writeSpi(0x403, value & 0xFF);
        writeSpi(0x401, 0x80 + i);
        pause(1);
    }
    writeSpi(0x400, ceil(coe.size() / 16) - 1);
    writeSpi(0x404, 00);
    writeSpi(0x404, 01);
}

void configTxFIRCoe(const std::vector<double>& coe)
{
    for (auto i = 0; i < coe.size(); ++i) {
        const auto value = round(coe[i] * std::pow(2, 15)) + (coe[i] < 0 ? 65536 : 0);
        writeSpi(0x501, i);
        writeSpi(0x502, value >> 8 & 0xFF);
        writeSpi(0x503, value & 0xFF);
        writeSpi(0x501, 0x80 + i);
        pause(1);
    }
    writeSpi(0x500, ceil(coe.size() / 16) - 1);
    writeSpi(0x504, 00);
    writeSpi(0x504, 01);
}

CalibPredis readRxCalibPredis(const RxChannel chan)
{
    writeSpi(0x000, chan == RxChannel::Rx1 ? 0x12 : chan == RxChannel::Rx2 ? 0x22 : 0x32);
    writeSpi(0x121, 0x00);
    const CalibPredis predis{ .bHigh = readSpi(0x13D),
                              .bLow = readSpi(0x13E),
                              .cHigh = readSpi(0x13F),
                              .cLow = readSpi(0x140),
                              .dciHigh = readSpi(0x141),
                              .dciLow = readSpi(0x142),
                              .dcqHigh = readSpi(0x143),
                              .dcqLow = readSpi(0x144) };
    writeSpi(0x000, 02);
    return predis;
}

void saveRxCalibPredis(const unsigned char index, const RxChannel chan, const CalibPredis& predis)
{
    writeSpi(0x09C, 0x00);
    writeSpi(0x094, predis.bHigh);
    writeSpi(0x095, predis.bLow);
    writeSpi(0x096, predis.cHigh);
    writeSpi(0x097, predis.cLow);
    writeSpi(0x098, predis.dciHigh);
    writeSpi(0x099, predis.dciLow);
    writeSpi(0x09A, predis.dcqHigh);
    writeSpi(0x09B, predis.dcqLow);
    writeSpi(0x09F, index);
    writeSpi(0x09E, chan == RxChannel::Rx1 ? 0x00 : chan == RxChannel::Rx2 ? 0x01 : 0x02);
    writeSpi(0x09C, 0x01);
}

void loadRxCalibPredis(const unsigned char index)
{
    writeSpi(0x09C, 0x00);
    writeSpi(0x09F, index);
    writeSpi(0x09C, 0x02);
}

void configFPGA(const Interface& interface)
{
    setPin(33, 1);
    setPin(39, 1);
    setPin(40, 1);

    setPin(32, 1);
    setPin(7, interface.ioMode == IOMode::CMOS ? 0 : 1);
    setPin(34, 1);
    setPin(34, 0);

    setPin(38, interface.portMode == PortMode::Single);
    setPin(37, interface.trMode == TrMode::R2T2);
    setPin(36, interface.workMode != WorkMode::FDD);
    setPin(35, interface.workMode == WorkMode::Rx);

    setPin(43, 0);
    setPin(43, 1);
}

} // namespace CX9261A
