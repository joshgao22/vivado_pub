# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BUFFER_EARLY_RELEASE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_PATH_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FRAMES_PER_MULTIFRAME" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LINK_MODE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_LANES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_LINKS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OCTETS_PER_FRAME" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SCR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SYSREF_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SYSREF_ONE_SHOT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TPL_DATA_PATH_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.BUFFER_EARLY_RELEASE { PARAM_VALUE.BUFFER_EARLY_RELEASE } {
	# Procedure called to update BUFFER_EARLY_RELEASE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUFFER_EARLY_RELEASE { PARAM_VALUE.BUFFER_EARLY_RELEASE } {
	# Procedure called to validate BUFFER_EARLY_RELEASE
	return true
}

proc update_PARAM_VALUE.DATA_PATH_WIDTH { PARAM_VALUE.DATA_PATH_WIDTH } {
	# Procedure called to update DATA_PATH_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_PATH_WIDTH { PARAM_VALUE.DATA_PATH_WIDTH } {
	# Procedure called to validate DATA_PATH_WIDTH
	return true
}

proc update_PARAM_VALUE.FRAMES_PER_MULTIFRAME { PARAM_VALUE.FRAMES_PER_MULTIFRAME } {
	# Procedure called to update FRAMES_PER_MULTIFRAME when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRAMES_PER_MULTIFRAME { PARAM_VALUE.FRAMES_PER_MULTIFRAME } {
	# Procedure called to validate FRAMES_PER_MULTIFRAME
	return true
}

proc update_PARAM_VALUE.LINK_MODE { PARAM_VALUE.LINK_MODE } {
	# Procedure called to update LINK_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LINK_MODE { PARAM_VALUE.LINK_MODE } {
	# Procedure called to validate LINK_MODE
	return true
}

proc update_PARAM_VALUE.NUM_LANES { PARAM_VALUE.NUM_LANES } {
	# Procedure called to update NUM_LANES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_LANES { PARAM_VALUE.NUM_LANES } {
	# Procedure called to validate NUM_LANES
	return true
}

proc update_PARAM_VALUE.NUM_LINKS { PARAM_VALUE.NUM_LINKS } {
	# Procedure called to update NUM_LINKS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_LINKS { PARAM_VALUE.NUM_LINKS } {
	# Procedure called to validate NUM_LINKS
	return true
}

proc update_PARAM_VALUE.OCTETS_PER_FRAME { PARAM_VALUE.OCTETS_PER_FRAME } {
	# Procedure called to update OCTETS_PER_FRAME when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OCTETS_PER_FRAME { PARAM_VALUE.OCTETS_PER_FRAME } {
	# Procedure called to validate OCTETS_PER_FRAME
	return true
}

proc update_PARAM_VALUE.SCR { PARAM_VALUE.SCR } {
	# Procedure called to update SCR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SCR { PARAM_VALUE.SCR } {
	# Procedure called to validate SCR
	return true
}

proc update_PARAM_VALUE.SYSREF_DISABLE { PARAM_VALUE.SYSREF_DISABLE } {
	# Procedure called to update SYSREF_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYSREF_DISABLE { PARAM_VALUE.SYSREF_DISABLE } {
	# Procedure called to validate SYSREF_DISABLE
	return true
}

proc update_PARAM_VALUE.SYSREF_ONE_SHOT { PARAM_VALUE.SYSREF_ONE_SHOT } {
	# Procedure called to update SYSREF_ONE_SHOT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYSREF_ONE_SHOT { PARAM_VALUE.SYSREF_ONE_SHOT } {
	# Procedure called to validate SYSREF_ONE_SHOT
	return true
}

proc update_PARAM_VALUE.TPL_DATA_PATH_WIDTH { PARAM_VALUE.TPL_DATA_PATH_WIDTH } {
	# Procedure called to update TPL_DATA_PATH_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TPL_DATA_PATH_WIDTH { PARAM_VALUE.TPL_DATA_PATH_WIDTH } {
	# Procedure called to validate TPL_DATA_PATH_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.NUM_LANES { MODELPARAM_VALUE.NUM_LANES PARAM_VALUE.NUM_LANES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_LANES}] ${MODELPARAM_VALUE.NUM_LANES}
}

proc update_MODELPARAM_VALUE.NUM_LINKS { MODELPARAM_VALUE.NUM_LINKS PARAM_VALUE.NUM_LINKS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_LINKS}] ${MODELPARAM_VALUE.NUM_LINKS}
}

proc update_MODELPARAM_VALUE.OCTETS_PER_FRAME { MODELPARAM_VALUE.OCTETS_PER_FRAME PARAM_VALUE.OCTETS_PER_FRAME } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OCTETS_PER_FRAME}] ${MODELPARAM_VALUE.OCTETS_PER_FRAME}
}

proc update_MODELPARAM_VALUE.FRAMES_PER_MULTIFRAME { MODELPARAM_VALUE.FRAMES_PER_MULTIFRAME PARAM_VALUE.FRAMES_PER_MULTIFRAME } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRAMES_PER_MULTIFRAME}] ${MODELPARAM_VALUE.FRAMES_PER_MULTIFRAME}
}

proc update_MODELPARAM_VALUE.SCR { MODELPARAM_VALUE.SCR PARAM_VALUE.SCR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SCR}] ${MODELPARAM_VALUE.SCR}
}

proc update_MODELPARAM_VALUE.BUFFER_EARLY_RELEASE { MODELPARAM_VALUE.BUFFER_EARLY_RELEASE PARAM_VALUE.BUFFER_EARLY_RELEASE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUFFER_EARLY_RELEASE}] ${MODELPARAM_VALUE.BUFFER_EARLY_RELEASE}
}

proc update_MODELPARAM_VALUE.LINK_MODE { MODELPARAM_VALUE.LINK_MODE PARAM_VALUE.LINK_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LINK_MODE}] ${MODELPARAM_VALUE.LINK_MODE}
}

proc update_MODELPARAM_VALUE.SYSREF_DISABLE { MODELPARAM_VALUE.SYSREF_DISABLE PARAM_VALUE.SYSREF_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYSREF_DISABLE}] ${MODELPARAM_VALUE.SYSREF_DISABLE}
}

proc update_MODELPARAM_VALUE.SYSREF_ONE_SHOT { MODELPARAM_VALUE.SYSREF_ONE_SHOT PARAM_VALUE.SYSREF_ONE_SHOT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYSREF_ONE_SHOT}] ${MODELPARAM_VALUE.SYSREF_ONE_SHOT}
}

proc update_MODELPARAM_VALUE.DATA_PATH_WIDTH { MODELPARAM_VALUE.DATA_PATH_WIDTH PARAM_VALUE.DATA_PATH_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_PATH_WIDTH}] ${MODELPARAM_VALUE.DATA_PATH_WIDTH}
}

proc update_MODELPARAM_VALUE.TPL_DATA_PATH_WIDTH { MODELPARAM_VALUE.TPL_DATA_PATH_WIDTH PARAM_VALUE.TPL_DATA_PATH_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TPL_DATA_PATH_WIDTH}] ${MODELPARAM_VALUE.TPL_DATA_PATH_WIDTH}
}

