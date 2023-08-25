
#Step1 : setting up library paths
set_attr init_lib_search_path ../lib/
set_attr init_hdl_search_path ../rtl/
set_attr library slow_vdd1v0_basicCells.lib

#step2 :Reading netlist
read_hdl counter.v

#step3 : elaborate/connect all modules
elaborate

#step4 : Read constraints
read_sdc ../constraints/constraints_top.sdc

#step5: Synthesize the design to generic gates and set the effort level
set_attr syn_generic_effort high
syn_generic

#step6: Maps the design to the cells described in the supplied technology library and performs logic optimization
syn_map

#step7: Report results before optimisation
report_gates> reports/new_results/pre_optimized_gates.txt
report_area> reports/new_results/pre_optimized_area.txt
report_power> reports/new_results/pre_optimized_power.txt
report_timing> reports/new_results/pre_optimized_timing.txt

#step8: Optimization of design and running synthesis
#perform gate level optimization to improve timing on critical paths
set_attr syn_opt_effort high
syn_opt

#step9: Report results after optimization
report_gates> reports/new_results/post_optimized_gates.txt
report_power> reports/new_results/power.txt

#step10: Check design for timing errors
check_design> reports/new_results/design_check.txt

#step11: Writing out synthesized netlist and constraints 
write_hdl> reports/new_results/hdl_synthesis.v
write_sdc> reports/new_results/counter_sdc.sdc

#step12: Schematic
gui_show

#step13: Report final results
report_gates> reports/new_results/post_optimized_gates.txt
report_area> reports/new_results/area.txt
report_power> reports/new_results/power.txt
report_timing> reports/new_results/timing.txt


