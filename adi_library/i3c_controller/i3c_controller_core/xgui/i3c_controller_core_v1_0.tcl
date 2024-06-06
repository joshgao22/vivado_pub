# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set I3C_Controller_Core [ipgui::add_page $IPINST -name "I3C Controller Core" -display_name {AXI I3C Controller Core}]
  #Adding Group
  set General_Configuration [ipgui::add_group $IPINST -name "General Configuration" -parent ${I3C_Controller_Core}]
  set MAX_DEVS [ipgui::add_param $IPINST -name "MAX_DEVS" -parent ${General_Configuration}]
  set_property tooltip {[MAX_DEVS] Maximum number of peripherals in the bus, counting the controller} ${MAX_DEVS}
  set CLK_MOD [ipgui::add_param $IPINST -name "CLK_MOD" -parent ${General_Configuration} -widget comboBox]
  set_property tooltip {[CLK_MOD] Adjust clock cycles required to modulate the lane bus bits. Set 8 to achieve 12.5MHz at 100Mhz input clock, and 4 at 50MHz.} ${CLK_MOD}



}

proc update_PARAM_VALUE.CLK_MOD { PARAM_VALUE.CLK_MOD } {
	# Procedure called to update CLK_MOD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLK_MOD { PARAM_VALUE.CLK_MOD } {
	# Procedure called to validate CLK_MOD
	return true
}

proc update_PARAM_VALUE.MAX_DEVS { PARAM_VALUE.MAX_DEVS } {
	# Procedure called to update MAX_DEVS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_DEVS { PARAM_VALUE.MAX_DEVS } {
	# Procedure called to validate MAX_DEVS
	return true
}


proc update_MODELPARAM_VALUE.MAX_DEVS { MODELPARAM_VALUE.MAX_DEVS PARAM_VALUE.MAX_DEVS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_DEVS}] ${MODELPARAM_VALUE.MAX_DEVS}
}

proc update_MODELPARAM_VALUE.CLK_MOD { MODELPARAM_VALUE.CLK_MOD PARAM_VALUE.CLK_MOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLK_MOD}] ${MODELPARAM_VALUE.CLK_MOD}
}

