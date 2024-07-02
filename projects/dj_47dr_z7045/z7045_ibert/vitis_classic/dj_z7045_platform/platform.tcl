# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr_z7045/z7045_ibert/vitis_classic/dj_z7045_platform/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr_z7045/z7045_ibert/vitis_classic/dj_z7045_platform/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {dj_z7045_platform}\
-hw {/home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr_z7045/z7045_ibert/system_top.xsa}\
-out {/home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr_z7045/z7045_ibert/vitis_classic}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {zynq_fsbl}
platform generate -domains 
platform write
domain active {zynq_fsbl}
domain active {standalone_ps7_cortexa9_0}
platform generate -quick
domain active {zynq_fsbl}
bsp reload
domain active {standalone_ps7_cortexa9_0}
bsp reload
bsp reload
platform generate
platform active {dj_z7045_platform}
platform config -updatehw {/home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr_z7045/z7045_ibert/system_top.xsa}
platform generate -domains 
platform config -updatehw {/home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr_z7045/z7045_ibert/system_top.xsa}
platform generate -domains 
