# README

## 基本功能

最开始开发本程序的想法是使用 SPI 0 作为 Master，使用 SPI 1 作为 Slave，实现 Master 下发、Slave echo 的功能，并基于 Xilinx SPI 实现 3-wire SPI 的支持。

在开发软件程序的时候发现 Xilinx SPI 的功能比较复杂。在 Master 模式下，使用 `XSpiPs_PolledTransfer()` 可以驱动 SCLK 工作，会发送 Tx buffer 的数据到 MOSI 端口，并将 SCLK 持续过程中 MISO 端口的数据接收到 Rx buffer 中，过程中各端口的三态控制保持不变，因此无法使用三态信号控制 3-wire SPI 的 Input/Output 管脚。

目前对于 3-wire SPI 的初步想法是先写后读，使用 1-bit GPIO 对 IO 管脚进行 tri-state 控制，但是这样会造成 SCLK 不连续，也会造成 CS 信号的中断，暂时无法确定对 Slave 的 SPI 状态机有无影响；CS 信号是否持续可以通过寄存器 `XSPIPS_FORCE_SSELECT_OPTION` 控制。

## 扩展功能

本程序还启用了两个 IIC Controller，同样想要开发使用 IIC 0 作为 Master，使用 IIC 1 作为 Slave，实现 Master 下发、Slave echo 的功能。
