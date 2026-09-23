class i2c_driver extends uvm_driver #(i2c_transaction);
	`uvm_component_utils(i2c_driver)

	virtual i2c_if i2c_vif;
	uvm_analysis_port #(i2c_transaction) i2c_observed_port;

	function new(string name = "i2c_driver", uvm_component parent);
		super.new(name, parent);
		i2c_observed_port = new("i2c_observed_port", this);
	endfunction: new

	virtual function void build_phase(uvm_phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_LOW)

		/* Config */
		if (!uvm_config_db#(virtual i2c_if)::get(this, "", "i2c_vif", i2c_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get i2c_if from uvm_config_db"))
		end

		`uvm_info("build_phase", "Exiting...", UVM_LOW)
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		`uvm_info("run_phase", "Entered...", UVM_LOW)
		
		wait (i2c_vif.rst_n === 1'b1);
		forever begin
			seq_item_port.get_next_item(req);
			i2c_observed_port.write(req);
			drive();
			seq_item_port.item_done();
		end

		`uvm_info("run_phase", "Exiting...", UVM_LOW)
	endtask: run_phase

	task drive();
		@(posedge i2c_vif.clk);
		i2c_vif.addr <= req.addr;
		i2c_vif.data_in <= req.data;
		i2c_vif.start <= 1'b1;
		@(posedge i2c_vif.clk);
		i2c_vif.start <= 1'b0;
		`uvm_info(get_type_name(), $sformatf("Loaded transaction with addr = %0h, data = %0h", req.addr, req.data_in), UVM_LOW)
		@(posedge i2c_vif.clk iff i2c_vif.done === 1'b1);
	endtask: drive

endclass: i2c_driver
