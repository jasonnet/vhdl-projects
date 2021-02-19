#!/bin/sh
rm vivado.jou
rm vivado.log
vivado -notrace -mode batch -source project.tcl
