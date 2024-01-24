# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: /home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/vitis/ax7020_spi_system/_ide/scripts/debugger_ax7020_spi-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source /home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/vitis/ax7020_spi_system/_ide/scripts/debugger_ax7020_spi-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent JTAG-HS1 210512180081" && level==0 && jtag_device_ctx=="jsn-JTAG-HS1-210512180081-23727093-0"}
fpga -file /home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/vitis/ax7020_spi/_ide/bitstream/system_bd_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw /home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/vitis/ax7020_platform/export/ax7020_platform/hw/system_bd_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source /home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/vitis/ax7020_spi/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow /home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/vitis/ax7020_spi/Debug/ax7020_spi.elf
configparams force-mem-access 0
bpadd -addr &main
