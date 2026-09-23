module testbench;
	import uvm_pkg::*;
	import i2c_pkg::*;
	import test_pkg::*;

	i2c_if i2c_vif();

	i2c_top dut(
		.clk		(i2c_vif.clk),
		.rst_n		(i2c_vif.rst_n),
		.clk_div_tick	(i2c_vif.clk_div_tick),
		.start		(i2c_vif.start),
		.addr		(i2c_vif.addr),
		.data_in	(i2c_vif.data_in),
		.scl		(i2c_vif.scl),
		.sda		(i2c_vif.sda),
		.busy		(i2c_vif.busy),
		.done		(i2c_vif.done)
	);

	/* Config timing */
	initial begin
		i2c_vif.clk = 0;
		forever begin
			#5ns;
			i2c_vif.clk = ~i2c_vif.clk;
		end
	end

	/* Setup */
	initial begin
		i2c_vif.rst_n = 1'b0;
		i2c_vif.start = 1'b0;
		i2c_vif.addr = 7'h0;
		i2c_vif.data_in = 8'h0;
		#10ns;
		i2c_vif.rst_n = 1'b1;
	end

	initial begin
		/* Config */
		uvm_config_db#(virtual i2c_if)::set(uvm_root::get(), "uvm_test_top", "i2c_vif", i2c_vif);
		/* Run test */
		run_test();
	end

endmodule
