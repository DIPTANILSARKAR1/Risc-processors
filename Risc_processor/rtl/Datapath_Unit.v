`timescale 1ns / 1ps
// Verilog code for Data Path of the processor
module Datapath_Unit(
 input clk,               // Clock input
 // Control signals from Control Unit
 input jump,              // Jump control
 input beq,               // Branch on Equal control
 input mem_read,          // Memory Read control
 input mem_write,         // Memory Write control
 input alu_src,           // ALU source select control
 input reg_dst,           // Register destination select control
 input mem_to_reg,        // Memory to Register write-back select control
 input reg_write,         // Register Write enable
 input bne,               // Branch on Not Equal control
 input [1:0] alu_op,      // ALU operation type (for ALU_Control)
 output [3:0] opcode      // Opcode extracted from instruction (to Control Unit)
);

 // Program Counter (PC)
 reg  [15:0] pc_current;   // Current Program Counter value
 wire [15:0] pc_next;      // Next Program Counter value
 wire [15:0] pc2;          // PC + 2 (for next instruction fetch and branch target calculation)

 // Instruction Memory Interface
 wire [15:0] instr;        // Current instruction fetched from Instruction Memory

 // Register File Interface
 wire [2:0] reg_write_dest;  // Destination register address for write
 wire [15:0] reg_write_data;  // Data to be written to register file
 wire [2:0] reg_read_addr_1; // Read address for rs1
 wire [15:0] reg_read_data_1; // Data read from rs1
 wire [2:0] reg_read_addr_2; // Read address for rs2
 wire [15:0] reg_read_data_2; // Data read from rs2

 // Immediate Extension / ALU Second Operand Mux
 wire [15:0] ext_im;        // Sign-extended immediate value
 wire [15:0] read_data2;    // Second operand for ALU (rs2 or immediate)

 // ALU and ALU Control
 wire [2:0] ALU_Control;   // ALU function select signal
 wire [15:0] ALU_out;       // Result from ALU
 wire zero_flag;           // Zero flag from ALU

 // Branch/Jump Target Calculation
 wire [15:0] PC_j;          // Jump target address
 wire [15:0] PC_beq;        // Branch on Equal target address
 wire [15:0] PC_bne;        // Branch on Not Equal target address
 wire [15:0] PC_2beq;       // PC after BEQ check
 wire [15:0] PC_2bne;       // PC after BNE check
 wire [12:0] jump_shift;    // Shifted immediate for Jump
 wire beq_control;         // Combined BEQ condition
 wire bne_control;         // Combined BNE condition

 // Data Memory Interface
 wire [15:0] mem_read_data; // Data read from Data Memory

 // PC Logic: Initialize PC and update on clock edge
 initial begin
  pc_current <= 16'd0; // Start PC at address 0
 end
 always @(posedge clk) begin 
   pc_current <= pc_next; // Update PC with the next instruction address
 end
 assign pc2 = pc_current + 16'd2; // Increment PC by 2 (for 16-bit instructions, 2 bytes/instruction)

 // Instruction Memory Instantiation
 Instruction_Memory im(
  .pc(pc_current),      // Current PC as address
  .instruction(instr)   // Output current instruction
 );

 // Jump Target Calculation: Shift immediate left by 1 and combine with PC[15:13]
 assign jump_shift = {instr[11:0], 1'b0}; // Shift 12-bit immediate by 1 (effective 13-bit offset, word aligned)

 // Register Destination Mux: Selects destination register for write-back
 // reg_dst = 1: D-type instruction (ws = instr[5:3])
 // reg_dst = 0: Load instruction (ws = instr[8:6])
 assign reg_write_dest = (reg_dst == 1'b1) ? instr[5:3] : instr[8:6];

 // Register File Read Address Assignments
 assign reg_read_addr_1 = instr[11:9]; // rs1 register address
 assign reg_read_addr_2 = instr[8:6];  // rs2 register address

 // GENERAL PURPOSE REGISTERS Instantiation
 GPRs reg_file
 (
  .clk(clk),                 // Clock
  .reg_write_en(reg_write),  // Register write enable
  .reg_write_dest(reg_write_dest), // Destination register address
  .reg_write_data(reg_write_data), // Data to write
  .reg_read_addr_1(reg_read_addr_1), // Read address 1
  .reg_read_data_1(reg_read_data_1), // Data read 1
  .reg_read_addr_2(reg_read_addr_2), // Read address 2
  .reg_read_data_2(reg_read_data_2)  // Data read 2
 );

 // Immediate Extension (Sign-extend 6-bit immediate to 16-bit)
 assign ext_im = {{10{instr[5]}}, instr[5:0]}; // Sign-extend bit 5 of instruction

 // ALU Control Unit Instantiation
 alu_control ALU_Control_unit(
  .ALUOp(alu_op),             // ALU operation from Control Unit
  .Opcode(instr[15:12]),      // Instruction opcode
  .ALU_Cnt(ALU_Control)       // Output ALU function select
 );

 // ALU Second Operand Mux
 // alu_src = 1: Immediate value (for LW, SW)
 // alu_src = 0: Second register operand (for data processing, branches)
 assign read_data2 = (alu_src == 1'b1) ? ext_im : reg_read_data_2;

 // ALU Instantiation
 ALU alu_unit(
  .a(reg_read_data_1),   // First operand (rs1)
  .b(read_data2),        // Second operand (rs2 or immediate)
  .alu_control(ALU_Control), // ALU function select
  .result(ALU_out),      // ALU result
  .zero(zero_flag)       // Zero flag output
 );

 // Branch Target Calculation: PC + 2 + (sign-extended offset << 1)
 assign PC_beq = pc2 + {ext_im[14:0], 1'b0}; // Shift 15-bit immediate by 1 (word aligned)
 assign PC_bne = pc2 + {ext_im[14:0], 1'b0}; // Same calculation for BNE

 // Branch Condition Evaluation
 assign beq_control = beq & zero_flag;      // Branch if BEQ enabled AND ALU result is zero
 assign bne_control = bne & (~zero_flag);   // Branch if BNE enabled AND ALU result is NOT zero

 // PC_next determination logic
 // Priority: Jump > BNE > BEQ > PC+2
 assign PC_2beq = (beq_control == 1'b1) ? PC_beq : pc2;       // If BEQ, take branch, else PC+2
 assign PC_2bne = (bne_control == 1'b1) ? PC_bne : PC_2beq;    // If BNE, take branch, else PC_2beq
 assign PC_j    = {pc2[15:13], jump_shift};                  // Jump address calculation
 assign pc_next = (jump == 1'b1) ? PC_j : PC_2bne;            // If Jump, take jump, else PC_2bne

 /// Data Memory Instantiation
  Data_Memory dm
   (
    .clk(clk),                     // Clock
    .mem_access_addr(ALU_out),     // Memory address from ALU result (for LW/SW)
    .mem_write_data(reg_read_data_2), // Data to write (from rs2 for SW)
    .mem_write_en(mem_write),      // Memory write enable
    .mem_read(mem_read),           // Memory read enable
    .mem_read_data(mem_read_data)  // Data read from memory
   );
 
 // Write-Back Stage Mux: Selects data to write back to register file
 // mem_to_reg = 1: Data from Data Memory (for LW)
 // mem_to_reg = 0: ALU result (for data processing)
 assign reg_write_data = (mem_to_reg == 1'b1) ? mem_read_data : ALU_out;

 // Output opcode to Control Unit
 assign opcode = instr[15:12];

endmodule