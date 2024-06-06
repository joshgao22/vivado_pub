# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set AXI_AD7606X [ipgui::add_page $IPINST -name "AXI AD7606X"]
  set EXTERNAL_CLK [ipgui::add_param $IPINST -name "EXTERNAL_CLK" -parent ${AXI_AD7606X} -widget checkBox]
  set_property tooltip {External clock for the ADC} ${EXTERNAL_CLK}
  ipgui::add_param $IPINST -name "DEV_CONFIG" -parent ${AXI_AD7606X} -widget comboBox


}

proc update_PARAM_VALUE.ADC_N_BITS { PARAM_VALUE.ADC_N_BITS } {
	# Procedure called to update ADC_N_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_N_BITS { PARAM_VALUE.ADC_N_BITS } {
	# Procedure called to validate ADC_N_BITS
	return true
}

proc update_PARAM_VALUE.ADC_TO_DMA_N_BITS { PARAM_VALUE.ADC_TO_DMA_N_BITS } {
	# Procedure called to update ADC_TO_DMA_N_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_TO_DMA_N_BITS { PARAM_VALUE.ADC_TO_DMA_N_BITS } {
	# Procedure called to validate ADC_TO_DMA_N_BITS
	return true
}

proc update_PARAM_VALUE.DEV_CONFIG { PARAM_VALUE.DEV_CONFIG } {
	# Procedure called to update DEV_CONFIG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEV_CONFIG { PARAM_VALUE.DEV_CONFIG } {
	# Procedure called to validate DEV_CONFIG
	return true
}

proc update_PARAM_VALUE.EXTERNAL_CLK { PARAM_VALUE.EXTERNAL_CLK } {
	# Procedure called to update EXTERNAL_CLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXTERNAL_CLK { PARAM_VALUE.EXTERNAL_CLK } {
	# Procedure called to validate EXTERNAL_CLK
	return true
}

proc update_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to update ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to validate ID
	return true
}


proc update_MODELPARAM_VALUE.ID { MODELPARAM_VALUE.ID PARAM_VALUE.ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ID}] ${MODELPARAM_VALUE.ID}
}

proc update_MODELPARAM_VALUE.DEV_CONFIG { MODELPARAM_VALUE.DEV_CONFIG PARAM_VALUE.DEV_CONFIG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEV_CONFIG}] ${MODELPARAM_VALUE.DEV_CONFIG}
}

proc update_MODELPARAM_VALUE.ADC_TO_DMA_N_BITS { MODELPARAM_VALUE.ADC_TO_DMA_N_BITS PARAM_VALUE.ADC_TO_DMA_N_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_TO_DMA_N_BITS}] ${MODELPARAM_VALUE.ADC_TO_DMA_N_BITS}
}

proc update_MODELPARAM_VALUE.ADC_N_BITS { MODELPARAM_VALUE.ADC_N_BITS PARAM_VALUE.ADC_N_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_N_BITS}] ${MODELPARAM_VALUE.ADC_N_BITS}
}

proc update_MODELPARAM_VALUE.EXTERNAL_CLK { MODELPARAM_VALUE.EXTERNAL_CLK PARAM_VALUE.EXTERNAL_CLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXTERNAL_CLK}] ${MODELPARAM_VALUE.EXTERNAL_CLK}
}

