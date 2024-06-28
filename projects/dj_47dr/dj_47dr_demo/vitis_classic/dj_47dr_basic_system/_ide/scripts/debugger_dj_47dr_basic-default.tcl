# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: /home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/vitis_classic/dj_47dr_basic_system/_ide/scripts/debugger_dj_47dr_basic-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source /home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/vitis_classic/dj_47dr_basic_system/_ide/scripts/debugger_dj_47dr_basic-default.tcl
# 
connect -url tcp:127.0.0.1:3121
source /tools/Xilinx/Vitis/2024.1/scripts/vitis/util/zynqmp_utils.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent JTAG-HS1 210512180081" && jtag_device_ctx=="jsn-JTAG-HS1-210512180081-5ba00477-0"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent JTAG-HS1 210512180081" && level==0 && jtag_device_ctx=="jsn-JTAG-HS1-210512180081-147ff093-0"}
fpga -file /home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/vitis_classic/dj_47dr_basic/_ide/bitstream/system_top.bit
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent JTAG-HS1 210512180081" && jtag_device_ctx=="jsn-JTAG-HS1-210512180081-5ba00477-0"}
loadhw -hw /home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/vitis_classic/dj_47dr_platform/export/dj_47dr_platform/hw/system_top.xsa -mem-ranges [list {0x80000000 0xbfffffff} {0x400000000 0x5ffffffff} {0x1000000000 0x7fffffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent JTAG-HS1 210512180081" && jtag_device_ctx=="jsn-JTAG-HS1-210512180081-5ba00477-0"}
set mode [expr [mrd -value 0xFF5E0200] & 0xf]
targets -set -nocase -filter {name =~ "*A53*#0" && jtag_cable_name =~ "Digilent JTAG-HS1 210512180081" && jtag_device_ctx=="jsn-JTAG-HS1-210512180081-5ba00477-0"}
rst -processor
dow /home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/vitis_classic/dj_47dr_platform/export/dj_47dr_platform/sw/dj_47dr_platform/boot/fsbl.elf
set bp_54_45_fsbl_bp [bpadd -addr &XFsbl_Exit]
con -block -timeout 60
bpremove $bp_54_45_fsbl_bp
targets -set -nocase -filter {name =~ "*A53*#0" && jtag_cable_name =~ "Digilent JTAG-HS1 210512180081" && jtag_device_ctx=="jsn-JTAG-HS1-210512180081-5ba00477-0"}
rst -processor
dow /home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/vitis_classic/dj_47dr_basic/Debug/dj_47dr_basic.elf
configparams force-mem-access 0
bpadd -addr &main
