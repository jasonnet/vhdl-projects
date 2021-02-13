#!/bin/bash

rm vivado.jou
rm vivado.log
vivado -notrace -mode batch -source build.tcl
