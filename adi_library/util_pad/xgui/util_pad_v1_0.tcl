# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "IN_BITS_PER_SAMPLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_OF_SAMPLES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OUT_BITS_PER_SAMPLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PADDING_TO_MSB_LSB_N" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SIGN_EXTEND" -parent ${Page_0}


}

proc update_PARAM_VALUE.IN_BITS_PER_SAMPLE { PARAM_VALUE.IN_BITS_PER_SAMPLE } {
	# Procedure called to update IN_BITS_PER_SAMPLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IN_BITS_PER_SAMPLE { PARAM_VALUE.IN_BITS_PER_SAMPLE } {
	# Procedure called to validate IN_BITS_PER_SAMPLE
	return true
}

proc update_PARAM_VALUE.NUM_OF_SAMPLES { PARAM_VALUE.NUM_OF_SAMPLES } {
	# Procedure called to update NUM_OF_SAMPLES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_OF_SAMPLES { PARAM_VALUE.NUM_OF_SAMPLES } {
	# Procedure called to validate NUM_OF_SAMPLES
	return true
}

proc update_PARAM_VALUE.OUT_BITS_PER_SAMPLE { PARAM_VALUE.OUT_BITS_PER_SAMPLE } {
	# Procedure called to update OUT_BITS_PER_SAMPLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OUT_BITS_PER_SAMPLE { PARAM_VALUE.OUT_BITS_PER_SAMPLE } {
	# Procedure called to validate OUT_BITS_PER_SAMPLE
	return true
}

proc update_PARAM_VALUE.PADDING_TO_MSB_LSB_N { PARAM_VALUE.PADDING_TO_MSB_LSB_N } {
	# Procedure called to update PADDING_TO_MSB_LSB_N when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PADDING_TO_MSB_LSB_N { PARAM_VALUE.PADDING_TO_MSB_LSB_N } {
	# Procedure called to validate PADDING_TO_MSB_LSB_N
	return true
}

proc update_PARAM_VALUE.SIGN_EXTEND { PARAM_VALUE.SIGN_EXTEND } {
	# Procedure called to update SIGN_EXTEND when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIGN_EXTEND { PARAM_VALUE.SIGN_EXTEND } {
	# Procedure called to validate SIGN_EXTEND
	return true
}


proc update_MODELPARAM_VALUE.NUM_OF_SAMPLES { MODELPARAM_VALUE.NUM_OF_SAMPLES PARAM_VALUE.NUM_OF_SAMPLES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_OF_SAMPLES}] ${MODELPARAM_VALUE.NUM_OF_SAMPLES}
}

proc update_MODELPARAM_VALUE.IN_BITS_PER_SAMPLE { MODELPARAM_VALUE.IN_BITS_PER_SAMPLE PARAM_VALUE.IN_BITS_PER_SAMPLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IN_BITS_PER_SAMPLE}] ${MODELPARAM_VALUE.IN_BITS_PER_SAMPLE}
}

proc update_MODELPARAM_VALUE.OUT_BITS_PER_SAMPLE { MODELPARAM_VALUE.OUT_BITS_PER_SAMPLE PARAM_VALUE.OUT_BITS_PER_SAMPLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OUT_BITS_PER_SAMPLE}] ${MODELPARAM_VALUE.OUT_BITS_PER_SAMPLE}
}

proc update_MODELPARAM_VALUE.PADDING_TO_MSB_LSB_N { MODELPARAM_VALUE.PADDING_TO_MSB_LSB_N PARAM_VALUE.PADDING_TO_MSB_LSB_N } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PADDING_TO_MSB_LSB_N}] ${MODELPARAM_VALUE.PADDING_TO_MSB_LSB_N}
}

proc update_MODELPARAM_VALUE.SIGN_EXTEND { MODELPARAM_VALUE.SIGN_EXTEND PARAM_VALUE.SIGN_EXTEND } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIGN_EXTEND}] ${MODELPARAM_VALUE.SIGN_EXTEND}
}

