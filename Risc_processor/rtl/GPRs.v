`timescale 1ns / 1ps
// Verilog code for register file
module GPRs(
 input    clk,                 // Clock input
 // write port
 input    reg_write_en,        // Register write enable
 input  [2:0] reg_write_dest,  // Destination register address for write
 input  [15:0] reg_write_data, // Data to be written
 //read port 1
 input  [2:0] reg_read_addr_1,  // Read address for port 1
 output  [15:0] reg_read_data_1, // Data read from port 1
 //read port 2
 input  [2:0] reg_read_addr_2,  // Read address for port 2
 output  [15:0] reg_read_data_2  // Data read from port 2
);

// Declare a register array for 8 16-bit general purpose registers
reg [15:0] reg_array [7:0]; 
integer i; // Loop variable for initialization

// Initialize all registers to 0 at the beginning of simulation
initial begin
  for(i = 0; i < 8; i = i + 1) begin
   reg_array[i] <= 16'd0;
  end
end
 
// Always block for register write operation on positive clock edge
always @ (posedge clk ) begin
   if(reg_write_en) begin // If register write is enabled
    reg_array[reg_write_dest] <= reg_write_data; // Write data to the destination register
   end
end
 
// Assign read data directly from the register array (combinational read)
assign reg_read_data_1 = reg_array[reg_read_addr_1]; // Read data from address 1
assign reg_read_data_2 = reg_array[reg_read_addr_2]; // Read data from address 2

endmodule