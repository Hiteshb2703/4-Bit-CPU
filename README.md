# Custom 4-Bit Single-Cycle Processor (Verilog RTL)

A minimalist, single-cycle 4-bit CPU designed from the ground up in Verilog. This processor features a Harvard architecture with an 8-bit instruction word, dedicated Data RAM and Instruction ROM domains, a centralized Control Unit, and a custom 6-instruction ISA.

---

## Architecture Overview

The CPU is structured around a streamlined, non-pipelined single-cycle datapath designed for predictable instruction execution without complex hazards.

### Module Breakdown

* **`pc.v` (Program Counter):** 4-bit counter with asynchronous active-high reset. Automatically increments address execution sequentially on each rising clock edge.
* **`rom.v` (Instruction Memory):** 16-word $\times$ 8-bit asynchronous ROM containing pre-loaded program instructions.
* **`ram.v` (Data Memory):** 16-word $\times$ 4-bit RAM featuring asynchronous (combinational) reads and synchronous writes.
* **`alu.v` (Arithmetic Logic Unit):** 4-bit execution core performing basic arithmetic and bitwise logic operations.
* **`control_unit.v`:** Combinational opcode decoder generating routing signals (`Mem_Write` and `ACC_Write`).
* **`cpu_top.v`:** Top-level structural module integrating datapath, control, and accumulator storage.
* **`tb_cpu.v`:** Testbench generating a 100 MHz clock (`10ns` period), system reset sequencing, `$monitor` runtime logging, and VCD generation for waveform analysis.

---

## Instruction Set Architecture (ISA)

The architecture uses an **8-bit fixed instruction format**:
* **Bits [7:4]:** 4-bit Opcode
* **Bits [3:0]:** 4-bit Memory Address Operand

| Opcode (Hex) | Binary | Mnemonic | Format | Operation Description |
| :--- | :--- | :--- | :--- | :--- |
| `0x0` | `0000` | **LOAD** | `LOAD [addr]` | `ACC <= RAM[addr]` |
| `0x1` | `0001` | **STORE** | `STORE [addr]` | `RAM[addr] <= ACC` |
| `0x2` | `0010` | **ADD** | `ADD [addr]` | `ACC <= ACC + RAM[addr]` |
| `0x3` | `0011` | **SUB** | `SUB [addr]` | `ACC <= ACC - RAM[addr]` |
| `0x4` | `0100` | **AND** | `AND [addr]` | `ACC <= ACC & RAM[addr]` |
| `0x5` | `0101` | **XOR** | `XOR [addr]` | `ACC <= ACC ^ RAM[addr]` |

---

## Key Timing & Architectural Design Choices

* **Hazard Elimination via Asynchronous Reads:** The Data RAM read datapath is combinational (`assign data_out = ram[addr]`). This ensures operands are immediately available to the ALU within the same cycle the instruction is fetched, eliminating stale-data hazards without requiring multi-cycle stalls or forwarding networks.
* **Synchronous Updates:** All state elements (Program Counter, Accumulator, and RAM write buffers) update synchronously on the positive clock edge (`posedge clk`), maintaining clear timing boundaries.

---

## Verification & Execution Flow

The testbench validates the full instruction set through an embedded diagnostic program:

1. `LOAD 0` $\rightarrow$ Loads `RAM[0]` (value `2`) into Accumulator (`ACC = 2`)
2. `ADD 1`  $\rightarrow$ Adds `RAM[1]` (value `3`) to Accumulator (`ACC = 2 + 3 = 5`)
3. `SUB 2`  $\rightarrow$ Subtracts `RAM[2]` (value `4`) from Accumulator (`ACC = 5 - 4 = 1`)
4. `AND 0`  $\rightarrow$ Bitwise AND with `RAM[0]` (`ACC = 1 & 2 = 0`)
5. `XOR 1`  $\rightarrow$ Bitwise XOR with `RAM[1]` (`ACC = 0 ^ 3 = 3`)
6. `STORE 3` $\rightarrow$ Asserts `Mem_Write` and commits `ACC` (`3`) to `RAM[3]`

---

## Simulation & Build Instructions

### Prerequisites
* [Icarus Verilog (`iverilog`)](http://iverilog.icarus.com/)
* [GTKWave](http://gtkwave.sourceforge.net/)

### Running Simulation

1. **Compile the design and testbench:**
   ```bash
   iverilog -o cpu_sim *.v