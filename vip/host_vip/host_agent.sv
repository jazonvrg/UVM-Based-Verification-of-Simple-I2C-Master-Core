class host_agent extends uvm_agent;
	`uvm_component_utils(host_agent)

	virtual host_if host_vif;
	host_sequencer seq;
	host_driver drv;
	host_monitor mnt;

	function new(string name = "host_agent", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	virtual function build_phase(uvm_phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_LOW)

		/* Config */
		if (!uvm_config_db#(virtual host_if)::get(this, "", "host_vif", host_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get host_vif from uvm_config_db"))
		end

		/* Categorized  */
		if (get_active == UVM_ACTIVE) begin
			/* Initialize */
			seq = host_sequencer::type_id::create("seq", this);
			drv = host_driver::type_id::create("drv", this);
			mnt = host_monitor::type_id::create("mnt", this);
			
			/* Config */
			uvm_config_db#(virtual host_if)::set(this, "drv", "host_vif", host_vif);
			uvm_config_db#(virtual host_if)::set(this, "mnt", "host_vif", host_vif);
		end else begin
			/*Initialize */
			mnt = host_monitor::type_id::create("mnt", this);

			/* Config */
			uvm_config_db#(virtual host_if)::set(this, "mnt", "host_vif", host_vif);
		end

		`uvm_info("build_phase", "Exiting...", UVM_LOW)
	endfunction: build_phase

	virtual function connect_phase(uvm_phase);
		super.connect_phase(phase);
		`uvm_info("connect_phase", "Entered...", UVM_LOW)
		
		if (get_is_active == UVM_ACTIVE) begin
			drv.seq_item_port.connect(seq.seq_item_export);
		end

		`uvm_info("connect_phase", "Exiting...", UVM_LOW)
	endfunction: connect_phase

endclass: host_agent
