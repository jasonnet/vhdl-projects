
# Makefile

all: test_blink_one  module_fifo_regs_no_flags

test_blink_one:  blink.vhd  tests/blink.one.tb.vhd
	xvhdl $^                    --log logs/xvhdl.log
	xelab $@  --debug typical   --log logs/xelab.log
	xsim  $@ --R                --log logs/xsim.log   | bash tools/detect-error.sh
	@echo To re-run in gui...
	@echo "  " xsim $@  --gui
	@mv *.jou  logs/
	@mv *.pb   logs/
	@rm *.wdb


module_fifo_regs_no_flags: src/module_fifo_regs_no_flags.vhd  src/module_fifo_regs_no_flags_tb.vhd
	xvhdl $^                       --log logs/xvhdl.log
	xelab $@_tb  --debug typical   --log logs/xelab.log
	xsim  $@_tb --R                --log logs/xsim.log   | bash tools/detect-error.sh
	@echo To re-run in gui...
	@echo "  " xsim $@_tb  --gui
	@mv *.jou  logs/
	@mv *.pb   logs/
	@rm *.wdb
	
clean:
	rm -fr webtalk* xelab* xim* xvhdl*
	rm -Rf .Xil *.pb *.jou  *.wdb  logs/*.log
	rm logs/*

