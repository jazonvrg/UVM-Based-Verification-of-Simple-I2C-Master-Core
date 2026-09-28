class host_monitor extends uvm_monitor;
	`uvm_component_utils(host_monitor)
	
	virtual host_if host_vif;
	host_transaction trans;
	uvm_analysis_port #(host_transaction) host_idle_observed_port;
	uvm_analysis_port #(host_transaction) host_busy_observed_port;
	uvm_analysis_port #(host_transaction) host_done_observed_port;

	function new(string name = "host_monitor", uvm_component parent);
		super.new(name, parent);
		host_idle_observed_port = new("host_idle_observed_port", this);
		host_busy_observed_port = new("host_busy_observed_port", this);
		host_done_observed_port = new("host_done_observed_port", this);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_LOW)

		/* Config */
		if (!uvm_config_db#(virtual host_if)::get(this, "", "host_vif", host_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get host_vif from uvm_config_db"))
		end

		`uvm_info("build_phase", "Exiting...", UVM_LOW)
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		`uvm_info("run_phase", "Entered...", UVM_LOW)

		/* Setup */
		trans = host_transaction::type_id::create("trans", this);

		wait (host_vif.rst_n === 1'b1);
		forever begin
			/* Start */
			@(posedge host_vif.clk iff host_vif.start === 1'b1);
			trans.busy = host_vif.busy;
			trans.done = host_vif.done;
			host_busy_observed_port.write(trans);

			/* Done */
			@(posedge host_vif.clk iff host_vif.done === 1'b1);
			trans.busy = host_vif.busy;
			trans.done = host_vif.done;
			host_done_observed_port.write(trans);
			
			/* Idle */
			@(posedge host_vif.clk iff (host_vif.busy === 1'b0 && host_vif.done === 1'b0));
			trans.busy = host_vif.busy;
			trans.done = host_vif.done;
			host_idle_observed_port.write(trans);
		end

		`uvm_info("run_phase", "Exiting...", UVM_LOW)
	endtask: run_phase

endclass: host_monitor
