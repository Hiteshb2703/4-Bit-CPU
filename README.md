# Custom 4-Bit Single-Cycle Processor (Verilog RTL)

A minimal single-cycle 4-bit accumulator CPU in Verilog. This processor features a 8-bit instruction word, dedicated Data RAM and Instruction ROM domains, a centralized Control Unit, and a custom 6-instruction ISA.

---

## Architecture Overview

The CPU is structured around a streamlined, non-pipelined single-cycle datapath designed for predictable instruction execution without complex hazards.

Microarchitecture: Harvard (separate instruction ROM and data RAM), single-cycle, accumulator-based, with one memory operand per instruction (not load-store).

### Module Breakdown

* **`pc.v` (Program Counter):** 4-bit counter with asynchronous active-high reset. Automatically increments address execution sequentially on each rising clock edge.
* **`rom.v` (Instruction Memory):** 16-word $\times$ 8-bit asynchronous ROM containing pre-loaded program instructions.
* **`ram.v` (Data Memory):** 16-word $\times$ 4-bit RAM featuring asynchronous (combinational) reads and synchronous writes.
* **`alu.v` (Arithmetic Logic Unit):** 4-bit execution core performing basic arithmetic and bitwise logic operations.
* **`control_unit.v`:** Combinational opcode decoder generating routing signals (`Mem_Write` and `ACC_Write`).
* **`cpu_top.v`:** Top-level structural module integrating datapath, control, and accumulator storage.
* **`tb_cpu.v`:** Testbench with a 10 ns simulation clock, reset sequencing, `$monitor` logging, a PASS/FAIL self-check that STORE/LOAD round-trips through RAM[3], and VCD generation.

---

## Instruction Set Architecture (ISA)

The architecture uses an **8-bit fixed instruction format**:
* **Bits [7:4]:** 4-bit Opcode
* **Bits [3:0]:** 4-bit Memory Address Operand

| Opcode | Binary | Mnemonic | Format | Operation Description |
| :--- | :--- | :--- | :--- | :--- |
| `0x0` | `0000` | **LOAD** | `LOAD [addr]` | `ACC <= RAM[addr]` |
| `0x1` | `0001` | **STORE** | `STORE [addr]` | `RAM[addr] <= ACC` |
| `0x2` | `0010` | **ADD** | `ADD [addr]` | `ACC <= ACC + RAM[addr]` |
| `0x3` | `0011` | **SUB** | `SUB [addr]` | `ACC <= ACC - RAM[addr]` |
| `0x4` | `0100` | **AND** | `AND [addr]` | `ACC <= ACC & RAM[addr]` |
| `0x5` | `0101` | **XOR** | `XOR [addr]` | `ACC <= ACC ^ RAM[addr]` |

---

## Key Timing & Architectural Design Choices

* **Hazards:** Single-cycle, so no pipeline hazards by construction. RAM reads are combinational, so the operand reaches the ALU in the same cycle.
* **Clocking:** PC, ACC and RAM writes update on `posedge clk`. PC and ACC also have an asynchronous active-high reset. RAM has no reset and is initialized by an `initial` block (simulation only).

---

## Verification & Execution Flow

The ROM holds a directed diagnostic program (one test vector per instruction, not exhaustive). The testbench runs it and self-checks the result:

1. `LOAD 0` $\rightarrow$ Loads `RAM[0]` (value `2`) into Accumulator (`ACC = 2`)
2. `ADD 1`  $\rightarrow$ Adds `RAM[1]` (value `3`) to Accumulator (`ACC = 2 + 3 = 5`)
3. `SUB 2`  $\rightarrow$ Subtracts `RAM[2]` (value `4`) from Accumulator (`ACC = 5 - 4 = 1`)
4. `AND 0`  $\rightarrow$ Bitwise AND with `RAM[0]` (`ACC = 1 & 2 = 0`)
5. `XOR 1`  $\rightarrow$ Bitwise XOR with `RAM[1]` (`ACC = 0 ^ 3 = 3`)
6. `STORE 3` $\rightarrow$ Asserts `Mem_Write` and commits `ACC` (`3`) to `RAM[3]`
7. `LOAD 0`  $\rightarrow$ ACC = 2 (overwrites ACC so the next step proves something)
8. `LOAD 3`  $\rightarrow$ ACC = 3, read back from `RAM[3]`, which verifies STORE

---

## Limitations

* No branch/jump or flags; no HALT (unused ROM is LOAD 0, PC wraps at 16)
* 4-bit arithmetic wraps silently (no carry or overflow flag)
* Opcodes 0x6 to 0xF are undefined and behave as NOP
* Simulation only: not synthesized, no timing analysis. The 10 ns clock is a sim parameter, not a claimed Fmax
* `initial`-block memory init is not ASIC-ready (would need a case-based ROM and a RAM macro or flops)

## Prerequisites

* [Icarus Verilog (`iverilog`)](http://iverilog.icarus.com/)
* [GTKWave](http://gtkwave.sourceforge.net/)

## Run

```bash
iverilog -o cpu_sim tb_cpu.v cpu_top.v pc.v rom.v ram.v alu.v control_unit.v
vvp cpu_sim
gtkwave waveform.vcd
```
