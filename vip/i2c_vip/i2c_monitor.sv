class i2c_monitor extends uvm_monitor;
	`uvm_component_utils(i2c_monitor)

	virtual i2c_if i2c_vif;
	uvm_analasys_port #(i2c_transaction) i2c_observed_port;
	i2c_transaction trans;

	function new(string name = "i2c_monitor", uvm_component parent);
		super.new(name, parent);
		i2c_observed_port = new("i2c_observed_port", this);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_LOW)

		/* Config */	
		if (!uvm_config_db#(virtual i2c_if)::get(this, "", "i2c_vif", i2c_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get i2c_vif from uvm_config_db"))
		end
		
		`uvm_info("build_phase", "Exiting...", UVM_LOW)
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		`uvm_info("run_phase", "Entered...", UVM_LOW)
		
		trans = i2c_transaction::type_id::create("trans", this);
		wait (i2c_vif.rst_n === 1'b1);
		forever begin
			do begin
				@(posedge i2c_vif.clk);
			end while (!(i2c_vif.scl === 1'b1 && i2c_vif.sda === 1'b0);
			for(int i = 6; i >= 0; i = i - 1) begin
				@(posedge i2c_vif.scl);
				trans.addr[i] = i2c_vif.sda;
			end
			@(posedge i2c_vif.scl);
			mem_rw = i2c_vif.sda;
			for(int i = 7; i >= 0; i = i - 1) begin
				@(posedge i2c_vif.scl);
				trans.data[i] = i2c_vif.sda;
			end
			`uvm_info(get_type_name(), $sformatf("Capturing addr = %0h, data = %0h", trans.addr,  trans.data), UVM_LOW)
			i2c_observed_port.write(trans);	
		end	
		
		`uvm_info("run_phase", "Exiting...", UVM_LOW)
	endtask: run_phase

endclass: i2c_monitor
