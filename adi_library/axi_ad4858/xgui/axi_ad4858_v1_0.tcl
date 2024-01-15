
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/axi_ad4858_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DELAY_REFCLK_FREQ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ECHO_CLK_EN" -parent ${Page_0} -widget checkBox
  set EXTERNAL_CLK [ipgui::add_param $IPINST -name "EXTERNAL_CLK" -parent ${Page_0} -widget checkBox]
  set_property tooltip {External clock for interface logic, must be 2x faster than IF clk} ${EXTERNAL_CLK}
  ipgui::add_param $IPINST -name "ID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IODELAY_ENABLE" -parent ${Page_0}
  set LANE_0_ENABLE [ipgui::add_param $IPINST -name "LANE_0_ENABLE" -parent ${Page_0}]
  set_property tooltip {Lane 0 is used} ${LANE_0_ENABLE}
  set LANE_1_ENABLE [ipgui::add_param $IPINST -name "LANE_1_ENABLE" -parent ${Page_0}]
  set_property tooltip {Lane 1 is used} ${LANE_1_ENABLE}
  set LANE_2_ENABLE [ipgui::add_param $IPINST -name "LANE_2_ENABLE" -parent ${Page_0}]
  set_property tooltip {Lane 2 is used} ${LANE_2_ENABLE}
  set LANE_3_ENABLE [ipgui::add_param $IPINST -name "LANE_3_ENABLE" -parent ${Page_0}]
  set_property tooltip {Lane 3 is used} ${LANE_3_ENABLE}
  set LANE_4_ENABLE [ipgui::add_param $IPINST -name "LANE_4_ENABLE" -parent ${Page_0}]
  set_property tooltip {Lane 4 is used} ${LANE_4_ENABLE}
  set LANE_5_ENABLE [ipgui::add_param $IPINST -name "LANE_5_ENABLE" -parent ${Page_0}]
  set_property tooltip {Lane 5 is used} ${LANE_5_ENABLE}
  set LANE_6_ENABLE [ipgui::add_param $IPINST -name "LANE_6_ENABLE" -parent ${Page_0}]
  set_property tooltip {Lane 6 is used} ${LANE_6_ENABLE}
  set LANE_7_ENABLE [ipgui::add_param $IPINST -name "LANE_7_ENABLE" -parent ${Page_0}]
  set_property tooltip {Lane 7 is used} ${LANE_7_ENABLE}
  ipgui::add_param $IPINST -name "LVDS_CMOS_N" -parent ${Page_0}
  #Adding Group
  set FPGA_info [ipgui::add_group $IPINST -name "FPGA info" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "FPGA_TECHNOLOGY" -parent ${FPGA_info} -widget comboBox



}

proc update_PARAM_VALUE.LANE_0_ENABLE { PARAM_VALUE.LANE_0_ENABLE PARAM_VALUE.LVDS_CMOS_N } {
	# Procedure called to update LANE_0_ENABLE when any of the dependent parameters in the arguments change
	
	set LANE_0_ENABLE ${PARAM_VALUE.LANE_0_ENABLE}
	set LVDS_CMOS_N ${PARAM_VALUE.LVDS_CMOS_N}
	set values(LVDS_CMOS_N) [get_property value $LVDS_CMOS_N]
	if { [gen_USERPARAMETER_LANE_0_ENABLE_ENABLEMENT $values(LVDS_CMOS_N)] } {
		set_property enabled true $LANE_0_ENABLE
	} else {
		set_property enabled false $LANE_0_ENABLE
	}
}

proc validate_PARAM_VALUE.LANE_0_ENABLE { PARAM_VALUE.LANE_0_ENABLE } {
	# Procedure called to validate LANE_0_ENABLE
	return true
}

proc update_PARAM_VALUE.LANE_1_ENABLE { PARAM_VALUE.LANE_1_ENABLE PARAM_VALUE.LVDS_CMOS_N } {
	# Procedure called to update LANE_1_ENABLE when any of the dependent parameters in the arguments change
	
	set LANE_1_ENABLE ${PARAM_VALUE.LANE_1_ENABLE}
	set LVDS_CMOS_N ${PARAM_VALUE.LVDS_CMOS_N}
	set values(LVDS_CMOS_N) [get_property value $LVDS_CMOS_N]
	if { [gen_USERPARAMETER_LANE_1_ENABLE_ENABLEMENT $values(LVDS_CMOS_N)] } {
		set_property enabled true $LANE_1_ENABLE
	} else {
		set_property enabled false $LANE_1_ENABLE
	}
}

proc validate_PARAM_VALUE.LANE_1_ENABLE { PARAM_VALUE.LANE_1_ENABLE } {
	# Procedure called to validate LANE_1_ENABLE
	return true
}

proc update_PARAM_VALUE.LANE_2_ENABLE { PARAM_VALUE.LANE_2_ENABLE PARAM_VALUE.LVDS_CMOS_N } {
	# Procedure called to update LANE_2_ENABLE when any of the dependent parameters in the arguments change
	
	set LANE_2_ENABLE ${PARAM_VALUE.LANE_2_ENABLE}
	set LVDS_CMOS_N ${PARAM_VALUE.LVDS_CMOS_N}
	set values(LVDS_CMOS_N) [get_property value $LVDS_CMOS_N]
	if { [gen_USERPARAMETER_LANE_2_ENABLE_ENABLEMENT $values(LVDS_CMOS_N)] } {
		set_property enabled true $LANE_2_ENABLE
	} else {
		set_property enabled false $LANE_2_ENABLE
	}
}

proc validate_PARAM_VALUE.LANE_2_ENABLE { PARAM_VALUE.LANE_2_ENABLE } {
	# Procedure called to validate LANE_2_ENABLE
	return true
}

proc update_PARAM_VALUE.LANE_3_ENABLE { PARAM_VALUE.LANE_3_ENABLE PARAM_VALUE.LVDS_CMOS_N } {
	# Procedure called to update LANE_3_ENABLE when any of the dependent parameters in the arguments change
	
	set LANE_3_ENABLE ${PARAM_VALUE.LANE_3_ENABLE}
	set LVDS_CMOS_N ${PARAM_VALUE.LVDS_CMOS_N}
	set values(LVDS_CMOS_N) [get_property value $LVDS_CMOS_N]
	if { [gen_USERPARAMETER_LANE_3_ENABLE_ENABLEMENT $values(LVDS_CMOS_N)] } {
		set_property enabled true $LANE_3_ENABLE
	} else {
		set_property enabled false $LANE_3_ENABLE
	}
}

proc validate_PARAM_VALUE.LANE_3_ENABLE { PARAM_VALUE.LANE_3_ENABLE } {
	# Procedure called to validate LANE_3_ENABLE
	return true
}

proc update_PARAM_VALUE.LANE_4_ENABLE { PARAM_VALUE.LANE_4_ENABLE PARAM_VALUE.LVDS_CMOS_N } {
	# Procedure called to update LANE_4_ENABLE when any of the dependent parameters in the arguments change
	
	set LANE_4_ENABLE ${PARAM_VALUE.LANE_4_ENABLE}
	set LVDS_CMOS_N ${PARAM_VALUE.LVDS_CMOS_N}
	set values(LVDS_CMOS_N) [get_property value $LVDS_CMOS_N]
	if { [gen_USERPARAMETER_LANE_4_ENABLE_ENABLEMENT $values(LVDS_CMOS_N)] } {
		set_property enabled true $LANE_4_ENABLE
	} else {
		set_property enabled false $LANE_4_ENABLE
	}
}

proc validate_PARAM_VALUE.LANE_4_ENABLE { PARAM_VALUE.LANE_4_ENABLE } {
	# Procedure called to validate LANE_4_ENABLE
	return true
}

proc update_PARAM_VALUE.LANE_5_ENABLE { PARAM_VALUE.LANE_5_ENABLE PARAM_VALUE.LVDS_CMOS_N } {
	# Procedure called to update LANE_5_ENABLE when any of the dependent parameters in the arguments change
	
	set LANE_5_ENABLE ${PARAM_VALUE.LANE_5_ENABLE}
	set LVDS_CMOS_N ${PARAM_VALUE.LVDS_CMOS_N}
	set values(LVDS_CMOS_N) [get_property value $LVDS_CMOS_N]
	if { [gen_USERPARAMETER_LANE_5_ENABLE_ENABLEMENT $values(LVDS_CMOS_N)] } {
		set_property enabled true $LANE_5_ENABLE
	} else {
		set_property enabled false $LANE_5_ENABLE
	}
}

proc validate_PARAM_VALUE.LANE_5_ENABLE { PARAM_VALUE.LANE_5_ENABLE } {
	# Procedure called to validate LANE_5_ENABLE
	return true
}

proc update_PARAM_VALUE.LANE_6_ENABLE { PARAM_VALUE.LANE_6_ENABLE PARAM_VALUE.LVDS_CMOS_N } {
	# Procedure called to update LANE_6_ENABLE when any of the dependent parameters in the arguments change
	
	set LANE_6_ENABLE ${PARAM_VALUE.LANE_6_ENABLE}
	set LVDS_CMOS_N ${PARAM_VALUE.LVDS_CMOS_N}
	set values(LVDS_CMOS_N) [get_property value $LVDS_CMOS_N]
	if { [gen_USERPARAMETER_LANE_6_ENABLE_ENABLEMENT $values(LVDS_CMOS_N)] } {
		set_property enabled true $LANE_6_ENABLE
	} else {
		set_property enabled false $LANE_6_ENABLE
	}
}

proc validate_PARAM_VALUE.LANE_6_ENABLE { PARAM_VALUE.LANE_6_ENABLE } {
	# Procedure called to validate LANE_6_ENABLE
	return true
}

proc update_PARAM_VALUE.LANE_7_ENABLE { PARAM_VALUE.LANE_7_ENABLE PARAM_VALUE.LVDS_CMOS_N } {
	# Procedure called to update LANE_7_ENABLE when any of the dependent parameters in the arguments change
	
	set LANE_7_ENABLE ${PARAM_VALUE.LANE_7_ENABLE}
	set LVDS_CMOS_N ${PARAM_VALUE.LVDS_CMOS_N}
	set values(LVDS_CMOS_N) [get_property value $LVDS_CMOS_N]
	if { [gen_USERPARAMETER_LANE_7_ENABLE_ENABLEMENT $values(LVDS_CMOS_N)] } {
		set_property enabled true $LANE_7_ENABLE
	} else {
		set_property enabled false $LANE_7_ENABLE
	}
}

proc validate_PARAM_VALUE.LANE_7_ENABLE { PARAM_VALUE.LANE_7_ENABLE } {
	# Procedure called to validate LANE_7_ENABLE
	return true
}

proc update_PARAM_VALUE.DELAY_REFCLK_FREQ { PARAM_VALUE.DELAY_REFCLK_FREQ } {
	# Procedure called to update DELAY_REFCLK_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_REFCLK_FREQ { PARAM_VALUE.DELAY_REFCLK_FREQ } {
	# Procedure called to validate DELAY_REFCLK_FREQ
	return true
}

proc update_PARAM_VALUE.ECHO_CLK_EN { PARAM_VALUE.ECHO_CLK_EN } {
	# Procedure called to update ECHO_CLK_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ECHO_CLK_EN { PARAM_VALUE.ECHO_CLK_EN } {
	# Procedure called to validate ECHO_CLK_EN
	return true
}

proc update_PARAM_VALUE.EXTERNAL_CLK { PARAM_VALUE.EXTERNAL_CLK } {
	# Procedure called to update EXTERNAL_CLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXTERNAL_CLK { PARAM_VALUE.EXTERNAL_CLK } {
	# Procedure called to validate EXTERNAL_CLK
	return true
}

proc update_PARAM_VALUE.FPGA_TECHNOLOGY { PARAM_VALUE.FPGA_TECHNOLOGY } {
	# Procedure called to update FPGA_TECHNOLOGY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FPGA_TECHNOLOGY { PARAM_VALUE.FPGA_TECHNOLOGY } {
	# Procedure called to validate FPGA_TECHNOLOGY
	return true
}

proc update_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to update ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to validate ID
	return true
}

proc update_PARAM_VALUE.IODELAY_ENABLE { PARAM_VALUE.IODELAY_ENABLE } {
	# Procedure called to update IODELAY_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IODELAY_ENABLE { PARAM_VALUE.IODELAY_ENABLE } {
	# Procedure called to validate IODELAY_ENABLE
	return true
}

proc update_PARAM_VALUE.LVDS_CMOS_N { PARAM_VALUE.LVDS_CMOS_N } {
	# Procedure called to update LVDS_CMOS_N when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LVDS_CMOS_N { PARAM_VALUE.LVDS_CMOS_N } {
	# Procedure called to validate LVDS_CMOS_N
	return true
}


proc update_MODELPARAM_VALUE.FPGA_TECHNOLOGY { MODELPARAM_VALUE.FPGA_TECHNOLOGY PARAM_VALUE.FPGA_TECHNOLOGY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FPGA_TECHNOLOGY}] ${MODELPARAM_VALUE.FPGA_TECHNOLOGY}
}

proc update_MODELPARAM_VALUE.DELAY_REFCLK_FREQ { MODELPARAM_VALUE.DELAY_REFCLK_FREQ PARAM_VALUE.DELAY_REFCLK_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_REFCLK_FREQ}] ${MODELPARAM_VALUE.DELAY_REFCLK_FREQ}
}

proc update_MODELPARAM_VALUE.IODELAY_ENABLE { MODELPARAM_VALUE.IODELAY_ENABLE PARAM_VALUE.IODELAY_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IODELAY_ENABLE}] ${MODELPARAM_VALUE.IODELAY_ENABLE}
}

proc update_MODELPARAM_VALUE.ID { MODELPARAM_VALUE.ID PARAM_VALUE.ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ID}] ${MODELPARAM_VALUE.ID}
}

proc update_MODELPARAM_VALUE.LVDS_CMOS_N { MODELPARAM_VALUE.LVDS_CMOS_N PARAM_VALUE.LVDS_CMOS_N } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LVDS_CMOS_N}] ${MODELPARAM_VALUE.LVDS_CMOS_N}
}

proc update_MODELPARAM_VALUE.LANE_0_ENABLE { MODELPARAM_VALUE.LANE_0_ENABLE PARAM_VALUE.LANE_0_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LANE_0_ENABLE}] ${MODELPARAM_VALUE.LANE_0_ENABLE}
}

proc update_MODELPARAM_VALUE.LANE_1_ENABLE { MODELPARAM_VALUE.LANE_1_ENABLE PARAM_VALUE.LANE_1_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LANE_1_ENABLE}] ${MODELPARAM_VALUE.LANE_1_ENABLE}
}

proc update_MODELPARAM_VALUE.LANE_2_ENABLE { MODELPARAM_VALUE.LANE_2_ENABLE PARAM_VALUE.LANE_2_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LANE_2_ENABLE}] ${MODELPARAM_VALUE.LANE_2_ENABLE}
}

proc update_MODELPARAM_VALUE.LANE_3_ENABLE { MODELPARAM_VALUE.LANE_3_ENABLE PARAM_VALUE.LANE_3_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LANE_3_ENABLE}] ${MODELPARAM_VALUE.LANE_3_ENABLE}
}

proc update_MODELPARAM_VALUE.LANE_4_ENABLE { MODELPARAM_VALUE.LANE_4_ENABLE PARAM_VALUE.LANE_4_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LANE_4_ENABLE}] ${MODELPARAM_VALUE.LANE_4_ENABLE}
}

proc update_MODELPARAM_VALUE.LANE_5_ENABLE { MODELPARAM_VALUE.LANE_5_ENABLE PARAM_VALUE.LANE_5_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LANE_5_ENABLE}] ${MODELPARAM_VALUE.LANE_5_ENABLE}
}

proc update_MODELPARAM_VALUE.LANE_6_ENABLE { MODELPARAM_VALUE.LANE_6_ENABLE PARAM_VALUE.LANE_6_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LANE_6_ENABLE}] ${MODELPARAM_VALUE.LANE_6_ENABLE}
}

proc update_MODELPARAM_VALUE.LANE_7_ENABLE { MODELPARAM_VALUE.LANE_7_ENABLE PARAM_VALUE.LANE_7_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LANE_7_ENABLE}] ${MODELPARAM_VALUE.LANE_7_ENABLE}
}

proc update_MODELPARAM_VALUE.ECHO_CLK_EN { MODELPARAM_VALUE.ECHO_CLK_EN PARAM_VALUE.ECHO_CLK_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ECHO_CLK_EN}] ${MODELPARAM_VALUE.ECHO_CLK_EN}
}

proc update_MODELPARAM_VALUE.EXTERNAL_CLK { MODELPARAM_VALUE.EXTERNAL_CLK PARAM_VALUE.EXTERNAL_CLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXTERNAL_CLK}] ${MODELPARAM_VALUE.EXTERNAL_CLK}
}

