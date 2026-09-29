class i2c_environment extends uvm_env;
	`uvm_component_utils(i2c_environment)

	virtual i2c_if i2c_vif;
	virtual host_if host_vif;
	i2c_agent i2c_agt;
	host_agent host_agt;
	i2c_scoreboard scb;

	function new(string name = "i2c_environment", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", "UVM_LOW")

		/* Config */
		if (!uvm_config_db#(virtual i2c_if)::get(this, "", "i2c_vif", i2c_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get i2c_vif from uvm_config_db"))
		end
		if (!uvm_config_db#(virtual host_if)::get(this, "", "host_vif", host_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get host_vif from uvm_config_db"))
		end

		/* Initialize */
		i2c_agt = i2c_agent::type_id::create("i2c_agt", this);
		host_agt = host_agent::type_id::create("host_agt", this);
		scb = i2c_scoreboard::type_id::create("scb", this);

		/* Config */
		uvm_config_db#(virtual i2c_if)::set(this, "i2c_agt", "i2c_vif", i2c_vif);
		uvm_config_db#(virtual host_if)::set(this, "host_agt", "host_vif", host_vif);

		`uvm_info("build_phase", "Exiting...", "UVM_LOW")
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("connect_phase", "Entered...", "UVM_LOW")

		/* Comparative of transaction */
		host_agt.drv.host_observed_port.connect(scb.host_exp_export);
		i2c_agt.mnt.i2c_observed_port.connect(scb.i2c_act_export);	
		
		/* Comparative of busy & done signal */
		host_agt.mnt.host_idle_observed_port.connect(scb.host_idle_export);
		host_agt.mnt.host_busy_observed_port.connect(scb.host_busy_export);
		host_agt.mnt.host_done_observed_port.connect(scb.host_done_export);

		`uvm_info("connect_phase", "Exiting...", "UVM_LOW")
	endfunction: connect_phase

endclass: i2c_environment
