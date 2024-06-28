# README.md

> Vivado Project Name: dj_47dr_demo
>
> Vitis Project Name: fsbl_debug
>
> Board: RFSOC_47DR_Z7045
>
> Device: xczu47dr-2ffve1156i(u15), lmk04828(u66),
>
> Date: 2024/06/28
>
> Archiver: Josh Gao

1. 注意事项

   本工程启用了动态 DDR 配置，依赖于 FSBL 启动，在启动时 FSBL 会使用 I2C 读取 DDR 的 SPD EEPROM 获得 DDR 参数，并初始化 DDR 控制器。

   由于原理图与 Xilinx 开发板 I2C Mux Slave 连接不一致，FSBL 已将 I2C Mux 的 Slave 选择改为 `0x04`。若重新建立 PS 工程，注意修改 FSBL，否则可能无法正常启动。

2. 实现的功能

   - 调试 FSBL，观察动态 DDR 操作的过程。
   - 为启用 DDR 调试，对编译选项进行了部分修改，具体参见：[Zynq MPSoC / RFSoC 动态配置 DIMM DDR](https://josh-gao.top/posts/11cd1dc.html)。

3. 存在的问题

   暂无。
