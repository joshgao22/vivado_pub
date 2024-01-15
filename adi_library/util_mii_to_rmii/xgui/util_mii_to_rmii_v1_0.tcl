# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "INTF_CFG" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "RATE_10_100" -parent ${Page_0} -widget comboBox


}

proc update_PARAM_VALUE.INTF_CFG { PARAM_VALUE.INTF_CFG } {
	# Procedure called to update INTF_CFG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INTF_CFG { PARAM_VALUE.INTF_CFG } {
	# Procedure called to validate INTF_CFG
	return true
}

proc update_PARAM_VALUE.RATE_10_100 { PARAM_VALUE.RATE_10_100 } {
	# Procedure called to update RATE_10_100 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RATE_10_100 { PARAM_VALUE.RATE_10_100 } {
	# Procedure called to validate RATE_10_100
	return true
}


proc update_MODELPARAM_VALUE.INTF_CFG { MODELPARAM_VALUE.INTF_CFG PARAM_VALUE.INTF_CFG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INTF_CFG}] ${MODELPARAM_VALUE.INTF_CFG}
}

proc update_MODELPARAM_VALUE.RATE_10_100 { MODELPARAM_VALUE.RATE_10_100 PARAM_VALUE.RATE_10_100 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RATE_10_100}] ${MODELPARAM_VALUE.RATE_10_100}
}

