set_attr lib_search_path ../lib/
set_attr hdl_search_path ../rtl/
set_attr library slow_vdd1v0_basicCells.lib
read_hdl counter.v
elaborate 
read_sdc ../constraints/constraints_top.sdc
synthesize -to_mapped 
set_attr dft_scan_style muxed_scan 
set_attr dft_prefix dft_
define_dft shift_enable -name SE -active high -create_port SE
synthesize -to_mapped 
check_dft_rules 
set_attr dft_min_number_of_scan_chains 1 /designs/counter
define_dft scan_chain -name top_chain -sdi scan_in -sdo scan_out -create_ports  
synthesize -to_mapped 
connect_scan_chains -auto_create_chains 
synthesize -to_mapped 
report dft_chains 
write_sdf -nonegchecks -edges check_edge -timescale ns -recrem split > delays.sdf
write_et_atpg -library ../lib/slow_vdd1v0_basiccells.v
write_hdl > counter_netlist_dft.v
write_sdc > counter_sdc.sdc


