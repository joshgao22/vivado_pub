# README.md

> Vivado Project Name: dj_47dr_demo
>
> Vitis Project Name: dj_47dr_tcp_perf_server
>
> Board: RFSOC_47DR_Z7045
>
> Device: xczu47dr-2ffve1156i(u15)
>
> Date: 2024/07/01
>
> Archiver: Josh Gao

1. 注意事项

   本工程启用了动态 DDR 配置，依赖于 FSBL 启动，在启动时 FSBL 会使用 I2C 读取 DDR 的 SPD EEPROM 获得 DDR 参数，并初始化 DDR 控制器。

   由于原理图与 Xilinx 开发板 I2C Mux Slave 连接不一致，FSBL 已将 I2C Mux 的 Slave 选择改为 `0x04`。若重新建立 PS 工程，注意修改 FSBL，否则可能无法正常启动。

2. 实现的功能

   - 使用 TCP Performance Server 测试历程，测试板卡到 PC 的速率，测试结果如下：

     ``` plain
     [josh@gatsby-dev ~]$ iperf -c 192.168.253.195 -i 2 -t 30 -w 2M
     ------------------------------------------------------------
     Client connecting to 192.168.253.195, TCP port 5001
     TCP window size:  416 KByte (WARNING: requested 2.00 MByte)
     ------------------------------------------------------------
     [  1] local 192.168.253.253 port 40280 connected with 192.168.253.195 port 5001
     [ ID] Interval       Transfer     Bandwidth
     [  1] 0.00-2.00 sec   220 MBytes   924 Mbits/sec
     [  1] 2.00-4.00 sec   226 MBytes   947 Mbits/sec
     [  1] 4.00-6.00 sec   221 MBytes   926 Mbits/sec
     [  1] 6.00-8.00 sec   225 MBytes   945 Mbits/sec
     [  1] 8.00-10.00 sec   226 MBytes   946 Mbits/sec
     [  1] 10.00-12.00 sec   222 MBytes   932 Mbits/sec
     [  1] 12.00-14.00 sec   225 MBytes   945 Mbits/sec
     [  1] 14.00-16.00 sec   223 MBytes   936 Mbits/sec
     [  1] 16.00-18.00 sec   225 MBytes   945 Mbits/sec
     [  1] 18.00-20.00 sec   225 MBytes   945 Mbits/sec
     [  1] 20.00-22.00 sec   222 MBytes   933 Mbits/sec
     [  1] 22.00-24.00 sec   226 MBytes   946 Mbits/sec
     [  1] 24.00-26.00 sec   224 MBytes   939 Mbits/sec
     [  1] 26.00-28.00 sec   225 MBytes   945 Mbits/sec
     [  1] 28.00-30.00 sec   225 MBytes   945 Mbits/sec
     [  1] 0.00-30.01 sec  3.28 GBytes   940 Mbits/sec
     ```

3. 存在的问题

   暂无。
