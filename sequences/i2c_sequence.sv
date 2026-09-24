class i2c_sequence extends uvm_sequence #(i2c_transaction);
	`uvm_object_utils(i2c_sequence)

	function new(sting name = "i2c_sequence");
		super.new(name);
	endfunction:n new

	virtual task body();
		`uvm_info("body", "Entered...", UVM_LOW)

		req = i2c_transaction::type_id::create("req");
		start_item(req);
		if (req.randomize()) begin
			`uvm_info("body", $sformatf("Transaction randomize is: \n%0s", rerq.sprint()), UVM_LOW)
		end else begin
			`uvm_fatal("body", $sformatf("Randomize failure"));
		end
		finish_item(req);

		`uvm_info("body", "Exiting...", UVM_LOW)
	endtask: body

endclass: i2c_sequence
