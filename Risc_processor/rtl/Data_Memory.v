`include "../rtl/Parameter.v"
// Verilog code for data Memory
module Data_Memory(
 input clk,                 // Clock input
 // address input, shared by read and write port
 input [15:0]   mem_access_addr, // Address for memory access
 
 // write port
 input [15:0]   mem_write_data,  // Data to be written into memory
 input     mem_write_en,    // Write enable signal
 input mem_read,            // Read enable signal
 // read port
 output [15:0]   mem_read_data   // Data read from memory
);

// Declare a register array to represent the memory
reg [`col - 1:0] memory [`row_d - 1:0]; 
integer f; // File handle for monitoring
wire [2:0] ram_addr = mem_access_addr[2:0]; // Use lower 3 bits for 8-word memory

initial begin
 // Load initial data from test.data file into memory
 $readmemb("../test/test.data", memory);
  
 // Open a file for monitoring memory contents (specified by `filename in Parameter.v)
 f = $fopen(`filename);
 // Monitor memory contents and write them to the file at each time step
 $monitor(f, "time = %d\n", $time, 
 "\tmemory[0] = %b\n", memory[0],   
 "\tmemory[1] = %b\n", memory[1],
 "\tmemory[2] = %b\n", memory[2],
 "\tmemory[3] = %b\n", memory[3],
 "\tmemory[4] = %b\n", memory[4],
 "\tmemory[5] = %b\n", memory[5],
 "\tmemory[6] = %b\n", memory[6],
 "\tmemory[7] = %b\n", memory[7]);

 // Define the simulation stop time (from Parameter.v)
 `simulation_time;
 $fclose(f); // Close the file when simulation finishes
end
 
// Always block for memory write operation on positive clock edge
always @(posedge clk) begin
  if (mem_write_en) begin
   memory[ram_addr] <= mem_write_data; // Write data to memory at the specified address
  end
end

// Assign memory read data based on mem_read signal
// If mem_read is enabled, output data from memory; otherwise, output 0
assign mem_read_data = (mem_read == 1'b1) ? memory[ram_addr] : 16'd0;

endmodule