# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/vitis_classic/dj_47dr_platform/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/vitis_classic/dj_47dr_platform/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {dj_47dr_platform}\
-hw {/home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/system_top.xsa}\
-arch {64-bit} -fsbl-target {psu_cortexa53_0} -out {/home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/vitis_classic}

platform write
domain create -name {standalone_psu_cortexa53_0} -display-name {standalone_psu_cortexa53_0} -os {standalone} -proc {psu_cortexa53_0} -runtime {cpp} -arch {64-bit} -support-app {empty_application}
platform generate -domains 
platform active {dj_47dr_platform}
domain active {zynqmp_fsbl}
domain active {zynqmp_pmufw}
domain active {standalone_psu_cortexa53_0}
platform generate -quick
platform generate
platform config -updatehw {/home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/system_top.xsa}
platform generate -domains 
bsp reload
bsp setlib -name xilffs -ver 5.2
bsp setlib -name xilpm -ver 5.2
bsp setlib -name xilsecure -ver 5.3
bsp write
bsp reload
catch {bsp regenerate}
bsp config extra_compiler_flags "-g -Wall -Wextra -fno-tree-loop-distribute-patterns"
bsp config extra_compiler_flags "-g -Wall -Wextra -Os"
bsp config stdin "psu_coresight_0"
bsp config stdout "psu_coresight_0"
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains standalone_psu_cortexa53_0 
bsp config extra_compiler_flags "-g -Wall -Wextra -Os"
bsp config extra_compiler_flags "-g -Wall -Wextra -Os"
bsp reload
platform active {dj_47dr_platform}
platform generate -domains 
platform generate -domains zynqmp_fsbl 
platform active {dj_47dr_platform}
bsp reload
bsp reload
catch {bsp regenerate}
bsp config extra_compiler_flags "-g -Wall -Wextra -Os"
bsp reload
platform generate -domains standalone_psu_cortexa53_0 
bsp reload
bsp reload
platform config -updatehw {home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/system_top.xsa}
platform config -updatehw {/home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/system_top.xsa}
platform generate -domains 
platform active {dj_47dr_platform}
platform active {dj_47dr_platform}
platform config -updatehw {/home/josh/Workspace/vivado/vivado_pub/projects/dj_47dr/dj_47dr_demo/system_top.xsa}
bsp reload
bsp setlib -name lwip220 -ver 1.0
bsp config mem_size "524288"
bsp config memp_n_pbuf "2048"
bsp config memp_n_tcp_pcb "1024"
bsp config memp_n_tcp_seg "1024"
bsp config pbuf_pool_size "1096"
bsp config pbuf_pool_size "4096"
bsp write
bsp reload
catch {bsp regenerate}
platform generate
bsp config lwip_dhcp "true"
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains standalone_psu_cortexa53_0 
bsp config tcp_snd_buf "65535"
bsp config tcp_wnd "65535"
bsp config tcp_ip_rx_checksum_offload "true"
bsp config tcp_ip_tx_checksum_offload "true"
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains standalone_psu_cortexa53_0 
