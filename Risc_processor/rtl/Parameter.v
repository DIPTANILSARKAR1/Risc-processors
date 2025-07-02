`ifndef PARAMETER_H_
`define PARAMETER_H_

// fpga4student.com // FPGA projects, VHDL projects, Verilog projects
// Verilog code for RISC Processor
// Parameter file

`define col 16    // Width of instruction and data memory words (16 bits)
`define row_i 15  // Number of instructions in instruction memory (addresses 0 to 14, total 15 words)
                  // This number can be changed. Adding more instructions to verify your design is a good idea.
`define row_d 8   // The number of data words in data memory (addresses 0 to 7, total 8 words)
                  // We only use 8 data. Do not change this number. You can change the value of each data inside test.data file. Total number is fixed at 8.

// Filename for data memory monitoring output
`define filename "./test/memory_trace.txt" // Changed from original to a more descriptive name

// Simulation stop time
`define simulation_time #160 // Simulation will run for 160 time units

`endif