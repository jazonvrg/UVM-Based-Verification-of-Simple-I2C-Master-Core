`uvm_analysis_imp_decl(_i2c_drv)
`uvm_analysis_imp_decl(_i2c_mnt)

class i2c_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(i2c_scoreboard)

	uvm_analysis_imp_i2c_drv #(i2c_transaction, i2c_scoreboard) i2c_drv_export;
	uvm_analysis_imp_i2c_mnt #(i2c_transaction ,i2c_scoreboard) i2c_mnt_export;

	function new(string name = "i2c_scoerboard", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_LOW)

		/* Initialize */
		i2c_drv_export = new("i2c_drv_export", this);
		i2c_mnt_export = new("i2c_mnt_export", this);

		`uvm_info("build_phase", "Exiting...", UVM_LOW)
	endfunction: build_phase

	function void write_i2c_drv(i2c_transaction trans);
		`uvm_info("write_i2c_drv", $sformatf("Add I2C's driver transaction into queue"), UVM_LOW)
		i2c_drv_q.push_pack(trans);
	endfunction

	function void write_i2c_mnt(i2c_tranasction act);
		`uvm_info("write_i2c_mnt", $sformatf("I2C TRANSACTION COMPARATIVE"), UVM_LOW)
		if (i2c_drv_q.size() > 0) begin
			exp = i2c_drv_q.pop_front();
			$display("============================================================================================================================");
			if (exp.addr === act.addr && exp.data === act.data) begin
				`uvm_info(get_type_name(), $sformatf("PASSED! Signal is matching| Exp: addr = %0h, data = %0h| Act: addr = %0h, data = %0h", exp.addr, exp.data, act.addr, act.data), UVM_LOW)
			end else if (exp.addr === act.addr && exp.data !== act.data) begin
				`uvm_error(get_type_name(), $sformatf("FAILED! Data is not matching| Exp: addr = %0h, data = %0h| Act: addr = %0h, data = %0h", exp.addr, exp.data, act.addr, act.data))
			end else begin if (exp.addr !== act.addr && exp.data === act.data) begin
				`uvm_error(get_type_name(), $sformatf("FAILED! Address is not matching| Exp: addr = %0h, data = %0h| Act: add = %0h, data = %0h", exp.addr, exp.data, act.addr, act.data))
			end else begin
				`uvm_error(get_type_name(), $sformatf("FAILED! Signal is not matching| Exp: addr = %0h, data = %0h| Act: addr = %0h, data = %0h", exp.addr, exp.data, act.addr, act.data))
			end
			$display("============================================================================================================================");
		end
	endfunction

endclass: i2c_scoreboard
