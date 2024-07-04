# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_lmx/vitis_classic/dj_47dr_platform/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_lmx/vitis_classic/dj_47dr_platform/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {dj_47dr_platform}\
-hw {/home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_lmx/system_top.xsa}\
-arch {64-bit} -fsbl-target {psu_cortexa53_0} -out {/home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_lmx/vitis_classic}

platform write
domain create -name {standalone_psu_cortexa53_0} -display-name {standalone_psu_cortexa53_0} -os {standalone} -proc {psu_cortexa53_0} -runtime {cpp} -arch {64-bit} -support-app {empty_application}
platform generate -domains 
platform active {dj_47dr_platform}
domain active {zynqmp_fsbl}
domain active {zynqmp_pmufw}
domain active {standalone_psu_cortexa53_0}
platform generate -quick
bsp reload
bsp config stdin "psu_coresight_0"
bsp config stdout "psu_coresight_0"
bsp write
bsp reload
catch {bsp regenerate}
platform generate
platform generate -domains zynqmp_fsbl 
platform config -updatehw {/home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_lmx/system_top.xsa}
platform generate -domains 
