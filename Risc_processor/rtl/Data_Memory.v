`include "../rtl/Parameter.v"

module Data_Memory(
  input clk,
  input [15:0] mem_access_addr,
  input [15:0] mem_write_data,
  input mem_write_en,
  input mem_read,
  output [15:0] mem_read_data
);

reg [`col - 1:0] memory [`row_d - 1:0];
integer f;
wire [2:0] ram_addr = mem_access_addr[2:0];

initial begin
  $readmemb("../test/test.data", memory);
  f = $fopen(`filename);
  $monitor(f, "time = %d\n", $time,
           "\tmemory[0] = %b\n", memory[0],
           "\tmemory[1] = %b\n", memory[1],
           "\tmemory[2] = %b\n", memory[2],
           "\tmemory[3] = %b\n", memory[3],
           "\tmemory[4] = %b\n", memory[4],
           "\tmemory[5] = %b\n", memory[5],
           "\tmemory[6] = %b\n", memory[6],
           "\tmemory[7] = %b\n", memory[7]);
  `simulation_time;
  $fclose(f);
end

always @(posedge clk) begin
  if (mem_write_en)
    memory[ram_addr] <= mem_write_data;
end

assign mem_read_data = (mem_read) ? memory[ram_addr] : 16'd0;

endmodule
