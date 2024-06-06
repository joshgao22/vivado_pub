// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2024 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


`ifndef spi_engine_ctrl_v1_0
`define spi_engine_ctrl_v1_0

package parameter_structs;

  typedef struct packed {
      bit    portEnabled;
      integer    portWidth;
  }portConfig;

  typedef struct packed {
    // <typeName> <LogicalName> = {<enablement>, <width>}
    portConfig sdo_data;
    portConfig sdi_data;
  }spi_engine_ctrl_v1_0_port_configuration;

  parameter spi_engine_ctrl_v1_0_port_configuration spi_engine_ctrl_v1_0_default_port_configuration = '{sdo_data:'{1, -1}, sdi_data:'{1, -1}};

endpackage

interface spi_engine_ctrl_v1_0 #(parameter_structs::spi_engine_ctrl_v1_0_port_configuration port_configuration)();
  logic cmd_ready;                                                       // 
  logic cmd_valid;                                                       // 
  logic [15:0] cmd_data;                                                  // 
  logic sdo_ready;                                                       // 
  logic sdo_valid;                                                       // 
  logic [port_configuration.sdo_data.portWidth-1:0] sdo_data;            // 
  logic sdi_ready;                                                       // 
  logic sdi_valid;                                                       // 
  logic [port_configuration.sdi_data.portWidth-1:0] sdi_data;            // 
  logic sync_ready;                                                      // 
  logic sync_valid;                                                      // 
  logic [7:0] sync_data;                                                 // 

  modport MASTER (
    input cmd_ready, sdo_ready, sdi_valid, sdi_data, sync_valid, sync_data, 
    output cmd_valid, cmd_data, sdo_valid, sdo_data, sdi_ready, sync_ready
    );

  modport SLAVE (
    input cmd_valid, cmd_data, sdo_valid, sdo_data, sdi_ready, sync_ready, 
    output cmd_ready, sdo_ready, sdi_valid, sdi_data, sync_valid, sync_data
    );

  modport MONITOR (
    input cmd_ready, cmd_valid, cmd_data, sdo_ready, sdo_valid, sdo_data, sdi_ready, sdi_valid, sdi_data, sync_ready, sync_valid, sync_data
    );

endinterface // spi_engine_ctrl_v1_0

`endif