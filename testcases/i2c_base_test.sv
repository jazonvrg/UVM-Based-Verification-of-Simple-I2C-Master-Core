class i2c_base_test extends uvm_test;
	`uvm_component_utils(i2c_base_test)

	virtual i2c_if i2c_vif;
	virtual host_if host_vif;
	i2c_environment env;
	i2c_error_catcher i2c_err_catcher;
	host_error_catcher host_err_catcher;

	time usr_timeout = 50s;

	function new(string name = "i2c_base_test", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase;
		`uvm_info("build_phase", "Entered...", UVM_LOW)

		/* Config */
		if (!uvm_config_db#(virtual i2c_if)::get(this, "", "i2c_vif", i2c_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get i2c_vif from uvm_config_db"))
		end
		if (!uvm_config_db#(virtual host_if)::get(this, "", "host_vif", host_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get host_vif from uvm_config_db"))
		end
		
		/* Initialize */
		env = i2c_environment::type_id::create("env", this);
		i2c_err_catcher = i2c_error_catcher::type_id::create("i2c_err_catcher");
		host_err_catcher = host_error_catcher::type_id::create("host_err_catcher");
		uvm_report_cb::add(null, i2c_err_catcher);
		uvm_report_cb::add(null, host_err_catcher);
		uvm_config_db#(virtual i2c_if)::set(this, "env", "i2c_vif", i2c_vif);
		uvm_config_db#(virtual host_if)::set(this, "env", "host_vif", host_vif);
		uvm_top.set_timeout(usr_timeout);

		`uvm_info("build_phase", "Exiting...", UVM_LOW)
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("connect_phase", "Entered...", UVM_LOW)
		//
		`uvm_info("connect_phase", "Exiting...", UVM_LOW)
	endfunction: connect_phase

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		`uvm_info("end_of_elaboration_phase", "Entered...", UVM_LOW)
		
		uvm_top.print_topology();

		`uvm_info("end_of_elaboration_phase", "Exiting...", UVM_LOW)
	endfunction: end_of_elaboration_phase

	task reset();
		host_vif.rst_n = 1'b0;
		host_vif.addr = 7'h0;
		host_vif.data_in = 8'h0; 
		#10;
		host_vif.rst_n = 1'b1;
		@(posedge host_vif.clk);
	endtask: reset

	virtual function void final_phase(uvm_phase phase);
		super.final_phase(phase);
		`uvm_info("final_phase", "Entered...", UVM_LOW)

		uvm_report_server svr;
		svr = uvm_report_server::get_server();
		if (svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) begin
			$display("\n=====================================================");
			$display("            #### Status: TEST FAILED ####              ");
			$display("\n=====================================================");
		end else begin
			$display("\n=====================================================");
			$display("            #### Status: TEST PASSED ####              ");
			$display("\n=====================================================");
		end

		`uvm_info("final_phase", "Exiting...", UVM_LOW)
	endfunction: final_phase

endclass: i2c_base_test
