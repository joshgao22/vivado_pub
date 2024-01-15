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


`ifndef if_xcvr_ch_v1_0
`define if_xcvr_ch_v1_0

interface if_xcvr_ch_v1_0();
  logic pll_locked;                                      // 
  logic rst;                                             // 
  logic user_ready;                                      // 
  logic rst_done;                                        // 
  logic [3:0] prbssel;                                   // 
  logic prbsforceerr;                                    // 
  logic prbscntreset;                                    // 
  logic prbserr;                                         // 
  logic prbslocked;                                      // 
  logic lpm_dfe_n;                                       // 
  logic [2:0] rate;                                      // 
  logic [1:0] sys_clk_sel;                               // 
  logic [2:0] out_clk_sel;                               // 
  logic [3:0] tx_diffctrl;                               // 
  logic [4:0] tx_postcursor;                             // 
  logic [4:0] tx_precursor;                              // 
  logic enb;                                             // 
  logic [11:0] addr;                                      // 
  logic wr;                                              // 
  logic [15:0] wdata;                                     // 
  logic [15:0] rdata;                                     // 
  logic ready;                                           // 
  logic [1:0] bufstatus;                                 // 
  logic bufstatus_rst;                                   // 

  modport MASTER (
    input pll_locked, rst_done, prbserr, prbslocked, rdata, ready, 
    output rst, user_ready, prbssel, prbsforceerr, prbscntreset, lpm_dfe_n, rate, sys_clk_sel, out_clk_sel, tx_diffctrl, tx_postcursor, tx_precursor, enb, addr, wr, wdata, bufstatus, bufstatus_rst
    );

  modport SLAVE (
    input rst, user_ready, prbssel, prbsforceerr, prbscntreset, lpm_dfe_n, rate, sys_clk_sel, out_clk_sel, tx_diffctrl, tx_postcursor, tx_precursor, enb, addr, wr, wdata, bufstatus, bufstatus_rst, 
    output pll_locked, rst_done, prbserr, prbslocked, rdata, ready
    );

  modport MONITOR (
    input pll_locked, rst, user_ready, rst_done, prbssel, prbsforceerr, prbscntreset, prbserr, prbslocked, lpm_dfe_n, rate, sys_clk_sel, out_clk_sel, tx_diffctrl, tx_postcursor, tx_precursor, enb, addr, wr, wdata, rdata, ready, bufstatus, bufstatus_rst
    );

endinterface // if_xcvr_ch_v1_0

`endif