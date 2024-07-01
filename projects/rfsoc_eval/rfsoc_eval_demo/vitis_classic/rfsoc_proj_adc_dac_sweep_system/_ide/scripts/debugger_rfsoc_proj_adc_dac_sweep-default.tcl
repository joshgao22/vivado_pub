# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: /home/josh/Workspace/vivado/vivado_pub/projects/rfsoc_eval/rfsoc_eval_demo/vitis_classic/rfsoc_proj_adc_dac_sweep_system/_ide/scripts/debugger_rfsoc_proj_adc_dac_sweep-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source /home/josh/Workspace/vivado/vivado_pub/projects/rfsoc_eval/rfsoc_eval_demo/vitis_classic/rfsoc_proj_adc_dac_sweep_system/_ide/scripts/debugger_rfsoc_proj_adc_dac_sweep-default.tcl
# 
connect -url tcp:127.0.0.1:3121
source /tools/Xilinx/Vitis/2024.1/scripts/vitis/util/zynqmp_utils.tcl
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Xilinx HW-U1-VCU1525 FT4232H 12809621t348A" && level==0 && jtag_device_ctx=="jsn-HW-U1-VCU1525 FT4232H-12809621t348A-147fb093-0"}
fpga -file /home/josh/Workspace/vivado/vivado_pub/projects/rfsoc_eval/rfsoc_eval_demo/vitis_classic/rfsoc_proj_adc_dac_sweep/_ide/bitstream/system_top.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw /home/josh/Workspace/vivado/vivado_pub/projects/rfsoc_eval/rfsoc_eval_demo/vitis_classic/rfsoc_eval_platform/export/rfsoc_eval_platform/hw/system_top.xsa -mem-ranges [list {0x80000000 0xbfffffff} {0x400000000 0x5ffffffff} {0x1000000000 0x7fffffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
set mode [expr [mrd -value 0xFF5E0200] & 0xf]
targets -set -nocase -filter {name =~ "*A53*#0"}
rst -processor
dow /home/josh/Workspace/vivado/vivado_pub/projects/rfsoc_eval/rfsoc_eval_demo/vitis_classic/rfsoc_eval_platform/export/rfsoc_eval_platform/sw/rfsoc_eval_platform/boot/fsbl.elf
set bp_9_49_fsbl_bp [bpadd -addr &XFsbl_Exit]
con -block -timeout 60
bpremove $bp_9_49_fsbl_bp
targets -set -nocase -filter {name =~ "*A53*#0"}
rst -processor
dow /home/josh/Workspace/vivado/vivado_pub/projects/rfsoc_eval/rfsoc_eval_demo/vitis_classic/rfsoc_proj_adc_dac_sweep/Debug/rfsoc_proj_adc_dac_sweep.elf
configparams force-mem-access 0
bpadd -addr &main
