# filename: build.tcl

# This script is derived from this sequence of articles: https://hwjedi.wordpress.com/2017/01/04/vivado-non-project-mode-the-only-way-to-go-for-serious-fpga-designers/

# Invoke in batch mode via:
#     vivado -notrace -mode batch -source build.tcl

# -1: generic,  0: plain,  1: black,  2: blue, 3: one
set target 3
puts "line10"

set BUILD_DATE [ clock format [ clock seconds ] -format %m%d%Y ]
set BUILD_TIME [ clock format [ clock seconds ] -format %H%M%S ]


# Assign part to in-memory project (will also create the in-memory project)
# Used when generating ip and executing synth, impl.
#set_part "xc7z010clg400-1"

if {$target == -1 } {
  # generic, no particular board or part  
} elseif {$target == 0 } {
  # plain
  set PART_NM "xc7z010clg400-1"
  #set_property board_part krtkl.com:snickerdoodle:part0:1.0 [current_project]
} elseif {$target == 1 } {
  # black
  set PART_NM "xc7z020clg400-3"
  #set_property board_part krtkl.com:snickerdoodle_black:part0:1.0 [current_project]
} elseif {$target == 2 } {
  # blue
  set PART_NM "xc7z010clg400-1"
  #set_property board_part krtkl.com:snickerdoodle_prime_le:part0:1.0 [current_project]
} elseif {$target == 3 } {
  # one
  set PART_NM "xc7z010clg400-1"
  #set_part "xc7z010clg400-1"
  #set_property board_part krtkl.com:snickerdoodle_one:part0:1.0 [current_project]
} else {
  puts "invalid target board"
  exit
}
puts "line42"

# Assign part to in-memory project (will also create the in-memory project)
# Used when generating ip and executing synth, impl.
set_part $PART_NM

# read all design files
#read_verilog -sv ../rtl/lms.sv
#read_verilog -sv ../rtl/filt.sv
#read_verilog -sv ../rtl/top.sv
read_vhdl blink.vhd

#read_ip ../rtl/x_ip/A19xB17pP37iq/A19xB17pP37iq.xci
# read constraints

#read_xdc ../rtl/clocks.xdc
#read_xdc ../rtl/pblocks.xdc
#read_xdc ../rtl/pins.xdc

# generate ip
generate_target all [get_ips]
# Synthesize Design
synth_design -top blink -part $PART_NM

# Opt Design 
opt_design

# Place Design
place_design 

#place_design -directive Explore
#phys_opt_design -directive AggressiveExplore
#phys_opt_design -directive AggressiveFanoutOpt
#phys_opt_design -directive AlternateReplication
#route_design -directive Explore
#phys_opt_design -directive AggressiveExplore
#route_design -tns_cleanup


# Route Design
route_design

# Write out bitfile
#write_debug_probes -force my_proj/my_proj.ltx
write_bitstream -force system.bit

# To run this build script run in a vivado tcl shell like this:
#
# $ vivado -mode tcl
# ...
# Vivado% source build.tcl
