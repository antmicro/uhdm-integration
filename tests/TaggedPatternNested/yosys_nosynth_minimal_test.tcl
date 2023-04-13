yosys -import
plugin -i systemverilog 

yosys -import

proc read_files {} {
read_systemverilog -debug \
../src/lowrisc_ip_flash_ctrl_0.1/rtl/minimal_test.sv \

}

set top flash_ctrl
set name lowrisc_ip_flash_ctrl_0.1

verilog_defaults -push
verilog_defaults -add -defer

read_files
write_rtlil flash_ctrl.rtlil

verilog_defaults -pop
