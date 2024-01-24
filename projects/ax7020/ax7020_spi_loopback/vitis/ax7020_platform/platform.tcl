# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/vitis/ax7020_platform/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/vitis/ax7020_platform/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {ax7020_platform}\
-hw {/home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/ax7020_spi_loopback.xsa}\
-proc {ps7_cortexa9_0} -os {standalone} -out {/home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/vitis}

platform write
platform generate -domains 
platform active {ax7020_platform}
bsp reload
platform generate
domain active {zynq_fsbl}
domain active {standalone_domain}
bsp reload
bsp reload
platform generate -domains 
platform config -updatehw {/home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/ax7020_spi_loopback.xsa}
platform generate -domains 
platform config -updatehw {/home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/system_bd_wrapper.xsa}
platform generate -domains 
platform config -updatehw {/home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/system_bd_wrapper.xsa}
platform generate -domains 
platform config -updatehw {/home/josh/Workspace/vivado/vivado_pub/projects/ax7020/ax7020_spi_loopback/system_bd_wrapper.xsa}
platform generate -domains 
bsp reload
platform generate -domains 
domain active {zynq_fsbl}
bsp reload
bsp reload
