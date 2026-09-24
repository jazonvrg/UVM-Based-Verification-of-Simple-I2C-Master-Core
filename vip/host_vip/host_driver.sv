class host_driver extends uvm_driver #(host_transaction);
	`uvm_component_utils(host_driver)

	virtual host_if host_vif;
	uvm_analysis_port #(host_transaction) i2c_observed_port;

	function new(string name = "host_driver", uvm_component parent);
		super.new(name, parent);
		i2c_observed_port = new("i2c_observed_port", this);
	endfunction: new

	virtual function build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_LOW)

		/* Config */
		if (!uvm_config_db#(virtual host_if)::get(this, "", "host_vif", host_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get host_vif from uvm_config_db"))
		end

		`uvm_info("build_phase", "Exiting...", UVM_LOW)
	endfunction: build_phase

	virtual task run_pphase(uvm_phase phase);
		`uvm_info("run_phase", "Entered...", UVM_LOW)

		/* Setup */
		host_vif.addr <= 7'h0;
		host_vif.data <= 8'h0;
		host_vif.clk_div_tick <= 1'b0;
		host_vif.start <= 1'b0;

		/* Trigger */
		wait (host_vif.rst_n === 1'b1);
		forever begin
			seq_item_port.get_next_item(req);	
			i2c_obseved_port.write(req);	
			drive();
			seq_item_port.get_finish(req);		
		end

		`uvm_info("run_phase", "Exiting...", UVM_LOW)
	endtask: run_phase

	task drive();
		@(posedge host_vif.clk);
		host_vif.addr <= req.addr;
		host_vif.data_in <= req.data;
		host_vif.done <= 1'b1;
		@(posedge host_vif.clk);
		host_vif.done <= 1'b0;
		`uvm_info(get_type_name(), $sformatf("Loading transaction with addr = %0h, data = %0h", req.addr, req.data), UVM_LOW)
		@(posedge host_vif.clk iff host_vif.done === 1'b1);
	endtask: drive

endclass: host_driver
