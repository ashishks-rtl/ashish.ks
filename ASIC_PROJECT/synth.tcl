
# =====================================================
# Vivado 2019.1 - VS Code Integration
# FPGA: Nexys Video Artix-7
# Part: XC7A200T-1SBG484C
# Top: clock_divider
# =====================================================

set project_dir "D:/shared/ashish.k/RTL/ashish.ks/ASIC_PROJECT"

cd $project_dir

set top_module "clock_divider"
set fpga_part "xc7a200tsbg484-1"

# Create output directories
file mkdir reports
file mkdir checkpoints
file mkdir output

puts "=================================="
puts "VIVADO 2019.1 SYNTHESIS STARTED"
puts "=================================="

# Read RTL
read_verilog clock_divider.v

# Synthesis
synth_design -top $top_module -part $fpga_part

# Reports
report_utilization -file reports/utilization.rpt
report_timing_summary -file reports/timing_summary.rpt
report_clock_utilization -file reports/clock_utilization.rpt
report_drc -file reports/synthesis_drc.rpt

# Save checkpoint
write_checkpoint -force checkpoints/post_synth.dcp

# Export synthesized netlist
write_verilog -force output/synthesized_netlist.v

puts "=================================="
puts "SYNTHESIS COMPLETED"
puts "=================================="

exit
