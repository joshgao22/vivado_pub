
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/axi_pwm_gen_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set AXI_PWM_Generator [ipgui::add_page $IPINST -name "AXI PWM Generator"]
  ipgui::add_param $IPINST -name "N_PWMS" -parent ${AXI_PWM_Generator}
  set ASYNC_CLK_EN [ipgui::add_param $IPINST -name "ASYNC_CLK_EN" -parent ${AXI_PWM_Generator}]
  set_property tooltip {The logic and PWMs will be driven by ext_clk. Otherwise the axi clock will be used} ${ASYNC_CLK_EN}
  set PWM_EXT_SYNC [ipgui::add_param $IPINST -name "PWM_EXT_SYNC" -parent ${AXI_PWM_Generator} -widget checkBox]
  set_property tooltip {If active the whole pwm gen module will be waiting for the ext_sync to be set low. A load config or reset must be used before de-asserting the ext_sync to retrigger the sync process} ${PWM_EXT_SYNC}
  set EXT_ASYNC_SYNC [ipgui::add_param $IPINST -name "EXT_ASYNC_SYNC" -parent ${AXI_PWM_Generator} -widget checkBox]
  set_property tooltip {NOTE: If active the ext_sync will be delayed 2 clock cycles.} ${EXT_ASYNC_SYNC}
  set SOFTWARE_BRINGUP [ipgui::add_param $IPINST -name "SOFTWARE_BRINGUP" -parent ${AXI_PWM_Generator} -widget checkBox]
  set_property tooltip {If active the software must bring the core out of soft reset, after a system reset, in order for the pwm signals to be generated} ${SOFTWARE_BRINGUP}
  set EXT_SYNC_PHASE_ALIGN [ipgui::add_param $IPINST -name "EXT_SYNC_PHASE_ALIGN" -parent ${AXI_PWM_Generator} -widget checkBox]
  set_property tooltip {If active the ext_sync will trigger a phase align at each neg-edge. Otherwise the phase align will be armed by a load config toggle. Software over writable at runtime.} ${EXT_SYNC_PHASE_ALIGN}
  set FORCE_ALIGN [ipgui::add_param $IPINST -name "FORCE_ALIGN" -parent ${AXI_PWM_Generator} -widget checkBox]
  set_property tooltip {If active the current active pulses are immediately stopped and realigned. Otherwise, the synchronized pulses will start only after all running pulse periods end. Software over writable at runtime.} ${FORCE_ALIGN}
  set START_AT_SYNC [ipgui::add_param $IPINST -name "START_AT_SYNC" -parent ${AXI_PWM_Generator} -widget checkBox]
  set_property tooltip {If active, the pulses will start after the trigger event. Otherwise each pulse will start after a period equal to the one for which it is set. Software over writable at runtime.} ${START_AT_SYNC}
  set PULSE_0_WIDTH [ipgui::add_param $IPINST -name "PULSE_0_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_0_WIDTH}
  set PULSE_0_PERIOD [ipgui::add_param $IPINST -name "PULSE_0_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_0_PERIOD}
  set PULSE_0_OFFSET [ipgui::add_param $IPINST -name "PULSE_0_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_0_OFFSET}
  set PULSE_1_WIDTH [ipgui::add_param $IPINST -name "PULSE_1_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_1_WIDTH}
  set PULSE_1_PERIOD [ipgui::add_param $IPINST -name "PULSE_1_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_1_PERIOD}
  set PULSE_1_OFFSET [ipgui::add_param $IPINST -name "PULSE_1_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_1_OFFSET}
  set PULSE_2_WIDTH [ipgui::add_param $IPINST -name "PULSE_2_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_2_WIDTH}
  set PULSE_2_PERIOD [ipgui::add_param $IPINST -name "PULSE_2_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_2_PERIOD}
  set PULSE_2_OFFSET [ipgui::add_param $IPINST -name "PULSE_2_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_2_OFFSET}
  set PULSE_3_WIDTH [ipgui::add_param $IPINST -name "PULSE_3_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_3_WIDTH}
  set PULSE_3_PERIOD [ipgui::add_param $IPINST -name "PULSE_3_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_3_PERIOD}
  set PULSE_3_OFFSET [ipgui::add_param $IPINST -name "PULSE_3_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_3_OFFSET}
  set PULSE_4_WIDTH [ipgui::add_param $IPINST -name "PULSE_4_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_4_WIDTH}
  set PULSE_4_PERIOD [ipgui::add_param $IPINST -name "PULSE_4_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_4_PERIOD}
  set PULSE_4_OFFSET [ipgui::add_param $IPINST -name "PULSE_4_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_4_OFFSET}
  set PULSE_5_WIDTH [ipgui::add_param $IPINST -name "PULSE_5_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_5_WIDTH}
  set PULSE_5_PERIOD [ipgui::add_param $IPINST -name "PULSE_5_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_5_PERIOD}
  set PULSE_5_OFFSET [ipgui::add_param $IPINST -name "PULSE_5_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_5_OFFSET}
  set PULSE_6_WIDTH [ipgui::add_param $IPINST -name "PULSE_6_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_6_WIDTH}
  set PULSE_6_PERIOD [ipgui::add_param $IPINST -name "PULSE_6_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_6_PERIOD}
  set PULSE_6_OFFSET [ipgui::add_param $IPINST -name "PULSE_6_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_6_OFFSET}
  set PULSE_7_WIDTH [ipgui::add_param $IPINST -name "PULSE_7_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_7_WIDTH}
  set PULSE_7_PERIOD [ipgui::add_param $IPINST -name "PULSE_7_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_7_PERIOD}
  set PULSE_7_OFFSET [ipgui::add_param $IPINST -name "PULSE_7_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_7_OFFSET}
  set PULSE_8_WIDTH [ipgui::add_param $IPINST -name "PULSE_8_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_8_WIDTH}
  set PULSE_8_PERIOD [ipgui::add_param $IPINST -name "PULSE_8_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_8_PERIOD}
  set PULSE_8_OFFSET [ipgui::add_param $IPINST -name "PULSE_8_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_8_OFFSET}
  set PULSE_9_WIDTH [ipgui::add_param $IPINST -name "PULSE_9_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_9_WIDTH}
  set PULSE_9_PERIOD [ipgui::add_param $IPINST -name "PULSE_9_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_9_PERIOD}
  set PULSE_9_OFFSET [ipgui::add_param $IPINST -name "PULSE_9_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_9_OFFSET}
  set PULSE_10_WIDTH [ipgui::add_param $IPINST -name "PULSE_10_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_10_WIDTH}
  set PULSE_10_PERIOD [ipgui::add_param $IPINST -name "PULSE_10_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_10_PERIOD}
  set PULSE_10_OFFSET [ipgui::add_param $IPINST -name "PULSE_10_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_10_OFFSET}
  set PULSE_11_WIDTH [ipgui::add_param $IPINST -name "PULSE_11_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_11_WIDTH}
  set PULSE_11_PERIOD [ipgui::add_param $IPINST -name "PULSE_11_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_11_PERIOD}
  set PULSE_11_OFFSET [ipgui::add_param $IPINST -name "PULSE_11_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_11_OFFSET}
  set PULSE_12_WIDTH [ipgui::add_param $IPINST -name "PULSE_12_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_12_WIDTH}
  set PULSE_12_PERIOD [ipgui::add_param $IPINST -name "PULSE_12_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_12_PERIOD}
  set PULSE_12_OFFSET [ipgui::add_param $IPINST -name "PULSE_12_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_12_OFFSET}
  set PULSE_13_WIDTH [ipgui::add_param $IPINST -name "PULSE_13_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_13_WIDTH}
  set PULSE_13_PERIOD [ipgui::add_param $IPINST -name "PULSE_13_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_13_PERIOD}
  set PULSE_13_OFFSET [ipgui::add_param $IPINST -name "PULSE_13_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_13_OFFSET}
  set PULSE_14_WIDTH [ipgui::add_param $IPINST -name "PULSE_14_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_14_WIDTH}
  set PULSE_14_PERIOD [ipgui::add_param $IPINST -name "PULSE_14_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_14_PERIOD}
  set PULSE_14_OFFSET [ipgui::add_param $IPINST -name "PULSE_14_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_14_OFFSET}
  set PULSE_15_WIDTH [ipgui::add_param $IPINST -name "PULSE_15_WIDTH" -parent ${AXI_PWM_Generator}]
  set_property tooltip {PULSE width of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_15_WIDTH}
  set PULSE_15_PERIOD [ipgui::add_param $IPINST -name "PULSE_15_PERIOD" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Period of the generated signal. The unit interval represents a period the system or external clock period.} ${PULSE_15_PERIOD}
  set PULSE_15_OFFSET [ipgui::add_param $IPINST -name "PULSE_15_OFFSET" -parent ${AXI_PWM_Generator}]
  set_property tooltip {Offset of the generated signal referenced to PULSE 1. The unit interval represents a period the system or external clock period.} ${PULSE_15_OFFSET}


}

proc update_PARAM_VALUE.EXT_ASYNC_SYNC { PARAM_VALUE.EXT_ASYNC_SYNC PARAM_VALUE.PWM_EXT_SYNC } {
	# Procedure called to update EXT_ASYNC_SYNC when any of the dependent parameters in the arguments change
	
	set EXT_ASYNC_SYNC ${PARAM_VALUE.EXT_ASYNC_SYNC}
	set PWM_EXT_SYNC ${PARAM_VALUE.PWM_EXT_SYNC}
	set values(PWM_EXT_SYNC) [get_property value $PWM_EXT_SYNC]
	if { [gen_USERPARAMETER_EXT_ASYNC_SYNC_ENABLEMENT $values(PWM_EXT_SYNC)] } {
		set_property enabled true $EXT_ASYNC_SYNC
	} else {
		set_property enabled false $EXT_ASYNC_SYNC
	}
}

proc validate_PARAM_VALUE.EXT_ASYNC_SYNC { PARAM_VALUE.EXT_ASYNC_SYNC } {
	# Procedure called to validate EXT_ASYNC_SYNC
	return true
}

proc update_PARAM_VALUE.EXT_SYNC_PHASE_ALIGN { PARAM_VALUE.EXT_SYNC_PHASE_ALIGN PARAM_VALUE.PWM_EXT_SYNC } {
	# Procedure called to update EXT_SYNC_PHASE_ALIGN when any of the dependent parameters in the arguments change
	
	set EXT_SYNC_PHASE_ALIGN ${PARAM_VALUE.EXT_SYNC_PHASE_ALIGN}
	set PWM_EXT_SYNC ${PARAM_VALUE.PWM_EXT_SYNC}
	set values(PWM_EXT_SYNC) [get_property value $PWM_EXT_SYNC]
	if { [gen_USERPARAMETER_EXT_SYNC_PHASE_ALIGN_ENABLEMENT $values(PWM_EXT_SYNC)] } {
		set_property enabled true $EXT_SYNC_PHASE_ALIGN
	} else {
		set_property enabled false $EXT_SYNC_PHASE_ALIGN
	}
}

proc validate_PARAM_VALUE.EXT_SYNC_PHASE_ALIGN { PARAM_VALUE.EXT_SYNC_PHASE_ALIGN } {
	# Procedure called to validate EXT_SYNC_PHASE_ALIGN
	return true
}

proc update_PARAM_VALUE.PULSE_0_OFFSET { PARAM_VALUE.PULSE_0_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_0_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_0_OFFSET ${PARAM_VALUE.PULSE_0_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_0_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_0_OFFSET
	} else {
		set_property enabled false $PULSE_0_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_0_OFFSET { PARAM_VALUE.PULSE_0_OFFSET } {
	# Procedure called to validate PULSE_0_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_0_PERIOD { PARAM_VALUE.PULSE_0_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_0_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_0_PERIOD ${PARAM_VALUE.PULSE_0_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_0_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_0_PERIOD
	} else {
		set_property enabled false $PULSE_0_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_0_PERIOD { PARAM_VALUE.PULSE_0_PERIOD } {
	# Procedure called to validate PULSE_0_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_0_WIDTH { PARAM_VALUE.PULSE_0_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_0_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_0_WIDTH ${PARAM_VALUE.PULSE_0_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_0_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_0_WIDTH
	} else {
		set_property enabled false $PULSE_0_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_0_WIDTH { PARAM_VALUE.PULSE_0_WIDTH } {
	# Procedure called to validate PULSE_0_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_10_OFFSET { PARAM_VALUE.PULSE_10_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_10_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_10_OFFSET ${PARAM_VALUE.PULSE_10_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_10_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_10_OFFSET
	} else {
		set_property enabled false $PULSE_10_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_10_OFFSET { PARAM_VALUE.PULSE_10_OFFSET } {
	# Procedure called to validate PULSE_10_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_10_PERIOD { PARAM_VALUE.PULSE_10_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_10_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_10_PERIOD ${PARAM_VALUE.PULSE_10_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_10_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_10_PERIOD
	} else {
		set_property enabled false $PULSE_10_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_10_PERIOD { PARAM_VALUE.PULSE_10_PERIOD } {
	# Procedure called to validate PULSE_10_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_10_WIDTH { PARAM_VALUE.PULSE_10_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_10_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_10_WIDTH ${PARAM_VALUE.PULSE_10_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_10_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_10_WIDTH
	} else {
		set_property enabled false $PULSE_10_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_10_WIDTH { PARAM_VALUE.PULSE_10_WIDTH } {
	# Procedure called to validate PULSE_10_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_11_OFFSET { PARAM_VALUE.PULSE_11_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_11_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_11_OFFSET ${PARAM_VALUE.PULSE_11_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_11_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_11_OFFSET
	} else {
		set_property enabled false $PULSE_11_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_11_OFFSET { PARAM_VALUE.PULSE_11_OFFSET } {
	# Procedure called to validate PULSE_11_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_11_PERIOD { PARAM_VALUE.PULSE_11_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_11_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_11_PERIOD ${PARAM_VALUE.PULSE_11_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_11_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_11_PERIOD
	} else {
		set_property enabled false $PULSE_11_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_11_PERIOD { PARAM_VALUE.PULSE_11_PERIOD } {
	# Procedure called to validate PULSE_11_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_11_WIDTH { PARAM_VALUE.PULSE_11_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_11_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_11_WIDTH ${PARAM_VALUE.PULSE_11_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_11_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_11_WIDTH
	} else {
		set_property enabled false $PULSE_11_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_11_WIDTH { PARAM_VALUE.PULSE_11_WIDTH } {
	# Procedure called to validate PULSE_11_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_12_OFFSET { PARAM_VALUE.PULSE_12_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_12_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_12_OFFSET ${PARAM_VALUE.PULSE_12_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_12_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_12_OFFSET
	} else {
		set_property enabled false $PULSE_12_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_12_OFFSET { PARAM_VALUE.PULSE_12_OFFSET } {
	# Procedure called to validate PULSE_12_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_12_PERIOD { PARAM_VALUE.PULSE_12_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_12_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_12_PERIOD ${PARAM_VALUE.PULSE_12_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_12_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_12_PERIOD
	} else {
		set_property enabled false $PULSE_12_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_12_PERIOD { PARAM_VALUE.PULSE_12_PERIOD } {
	# Procedure called to validate PULSE_12_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_12_WIDTH { PARAM_VALUE.PULSE_12_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_12_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_12_WIDTH ${PARAM_VALUE.PULSE_12_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_12_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_12_WIDTH
	} else {
		set_property enabled false $PULSE_12_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_12_WIDTH { PARAM_VALUE.PULSE_12_WIDTH } {
	# Procedure called to validate PULSE_12_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_13_OFFSET { PARAM_VALUE.PULSE_13_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_13_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_13_OFFSET ${PARAM_VALUE.PULSE_13_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_13_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_13_OFFSET
	} else {
		set_property enabled false $PULSE_13_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_13_OFFSET { PARAM_VALUE.PULSE_13_OFFSET } {
	# Procedure called to validate PULSE_13_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_13_PERIOD { PARAM_VALUE.PULSE_13_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_13_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_13_PERIOD ${PARAM_VALUE.PULSE_13_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_13_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_13_PERIOD
	} else {
		set_property enabled false $PULSE_13_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_13_PERIOD { PARAM_VALUE.PULSE_13_PERIOD } {
	# Procedure called to validate PULSE_13_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_13_WIDTH { PARAM_VALUE.PULSE_13_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_13_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_13_WIDTH ${PARAM_VALUE.PULSE_13_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_13_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_13_WIDTH
	} else {
		set_property enabled false $PULSE_13_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_13_WIDTH { PARAM_VALUE.PULSE_13_WIDTH } {
	# Procedure called to validate PULSE_13_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_14_OFFSET { PARAM_VALUE.PULSE_14_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_14_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_14_OFFSET ${PARAM_VALUE.PULSE_14_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_14_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_14_OFFSET
	} else {
		set_property enabled false $PULSE_14_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_14_OFFSET { PARAM_VALUE.PULSE_14_OFFSET } {
	# Procedure called to validate PULSE_14_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_14_PERIOD { PARAM_VALUE.PULSE_14_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_14_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_14_PERIOD ${PARAM_VALUE.PULSE_14_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_14_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_14_PERIOD
	} else {
		set_property enabled false $PULSE_14_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_14_PERIOD { PARAM_VALUE.PULSE_14_PERIOD } {
	# Procedure called to validate PULSE_14_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_14_WIDTH { PARAM_VALUE.PULSE_14_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_14_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_14_WIDTH ${PARAM_VALUE.PULSE_14_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_14_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_14_WIDTH
	} else {
		set_property enabled false $PULSE_14_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_14_WIDTH { PARAM_VALUE.PULSE_14_WIDTH } {
	# Procedure called to validate PULSE_14_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_15_OFFSET { PARAM_VALUE.PULSE_15_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_15_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_15_OFFSET ${PARAM_VALUE.PULSE_15_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_15_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_15_OFFSET
	} else {
		set_property enabled false $PULSE_15_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_15_OFFSET { PARAM_VALUE.PULSE_15_OFFSET } {
	# Procedure called to validate PULSE_15_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_15_PERIOD { PARAM_VALUE.PULSE_15_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_15_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_15_PERIOD ${PARAM_VALUE.PULSE_15_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_15_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_15_PERIOD
	} else {
		set_property enabled false $PULSE_15_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_15_PERIOD { PARAM_VALUE.PULSE_15_PERIOD } {
	# Procedure called to validate PULSE_15_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_15_WIDTH { PARAM_VALUE.PULSE_15_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_15_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_15_WIDTH ${PARAM_VALUE.PULSE_15_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_15_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_15_WIDTH
	} else {
		set_property enabled false $PULSE_15_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_15_WIDTH { PARAM_VALUE.PULSE_15_WIDTH } {
	# Procedure called to validate PULSE_15_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_1_OFFSET { PARAM_VALUE.PULSE_1_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_1_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_1_OFFSET ${PARAM_VALUE.PULSE_1_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_1_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_1_OFFSET
	} else {
		set_property enabled false $PULSE_1_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_1_OFFSET { PARAM_VALUE.PULSE_1_OFFSET } {
	# Procedure called to validate PULSE_1_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_1_PERIOD { PARAM_VALUE.PULSE_1_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_1_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_1_PERIOD ${PARAM_VALUE.PULSE_1_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_1_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_1_PERIOD
	} else {
		set_property enabled false $PULSE_1_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_1_PERIOD { PARAM_VALUE.PULSE_1_PERIOD } {
	# Procedure called to validate PULSE_1_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_1_WIDTH { PARAM_VALUE.PULSE_1_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_1_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_1_WIDTH ${PARAM_VALUE.PULSE_1_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_1_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_1_WIDTH
	} else {
		set_property enabled false $PULSE_1_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_1_WIDTH { PARAM_VALUE.PULSE_1_WIDTH } {
	# Procedure called to validate PULSE_1_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_2_OFFSET { PARAM_VALUE.PULSE_2_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_2_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_2_OFFSET ${PARAM_VALUE.PULSE_2_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_2_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_2_OFFSET
	} else {
		set_property enabled false $PULSE_2_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_2_OFFSET { PARAM_VALUE.PULSE_2_OFFSET } {
	# Procedure called to validate PULSE_2_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_2_PERIOD { PARAM_VALUE.PULSE_2_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_2_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_2_PERIOD ${PARAM_VALUE.PULSE_2_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_2_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_2_PERIOD
	} else {
		set_property enabled false $PULSE_2_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_2_PERIOD { PARAM_VALUE.PULSE_2_PERIOD } {
	# Procedure called to validate PULSE_2_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_2_WIDTH { PARAM_VALUE.PULSE_2_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_2_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_2_WIDTH ${PARAM_VALUE.PULSE_2_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_2_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_2_WIDTH
	} else {
		set_property enabled false $PULSE_2_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_2_WIDTH { PARAM_VALUE.PULSE_2_WIDTH } {
	# Procedure called to validate PULSE_2_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_3_OFFSET { PARAM_VALUE.PULSE_3_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_3_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_3_OFFSET ${PARAM_VALUE.PULSE_3_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_3_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_3_OFFSET
	} else {
		set_property enabled false $PULSE_3_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_3_OFFSET { PARAM_VALUE.PULSE_3_OFFSET } {
	# Procedure called to validate PULSE_3_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_3_PERIOD { PARAM_VALUE.PULSE_3_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_3_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_3_PERIOD ${PARAM_VALUE.PULSE_3_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_3_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_3_PERIOD
	} else {
		set_property enabled false $PULSE_3_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_3_PERIOD { PARAM_VALUE.PULSE_3_PERIOD } {
	# Procedure called to validate PULSE_3_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_3_WIDTH { PARAM_VALUE.PULSE_3_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_3_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_3_WIDTH ${PARAM_VALUE.PULSE_3_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_3_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_3_WIDTH
	} else {
		set_property enabled false $PULSE_3_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_3_WIDTH { PARAM_VALUE.PULSE_3_WIDTH } {
	# Procedure called to validate PULSE_3_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_4_OFFSET { PARAM_VALUE.PULSE_4_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_4_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_4_OFFSET ${PARAM_VALUE.PULSE_4_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_4_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_4_OFFSET
	} else {
		set_property enabled false $PULSE_4_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_4_OFFSET { PARAM_VALUE.PULSE_4_OFFSET } {
	# Procedure called to validate PULSE_4_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_4_PERIOD { PARAM_VALUE.PULSE_4_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_4_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_4_PERIOD ${PARAM_VALUE.PULSE_4_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_4_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_4_PERIOD
	} else {
		set_property enabled false $PULSE_4_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_4_PERIOD { PARAM_VALUE.PULSE_4_PERIOD } {
	# Procedure called to validate PULSE_4_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_4_WIDTH { PARAM_VALUE.PULSE_4_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_4_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_4_WIDTH ${PARAM_VALUE.PULSE_4_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_4_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_4_WIDTH
	} else {
		set_property enabled false $PULSE_4_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_4_WIDTH { PARAM_VALUE.PULSE_4_WIDTH } {
	# Procedure called to validate PULSE_4_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_5_OFFSET { PARAM_VALUE.PULSE_5_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_5_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_5_OFFSET ${PARAM_VALUE.PULSE_5_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_5_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_5_OFFSET
	} else {
		set_property enabled false $PULSE_5_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_5_OFFSET { PARAM_VALUE.PULSE_5_OFFSET } {
	# Procedure called to validate PULSE_5_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_5_PERIOD { PARAM_VALUE.PULSE_5_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_5_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_5_PERIOD ${PARAM_VALUE.PULSE_5_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_5_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_5_PERIOD
	} else {
		set_property enabled false $PULSE_5_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_5_PERIOD { PARAM_VALUE.PULSE_5_PERIOD } {
	# Procedure called to validate PULSE_5_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_5_WIDTH { PARAM_VALUE.PULSE_5_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_5_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_5_WIDTH ${PARAM_VALUE.PULSE_5_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_5_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_5_WIDTH
	} else {
		set_property enabled false $PULSE_5_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_5_WIDTH { PARAM_VALUE.PULSE_5_WIDTH } {
	# Procedure called to validate PULSE_5_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_6_OFFSET { PARAM_VALUE.PULSE_6_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_6_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_6_OFFSET ${PARAM_VALUE.PULSE_6_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_6_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_6_OFFSET
	} else {
		set_property enabled false $PULSE_6_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_6_OFFSET { PARAM_VALUE.PULSE_6_OFFSET } {
	# Procedure called to validate PULSE_6_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_6_PERIOD { PARAM_VALUE.PULSE_6_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_6_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_6_PERIOD ${PARAM_VALUE.PULSE_6_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_6_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_6_PERIOD
	} else {
		set_property enabled false $PULSE_6_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_6_PERIOD { PARAM_VALUE.PULSE_6_PERIOD } {
	# Procedure called to validate PULSE_6_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_6_WIDTH { PARAM_VALUE.PULSE_6_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_6_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_6_WIDTH ${PARAM_VALUE.PULSE_6_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_6_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_6_WIDTH
	} else {
		set_property enabled false $PULSE_6_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_6_WIDTH { PARAM_VALUE.PULSE_6_WIDTH } {
	# Procedure called to validate PULSE_6_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_7_OFFSET { PARAM_VALUE.PULSE_7_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_7_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_7_OFFSET ${PARAM_VALUE.PULSE_7_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_7_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_7_OFFSET
	} else {
		set_property enabled false $PULSE_7_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_7_OFFSET { PARAM_VALUE.PULSE_7_OFFSET } {
	# Procedure called to validate PULSE_7_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_7_PERIOD { PARAM_VALUE.PULSE_7_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_7_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_7_PERIOD ${PARAM_VALUE.PULSE_7_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_7_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_7_PERIOD
	} else {
		set_property enabled false $PULSE_7_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_7_PERIOD { PARAM_VALUE.PULSE_7_PERIOD } {
	# Procedure called to validate PULSE_7_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_7_WIDTH { PARAM_VALUE.PULSE_7_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_7_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_7_WIDTH ${PARAM_VALUE.PULSE_7_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_7_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_7_WIDTH
	} else {
		set_property enabled false $PULSE_7_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_7_WIDTH { PARAM_VALUE.PULSE_7_WIDTH } {
	# Procedure called to validate PULSE_7_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_8_OFFSET { PARAM_VALUE.PULSE_8_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_8_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_8_OFFSET ${PARAM_VALUE.PULSE_8_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_8_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_8_OFFSET
	} else {
		set_property enabled false $PULSE_8_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_8_OFFSET { PARAM_VALUE.PULSE_8_OFFSET } {
	# Procedure called to validate PULSE_8_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_8_PERIOD { PARAM_VALUE.PULSE_8_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_8_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_8_PERIOD ${PARAM_VALUE.PULSE_8_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_8_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_8_PERIOD
	} else {
		set_property enabled false $PULSE_8_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_8_PERIOD { PARAM_VALUE.PULSE_8_PERIOD } {
	# Procedure called to validate PULSE_8_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_8_WIDTH { PARAM_VALUE.PULSE_8_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_8_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_8_WIDTH ${PARAM_VALUE.PULSE_8_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_8_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_8_WIDTH
	} else {
		set_property enabled false $PULSE_8_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_8_WIDTH { PARAM_VALUE.PULSE_8_WIDTH } {
	# Procedure called to validate PULSE_8_WIDTH
	return true
}

proc update_PARAM_VALUE.PULSE_9_OFFSET { PARAM_VALUE.PULSE_9_OFFSET PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_9_OFFSET when any of the dependent parameters in the arguments change
	
	set PULSE_9_OFFSET ${PARAM_VALUE.PULSE_9_OFFSET}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_9_OFFSET_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_9_OFFSET
	} else {
		set_property enabled false $PULSE_9_OFFSET
	}
}

proc validate_PARAM_VALUE.PULSE_9_OFFSET { PARAM_VALUE.PULSE_9_OFFSET } {
	# Procedure called to validate PULSE_9_OFFSET
	return true
}

proc update_PARAM_VALUE.PULSE_9_PERIOD { PARAM_VALUE.PULSE_9_PERIOD PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_9_PERIOD when any of the dependent parameters in the arguments change
	
	set PULSE_9_PERIOD ${PARAM_VALUE.PULSE_9_PERIOD}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_9_PERIOD_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_9_PERIOD
	} else {
		set_property enabled false $PULSE_9_PERIOD
	}
}

proc validate_PARAM_VALUE.PULSE_9_PERIOD { PARAM_VALUE.PULSE_9_PERIOD } {
	# Procedure called to validate PULSE_9_PERIOD
	return true
}

proc update_PARAM_VALUE.PULSE_9_WIDTH { PARAM_VALUE.PULSE_9_WIDTH PARAM_VALUE.N_PWMS } {
	# Procedure called to update PULSE_9_WIDTH when any of the dependent parameters in the arguments change
	
	set PULSE_9_WIDTH ${PARAM_VALUE.PULSE_9_WIDTH}
	set N_PWMS ${PARAM_VALUE.N_PWMS}
	set values(N_PWMS) [get_property value $N_PWMS]
	if { [gen_USERPARAMETER_PULSE_9_WIDTH_ENABLEMENT $values(N_PWMS)] } {
		set_property enabled true $PULSE_9_WIDTH
	} else {
		set_property enabled false $PULSE_9_WIDTH
	}
}

proc validate_PARAM_VALUE.PULSE_9_WIDTH { PARAM_VALUE.PULSE_9_WIDTH } {
	# Procedure called to validate PULSE_9_WIDTH
	return true
}

proc update_PARAM_VALUE.ASYNC_CLK_EN { PARAM_VALUE.ASYNC_CLK_EN } {
	# Procedure called to update ASYNC_CLK_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ASYNC_CLK_EN { PARAM_VALUE.ASYNC_CLK_EN } {
	# Procedure called to validate ASYNC_CLK_EN
	return true
}

proc update_PARAM_VALUE.FORCE_ALIGN { PARAM_VALUE.FORCE_ALIGN } {
	# Procedure called to update FORCE_ALIGN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FORCE_ALIGN { PARAM_VALUE.FORCE_ALIGN } {
	# Procedure called to validate FORCE_ALIGN
	return true
}

proc update_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to update ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to validate ID
	return true
}

proc update_PARAM_VALUE.N_PWMS { PARAM_VALUE.N_PWMS } {
	# Procedure called to update N_PWMS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_PWMS { PARAM_VALUE.N_PWMS } {
	# Procedure called to validate N_PWMS
	return true
}

proc update_PARAM_VALUE.PWM_EXT_SYNC { PARAM_VALUE.PWM_EXT_SYNC } {
	# Procedure called to update PWM_EXT_SYNC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PWM_EXT_SYNC { PARAM_VALUE.PWM_EXT_SYNC } {
	# Procedure called to validate PWM_EXT_SYNC
	return true
}

proc update_PARAM_VALUE.SOFTWARE_BRINGUP { PARAM_VALUE.SOFTWARE_BRINGUP } {
	# Procedure called to update SOFTWARE_BRINGUP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SOFTWARE_BRINGUP { PARAM_VALUE.SOFTWARE_BRINGUP } {
	# Procedure called to validate SOFTWARE_BRINGUP
	return true
}

proc update_PARAM_VALUE.START_AT_SYNC { PARAM_VALUE.START_AT_SYNC } {
	# Procedure called to update START_AT_SYNC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.START_AT_SYNC { PARAM_VALUE.START_AT_SYNC } {
	# Procedure called to validate START_AT_SYNC
	return true
}


proc update_MODELPARAM_VALUE.ID { MODELPARAM_VALUE.ID PARAM_VALUE.ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ID}] ${MODELPARAM_VALUE.ID}
}

proc update_MODELPARAM_VALUE.ASYNC_CLK_EN { MODELPARAM_VALUE.ASYNC_CLK_EN PARAM_VALUE.ASYNC_CLK_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ASYNC_CLK_EN}] ${MODELPARAM_VALUE.ASYNC_CLK_EN}
}

proc update_MODELPARAM_VALUE.N_PWMS { MODELPARAM_VALUE.N_PWMS PARAM_VALUE.N_PWMS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_PWMS}] ${MODELPARAM_VALUE.N_PWMS}
}

proc update_MODELPARAM_VALUE.PWM_EXT_SYNC { MODELPARAM_VALUE.PWM_EXT_SYNC PARAM_VALUE.PWM_EXT_SYNC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PWM_EXT_SYNC}] ${MODELPARAM_VALUE.PWM_EXT_SYNC}
}

proc update_MODELPARAM_VALUE.EXT_ASYNC_SYNC { MODELPARAM_VALUE.EXT_ASYNC_SYNC PARAM_VALUE.EXT_ASYNC_SYNC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXT_ASYNC_SYNC}] ${MODELPARAM_VALUE.EXT_ASYNC_SYNC}
}

proc update_MODELPARAM_VALUE.SOFTWARE_BRINGUP { MODELPARAM_VALUE.SOFTWARE_BRINGUP PARAM_VALUE.SOFTWARE_BRINGUP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SOFTWARE_BRINGUP}] ${MODELPARAM_VALUE.SOFTWARE_BRINGUP}
}

proc update_MODELPARAM_VALUE.EXT_SYNC_PHASE_ALIGN { MODELPARAM_VALUE.EXT_SYNC_PHASE_ALIGN PARAM_VALUE.EXT_SYNC_PHASE_ALIGN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXT_SYNC_PHASE_ALIGN}] ${MODELPARAM_VALUE.EXT_SYNC_PHASE_ALIGN}
}

proc update_MODELPARAM_VALUE.FORCE_ALIGN { MODELPARAM_VALUE.FORCE_ALIGN PARAM_VALUE.FORCE_ALIGN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FORCE_ALIGN}] ${MODELPARAM_VALUE.FORCE_ALIGN}
}

proc update_MODELPARAM_VALUE.START_AT_SYNC { MODELPARAM_VALUE.START_AT_SYNC PARAM_VALUE.START_AT_SYNC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.START_AT_SYNC}] ${MODELPARAM_VALUE.START_AT_SYNC}
}

proc update_MODELPARAM_VALUE.PULSE_0_WIDTH { MODELPARAM_VALUE.PULSE_0_WIDTH PARAM_VALUE.PULSE_0_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_0_WIDTH}] ${MODELPARAM_VALUE.PULSE_0_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_1_WIDTH { MODELPARAM_VALUE.PULSE_1_WIDTH PARAM_VALUE.PULSE_1_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_1_WIDTH}] ${MODELPARAM_VALUE.PULSE_1_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_2_WIDTH { MODELPARAM_VALUE.PULSE_2_WIDTH PARAM_VALUE.PULSE_2_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_2_WIDTH}] ${MODELPARAM_VALUE.PULSE_2_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_3_WIDTH { MODELPARAM_VALUE.PULSE_3_WIDTH PARAM_VALUE.PULSE_3_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_3_WIDTH}] ${MODELPARAM_VALUE.PULSE_3_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_4_WIDTH { MODELPARAM_VALUE.PULSE_4_WIDTH PARAM_VALUE.PULSE_4_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_4_WIDTH}] ${MODELPARAM_VALUE.PULSE_4_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_5_WIDTH { MODELPARAM_VALUE.PULSE_5_WIDTH PARAM_VALUE.PULSE_5_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_5_WIDTH}] ${MODELPARAM_VALUE.PULSE_5_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_6_WIDTH { MODELPARAM_VALUE.PULSE_6_WIDTH PARAM_VALUE.PULSE_6_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_6_WIDTH}] ${MODELPARAM_VALUE.PULSE_6_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_7_WIDTH { MODELPARAM_VALUE.PULSE_7_WIDTH PARAM_VALUE.PULSE_7_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_7_WIDTH}] ${MODELPARAM_VALUE.PULSE_7_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_8_WIDTH { MODELPARAM_VALUE.PULSE_8_WIDTH PARAM_VALUE.PULSE_8_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_8_WIDTH}] ${MODELPARAM_VALUE.PULSE_8_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_9_WIDTH { MODELPARAM_VALUE.PULSE_9_WIDTH PARAM_VALUE.PULSE_9_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_9_WIDTH}] ${MODELPARAM_VALUE.PULSE_9_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_10_WIDTH { MODELPARAM_VALUE.PULSE_10_WIDTH PARAM_VALUE.PULSE_10_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_10_WIDTH}] ${MODELPARAM_VALUE.PULSE_10_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_11_WIDTH { MODELPARAM_VALUE.PULSE_11_WIDTH PARAM_VALUE.PULSE_11_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_11_WIDTH}] ${MODELPARAM_VALUE.PULSE_11_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_12_WIDTH { MODELPARAM_VALUE.PULSE_12_WIDTH PARAM_VALUE.PULSE_12_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_12_WIDTH}] ${MODELPARAM_VALUE.PULSE_12_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_13_WIDTH { MODELPARAM_VALUE.PULSE_13_WIDTH PARAM_VALUE.PULSE_13_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_13_WIDTH}] ${MODELPARAM_VALUE.PULSE_13_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_14_WIDTH { MODELPARAM_VALUE.PULSE_14_WIDTH PARAM_VALUE.PULSE_14_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_14_WIDTH}] ${MODELPARAM_VALUE.PULSE_14_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_15_WIDTH { MODELPARAM_VALUE.PULSE_15_WIDTH PARAM_VALUE.PULSE_15_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_15_WIDTH}] ${MODELPARAM_VALUE.PULSE_15_WIDTH}
}

proc update_MODELPARAM_VALUE.PULSE_0_PERIOD { MODELPARAM_VALUE.PULSE_0_PERIOD PARAM_VALUE.PULSE_0_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_0_PERIOD}] ${MODELPARAM_VALUE.PULSE_0_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_1_PERIOD { MODELPARAM_VALUE.PULSE_1_PERIOD PARAM_VALUE.PULSE_1_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_1_PERIOD}] ${MODELPARAM_VALUE.PULSE_1_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_2_PERIOD { MODELPARAM_VALUE.PULSE_2_PERIOD PARAM_VALUE.PULSE_2_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_2_PERIOD}] ${MODELPARAM_VALUE.PULSE_2_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_3_PERIOD { MODELPARAM_VALUE.PULSE_3_PERIOD PARAM_VALUE.PULSE_3_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_3_PERIOD}] ${MODELPARAM_VALUE.PULSE_3_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_4_PERIOD { MODELPARAM_VALUE.PULSE_4_PERIOD PARAM_VALUE.PULSE_4_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_4_PERIOD}] ${MODELPARAM_VALUE.PULSE_4_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_5_PERIOD { MODELPARAM_VALUE.PULSE_5_PERIOD PARAM_VALUE.PULSE_5_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_5_PERIOD}] ${MODELPARAM_VALUE.PULSE_5_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_6_PERIOD { MODELPARAM_VALUE.PULSE_6_PERIOD PARAM_VALUE.PULSE_6_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_6_PERIOD}] ${MODELPARAM_VALUE.PULSE_6_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_7_PERIOD { MODELPARAM_VALUE.PULSE_7_PERIOD PARAM_VALUE.PULSE_7_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_7_PERIOD}] ${MODELPARAM_VALUE.PULSE_7_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_8_PERIOD { MODELPARAM_VALUE.PULSE_8_PERIOD PARAM_VALUE.PULSE_8_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_8_PERIOD}] ${MODELPARAM_VALUE.PULSE_8_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_9_PERIOD { MODELPARAM_VALUE.PULSE_9_PERIOD PARAM_VALUE.PULSE_9_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_9_PERIOD}] ${MODELPARAM_VALUE.PULSE_9_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_10_PERIOD { MODELPARAM_VALUE.PULSE_10_PERIOD PARAM_VALUE.PULSE_10_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_10_PERIOD}] ${MODELPARAM_VALUE.PULSE_10_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_11_PERIOD { MODELPARAM_VALUE.PULSE_11_PERIOD PARAM_VALUE.PULSE_11_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_11_PERIOD}] ${MODELPARAM_VALUE.PULSE_11_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_12_PERIOD { MODELPARAM_VALUE.PULSE_12_PERIOD PARAM_VALUE.PULSE_12_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_12_PERIOD}] ${MODELPARAM_VALUE.PULSE_12_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_13_PERIOD { MODELPARAM_VALUE.PULSE_13_PERIOD PARAM_VALUE.PULSE_13_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_13_PERIOD}] ${MODELPARAM_VALUE.PULSE_13_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_14_PERIOD { MODELPARAM_VALUE.PULSE_14_PERIOD PARAM_VALUE.PULSE_14_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_14_PERIOD}] ${MODELPARAM_VALUE.PULSE_14_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_15_PERIOD { MODELPARAM_VALUE.PULSE_15_PERIOD PARAM_VALUE.PULSE_15_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_15_PERIOD}] ${MODELPARAM_VALUE.PULSE_15_PERIOD}
}

proc update_MODELPARAM_VALUE.PULSE_0_OFFSET { MODELPARAM_VALUE.PULSE_0_OFFSET PARAM_VALUE.PULSE_0_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_0_OFFSET}] ${MODELPARAM_VALUE.PULSE_0_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_1_OFFSET { MODELPARAM_VALUE.PULSE_1_OFFSET PARAM_VALUE.PULSE_1_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_1_OFFSET}] ${MODELPARAM_VALUE.PULSE_1_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_2_OFFSET { MODELPARAM_VALUE.PULSE_2_OFFSET PARAM_VALUE.PULSE_2_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_2_OFFSET}] ${MODELPARAM_VALUE.PULSE_2_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_3_OFFSET { MODELPARAM_VALUE.PULSE_3_OFFSET PARAM_VALUE.PULSE_3_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_3_OFFSET}] ${MODELPARAM_VALUE.PULSE_3_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_4_OFFSET { MODELPARAM_VALUE.PULSE_4_OFFSET PARAM_VALUE.PULSE_4_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_4_OFFSET}] ${MODELPARAM_VALUE.PULSE_4_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_5_OFFSET { MODELPARAM_VALUE.PULSE_5_OFFSET PARAM_VALUE.PULSE_5_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_5_OFFSET}] ${MODELPARAM_VALUE.PULSE_5_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_6_OFFSET { MODELPARAM_VALUE.PULSE_6_OFFSET PARAM_VALUE.PULSE_6_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_6_OFFSET}] ${MODELPARAM_VALUE.PULSE_6_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_7_OFFSET { MODELPARAM_VALUE.PULSE_7_OFFSET PARAM_VALUE.PULSE_7_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_7_OFFSET}] ${MODELPARAM_VALUE.PULSE_7_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_8_OFFSET { MODELPARAM_VALUE.PULSE_8_OFFSET PARAM_VALUE.PULSE_8_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_8_OFFSET}] ${MODELPARAM_VALUE.PULSE_8_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_9_OFFSET { MODELPARAM_VALUE.PULSE_9_OFFSET PARAM_VALUE.PULSE_9_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_9_OFFSET}] ${MODELPARAM_VALUE.PULSE_9_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_10_OFFSET { MODELPARAM_VALUE.PULSE_10_OFFSET PARAM_VALUE.PULSE_10_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_10_OFFSET}] ${MODELPARAM_VALUE.PULSE_10_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_11_OFFSET { MODELPARAM_VALUE.PULSE_11_OFFSET PARAM_VALUE.PULSE_11_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_11_OFFSET}] ${MODELPARAM_VALUE.PULSE_11_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_12_OFFSET { MODELPARAM_VALUE.PULSE_12_OFFSET PARAM_VALUE.PULSE_12_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_12_OFFSET}] ${MODELPARAM_VALUE.PULSE_12_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_13_OFFSET { MODELPARAM_VALUE.PULSE_13_OFFSET PARAM_VALUE.PULSE_13_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_13_OFFSET}] ${MODELPARAM_VALUE.PULSE_13_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_14_OFFSET { MODELPARAM_VALUE.PULSE_14_OFFSET PARAM_VALUE.PULSE_14_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_14_OFFSET}] ${MODELPARAM_VALUE.PULSE_14_OFFSET}
}

proc update_MODELPARAM_VALUE.PULSE_15_OFFSET { MODELPARAM_VALUE.PULSE_15_OFFSET PARAM_VALUE.PULSE_15_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PULSE_15_OFFSET}] ${MODELPARAM_VALUE.PULSE_15_OFFSET}
}

