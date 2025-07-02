#!/bin/bash
# Script to run the compiled Verilog simulation

# Check if the compiled executable exists
if [ -f "../build/riscv_sim" ]; then
    echo "Running simulation..."
    vvp ../build/riscv_sim
    echo "Simulation finished. Memory trace saved to ../test/memory_trace.txt"
else
    echo "Simulation executable not found. Please run compile.sh first."
fi