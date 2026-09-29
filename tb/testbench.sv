module testbench;
	import uvm_pkg::*;
	import i2c_pkg::*;
	import test_pkg::*;

	i2c_if i2c_vif();
	host_if host_vif();

	i2c_master dut(
		.clk		(host_vif.clk),
		.rst_n		(host_vif.rst_n),
		.clk_div_tick	(host_vif.clk_div_tick),
		.start		(host_vif.start),
		.addr		(host_vif.addr),
		.data_in	(host_vif.data_in),
		.scl		(i2c_vif.scl),
		.sda		(i2c_vif.sda),
		.busy		(host_vif.busy),
		.done		(host_vif.done)
	);

	clk_div clk_div_dut(
		.clk		(host_vif.clk),
		.rst_n		(host_vif.rst_n),
		.clk_div_tick	(host_vif.clk_div_tick)
	);

	/* Config timing */
	initial begin
		host_vif.clk = 0;
		forever begin
			#5ns;
			host_vif.clk = ~host_vif.clk;
		end
	end

	/* Setup */
	initial begin
		host_vif.rst_n = 1'b0;
		host_vif.start = 1'b0;
		host_vif.addr = 7'h0;
		host_vif.data_in = 8'h0;
		#10ns;
		host_vif.rst_n = 1'b1;
	end

	initial begin
		/* Config */
		uvm_config_db#(virtual i2c_if)::set(uvm_root::get(), "uvm_test_top", "i2c_vif", i2c_vif);
		uvm_config_db#(virtual host_if)::set(uvm_root::get(), "uvm_test_top", "host_vif", host_vif);
		/* Run test */
		run_test();
	end

endmodule
