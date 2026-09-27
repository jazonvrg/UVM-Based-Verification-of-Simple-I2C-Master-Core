class host_sequencer extends uvm_sequencer #(host_transaction);
	`uvm_component_utils(host_sequencer)

	local string msg = "[HOST_VIP][HOST_SEQUENCER]";

	function new(string name = "host_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction: new


endclass: host_sequencer
