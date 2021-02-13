
# Makefile

all: test_blink_one

test_blink_one:  blink.vhd  tests/blink.one.tb.vhd
	@mkdir -p build/tmp
	xvhdl $^                    --log logs/xvhdl.log
	xelab $@  --debug typical   --log logs/xelab.log
	xsim  $@ --R                --log logs/xsim.log   | bash tools/detect-error.sh
	@echo To re-run in gui...
	@echo "  " xsim $@  --gui
	@mv *.jou  logs/
	@mv *.pb   logs/
	@rm *.wdb
	
clean:
	rm -fr webtalk* xelab* xim* xvhdl*
	rm -Rf .Xil *.pb *.jou  *.wdb  logs/*.log
	rm logs/*

