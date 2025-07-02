`timescale 1ns / 1ps
// ALU_Control Verilog code
module alu_control(
 output reg[2:0] ALU_Cnt, // ALU control signal to select operation
 input [1:0] ALUOp,       // ALU operation from Control Unit
 input [3:0] Opcode       // Instruction opcode from instruction register
);

wire [5:0] ALUControlIn;
// Concatenate ALUOp and Opcode to form the input for ALU control logic
assign ALUControlIn = {ALUOp, Opcode};

always @(ALUControlIn) 
 begin
 casex (ALUControlIn)
   // Data Processing Instructions (ALUOp = 00, Opcode determines exact operation)
   // All data processing instructions use ALUOp = 00
   // 0000_0010: ADD (Opcode 0010, ALU_Cnt 000)
   6'b00_0010: ALU_Cnt = 3'b000; 
   // 0000_0011: SUB (Opcode 0011, ALU_Cnt 001)
   6'b00_0011: ALU_Cnt = 3'b001; 
   // 0000_0100: INV (Opcode 0100, ALU_Cnt 010)
   6'b00_0100: ALU_Cnt = 3'b010; 
   // 0000_0101: LSL (Opcode 0101, ALU_Cnt 011)
   6'b00_0101: ALU_Cnt = 3'b011; 
   // 0000_0110: LSR (Opcode 0110, ALU_Cnt 100)
   6'b00_0110: ALU_Cnt = 3'b100; 
   // 0000_0111: AND (Opcode 0111, ALU_Cnt 101)
   6'b00_0111: ALU_Cnt = 3'b101; 
   // 0000_1000: OR (Opcode 1000, ALU_Cnt 110)
   6'b00_1000: ALU_Cnt = 3'b110; 
   // 0000_1001: SLT (Opcode 1001, ALU_Cnt 111)
   6'b00_1001: ALU_Cnt = 3'b111; 

   // Memory Access Instructions (LW, SW) use ALUOp = 10 for address calculation (ADD)
   // The 'xxxx' means the opcode bits don't matter for ALUOp = 10, as they all perform ADD for address calculation
   6'b10_xxxx: ALU_Cnt = 3'b000; // LW, SW (Opcode 0000, 0001 respectively) - performs ADD for address calculation

   // Branch Instructions (BEQ, BNE) use ALUOp = 01 for subtraction to check equality/inequality
   // The 'xxxx' means the opcode bits don't matter for ALUOp = 01, as they both perform SUB for comparison
   6'b01_xxxx: ALU_Cnt = 3'b001; // BEQ, BNE (Opcode 1011, 1100 respectively) - performs SUB for comparison

   default: ALU_Cnt = 3'b000; // Default to ADD
  endcase
end

endmodule