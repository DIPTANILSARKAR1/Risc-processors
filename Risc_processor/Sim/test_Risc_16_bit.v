`timescale 1ns / 1ps
`include "../rtl/Parameter.v" // Include the parameter file

// Verilog testbench code to test the processor
module test_Risc_16_bit;

 // Inputs to the Unit Under Test (UUT)
 reg clk; // Clock signal

 // Instantiate the Unit Under Test (UUT) - the 16-bit RISC processor
 Risc_16_bit uut (
  .clk(clk) // Connect the clock to the processor
 );

 initial 
    begin
   $dumpfile("riscv_wave.vcd"); // waveform dump file
   $dumpvars(0, test_Risc_16_bit);
   $dumpvars(1, uut); // dump all signals in this testbenc
   end

 // Initial block for simulation setup
 initial begin
  // Initialize clock to 0
  clk <= 1'b0; 
  
  // Define simulation stop time using the parameter from Parameter.v
  // This will stop the simulation after `simulation_time (e.g., #160)
  `simulation_time; 
  
  // Finish the simulation
  $finish; 
 end

 // Always block to generate a free-running clock signal
 always begin
  #5 clk = ~clk; // Toggle clock every 5 time units (10 time units period, 100MHz clock if 1ns timescale)
 end

endmodule