`ifndef GUARD_I2C_TEST_PKG__SV
`define GUARD_I2C_TEST_PKG__SV

package test_pkg;
	import uvm_pkg::*;
  	import host_pkg::*;
  	import env_pkg::*;
  	import seq_pkg::*;
  	import i2c_pkg::*;

	`include "i2c_base_test.sv"

	`include "i2c_phase_test.sv"	

endpackage: test_pkg

`endif


