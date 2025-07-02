`timescale 1ns / 1ps

module alu_control(
  output reg [2:0] ALU_Cnt, // ALU control signal
  input [1:0] ALUOp,        // ALU operation type
  input [3:0] Opcode        // Instruction opcode
);

wire [5:0] ALUControlIn;
assign ALUControlIn = {ALUOp, Opcode};

always @(ALUControlIn) begin
  casex (ALUControlIn)
    6'b00_0010: ALU_Cnt = 3'b000; // ADD
    6'b00_0011: ALU_Cnt = 3'b001; // SUB
    6'b00_0100: ALU_Cnt = 3'b010; // INV
    6'b00_0101: ALU_Cnt = 3'b011; // LSL
    6'b00_0110: ALU_Cnt = 3'b100; // LSR
    6'b00_0111: ALU_Cnt = 3'b101; // AND
    6'b00_1000: ALU_Cnt = 3'b110; // OR
    6'b00_1001: ALU_Cnt = 3'b111; // SLT

    6'b10_xxxx: ALU_Cnt = 3'b000; // LW, SW → ADD
    6'b01_xxxx: ALU_Cnt = 3'b001; // BEQ, BNE → SUB

    default:    ALU_Cnt = 3'b000;
  endcase
end

endmodule
