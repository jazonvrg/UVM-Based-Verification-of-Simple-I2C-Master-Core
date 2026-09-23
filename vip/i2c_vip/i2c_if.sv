interface i2c_if();

	logic 		clk;
	logic 		rst_n;
	logic 		clk_div_tick;
	logic 		start;
	logic [6:0]	addr;
	logic [7:0]	data_in;
	logic 		scl;
	logic 		sda;
	logic 		busy;
	logic 		done;	

endinterface
