# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/josh/Workspace/vivado/vivado_pub/projects/rfsoc_eval/rfsoc_eval_demo/vitis_classic/rfsoc_eval_platform/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/josh/Workspace/vivado/vivado_pub/projects/rfsoc_eval/rfsoc_eval_demo/vitis_classic/rfsoc_eval_platform/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {rfsoc_eval_platform}\
-hw {/home/josh/Workspace/vivado/vivado_pub/projects/rfsoc_eval/rfsoc_eval_demo/system_top.xsa}\
-arch {64-bit} -fsbl-target {psu_cortexa53_0} -out {/home/josh/Workspace/vivado/vivado_pub/projects/rfsoc_eval/rfsoc_eval_demo/vitis_classic}

platform write
domain create -name {standalone_psu_cortexa53_0} -display-name {standalone_psu_cortexa53_0} -os {standalone} -proc {psu_cortexa53_0} -runtime {cpp} -arch {64-bit} -support-app {empty_application}
platform generate -domains 
platform active {rfsoc_eval_platform}
domain active {zynqmp_fsbl}
domain active {zynqmp_pmufw}
domain active {standalone_psu_cortexa53_0}
platform generate -quick
platform generate
