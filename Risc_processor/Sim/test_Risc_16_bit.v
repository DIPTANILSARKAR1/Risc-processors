`timescale 1ns / 1ps
`include "../rtl/Parameter.v"

module test_Risc_16_bit;

reg clk;

Risc_16_bit uut (
  .clk(clk)
);

initial begin
  $dumpfile("riscv_wave.vcd");
  $dumpvars(0, test_Risc_16_bit);
  $dumpvars(1, uut);
end

initial begin
  clk <= 1'b0;
  `simulation_time;
  $finish;
end

always begin
  #5 clk = ~clk;
end

endmodule
