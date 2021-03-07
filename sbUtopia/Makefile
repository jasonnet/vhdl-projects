



system.bit.bin: project.tcl Makefile src/design_1.bd  src/constraints.xdc  ip/blink/component.xml   ip/blink/blink.vhd
	rm -f vivado.jou   vivado.log
	rm -f system.bit.bin  system.bit system.bin
	vivado  -notrace  -mode batch -source do.tcl  -tclargs 1


new-project:
	rm vivado.jou   vivado.log
	vivado  -notrace  -mode batch -source do.tcl  -tclargs 0

gui:
	vivado  project/snickBlink.xpr &


clean: 
	rm -Rf  project  .Xil   system.bit system.bit.bin  system.bin   src/hdl  src/hw_*  src/ip   src/ipshared  src/sim  src/synth   src/*.bda  src/*.bxml src/design_1_ooc*  src/ui   vivado.jou  vivado.log 