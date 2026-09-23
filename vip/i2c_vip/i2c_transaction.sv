class i2c_transaction extends uvm_sequence_item;

	rand logic [6:0] addr;
	rand logic [7:0] data;

	`uvm_object_utils_begin (i2c_transaction)
		`uvm_field_int (addr, UVM_ALL_ON | UVM_HEX)
		`uvm_field_int (data, UVM_ALL_ON | UVM_HEX)
	`uvm_object_utils_end

	function new(string name = "i2c_transaction");
		super.new(name);
	endfunction: new

endclass: i2c_transaction
