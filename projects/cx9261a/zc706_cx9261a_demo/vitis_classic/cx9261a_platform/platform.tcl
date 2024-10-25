# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/josh/Workspace/vivado/vivado_pub/projects/cx9261a/zc706_cx9261a_demo/vitis_classic/cx9261a_platform/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/josh/Workspace/vivado/vivado_pub/projects/cx9261a/zc706_cx9261a_demo/vitis_classic/cx9261a_platform/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {cx9261a_platform}\
-hw {/home/josh/Workspace/vivado/vivado_pub/projects/cx9261a/zc706_cx9261a_demo/system_top.xsa}\
-proc {ps7_cortexa9_0} -os {standalone} -out {/home/josh/Workspace/vivado/vivado_pub/projects/cx9261a/zc706_cx9261a_demo/vitis_classic}

platform write
platform generate -domains 
platform active {cx9261a_platform}
platform generate
bsp reload
bsp setlib -name xiltimer -ver 2.0
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains standalone_domain 
bsp reload
bsp reload
platform generate -domains 
bsp removelib -name xiltimer
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains standalone_domain 
