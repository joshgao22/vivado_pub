# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set I3C_Controller_Host_Interface [ipgui::add_page $IPINST -name "I3C Controller Host Interface" -display_name {AXI I3C Controller Host Interface}]
  #Adding Group
  set General_Configuration [ipgui::add_group $IPINST -name "General Configuration" -parent ${I3C_Controller_Host_Interface}]
  set ID [ipgui::add_param $IPINST -name "ID" -parent ${General_Configuration}]
  set_property tooltip {[ID] Core instance ID} ${ID}
  set ASYNC_CLK [ipgui::add_param $IPINST -name "ASYNC_CLK" -parent ${General_Configuration}]
  set_property tooltip {[ASYNC_CLK] Define the relationship between the core clock and the memory mapped interface clock} ${ASYNC_CLK}
  set OFFLOAD [ipgui::add_param $IPINST -name "OFFLOAD" -parent ${General_Configuration}]
  set_property tooltip {[OFFLOAD] Allows to offload output data to a external receiver, like a DMA} ${OFFLOAD}



}

proc update_PARAM_VALUE.ASYNC_CLK { PARAM_VALUE.ASYNC_CLK } {
	# Procedure called to update ASYNC_CLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ASYNC_CLK { PARAM_VALUE.ASYNC_CLK } {
	# Procedure called to validate ASYNC_CLK
	return true
}

proc update_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to update ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to validate ID
	return true
}

proc update_PARAM_VALUE.OFFLOAD { PARAM_VALUE.OFFLOAD } {
	# Procedure called to update OFFLOAD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OFFLOAD { PARAM_VALUE.OFFLOAD } {
	# Procedure called to validate OFFLOAD
	return true
}


proc update_MODELPARAM_VALUE.ID { MODELPARAM_VALUE.ID PARAM_VALUE.ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ID}] ${MODELPARAM_VALUE.ID}
}

proc update_MODELPARAM_VALUE.ASYNC_CLK { MODELPARAM_VALUE.ASYNC_CLK PARAM_VALUE.ASYNC_CLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ASYNC_CLK}] ${MODELPARAM_VALUE.ASYNC_CLK}
}

proc update_MODELPARAM_VALUE.OFFLOAD { MODELPARAM_VALUE.OFFLOAD PARAM_VALUE.OFFLOAD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OFFLOAD}] ${MODELPARAM_VALUE.OFFLOAD}
}

