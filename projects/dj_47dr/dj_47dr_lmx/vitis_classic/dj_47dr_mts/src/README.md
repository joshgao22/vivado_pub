# README.md

> Vivado Project Name: dj_47dr_lmx
>
> Vitis Project Name: dj_47dr_mts
>
> Board: RFSOC_47DR_Z7045
>
> Device: xczu47dr-2ffve1156i(u15), lmk04828(u66), lmk2594(u67), lmk2594(u68)
>
> Date: 2024/07/04
>
> Archiver: Josh Gao

1. 注意事项

   本工程启用了动态 DDR 配置，依赖于 FSBL 启动，在启动时 FSBL 会使用 I2C 读取 DDR 的 SPD EEPROM 获得 DDR 参数，并初始化 DDR 控制器。

   由于原理图与 Xilinx 开发板 I2C Mux Slave 连接不一致，FSBL 已将 I2C Mux 的 Slave 选择改为 `0x04`。若重新建立 PS 工程，注意修改 FSBL，否则可能无法正常启动。

2. 实现的功能

   - 配置了 LMK04828，使用 10 MHz 输入时钟和 122.88 MHz VCXO 完成配置，PLL2 锁定，输出时钟频率为 245.76 MHz。
   - 配置了两片 LMK2594，RF 部分使用外部采样时钟，采样率为 4.9152 Gbps。
   - 参考 RFSoC Eval 板卡完成了多通道同步，输出结果显示 RF-ADC 和 RF-DAC 均完成同步。

3. 存在的问题

   - LMK04828 PLL1 锁定时间较长（约 1 分钟），单独配置 LMK04828 时同样存在该问题。
   - LMK2594 SPI 回读异常，ILA 可以看见回读，但是 PS 程序中无回读，问题待查；通过 LED 灯判断两片 LMK2594 均锁定。
