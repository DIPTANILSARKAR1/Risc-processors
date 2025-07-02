#!/bin/bash
# Script to compile the Verilog source files using Icarus Verilog

# Create output directories if they don't exist
mkdir -p ../build
mkdir -p ../test

# Remove previous simulation output file
rm -f ../test/memory_trace.txt

# Compile all Verilog modules
# -o: specify output file name
# -s: specify top-level module
# -I ../rtl: Add the ../rtl directory to the include path for modules to find Parameter.v
iverilog -o ../build/riscv_sim -s test_Risc_16_bit \
    -I ../rtl \
    ../rtl/Parameter.v \
    ../rtl/ALU.v \
    ../rtl/ALU_Control.v \
    ../rtl/GPRs.v \
    ../rtl/Instruction_Memory.v \
    ../rtl/Data_Memory.v \
    ../rtl/Control_Unit.v \
    ../rtl/Datapath_Unit.v \
    ../rtl/Risc_16_bit.v \
    ../sim/test_Risc_16_bit.v

if [ $? -eq 0 ]; then
    echo "Compilation successful. Executable created: ../build/riscv_sim"
else
    echo "Compilation failed."
fi