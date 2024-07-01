set (CMAKE_SYSTEM_PROCESSOR "microblaze" CACHE STRING "")
set (MACHINE "microblaze_generic")
set (CROSS_PREFIX "mb-" CACHE STRING "")
set (CMAKE_C_FLAGS " -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mxl-soft-mul -mcpu=v9.2  -mlittle-endian -g -ffunction-sections -fdata-sections -Wall -Wextra -fno-tree-loop-distribute-patterns  -Os -flto -ffat-lto-objects -I/home/josh/Workspace/vivado/vivado_pub/projects/rfsoc_eval/rfsoc_eval_demo/vitis_classic/rfsoc_eval_platform/zynqmp_pmufw/zynqmp_pmufw_bsp/psu_pmu_0/include" CACHE STRING "")
set (CMAKE_SYSTEM_NAME "Generic" CACHE STRING "")
include (CMakeForceCompiler)
CMAKE_FORCE_C_COMPILER ("${CROSS_PREFIX}gcc" GNU)
CMAKE_FORCE_CXX_COMPILER ("${CROSS_PREFIX}g++" GNU)
set (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE STRING "")
set (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER CACHE STRING "")
set (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER CACHE STRING "")
