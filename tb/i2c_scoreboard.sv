`uvm_analysis_imp_decl(_host_exp)
`uvm_analysis_imp_decl(_i2c_act)
`uvm_analysis_imp_decl(_host_idle)
`uvm_analysis_imp_decl(_host_done)
`uvm_analysis_imp_decl(_host_busy)

class i2c_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(i2c_scoreboard)

	uvm_analysis_imp_i2c_act #(i2c_transaction, i2c_scoreboard) i2c_act_export;
	uvm_analysis_imp_host_exp #(host_transaction, i2c_scoreboard) host_exp_export;
	uvm_analysis_imp_host_idle #(host_transaction, i2c_scoreboard) host_idle_export;
	uvm_analysis_imp_host_done #(host_transaction, i2c_scoreboard) host_done_export;
	uvm_analysis_imp_host_busy #(host_transaction, i2c_scoreboard) host_busy_export;

	logic exp_busy, exp_done;
	host_transaction host_exp_q[$], exp;

	function new(string name = "i2c_scoreboard", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_LOW)

		/* Initialize */
		i2c_act_export = new("i2c_act_export", this);
		host_exp_export = new("host_exp_export", this);
		host_idle_export = new("host_idle_export", this);
		host_done_export = new("host_done_export", this);
		host_busy_export = new("host_busy_export", this);

		`uvm_info("build_phase", "Exiting...", UVM_LOW)
	endfunction: build_phase

	function void write_host_exp(host_transaction trans);
		`uvm_info("write_i2c_drv", $sformatf("Add I2C's driver transaction into queue"), UVM_LOW)
		host_exp_q.push_back(trans);
	endfunction

	function void write_i2c_act(i2c_transaction act);
		$display("");
		`uvm_info("write_i2c_mnt", $sformatf("I2C TRANSACTION COMPARATIVE"), UVM_LOW)
		exp = host_transaction::type_id::create("exp", this);
		if (host_exp_q.size() > 0) begin
			exp = host_exp_q.pop_front();
			$display("============================================================================================================================");
			if (exp.addr === act.addr && exp.data === act.data) begin
				`uvm_info(get_type_name(), $sformatf("PASSED! Signal is matching| Exp: addr = %0h, data = %0h| Act: addr = %0h, data = %0h", exp.addr, exp.data, act.addr, act.data), UVM_LOW)
			end else if (exp.addr === act.addr && exp.data !== act.data) begin
				`uvm_error(get_type_name(), $sformatf("FAILED! Data is not matching| Exp: addr = %0h, data = %0h| Act: addr = %0h, data = %0h", exp.addr, exp.data, act.addr, act.data))
			end else if (exp.addr !== act.addr && exp.data === act.data) begin
				`uvm_error(get_type_name(), $sformatf("FAILED! Address is not matching| Exp: addr = %0h, data = %0h| Act: add = %0h, data = %0h", exp.addr, exp.data, act.addr, act.data))
			end else begin
				`uvm_error(get_type_name(), $sformatf("FAILED! Signal is not matching| Exp: addr = %0h, data = %0h| Act: addr = %0h, data = %0h", exp.addr, exp.data, act.addr, act.data))
			end
			$display("============================================================================================================================");
		end
		$display("");
	endfunction

	function void write_host_busy(host_transaction act);
		$display("");
		`uvm_info("write_host_busy", $sformatf("HOST'S BUSY COMPARATIVE"), UVM_LOW)
		exp_busy = 1'b1;
		exp_done = 1'b0;
		host_compared(exp_busy, exp_done, act);
		$display("");
	endfunction

	function void write_host_done(host_transaction act);
		$display("");
		`uvm_info("write_host_done", $sformatf("HOST'S DONE COMPARATIVE"), UVM_LOW)
		exp_busy = 1'b0;
		exp_done = 1'b1;
		host_compared(exp_busy, exp_done, act);
		$display("");
	endfunction

	function void write_host_idle(host_transaction act);
		$display("");
		`uvm_info("write_host_idle", $sformatf("HOST'S IDLE COMPARATIVE"), UVM_LOW)
		exp_busy = 1'b0;
		exp_done = 1'b0;
		host_compared(exp_busy, exp_done, act);
		$display("");
	endfunction

	function void host_compared(logic exp_busy, logic exp_done, host_transaction act);
		$display("============================================================================================================================");	
		if (exp_busy === act.busy && exp_done === act.done) begin
			`uvm_info(get_type_name(), $sformatf("PASSED! Signal is matching| Exp: busy = %0b, done = %0b| Act: busy = %0b, done = %0b", exp_busy, exp_done, act.busy, act.done), UVM_LOW)
		end else if (exp_busy === act.busy && exp_done !== act.done) begin
			`uvm_error(get_type_name(), $sformatf("FAILED! Done signal is not matching| Exp: busy = %0b, done = %0b| Act: busy = %0b, done = %0b", exp_busy, exp_done, act.busy, act.done))
		end else if (exp_busy !== act.busy && exp_done === act.done) begin
			`uvm_error(get_type_name(), $sformatf("FAILED! Busy signal is not matching| Exp: busy = %0b, done = %0b| Act: busy = %0b, done = %0b", exp_busy, exp_done, act.busy, act.done))
		end else begin
			`uvm_error(get_type_name(), $sformatf("FAILED! Signal is not matching| Exp: busy = %0b, done = %0b,| Act: busy = %0b, done = %0b", exp_busy, exp_done, act.busy, act.done))
		end
		$display("============================================================================================================================");	
	endfunction

endclass: i2c_scoreboard
