`ifndef GUARD_I2C_ENV_PKG__SV
`define GUARD_I2C_ENV_PKG__SV

package env_pkg;
	import uvm_pkg::*;
 	import i2c_pkg::*;
 	import host_pkg::*;

	`include "i2c_scoreboard.sv"
	`include "i2c_environment.sv"

endpackage: env_pkg

`endif


