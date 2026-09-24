+incdir+${I2C_IP_VERIF_PATH}/sequences
+incdir+${I2C_IP_VERIF_PATH}/testcases
+incdir+${I2C_IP_VERIF_PATH}/tb

// Compilation VIP design (agent) list
-f ${I2C_VIP_ROOT}/i2c_vip.f
-f ${HOST_VIP_ROOT}/host_vip.f

// Compilation Environment
${I2C_IP_VERIF_PATH}/tb/env_pkg.sv
${I2C_IP_VERIF_PATH}/sequences/seq_pkg.sv
${I2C_IP_VERIF_PATH}/testcases/test_pkg.sv
${I2C_IP_VERIF_PATH}/tb/testbench.sv

