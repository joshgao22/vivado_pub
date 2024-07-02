#include "dev_profile.h"
#include "../app_config.h"
#include "../adi_noos/drivers/frequency/lmk04828/lmk04828.h"


static spi_init_param lmk04828_spi_init = {
	.device_id = SPI_DEVICE_ID,
    .max_speed_hz = SPI_ENGINE_MAX_SPEED,
	.mode = SPI_MODE_0,
	.chip_select = SPI_CS_LMK04828,
	.platform_ops = SPI_OPS,
	.extra = SPI_PARAM
};

struct lmk04828_init_param lmk04828_default_init_param = {
	/* SPI */
	.spi_init = &lmk04828_spi_init
};

const uint32_t lmk04828_default_config_len = 136;
const struct lmk04828_config lmk04828_default_config[] = {
	{0x0000, 0x10}, // [7] normal operation; [4] 3-wire mode disabled
	{0x0002, 0x00}, // [0] normal operation
	{0x0003, 0x06}, // [7-0] product device type, read only, default: 6
	{0x0004, 0xD0}, // [7-0] msb of product identifier, read only, default: 208
	{0x0005, 0x5B}, // [7-0] lsb of product identifier, read only, default: 91
	{0x0006, 0x00}, // [7-0] ic version identifier, read only, default: 32
	{0x000C, 0x51}, // [7-0] msb of vendor identifier, read only, default: 81
	{0x000D, 0x04}, // [7-0] lsb of vendor identifier, read only, default: 4
	// device clock 0
	{0x0100, 0x0C}, // [6] output drive level (ODL); [5] input drive level (IDL); [4-0] device clock (DCLK) output divider
	{0x0101, 0x55}, // DCLK: [7-4] output digital delay (DDLY) high count; [3-0] DDLY low count
	{0x0102, 0x55},
	{0x0103, 0x01}, // DCLK: [7-3] analog delay (ADLY) value, 25 ps per lsb; [2] ADLY input mux; [1-0] DCLK input mux
	{0x0104, 0x22}, // [6] DCLK half step value; [5] SDCLK output MUX; [4-1] SDCLK DDLY; [0] SYSREF half step value
	{0x0105, 0x00}, // SYSREF: [4] ADLY enable; [3:0] ADLY value, 600 ps + 150 ps per lsb
	{0x0106, 0xF0}, // [7] DCLK DDLY enable; [6] DCLK glitchless half step enable; [5] DCLK glitchless ADLY enable; [4] DCLK ADLY enable; [3]: clock group enable; [2-1] SYSREF disable mode; [0]: SYSREF disable
	{0x0107, 0x11}, // [7] SDCLK output polarity; [6-4] SDCLK output format; [3] DCLK output polarity; [2:0] DCLK output format
	// device clock 2
	{0x0108, 0x0C}, // [6] output drive level (ODL); [5] input drive level (IDL); [4-0] device clock (DCLK) output divider
	{0x0109, 0x55}, // DCLK: [7-4] output digital delay (DDLY) high count; [3-0] DDLY low count
	{0x010A, 0x55},
	{0x010B, 0x00}, // DCLK: [7-3] analog delay (ADLY) value, 25 ps per lsb; [2] ADLY input mux; [1-0] DCLK input mux
	{0x010C, 0x22}, // [6] DCLK half step value; [5] SDCLK output MUX; [4-1] SDCLK DDLY; [0] SYSREF half step value
	{0x010D, 0x00}, // SYSREF: [4] ADLY enable; [3:0] ADLY value, 600 ps + 150 ps per lsb
	{0x010E, 0xF0}, // [7] DCLK DDLY enable; [6] DCLK glitchless half step enable; [5] DCLK glitchless ADLY enable; [4] DCLK ADLY enable; [3]: clock group enable; [2-1] SYSREF disable mode; [0]: SYSREF disable
	{0x010F, 0x10}, // [7] SDCLK output polarity; [6-4] SDCLK output format; [3] DCLK output polarity; [2:0] DCLK output format
	// device clock 4
	{0x0110, 0x0C}, // [6] output drive level (ODL); [5] input drive level (IDL); [4-0] device clock (DCLK) output divider
	{0x0111, 0x55}, // DCLK: [7-4] output digital delay (DDLY) high count; [3-0] DDLY low count
	{0x0112, 0x55},
	{0x0113, 0x00}, // DCLK: [7-3] analog delay (ADLY) value, 25 ps per lsb; [2] ADLY input mux; [1-0] DCLK input mux
	{0x0114, 0x22}, // [6] DCLK half step value; [5] SDCLK output MUX; [4-1] SDCLK DDLY; [0] SYSREF half step value
	{0x0115, 0x00}, // SYSREF: [4] ADLY enable; [3:0] ADLY value, 600 ps + 150 ps per lsb
	{0x0116, 0xF0}, // [7] DCLK DDLY enable; [6] DCLK glitchless half step enable; [5] DCLK glitchless ADLY enable; [4] DCLK ADLY enable; [3]: clock group enable; [2-1] SYSREF disable mode; [0]: SYSREF disable
	{0x0117, 0x11}, // [7] SDCLK output polarity; [6-4] SDCLK output format; [3] DCLK output polarity; [2:0] DCLK output format
	// device clock 6
	{0x0118, 0x0C}, // [6] output drive level (ODL); [5] input drive level (IDL); [4-0] device clock (DCLK) output divider
	{0x0119, 0x55}, // DCLK: [7-4] output digital delay (DDLY) high count; [3-0] DDLY low count
	{0x011A, 0x55},
	{0x011B, 0x00}, // DCLK: [7-3] analog delay (ADLY) value, 25 ps per lsb; [2] ADLY input mux; [1-0] DCLK input mux
	{0x011C, 0x02}, // [6] DCLK half step value; [5] SDCLK output MUX; [4-1] SDCLK DDLY; [0] SYSREF half step value
	{0x011D, 0x00}, // SYSREF: [4] ADLY enable; [3:0] ADLY value, 600 ps + 150 ps per lsb
	{0x011E, 0xF0}, // [7] DCLK DDLY enable; [6] DCLK glitchless half step enable; [5] DCLK glitchless ADLY enable; [4] DCLK ADLY enable; [3]: clock group enable; [2-1] SYSREF disable mode; [0]: SYSREF disable
	{0x011F, 0x55}, // [7] SDCLK output polarity; [6-4] SDCLK output format; [3] DCLK output polarity; [2:0] DCLK output format
	// device clock 8
	{0x0120, 0x0C}, // [6] output drive level (ODL); [5] input drive level (IDL); [4-0] device clock (DCLK) output divider
	{0x0121, 0x55}, // DCLK: [7-4] output digital delay (DDLY) high count; [3-0] DDLY low count
	{0x0122, 0x55},
	{0x0123, 0x00}, // DCLK: [7-3] analog delay (ADLY) value, 25 ps per lsb; [2] ADLY input mux; [1-0] DCLK input mux
	{0x0124, 0x22}, // [6] DCLK half step value; [5] SDCLK output MUX; [4-1] SDCLK DDLY; [0] SYSREF half step value
	{0x0125, 0x00}, // SYSREF: [4] ADLY enable; [3:0] ADLY value, 600 ps + 150 ps per lsb
	{0x0126, 0xF0}, // [7] DCLK DDLY enable; [6] DCLK glitchless half step enable; [5] DCLK glitchless ADLY enable; [4] DCLK ADLY enable; [3]: clock group enable; [2-1] SYSREF disable mode; [0]: SYSREF disable
	{0x0127, 0x55}, // [7] SDCLK output polarity; [6-4] SDCLK output format; [3] DCLK output polarity; [2:0] DCLK output format
	// device clock 10
	{0x0128, 0x0C}, // [6] output drive level (ODL); [5] input drive level (IDL); [4-0] device clock (DCLK) output divider
	{0x0129, 0x55}, // DCLK: [7-4] output digital delay (DDLY) high count; [3-0] DDLY low count
	{0x012A, 0x55},
	{0x012B, 0x00}, // DCLK: [7-3] analog delay (ADLY) value, 25 ps per lsb; [2] ADLY input mux; [1-0] DCLK input mux
	{0x012C, 0x22}, // [6] DCLK half step value; [5] SDCLK output MUX; [4-1] SDCLK DDLY; [0] SYSREF half step value
	{0x012D, 0x00}, // SYSREF: [4] ADLY enable; [3:0] ADLY value, 600 ps + 150 ps per lsb
	{0x012E, 0xF0}, // [7] DCLK DDLY enable; [6] DCLK glitchless half step enable; [5] DCLK glitchless ADLY enable; [4] DCLK ADLY enable; [3]: clock group enable; [2-1] SYSREF disable mode; [0]: SYSREF disable
	{0x012F, 0x51}, // [7] SDCLK output polarity; [6-4] SDCLK output format; [3] DCLK output polarity; [2:0] DCLK output format
	// device clock 12
	{0x0130, 0x0C}, // [6] output drive level (ODL); [5] input drive level (IDL); [4-0] device clock (DCLK) output divider
	{0x0131, 0x55}, // DCLK: [7-4] output digital delay (DDLY) high count; [3-0] DDLY low count
	{0x0132, 0x55},
	{0x0133, 0x00}, // DCLK: [7-3] analog delay (ADLY) value, 25 ps per lsb; [2] ADLY input mux; [1-0] DCLK input mux
	{0x0134, 0x22}, // [6] DCLK half step value; [5] SDCLK output MUX; [4-1] SDCLK DDLY; [0] SYSREF half step value
	{0x0135, 0x00}, // SYSREF: [4] ADLY enable; [3:0] ADLY value, 600 ps + 150 ps per lsb
	{0x0136, 0xF0}, // [7] DCLK DDLY enable; [6] DCLK glitchless half step enable; [5] DCLK glitchless ADLY enable; [4] DCLK ADLY enable; [3]: clock group enable; [2-1] SYSREF disable mode; [0]: SYSREF disable
	{0x0137, 0x55}, // [7] SDCLK output polarity; [6-4] SDCLK output format; [3] DCLK output polarity; [2:0] DCLK output format
	// clock distribution source
	{0x0138, 0x20}, // [6-5] VCO mux; [4] OSCout mux; [3:0] OSCout format
	{0x0139, 0x03}, // [2] SYSREF output mux; [1-0] SYSREF source
	{0x013A, 0x0C}, // [4-0] SYSREF divider [12:8]
	{0x013B, 0x00}, // [7-0] SYSREF divider [7:0]
	{0x013C, 0x00}, // [4-0] SYSREF DDLY [12:8]
	{0x013D, 0x08}, // [7-0] SYSREF DDLY [7:0]
	{0x013E, 0x03}, // [1-0] SYSREF pulse count
	{0x013F, 0x00}, // [4] pll2 mux; [3] pll1 mux; [2-1] feedback mux; [0]  feedback mux enable
	{0x0140, 0x0B}, // power-down control: [7] pll1; [6] vco_ldo; [5] vco; [4] OSCin; [3] individual SYSREF; [2] SYSREF; [1] SYSREF DDLY; [0] SYSREF pluse generator
	{0x0141, 0x00}, // dynamic DDLY control
	{0x0142, 0x00}, // dynamic DDLY step control
	{0x0143, 0x10},
	{0x0144, 0xFF},
	{0x0145, 0x7F},
	{0x0146, 0x12},
	{0x0147, 0x1A},
	{0x0148, 0x03},
	{0x0149, 0x05},
	{0x014A, 0x1B},
	{0x014B, 0x16},
	{0x014C, 0x00},
	{0x014D, 0x00},
	{0x014E, 0xC0},
	{0x014F, 0x7F},
	{0x0150, 0x03},
	{0x0151, 0x02},
	{0x0152, 0x00},
	{0x0153, 0x00},
	{0x0154, 0x78},
	{0x0155, 0x00},
	{0x0156, 0x7D},
	{0x0157, 0x00},
	{0x0158, 0x96},
	{0x0159, 0x06},
	{0x015A, 0x00},
	{0x015B, 0xD4},
	{0x015C, 0x20},
	{0x015D, 0x00},
	{0x015E, 0x00},
	{0x015F, 0x3B},
	{0x0160, 0x00},
	{0x0161, 0x01},
	{0x0162, 0x44},
	{0x0163, 0x00},
	{0x0164, 0x00},
	{0x0165, 0x0C},
	{0x0171, 0xAA},
	{0x0172, 0x02},
	{0x017C, 0x15},
	{0x017D, 0x33},
	{0x0166, 0x00},
	{0x0167, 0x00},
	{0x0168, 0x0C},
	{0x0169, 0x59},
	{0x016A, 0x20},
	{0x016B, 0x00},
	{0x016C, 0x00},
	{0x016D, 0x00},
	{0x016E, 0x1B},
	{0x0173, 0x00},
	{0x0182, 0x00},
	{0x0183, 0x00},
	{0x0184, 0x00},
	{0x0185, 0x00},
	{0x0188, 0x00},
	{0x0189, 0x00},
	{0x018A, 0x00},
	{0x018B, 0x00},
	{0x1FFD, 0x00},
	{0x1FFE, 0x00},
	{0x1FFF, 0x53}
};
