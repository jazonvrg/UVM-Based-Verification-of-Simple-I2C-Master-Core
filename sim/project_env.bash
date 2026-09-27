#!/bin/bash -f

setup_dva

## UVM library path
export UVM_HOME=/ictc/other/tools/QuestaDVA/questasim/verilog_src/uvm-1.2

## Verify root path
export I2C_IP_VERIF_PATH=./..

## I2C VIP Design root path
export I2C_VIP_ROOT=$I2C_IP_VERIF_PATH/vip/i2c_vip

## HOST VIP Design root path
export HOST_VIP_ROOT=$I2C_IP_VERIF_PATH/vip/host_vip
