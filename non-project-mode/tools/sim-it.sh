#!/bin/bash

# args
#    module-name:  ex. module_cluster
#    all the dependeny files

XELAB_OPS="--timeprecision_vhdl 100ps  --debug typical"

MODNAME=$1
shift;

xvhdl $@               --log logs/xvhdl.log
xelab ${MODNAME}_tb  ${XELAB_OPS}   --log logs/xelab.log
xsim  ${MODNAME}_tb --R                --log logs/xsim.log   | bash tools/detect-error.sh
echo To re-run in gui...
echo "  " xsim ${MODNAME}_tb  --gui
mv *.jou  *.pb  logs/
#rm *.wdb
touch logs/${MODNAME}.done
