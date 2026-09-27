class i2c_agent extends uvm_agent;
	`uvm_component_utils(i2c_agent)

	virtual i2c_if i2c_vif;
	i2c_monitor mnt;

	function new(string name = "i2c_agent", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_LOW)
		
		/* Config */
		if (!uvm_config_db#(virtual i2c_if)::get(this, "", "i2c_vif", i2c_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get i2c_vif from uvm_config_db"))
		end

		/* Initialize */
		mnt = i2c_monitor::type_id::create("mnt", this);
		uvm_config_db#(virtual i2c_if)::set(this, "mnt", "i2c_vif", i2c_vif);	

		`uvm_info("build_phase", "Exiting...", UVM_LOW)
	endfunction: build_phase

endclass: i2c_agent
