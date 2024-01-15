
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/data_offload_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Data_Offload [ipgui::add_page $IPINST -name "Data Offload"]
  #Adding Group
  set General_Configuration [ipgui::add_group $IPINST -name "General Configuration" -parent ${Data_Offload}]
  ipgui::add_param $IPINST -name "ID" -parent ${General_Configuration}
  ipgui::add_param $IPINST -name "TX_OR_RXN_PATH" -parent ${General_Configuration} -widget comboBox
  ipgui::add_param $IPINST -name "MEM_TYPE" -parent ${General_Configuration} -widget comboBox
  set MEM_SIZE_LOG2 [ipgui::add_param $IPINST -name "MEM_SIZE_LOG2" -parent ${General_Configuration} -widget comboBox]
  set_property tooltip {Log2 value of Storage Size in bytes} ${MEM_SIZE_LOG2}

  #Adding Group
  set Source_Endpoint_Configuration [ipgui::add_group $IPINST -name "Source Endpoint Configuration" -parent ${Data_Offload} -layout horizontal]
  ipgui::add_param $IPINST -name "SRC_DATA_WIDTH" -parent ${Source_Endpoint_Configuration}

  #Adding Group
  set Destination_Endpoint_Configuration [ipgui::add_group $IPINST -name "Destination Endpoint Configuration" -parent ${Data_Offload} -layout horizontal]
  ipgui::add_param $IPINST -name "DST_DATA_WIDTH" -parent ${Destination_Endpoint_Configuration}

  #Adding Group
  set Features [ipgui::add_group $IPINST -name "Features" -parent ${Data_Offload}]
  ipgui::add_param $IPINST -name "HAS_BYPASS" -parent ${Features}
  ipgui::add_param $IPINST -name "DST_CYCLIC_EN" -parent ${Features}
  ipgui::add_param $IPINST -name "SYNC_EXT_ADD_INTERNAL_CDC" -parent ${Features}



}

proc update_PARAM_VALUE.DST_CYCLIC_EN { PARAM_VALUE.DST_CYCLIC_EN PARAM_VALUE.TX_OR_RXN_PATH } {
	# Procedure called to update DST_CYCLIC_EN when any of the dependent parameters in the arguments change
	
	set DST_CYCLIC_EN ${PARAM_VALUE.DST_CYCLIC_EN}
	set TX_OR_RXN_PATH ${PARAM_VALUE.TX_OR_RXN_PATH}
	set values(TX_OR_RXN_PATH) [get_property value $TX_OR_RXN_PATH]
	if { [gen_USERPARAMETER_DST_CYCLIC_EN_ENABLEMENT $values(TX_OR_RXN_PATH)] } {
		set_property enabled true $DST_CYCLIC_EN
	} else {
		set_property enabled false $DST_CYCLIC_EN
	}
}

proc validate_PARAM_VALUE.DST_CYCLIC_EN { PARAM_VALUE.DST_CYCLIC_EN } {
	# Procedure called to validate DST_CYCLIC_EN
	return true
}

proc update_PARAM_VALUE.AUTO_BRINGUP { PARAM_VALUE.AUTO_BRINGUP } {
	# Procedure called to update AUTO_BRINGUP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AUTO_BRINGUP { PARAM_VALUE.AUTO_BRINGUP } {
	# Procedure called to validate AUTO_BRINGUP
	return true
}

proc update_PARAM_VALUE.DST_DATA_WIDTH { PARAM_VALUE.DST_DATA_WIDTH } {
	# Procedure called to update DST_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DST_DATA_WIDTH { PARAM_VALUE.DST_DATA_WIDTH } {
	# Procedure called to validate DST_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.HAS_BYPASS { PARAM_VALUE.HAS_BYPASS } {
	# Procedure called to update HAS_BYPASS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_BYPASS { PARAM_VALUE.HAS_BYPASS } {
	# Procedure called to validate HAS_BYPASS
	return true
}

proc update_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to update ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to validate ID
	return true
}

proc update_PARAM_VALUE.MEM_SIZE_LOG2 { PARAM_VALUE.MEM_SIZE_LOG2 } {
	# Procedure called to update MEM_SIZE_LOG2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_SIZE_LOG2 { PARAM_VALUE.MEM_SIZE_LOG2 } {
	# Procedure called to validate MEM_SIZE_LOG2
	return true
}

proc update_PARAM_VALUE.MEM_TYPE { PARAM_VALUE.MEM_TYPE } {
	# Procedure called to update MEM_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_TYPE { PARAM_VALUE.MEM_TYPE } {
	# Procedure called to validate MEM_TYPE
	return true
}

proc update_PARAM_VALUE.SRC_DATA_WIDTH { PARAM_VALUE.SRC_DATA_WIDTH } {
	# Procedure called to update SRC_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SRC_DATA_WIDTH { PARAM_VALUE.SRC_DATA_WIDTH } {
	# Procedure called to validate SRC_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.SYNC_EXT_ADD_INTERNAL_CDC { PARAM_VALUE.SYNC_EXT_ADD_INTERNAL_CDC } {
	# Procedure called to update SYNC_EXT_ADD_INTERNAL_CDC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_EXT_ADD_INTERNAL_CDC { PARAM_VALUE.SYNC_EXT_ADD_INTERNAL_CDC } {
	# Procedure called to validate SYNC_EXT_ADD_INTERNAL_CDC
	return true
}

proc update_PARAM_VALUE.TX_OR_RXN_PATH { PARAM_VALUE.TX_OR_RXN_PATH } {
	# Procedure called to update TX_OR_RXN_PATH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TX_OR_RXN_PATH { PARAM_VALUE.TX_OR_RXN_PATH } {
	# Procedure called to validate TX_OR_RXN_PATH
	return true
}


proc update_MODELPARAM_VALUE.ID { MODELPARAM_VALUE.ID PARAM_VALUE.ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ID}] ${MODELPARAM_VALUE.ID}
}

proc update_MODELPARAM_VALUE.MEM_TYPE { MODELPARAM_VALUE.MEM_TYPE PARAM_VALUE.MEM_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_TYPE}] ${MODELPARAM_VALUE.MEM_TYPE}
}

proc update_MODELPARAM_VALUE.MEM_SIZE_LOG2 { MODELPARAM_VALUE.MEM_SIZE_LOG2 PARAM_VALUE.MEM_SIZE_LOG2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_SIZE_LOG2}] ${MODELPARAM_VALUE.MEM_SIZE_LOG2}
}

proc update_MODELPARAM_VALUE.TX_OR_RXN_PATH { MODELPARAM_VALUE.TX_OR_RXN_PATH PARAM_VALUE.TX_OR_RXN_PATH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TX_OR_RXN_PATH}] ${MODELPARAM_VALUE.TX_OR_RXN_PATH}
}

proc update_MODELPARAM_VALUE.SRC_DATA_WIDTH { MODELPARAM_VALUE.SRC_DATA_WIDTH PARAM_VALUE.SRC_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SRC_DATA_WIDTH}] ${MODELPARAM_VALUE.SRC_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.DST_DATA_WIDTH { MODELPARAM_VALUE.DST_DATA_WIDTH PARAM_VALUE.DST_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DST_DATA_WIDTH}] ${MODELPARAM_VALUE.DST_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.DST_CYCLIC_EN { MODELPARAM_VALUE.DST_CYCLIC_EN PARAM_VALUE.DST_CYCLIC_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DST_CYCLIC_EN}] ${MODELPARAM_VALUE.DST_CYCLIC_EN}
}

proc update_MODELPARAM_VALUE.AUTO_BRINGUP { MODELPARAM_VALUE.AUTO_BRINGUP PARAM_VALUE.AUTO_BRINGUP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AUTO_BRINGUP}] ${MODELPARAM_VALUE.AUTO_BRINGUP}
}

proc update_MODELPARAM_VALUE.SYNC_EXT_ADD_INTERNAL_CDC { MODELPARAM_VALUE.SYNC_EXT_ADD_INTERNAL_CDC PARAM_VALUE.SYNC_EXT_ADD_INTERNAL_CDC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_EXT_ADD_INTERNAL_CDC}] ${MODELPARAM_VALUE.SYNC_EXT_ADD_INTERNAL_CDC}
}

proc update_MODELPARAM_VALUE.HAS_BYPASS { MODELPARAM_VALUE.HAS_BYPASS PARAM_VALUE.HAS_BYPASS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HAS_BYPASS}] ${MODELPARAM_VALUE.HAS_BYPASS}
}

