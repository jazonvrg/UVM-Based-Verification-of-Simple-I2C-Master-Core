class i2c_phase_test extends i2c_base_test;
	`uvm_component_utils(i2c_phase_test)
	
	function new(string name = "i2c_phase_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_LOW)
		//
		`uvm_info("build_phase", "Exiting...", UVM_LOW)
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		`uvm_info("run_phase", "Entered...", UVM_LOW)

		phase.raise_objection(this);
		reset();
		seq = uart_sequence::type_id::create("seq");
		$display("============================================================================================================================");
		$display("=================================================  ### RX UART | 13x  ###  =================================================");
		$display("============================================================================================================================");
		phase.drop_objection(this);
	
		`uvm_info("run_phase", "Exiting...", UVM_LOW)
	endtask: run_phase

endclassi
