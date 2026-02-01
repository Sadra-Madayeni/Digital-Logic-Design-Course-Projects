# 7-Segment Decoder Design (SystemVerilog)

This repository contains the design and implementation of a **Seven Segment Decoder** using SystemVerilog. The project was developed as part of the **Digital Logic Circuits** course at the **University of Tehran**.

The decoder converts a 4-bit Binary Coded Decimal (BCD) input (0-9) into a 7-bit output to drive a standard 7-segment display.

## 📌 Project Overview

* **Input:** 4-bit binary number (`w`, `x`, `y`, `z`) representing decimals 0 to 9.
* **Output:** 7-bit signal (`a` through `g`) corresponding to the segments.
* **Handling Don't Cares:** Input values from 10 to 15 (1010 to 1111) are treated as "Don't Care" conditions to optimize the logic.
* **Modeling Styles:** * **Structural:** Gate-level modeling with specific propagation delays.
    * **Behavioral:** High-level abstraction using `assign` statements.

## ⚙️ Design Methodology

### 1. Karnaugh Maps & Logic Simplification
For each of the 7 segments (a-g), a Karnaugh Map (K-Map) was generated to derive the minimal Sum-of-Products (SOP) boolean expression. 
* **Example Logic:**
    * Segment `a`: $w + y + \overline{x}\overline{z} + xz$
    * Segment `b`: $\overline{x} + yz + \overline{y}\overline{z}$
    * *(Full equations and K-Maps are available in the project report)*

### 2. Implementation Details
The project involves two types of Verilog implementations:

#### A. Structural Model (Gate Level)
This module uses basic logic gates (AND, OR, NOT) with specific delays assigned to simulate real-world propagation characteristics:
* **NOT Gate:** 1ns delay
* **AND Gate:** 2ns delay
* **OR Gate:** 3ns delay

#### B. Behavioral Model
A concise implementation using dataflow modeling to describe the circuit behavior without explicitly defining the gate structure.

## 🧪 Simulation & Verification
The design was verified using **ModelSim**. A testbench (`StructuralTestBench`) was created to:
1.  Iterate through all possible input combinations (0 to 15).
2.  Visualize the output waveforms.
3.  Analyze propagation delays (e.g., calculating the critical path delay when inputs change).

# Arithmetic Logic Unit (ALU) Design (CA2)

This project is the second Computer Assignment (CA2) for the **Digital Logic Circuits** course at the **University of Tehran**. It focuses on designing a modular **Arithmetic Logic Unit (ALU)** capable of performing arithmetic and logical operations on 4-bit signed numbers (2's complement).

## 📌 Project Overview

The system processes 16-bit **One-Hot encoded** inputs, converts them to binary for processing, and converts the result back to One-Hot format.

* **Input:** Two 16-bit One-Hot vectors (`Inp1`, `Inp2`) and a 3-bit Opcode.
* **Internal Processing:** 4-bit Binary (2's Complement).
* **Output:** 16-bit One-Hot vector and a **7-Segment Display** output (Bonus feature).

## ⚙️ Supported Operations

The ALU behavior is controlled by a 3-bit `Opcode` selector:

| Opcode | Instruction | Description |
| :---: | :--- | :--- |
| `001` | **ADD** | Result = Inp1 + Inp2 |
| `010` | **SUB** | Result = Inp1 - Inp2 |
| `011` | **Min (Adder)** | Minimum value using Adder logic |
| `100` | **Max (Adder)** | Maximum value using Adder logic |
| `101` | **Min (Comp)** | Minimum value using Comparator logic |
| `110` | **Max (Comp)** | Maximum value using Comparator logic |
| `111` | **Move** | Pass `Inp2` directly to output |

## 🛠 Module Architecture

The project follows a hierarchical design strategy using **SystemVerilog**:

### 1. Data Conversion (Encoders & Decoders)
* **16-to-4 Encoder:** Converts the One-Hot input to a 4-bit binary number.
* **4-to-16 Decoder:** Converts the calculated binary result back to One-Hot format.

### 2. Computational Modules (Gate-Level)
To demonstrate understanding of digital logic structure, the core calculation units were implemented at the **Gate Level**:
* **Carry Look-Ahead Adder (CLA):** A 4-bit adder designed using logic gates (AND, OR, XOR) to minimize propagation delay compared to Ripple Carry Adders.
* **4-Bit Comparator:** A gate-level circuit designed to compare two numbers (Greater than, Less than, Equal).

### 3. Top Module & Bonus
* **ALU Core:** Integrates the CLA and Comparator to execute the requested Opcode.
* **7-Segment Display:** A dedicated module (reused and adapted from CA1) visualizes the final result on a 7-segment display.

## 🧪 Simulation & Verification

The design was verified using **ModelSim**. The testbench (`Top_Module_tb`) validates all 7 operations.
* **Waveform Analysis:** Confirms correct state transitions and timing.
* **Corner Cases:** Tested with negative results (2's complement handling) and overflow conditions.

# Grain Stream Cipher Implementation (CA3)

This repository contains the design and implementation of the **Grain Pseudo-Random Number Generator (PRNG)** using **SystemVerilog**. This project was developed as Computer Assignment 3 (CA3) for the **Digital Logic Circuits** course at the **University of Tehran**.

The project follows a bottom-up design approach, starting from basic memory elements (Latches) and building up to a complex Stream Cipher architecture used in cryptography.

## 📌 Project Architecture

The system is built hierarchically using the following modules:

1.  **Async D-Latch:** Designed at the **Gate-Level** using NAND/NOT gates.
2.  **Master-Slave D-Flip-Flop:** Constructed by cascading two D-Latches.
3.  **Parametric Shift Register:** A generic shift register built using the D-Flip-Flops.
4.  **LFSR (Linear Feedback Shift Register):** 80-bit shift register with specific linear feedback.
5.  **NFSR (Non-Linear Feedback Shift Register):** 80-bit shift register with complex non-linear feedback.
6.  **Grain Top Module:** Combines LFSR and NFSR to generate the final random bitstream.

## 🧮 Logic & Equations

The Grain logic is defined by three main functions implemented in Verilog:

### 1. LFSR Feedback Polynomial $f(x)$
The 80-bit LFSR updates its input using the following linear function:
$$f(x) = x_{62} \oplus x_{51} \oplus x_{38} \oplus x_{23} \oplus x_{13} \oplus x_{0}$$

### 2. NFSR Feedback Function $g(x)$
The NFSR input is determined by a non-linear function involving XOR and AND operations:
$$g(x) = x_{0} \oplus x_{9} \oplus x_{17} \oplus x_{22} \oplus (x_{4} \cdot x_{13}) \oplus (x_{8} \cdot x_{16}) \oplus (x_{5} \cdot x_{11} \cdot x_{14}) \dots$$

### 3. Output Function $h(x)$
The final pseudo-random bit is generated by combining bits from both registers using function $h(x)$ masked with the NFSR output:
$$h(x) = x_{L0} \oplus x_{L3} \oplus (x_{L1} \cdot x_{L2}) \oplus x_{N0} \oplus (x_{N1} \cdot x_{L5}) \oplus (x_{N3} \cdot x_{L7}) \dots$$
$$Output = h(x) \oplus x_{N\_output}$$

## 🧪 Simulation & Verification

The design was verified using **ModelSim**.
* **Component Testing:** Each sub-module (Latch, DFF, Shift Register) was tested individually with waveforms confirming correct timing and state transitions.
* **System Verification:** The final Grain output was compared against a **C-code reference model** (`Grain.log`).
    * **Result:** The Verilog simulation output matched the reference pattern exactly for multiple 80-bit seeds (e.g., Seed `123456...`).



# Matrix Determinant Calculator (CA4)

This repository contains the final Computer Assignment (CA4) for the **Digital Logic Circuits** course at the **University of Tehran**. The project focuses on **Sequential Circuit Design**, separating the system into a **Datapath** and a **Control Unit (FSM)** to calculate matrix determinants.

## 📌 Project Overview

The goal is to design a hardware accelerator that reads matrix elements from a memory unit and calculates the determinant. The project is divided into two phases:

1.  **2x2 Determinant Calculator:** The core module.
2.  **3x3 Determinant Calculator:** A wrapper module that reuses the 2x2 core using cofactor expansion.

## 🧮 Theoretical Background

### 2x2 Matrix
For a matrix $A = \begin{pmatrix} a & b \\ c & d \end{pmatrix}$, the determinant is calculated as:
$$|A| = (a \times d) - (b \times c)$$

### 3x3 Matrix
For a 3x3 matrix, the system uses **Cofactor Expansion**:
$$|A| = a(ei - fh) - b(di - fg) + c(dh - eg)$$
The design efficiently reuses the 2x2 calculator hardware to compute the minor determinants.

## 🏗 System Architecture

### 1. The 2x2 Core (Basic Module)
This module implements a standard **Register-Transfer Level (RTL)** design:
* **Datapath:** Contains 8-bit registers for storing matrix elements, a signed Multiplier, a Subtractor, and Multiplexers to route data.
* **Controller (FSM):** A Finite State Machine that orchestrates the sequence:
    1.  **Fetch:** Reads data from memory (4 cycles).
    2.  **Multiply:** Calculates $a \times d$ and $b \times c$.
    3.  **Subtract:** Computes the difference.
    4.  **Done:** Asserts the finish signal.

### 2. The 3x3 Extension (Top Module)
This module acts as a higher-level controller. It does not perform calculations directly but instead:
* **Address Translation:** Maps the 3x3 indices to the required 2x2 sub-matrices using an `Address_to_Memory` module.
* **Accumulation:** Uses the 2x2 core iteratively and accumulates the results according to the expansion formula.

## 🧪 Simulation & Verification

The design was verified using **ModelSim**.
* **Test Case:** A specific matrix input yielding a determinant of `2007`.
* **Waveforms:** The simulation confirms the correct state transitions (Init → Read → Calc → Done) and accurate signed arithmetic operations.

 