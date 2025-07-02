`include "../rtl/Parameter.v"
// Verilog code for Instruction Memory
module Instruction_Memory(
 input [15:0] pc,            // Program Counter as address input
 output [15:0] instruction   // Output instruction at the given address
);

// Declare a register array to represent the instruction memory
// Size defined by `col (16-bit) and `row_i (number of instructions) from Parameter.v
reg [`col - 1:0] memory [`row_i - 1:0]; 

// Use lower 4 bits of PC for addressing (assuming 16-word instruction memory)
// (PC[4:1] for byte addressable memory where instructions are 2 bytes)
wire [3 : 0] rom_addr = pc[4 : 1]; 

// Initialize instruction memory by reading from test.prog file at the start of simulation
initial begin
  // $readmemb reads binary data from a file into a memory
  // "./test/test.prog" is the file path
  // memory is the destination memory
  // 0 is the start address in memory, 14 is the end address (15 words total, 0 to 14)
  $readmemb("../test/test.prog", memory, 0, 14); 
end

// Assign instruction output directly from memory based on calculated address
assign instruction =  memory[rom_addr]; 

endmodule