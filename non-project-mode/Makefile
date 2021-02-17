
# Makefile

all: module_fifo_regs_no_flags module_fifo_regs_with_flags module_dual_ring_node module_open_node_ring


logs/module_open_node_ring.done              : logs/%.done :  logs/module_dual_ring_node.done  src/%.vhd  src/%_tb.vhd  
	tools/sim-it.sh  $(patsubst logs/%.done, %, $@)  $(filter %.vhd,$^)
logs/module_dual_ring_node.done              : logs/%.done :  logs/module_fifo_regs_with_flags.done  src/%.vhd  src/%_tb.vhd  
	tools/sim-it.sh  $(patsubst logs/%.done, %, $@)  $(filter %.vhd,$^)
logs/module_fifo_regs_with_flags.done : logs/%.done :                                         src/%.vhd  src/%_tb.vhd  
	tools/sim-it.sh  $(patsubst logs/%.done, %, $@)  $(filter %.vhd,$^)
logs/module_fifo_regs_no_flags.done : logs/%.done :                                           src/%.vhd  src/%_tb.vhd  
	tools/sim-it.sh  $(patsubst logs/%.done, %, $@)  $(filter %.vhd,$^)

module_open_node_ring       :  % : logs/%.done
module_dual_ring_node       :  % : logs/%.done
module_fifo_regs_with_flags :  % : logs/%.done
module_fifo_regs_no_flags   :  % : logs/%.done

	
clean:
	rm -fr webtalk* xelab* xim* xvhdl*
	rm -Rf .Xil *.pb *.jou  *.wdb  logs/*.log
	rm logs/*

