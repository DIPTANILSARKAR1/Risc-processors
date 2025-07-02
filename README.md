# RISC-V 16 bit Processor 

This project implements a **minimal 16-bit RISC processor** using a single Verilog file: `Risc_16_bit.v`.  
The design includes instruction fetch, decode, register file, ALU operations, memory access, and basic control logic — all in a synthesizable format.

---

## 🔧 Features

- 16-bit data path and instruction width
- Register file with 8 general-purpose registers
- Supports R-type (e.g., ADD, SUB), I-type (e.g., LW, SW, BEQ), and J-type (JUMP) instructions
- Simple FSM-based control unit integrated
- Single-cycle execution per instruction (no pipelining)
- Clean, modular structure (ALU, memory, and control units are instantiated)

---

## 🧠 Architecture Overview

The top-level module `Risc_16_bit` instantiates the following submodules:

- **Control Unit**: Generates control signals based on the opcode
- **ALU Control**: Decodes function bits for ALU operations
- **Register File (GPRs)**: 8×16-bit register bank with dual read ports
- **Instruction Memory**: ROM initialized using `$readmemb`
- **Data Memory**: RAM accessible via LW and SW instructions
- **ALU**: Supports basic arithmetic and logical operations
- **Datapath**: Handles instruction execution, branching, and jumping

---

## 📄 File Description

### `Risc_16_bit.v`
This is the **top-level module** that connects all major components of the processor:
- Inputs: `clk`, `reset`
- Internal: Program Counter, instruction and data buses
- Built for simulation and FPGA synthesis

---

## ▶️ How to Simulate (Icarus Verilog Example)
....
