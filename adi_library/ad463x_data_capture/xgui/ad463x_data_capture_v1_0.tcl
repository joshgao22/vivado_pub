# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DDR_EN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_OF_LANES" -parent ${Page_0}


}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DDR_EN { PARAM_VALUE.DDR_EN } {
	# Procedure called to update DDR_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DDR_EN { PARAM_VALUE.DDR_EN } {
	# Procedure called to validate DDR_EN
	return true
}

proc update_PARAM_VALUE.NUM_OF_LANES { PARAM_VALUE.NUM_OF_LANES } {
	# Procedure called to update NUM_OF_LANES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_OF_LANES { PARAM_VALUE.NUM_OF_LANES } {
	# Procedure called to validate NUM_OF_LANES
	return true
}


proc update_MODELPARAM_VALUE.DDR_EN { MODELPARAM_VALUE.DDR_EN PARAM_VALUE.DDR_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DDR_EN}] ${MODELPARAM_VALUE.DDR_EN}
}

proc update_MODELPARAM_VALUE.NUM_OF_LANES { MODELPARAM_VALUE.NUM_OF_LANES PARAM_VALUE.NUM_OF_LANES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_OF_LANES}] ${MODELPARAM_VALUE.NUM_OF_LANES}
}

proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

