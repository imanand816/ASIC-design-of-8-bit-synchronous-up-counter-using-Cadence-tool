set_attr lib_search_path ../lib/
set_attr hdl_search_path ../rtl/
set_attr library slow_vdd1v0_basicCells.lib
read_hdl counter.v
elaborate
read_sdc ../constraints/constraints_top.sdc
synthesize -to_mapped -effort medium
write_hdl > counter_netlist.v
write_sdc > counter_sdc.sdc
