class host_monitor extends uvm_monitor;
	`uvm_component_utils(host_monitor)
	
	virtual host_if host_vif;
	host_transaction trans;
	uvm_analysis_port #(host_transaction) host_busy_observed_port;
	uvm_analysis_port #(host_transaction) host_free_observed_port;

	function new(string name = "host_monitor", uvm_component parent);
		super.new(name, parent);
		host_busy_observed_port = new("host_busy_observed_port", this);
		host_free_observed_port = new("host_free_observed_port", this);
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
		trans = host_transaction::type_id::create("trans", this);

		wait (host_vif.rst_n === 1'b1);
		forever begin
			/* In Process */
			do begin
				@(posedge host_vif.clk);
				trans.busy = host_vif.busy;
				trans.done = host_vif.done;
				if (host_vif.done === 1'b0) begin
					host_busy_observed_port.write(trans);	
				end else if (host_vif.done === 1'b1) begin
					host_free_observed_port.write(trans);
				end
			end while (!(host_vif.done === 1'b1));
		end

		`uvm_info("run_phase", "Exiting...", UVM_LOW)
	endtask: run_phase

endclass: host_monitor
