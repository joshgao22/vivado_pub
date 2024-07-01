<!-- omit in toc -->
# Josh & RFSoC EVB

- [`20240629` - 使用 Vivado 2024.1 进行开发，MTS 通过](#20240629---使用-vivado-20241-进行开发mts-通过)

## `20240629` - 使用 Vivado 2024.1 进行开发，MTS 通过

将工程迁移到了 Vivado 2024.1 版本，并进行以下改动：

- 按照 PG269 的推荐，修改了 PL CLK 和 PL SYSREF 接入 FPGA 的方法，原来使用 RF Data Converter 输出的时钟对 PL SYSREF 采样并输入到 RF Data Converter 中，但是 PG269 不允许这样操作，因此改为使用输入 FPGA 管脚的 PL CLK 对 PL SYSREF 进行采样。

- FPGA 的 PL CLK 接入了 HD Bank 的 HDGC 管脚，但是 HD Bank 旁边没有 CMT，需要通过 BUFG 接入相邻的 CMT，因此在约束中使用了 `set property CLOCK_DEDICATED_ROUTE FALSE [get_nets <net for clock input to MMCM/PLL>]` 来消除 Place 过程中的 Error。

  > First, make sure you are bringing your clock into the FPGA on a global clock (GC) pin. Then note from page 10 of UG572 that HD I/O banks do not have a CMT (eg. MMCM/PLL) next to them. However, from an HD I/O bank, you can reach a CMT via a BUFGCE (BUFG). Routing the clock from the GC pin and through a BUFGCE will cause the warnings you are seeing, which can be safely avoided by placing the following constraint in your in your xdc file.
  >
  > REF: [[PLace 30-716] Clock input driving MMCM/PLL in HDIO bank with BUFGCE](https://support.xilinx.com/s/question/0D52E00006lLh0DSAS/place-30716-clock-input-driving-mmcmpll-in-hdio-bank-with-bufgce?language=en_US)

- RF Data Converter 中开启了 8 个 RF-ADC 和 8 个 RF-DAC，各 RF-ADC 和 RF-DAC 配置相同，均为 4.9152 Gsps 采样率、x40 抽取/内插，和 PL 数据交互的速率为 245.76 MHz。

- PS 端有两个 Demo 工程，一个是可以修改部分 ADC/DAC 配置的扫频程序，一个是 RFSoC Multi-tile sync 多通道同步的程序，仅供参考。

- 启用了动态 DDR 配置，依赖于 FSBL 启动，在启动时 FSBL 会使用 I2C 读取 DDR 的 SPD EEPROM 获得 DDR 参数，并初始化 DDR 控制器。此部分原理图与 Xilinx 开发板 I2C Mux Slave 连接一致，因此重新建立工程时除了需要同时建立 FSBL 外不需要额外操作。
