#!/bin/bash

# args
#    module-name:  ex. module_cluster
#    all the dependeny files

XELAB_OPS="--timeprecision_vhdl 100ps  --debug typical"

MODNAME=$1
shift;

if [ -f logs/sim.writeout ] ; then  
  rm logs/sim.writeout
fi

xvhdl $@               --log logs/xvhdl.log                  | bash tools/detect-error.sh
if [ $? -ne 0 ]; then
  exit 1;
fi
xelab ${MODNAME}_tb  ${XELAB_OPS}   --log logs/xelab.log     | bash tools/detect-error.sh
if [ $? -ne 0 ]; then
  exit 2;
fi
SHOULD_EXIT=0
xsim  ${MODNAME}_tb --R                --log logs/xsim.log   | bash tools/detect-error.sh

if [ $? -ne 0 ]; then
    SHOULD_EXIT=$?
else  
    if [ -f logs/sim.writeout ] ; then  
      if [ -f expected_writeout/${MODNAME}.sim.writeout ] ; then  
        diff  expected_writeout/${MODNAME}.sim.writeout  logs/sim.writeout
        if [ $? -ne 0 ]; then
          SHOULD_EXIT=4;
          echo "To adopt this writeout as expected:"
          echo "   " cp  logs/sim.writeout  expected_writeout/${MODNAME}.sim.writeout  
        else
          echo "writeout files match";
        fi
      else
        echo "WARN: file not found: expected_writeout/${MODNAME}.sim.writeout"    
      fi  
    else
      echo "no writeout file";  
    fi
fi
echo "To re-run in gui:"
echo "   " xsim ${MODNAME}_tb  --gui
if [ $SHOULD_EXIT -ne 0 ] ; then
  exit $SHOULD_EXIT;
fi
mv *.jou  *.pb  logs/
#rm *.wdb
touch logs/${MODNAME}.done
