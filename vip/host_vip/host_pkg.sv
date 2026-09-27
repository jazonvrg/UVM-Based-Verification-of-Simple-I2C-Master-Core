`ifndef GUARD_HOST_PKG__SV
`define GUARD_HOST_PKG__SV
package host_pkg;
	import uvm_pkg::*;

	`include "host_transaction.sv"
	`include "host_sequencer.sv"
	`include "host_driver.sv"
	`include "host_monitor.sv"
	`include "host_error_catcher.sv"
	`include "host_agent.sv"

endpackage: host_pkg

`endif
