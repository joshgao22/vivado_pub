###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_xfer_state*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *d_xfer_toggle_m*}]

set_false_path -from [get_cells -hier -filter {name =~ *d_xfer_toggle_reg   && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *up_xfer_state_m1_reg   && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *up_xfer_toggle_reg  && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *d_xfer_toggle_m1_reg   && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *up_xfer_data*       && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *d_data_cntrl*          && IS_SEQUENTIAL}]
