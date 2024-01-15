
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/util_hbm_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  #Adding Group
  set General_Settings [ipgui::add_group $IPINST -name "General Settings" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "TX_RX_N" -parent ${General_Settings} -widget comboBox
  set LENGTH_WIDTH [ipgui::add_param $IPINST -name "LENGTH_WIDTH" -parent ${General_Settings}]
  set_property tooltip {Defines the amount of data can be stored starting from the base address of the storage.} ${LENGTH_WIDTH}

  #Adding Group
  set Data_Offload_Interface [ipgui::add_group $IPINST -name "Data Offload Interface" -parent ${Page_0}]
  set SRC_DATA_WIDTH [ipgui::add_param $IPINST -name "SRC_DATA_WIDTH" -parent ${Data_Offload_Interface}]
  set_property tooltip {Source AXIS Bus Width (s_axis)} ${SRC_DATA_WIDTH}
  set SRC_FIFO_SIZE [ipgui::add_param $IPINST -name "SRC_FIFO_SIZE" -parent ${Data_Offload_Interface} -widget comboBox]
  set_property tooltip {Size of internal data mover buffer used for write to external memory. In AXI bursts, where one burst is max 4096 bytes or 2*AXI_DATA_WIDTH bytes for AXI3 or 32*AXI_DATA_WIDTH bytes for AXI4.} ${SRC_FIFO_SIZE}
  set DST_DATA_WIDTH [ipgui::add_param $IPINST -name "DST_DATA_WIDTH" -parent ${Data_Offload_Interface}]
  set_property tooltip {Destination AXIS Bus Width (m_axis)} ${DST_DATA_WIDTH}
  set DST_FIFO_SIZE [ipgui::add_param $IPINST -name "DST_FIFO_SIZE" -parent ${Data_Offload_Interface} -widget comboBox]
  set_property tooltip {Size of internal data mover buffer used for read from the external memory. In AXI bursts, where one burst is max 4096 bytes or 2*AXI_DATA_WIDTH bytes for AXI3 or 32*AXI_DATA_WIDTH bytes for AXI4.} ${DST_FIFO_SIZE}

  #Adding Group
  set External_Memory_Interface [ipgui::add_group $IPINST -name "External Memory Interface" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "MEM_TYPE" -parent ${External_Memory_Interface} -widget comboBox
  set NUM_M [ipgui::add_param $IPINST -name "NUM_M" -parent ${External_Memory_Interface} -widget comboBox]
  set_property tooltip {Number of AXI masters the data stream bus is split} ${NUM_M}
  ipgui::add_param $IPINST -name "AXI_PROTOCOL" -parent ${External_Memory_Interface} -widget comboBox
  set AXI_DATA_WIDTH [ipgui::add_param $IPINST -name "AXI_DATA_WIDTH" -parent ${External_Memory_Interface}]
  set_property tooltip {Bus Width: Memory-Mapped interface with valid range of 32-1024 bits} ${AXI_DATA_WIDTH}
  #Adding Group
  set HBM_Interface [ipgui::add_group $IPINST -name "HBM Interface" -parent ${External_Memory_Interface}]
  set HBM_SEGMENTS_PER_MASTER [ipgui::add_param $IPINST -name "HBM_SEGMENTS_PER_MASTER" -parent ${HBM_Interface}]
  set_property tooltip {HBM sections (2Gb/256MB pseudo channels) per master} ${HBM_SEGMENTS_PER_MASTER}
  set HBM_SEGMENT_INDEX [ipgui::add_param $IPINST -name "HBM_SEGMENT_INDEX" -parent ${HBM_Interface} -widget comboBox]
  set_property tooltip {First used HBM section (2Gb pseudo channels).The base address where data is stored is generated based on this parameter} ${HBM_SEGMENT_INDEX}

  #Adding Group
  set DDR_Interface [ipgui::add_group $IPINST -name "DDR Interface" -parent ${External_Memory_Interface}]
  set DDR_BASE_ADDDRESS [ipgui::add_param $IPINST -name "DDR_BASE_ADDDRESS" -parent ${DDR_Interface}]
  set_property tooltip {The base address where data is stored is generated based on this parameter} ${DDR_BASE_ADDDRESS}




}

proc update_PARAM_VALUE.DDR_BASE_ADDDRESS { PARAM_VALUE.DDR_BASE_ADDDRESS PARAM_VALUE.MEM_TYPE } {
	# Procedure called to update DDR_BASE_ADDDRESS when any of the dependent parameters in the arguments change
	
	set DDR_BASE_ADDDRESS ${PARAM_VALUE.DDR_BASE_ADDDRESS}
	set MEM_TYPE ${PARAM_VALUE.MEM_TYPE}
	set values(MEM_TYPE) [get_property value $MEM_TYPE]
	if { [gen_USERPARAMETER_DDR_BASE_ADDDRESS_ENABLEMENT $values(MEM_TYPE)] } {
		set_property enabled true $DDR_BASE_ADDDRESS
	} else {
		set_property enabled false $DDR_BASE_ADDDRESS
	}
}

proc validate_PARAM_VALUE.DDR_BASE_ADDDRESS { PARAM_VALUE.DDR_BASE_ADDDRESS } {
	# Procedure called to validate DDR_BASE_ADDDRESS
	return true
}

proc update_PARAM_VALUE.HBM_SEGMENTS_PER_MASTER { PARAM_VALUE.HBM_SEGMENTS_PER_MASTER PARAM_VALUE.LENGTH_WIDTH PARAM_VALUE.NUM_M } {
	# Procedure called to update HBM_SEGMENTS_PER_MASTER when any of the dependent parameters in the arguments change
	
	set HBM_SEGMENTS_PER_MASTER ${PARAM_VALUE.HBM_SEGMENTS_PER_MASTER}
	set LENGTH_WIDTH ${PARAM_VALUE.LENGTH_WIDTH}
	set NUM_M ${PARAM_VALUE.NUM_M}
	set values(LENGTH_WIDTH) [get_property value $LENGTH_WIDTH]
	set values(NUM_M) [get_property value $NUM_M]
	set_property value [gen_USERPARAMETER_HBM_SEGMENTS_PER_MASTER_VALUE $values(LENGTH_WIDTH) $values(NUM_M)] $HBM_SEGMENTS_PER_MASTER
}

proc validate_PARAM_VALUE.HBM_SEGMENTS_PER_MASTER { PARAM_VALUE.HBM_SEGMENTS_PER_MASTER } {
	# Procedure called to validate HBM_SEGMENTS_PER_MASTER
	return true
}

proc update_PARAM_VALUE.HBM_SEGMENT_INDEX { PARAM_VALUE.HBM_SEGMENT_INDEX PARAM_VALUE.MEM_TYPE } {
	# Procedure called to update HBM_SEGMENT_INDEX when any of the dependent parameters in the arguments change
	
	set HBM_SEGMENT_INDEX ${PARAM_VALUE.HBM_SEGMENT_INDEX}
	set MEM_TYPE ${PARAM_VALUE.MEM_TYPE}
	set values(MEM_TYPE) [get_property value $MEM_TYPE]
	if { [gen_USERPARAMETER_HBM_SEGMENT_INDEX_ENABLEMENT $values(MEM_TYPE)] } {
		set_property enabled true $HBM_SEGMENT_INDEX
	} else {
		set_property enabled false $HBM_SEGMENT_INDEX
	}
}

proc validate_PARAM_VALUE.HBM_SEGMENT_INDEX { PARAM_VALUE.HBM_SEGMENT_INDEX } {
	# Procedure called to validate HBM_SEGMENT_INDEX
	return true
}

proc update_PARAM_VALUE.AXI_ADDR_WIDTH { PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to update AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_ADDR_WIDTH { PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to validate AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_DATA_WIDTH { PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to update AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_DATA_WIDTH { PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to validate AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_PROTOCOL { PARAM_VALUE.AXI_PROTOCOL } {
	# Procedure called to update AXI_PROTOCOL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_PROTOCOL { PARAM_VALUE.AXI_PROTOCOL } {
	# Procedure called to validate AXI_PROTOCOL
	return true
}

proc update_PARAM_VALUE.DST_DATA_WIDTH { PARAM_VALUE.DST_DATA_WIDTH } {
	# Procedure called to update DST_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DST_DATA_WIDTH { PARAM_VALUE.DST_DATA_WIDTH } {
	# Procedure called to validate DST_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DST_FIFO_SIZE { PARAM_VALUE.DST_FIFO_SIZE } {
	# Procedure called to update DST_FIFO_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DST_FIFO_SIZE { PARAM_VALUE.DST_FIFO_SIZE } {
	# Procedure called to validate DST_FIFO_SIZE
	return true
}

proc update_PARAM_VALUE.LENGTH_WIDTH { PARAM_VALUE.LENGTH_WIDTH } {
	# Procedure called to update LENGTH_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LENGTH_WIDTH { PARAM_VALUE.LENGTH_WIDTH } {
	# Procedure called to validate LENGTH_WIDTH
	return true
}

proc update_PARAM_VALUE.MEM_TYPE { PARAM_VALUE.MEM_TYPE } {
	# Procedure called to update MEM_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_TYPE { PARAM_VALUE.MEM_TYPE } {
	# Procedure called to validate MEM_TYPE
	return true
}

proc update_PARAM_VALUE.NUM_M { PARAM_VALUE.NUM_M } {
	# Procedure called to update NUM_M when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_M { PARAM_VALUE.NUM_M } {
	# Procedure called to validate NUM_M
	return true
}

proc update_PARAM_VALUE.SRC_DATA_WIDTH { PARAM_VALUE.SRC_DATA_WIDTH } {
	# Procedure called to update SRC_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SRC_DATA_WIDTH { PARAM_VALUE.SRC_DATA_WIDTH } {
	# Procedure called to validate SRC_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.SRC_FIFO_SIZE { PARAM_VALUE.SRC_FIFO_SIZE } {
	# Procedure called to update SRC_FIFO_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SRC_FIFO_SIZE { PARAM_VALUE.SRC_FIFO_SIZE } {
	# Procedure called to validate SRC_FIFO_SIZE
	return true
}

proc update_PARAM_VALUE.TX_RX_N { PARAM_VALUE.TX_RX_N } {
	# Procedure called to update TX_RX_N when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TX_RX_N { PARAM_VALUE.TX_RX_N } {
	# Procedure called to validate TX_RX_N
	return true
}


proc update_MODELPARAM_VALUE.TX_RX_N { MODELPARAM_VALUE.TX_RX_N PARAM_VALUE.TX_RX_N } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TX_RX_N}] ${MODELPARAM_VALUE.TX_RX_N}
}

proc update_MODELPARAM_VALUE.SRC_DATA_WIDTH { MODELPARAM_VALUE.SRC_DATA_WIDTH PARAM_VALUE.SRC_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SRC_DATA_WIDTH}] ${MODELPARAM_VALUE.SRC_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.DST_DATA_WIDTH { MODELPARAM_VALUE.DST_DATA_WIDTH PARAM_VALUE.DST_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DST_DATA_WIDTH}] ${MODELPARAM_VALUE.DST_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.LENGTH_WIDTH { MODELPARAM_VALUE.LENGTH_WIDTH PARAM_VALUE.LENGTH_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LENGTH_WIDTH}] ${MODELPARAM_VALUE.LENGTH_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_PROTOCOL { MODELPARAM_VALUE.AXI_PROTOCOL PARAM_VALUE.AXI_PROTOCOL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_PROTOCOL}] ${MODELPARAM_VALUE.AXI_PROTOCOL}
}

proc update_MODELPARAM_VALUE.AXI_DATA_WIDTH { MODELPARAM_VALUE.AXI_DATA_WIDTH PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_ADDR_WIDTH { MODELPARAM_VALUE.AXI_ADDR_WIDTH PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.MEM_TYPE { MODELPARAM_VALUE.MEM_TYPE PARAM_VALUE.MEM_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_TYPE}] ${MODELPARAM_VALUE.MEM_TYPE}
}

proc update_MODELPARAM_VALUE.HBM_SEGMENTS_PER_MASTER { MODELPARAM_VALUE.HBM_SEGMENTS_PER_MASTER PARAM_VALUE.HBM_SEGMENTS_PER_MASTER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HBM_SEGMENTS_PER_MASTER}] ${MODELPARAM_VALUE.HBM_SEGMENTS_PER_MASTER}
}

proc update_MODELPARAM_VALUE.HBM_SEGMENT_INDEX { MODELPARAM_VALUE.HBM_SEGMENT_INDEX PARAM_VALUE.HBM_SEGMENT_INDEX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HBM_SEGMENT_INDEX}] ${MODELPARAM_VALUE.HBM_SEGMENT_INDEX}
}

proc update_MODELPARAM_VALUE.DDR_BASE_ADDDRESS { MODELPARAM_VALUE.DDR_BASE_ADDDRESS PARAM_VALUE.DDR_BASE_ADDDRESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DDR_BASE_ADDDRESS}] ${MODELPARAM_VALUE.DDR_BASE_ADDDRESS}
}

proc update_MODELPARAM_VALUE.NUM_M { MODELPARAM_VALUE.NUM_M PARAM_VALUE.NUM_M } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_M}] ${MODELPARAM_VALUE.NUM_M}
}

proc update_MODELPARAM_VALUE.SRC_FIFO_SIZE { MODELPARAM_VALUE.SRC_FIFO_SIZE PARAM_VALUE.SRC_FIFO_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SRC_FIFO_SIZE}] ${MODELPARAM_VALUE.SRC_FIFO_SIZE}
}

proc update_MODELPARAM_VALUE.DST_FIFO_SIZE { MODELPARAM_VALUE.DST_FIFO_SIZE PARAM_VALUE.DST_FIFO_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DST_FIFO_SIZE}] ${MODELPARAM_VALUE.DST_FIFO_SIZE}
}

