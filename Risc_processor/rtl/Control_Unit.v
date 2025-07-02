`timescale 1ns / 1ps
// Verilog code for Control Unit
module Control_Unit(
      input [3:0] opcode,        // Opcode from the instruction
      output reg [1:0] alu_op,   // Control signal for ALU operation (to ALU_Control)
      output reg jump,           // Control signal for Jump instruction
      output reg beq,            // Control signal for Branch on Equal instruction
      output reg bne,            // Control signal for Branch on Not Equal instruction
      output reg mem_read,       // Control signal for Data Memory Read
      output reg mem_write,      // Control signal for Data Memory Write
      output reg alu_src,        // Control signal to select ALU second operand (register or immediate)
      output reg reg_dst,        // Control signal to select destination register (rd or rt)
      output reg mem_to_reg,     // Control signal to select data for write-back (ALU result or memory data)
      output reg reg_write       // Control signal for Register File Write Enable
    );

always @(*) begin
 case(opcode) 
 4'b0000:  begin // LW (Load Word) Instruction
   reg_dst    = 1'b0; // Write to rt (instr[8:6])
   alu_src    = 1'b1; // ALU second operand is sign-extended immediate
   mem_to_reg = 1'b1; // Write data from data memory to register
   reg_write  = 1'b1; // Enable register write
   mem_read   = 1'b1; // Enable data memory read
   mem_write  = 1'b0; // Disable data memory write
   beq        = 1'b0; // Not a branch
   bne        = 1'b0; // Not a branch
   alu_op     = 2'b10; // ALU operation for address calculation (ADD)
   jump       = 1'b0; // Not a jump
  end
 4'b0001:  begin // SW (Store Word) Instruction
   reg_dst    = 1'b0; // Not applicable for SW (no reg write)
   alu_src    = 1'b1; // ALU second operand is sign-extended immediate
   mem_to_reg = 1'b0; // Not applicable (no reg write from memory)
   reg_write  = 1'b0; // Disable register write
   mem_read   = 1'b0; // Disable data memory read
   mem_write  = 1'b1; // Enable data memory write
   beq        = 1'b0; // Not a branch
   bne        = 1'b0; // Not a branch
   alu_op     = 2'b10; // ALU operation for address calculation (ADD)
   jump       = 1'b0; // Not a jump
  end
 // Data Processing Instructions (ADD, SUB, INV, LSL, LSR, AND, OR, SLT)
 // These all have similar control signals, differing only in their specific opcode
 // and how the ALU_Control unit translates it to ALU_Cnt.
 // The ALUOp for these is 2'b00, indicating the Opcode directly selects the ALU operation.
 4'b0010:  begin // ADD
   reg_dst    = 1'b1; // Write to ws (instr[5:3])
   alu_src    = 1'b0; // ALU second operand is from register file (rs2)
   mem_to_reg = 1'b0; // Write ALU result to register
   reg_write  = 1'b1; // Enable register write
   mem_read   = 1'b0; // Disable data memory read
   mem_write  = 1'b0; // Disable data memory write
   beq        = 1'b0; // Not a branch
   bne        = 1'b0; // Not a branch
   alu_op     = 2'b00; // ALU operation determined by opcode (for ALU_Control)
   jump       = 1'b0; // Not a jump
  end
 4'b0011:  begin // SUB
   reg_dst    = 1'b1;
   alu_src    = 1'b0;
   mem_to_reg = 1'b0;
   reg_write  = 1'b1;
   mem_read   = 1'b0;
   mem_write  = 1'b0;
   beq        = 1'b0;
   bne        = 1'b0;
   alu_op     = 2'b00;
   jump       = 1'b0;
  end
 4'b0100:  begin // INV
   reg_dst    = 1'b1;
   alu_src    = 1'b0; // Though only one operand, this path is for consistency
   mem_to_reg = 1'b0;
   reg_write  = 1'b1;
   mem_read   = 1'b0;
   mem_write  = 1'b0;
   beq        = 1'b0;
   bne        = 1'b0;
   alu_op     = 2'b00;
   jump       = 1'b0;
  end
 4'b0101:  begin // LSL
   reg_dst    = 1'b1;
   alu_src    = 1'b0;
   mem_to_reg = 1'b0;
   reg_write  = 1'b1;
   mem_read   = 1'b0;
   mem_write  = 1'b0;
   beq        = 1'b0;
   bne        = 1'b0;
   alu_op     = 2'b00;
   jump       = 1'b0;
  end
 4'b0110:  begin // LSR
   reg_dst    = 1'b1;
   alu_src    = 1'b0;
   mem_to_reg = 1'b0;
   reg_write  = 1'b1;
   mem_read   = 1'b0;
   mem_write  = 1'b0;
   beq        = 1'b0;
   bne        = 1'b0;
   alu_op     = 2'b00;
   jump       = 1'b0;
  end
 4'b0111:  begin // AND
   reg_dst    = 1'b1;
   alu_src    = 1'b0;
   mem_to_reg = 1'b0;
   reg_write  = 1'b1;
   mem_read   = 1'b0;
   mem_write  = 1'b0;
   beq        = 1'b0;
   bne        = 1'b0;
   alu_op     = 2'b00;
   jump       = 1'b0;
  end
 4'b1000:  begin // OR
   reg_dst    = 1'b1;
   alu_src    = 1'b0;
   mem_to_reg = 1'b0;
   reg_write  = 1'b1;
   mem_read   = 1'b0;
   mem_write  = 1'b0;
   beq        = 1'b0;
   bne        = 1'b0;
   alu_op     = 2'b00;
   jump       = 1'b0;
  end
 4'b1001:  begin // SLT
   reg_dst    = 1'b1;
   alu_src    = 1'b0;
   mem_to_reg = 1'b0;
   reg_write  = 1'b1;
   mem_read   = 1'b0;
   mem_write  = 1'b0;
   beq        = 1'b0;
   bne        = 1'b0;
   alu_op     = 2'b00;
   jump       = 1'b0;
  end
 4'b1011:  begin // BEQ (Branch on Equal)
   reg_dst    = 1'b0; // No register write
   alu_src    = 1'b0; // ALU compares two registers (rs1, rs2)
   mem_to_reg = 1'b0; // No register write from memory
   reg_write  = 1'b0; // Disable register write
   mem_read   = 1'b0; // Disable data memory read
   mem_write  = 1'b0; // Disable data memory write
   beq        = 1'b1; // Enable Branch on Equal logic
   bne        = 1'b0; // Not a BNE branch
   alu_op     = 2'b01; // ALU operation for comparison (SUB)
   jump       = 1'b0; // Not a jump
  end
 4'b1100:  begin // BNE (Branch on Not Equal)
   reg_dst    = 1'b0; // No register write
   alu_src    = 1'b0; // ALU compares two registers (rs1, rs2)
   mem_to_reg = 1'b0; // No register write from memory
   reg_write  = 1'b0; // Disable register write
   mem_read   = 1'b0; // Disable data memory read
   mem_write  = 1'b0; // Disable data memory write
   beq        = 1'b0; // Not a BEQ branch
   bne        = 1'b1; // Enable Branch on Not Equal logic
   alu_op     = 2'b01; // ALU operation for comparison (SUB)
   jump       = 1'b0; // Not a jump
  end
 4'b1101:  begin // J (Jump) Instruction
   reg_dst    = 1'b0; // No register write
   alu_src    = 1'b0; // Not applicable
   mem_to_reg = 1'b0; // No register write from memory
   reg_write  = 1'b0; // Disable register write
   mem_read   = 1'b0; // Disable data memory read
   mem_write  = 1'b0; // Disable data memory write
   beq        = 1'b0; // Not a branch
   bne        = 1'b0; // Not a branch
   alu_op     = 2'b00; // Not directly used for PC update in JMP
   jump       = 1'b1; // Enable Jump logic
  end   
 default: begin // Default case for unhandled opcodes
    reg_dst    = 1'b1;
    alu_src    = 1'b0;
    mem_to_reg = 1'b0;
    reg_write  = 1'b1;
    mem_read   = 1'b0;
    mem_write  = 1'b0;
    beq        = 1'b0;
    bne        = 1'b0;
    alu_op     = 2'b00;
    jump       = 1'b0; 
  end
 endcase
end
endmodule
