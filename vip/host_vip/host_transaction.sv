class host_transaction extends uvm_sequence_item;
	`uvm_object_utils(host_transaction)

	rand logic [6:0] addr;
	rand logic [7:0] data;
	rand logic busy;
	rand logic done;

	function new(string name = "host_transaction");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin
		`uvm_field_int (addr, UVM_ALL_ON | UVM_HEX)
		`uvm_field_int (data, UVM_ALL_ON | UVM_HEX)
		`uvm_field_int (busy, UVM_ALL_ON | UVM_BIN)
		`uvm_field_int (done, UVM_ALL_ON | UVM_BIN)
	`uvm_object_utils_end

endclass: host_transaction
