#!/bin/sh

#. /AFs/ece/class/ece447/bin/setup_bash
rm -r work
vlib work
vlog +define+CLASSD  nand_controller_top2.v tb.v nand_model.v nand_die_model.v register.v counter.v buffer.v 
vsim -c -do "run -all" top
