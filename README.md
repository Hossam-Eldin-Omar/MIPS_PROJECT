## Description
This project involves the design and implementation of a MIPS (Microprocessor without Interlocked Pipeline Stages) processor using VHDL (VHSIC Hardware Description Language). The aim is to create a functional 16-bit MIPS processor capable of executing a variety of instructions, including arithmetic, logical, branching, and jumping operations.
## Features
1. 16-bit architecture: The processor operates with a 16-bit data path, which means it processes data in 16-bit chunks.
2. Instruction set: Implements a subset of the MIPS instruction set, including:
      Arithmetic operations: Addition (ADD), Subtraction (SUB), Multiplication (MUL), and Division (DIV).  
      Logical operations: AND, OR, and NOT.
      J-type Branch instructions: BEQ (Branch if Equal), Branch on carry, Branch if less than, Branch if greater than, Branch on zero.
3. Registers: Contains 8 general-purpose registers, each 16 bits wide, used for temporary data storage and manipulation.
      Memory Access: Supports basic load and store operations, allowing data transfer between the processor and memory.
4. Control Unit: Directs the operation of the processor, decoding instructions and generating the necessary control signals.
5. ALU (Arithmetic Logic Unit): Performs arithmetic and logical operations.
6. PC (Program Counter): Keeps track of the address of the next instruction to be executed.
