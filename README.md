# Traffic Light Control System with Controlled Right-Turn Logic

This repository contains a digital design and implementation of a four-way intersection traffic management system. The project follows a professional design workflow, transitioning from Hardware Description Language (HDL) modeling in **Xilinx Vivado** to gate-level schematic verification in **Logisim-evolution**.

## 1. Introduction
The objective of this project is to digitally model a real-life four-way intersection. The design ensures synchronized signal transitions (Green, Yellow, Red) while maintaining safety protocols where only one direction is granted a green signal at any time. A key feature is the implementation of independent, continuously blinking yellow lights for controlled right-turn movements. This project reinforces concepts of sequential circuit design, timing control, and Finite State Machine (FSM) logic.

## 2. System Description & Operating Logic
The system represents a four-way intersection operating under strict FSM-based rules:

* **Sequential Flow:** At any given time, only one direction is active.
* **Timing Intervals:** Due to real-time clock scaling and propagation delays, the intervals are optimized as follows:
    * **Green Phase:** 30 Seconds.
    * **Yellow Phase:** 3 Seconds.
    * **Red Phase:** Active for all other directions.
* **Controlled Right Turns:** Implemented as continuously blinking yellow signals that function independently from the main traffic cycle.



### FSM State Sequence:
- **State 0:** Direction 1 Green (30s) / Others Red
- **State 1:** Direction 1 Yellow (3s) / Others Red
- **State 2:** Direction 2 Green (30s) / Others Red
- **State 3:** Direction 2 Yellow (3s) / Others Red
- *... (Cycle continues for all 4 directions)*

## 3. Verilog Design & Implementation (Vivado)
The hardware description was implemented using **Xilinx Vivado**. The design focuses on modularity:

* **Clock & Reset Structure:** A global clock drives the system, while a synchronous reset initializes the FSM to the first direction's green phase.
* **Timing Counters:** Dedicated counter modules track the 30-second and 3-second intervals.
* **Blink Logic:** A periodic toggle (ON/OFF) logic is used for right-turn signals, achieved through clock division methods.
* **Output Control:** LED outputs are mapped to FSM states, ensuring the correct color is displayed for each direction.

## 4. Logisim Circuit Design
The logical equivalent of the Verilog design was verified in **Logisim**. This gate-level implementation illustrates the physical hardware construction:

* **Memory Unit:** 6 D-type Flip-Flops are utilized for state storage and timing.
* **Decoding:** Combinational logic gates and decoders process state signals to drive the LED outputs.
* **Validation:** The Logisim circuit visually demonstrates the hardware-level operation of the FSM and validates the correctness of the transition logic.



## 🛠️ Toolchain & Environment
- **Xilinx Vivado:** Primary HDL synthesis and design environment.
- **Logisim-evolution:** Gate-level schematic design and simulation.
- **VS Code:** Source code editing and linting.
- **Icarus Verilog & GTKWave:** Behavioral simulation and waveform analysis (.vcd files).

## 📂 Repository Content
* **`src/`**: Verilog source files (FSM, Counters, Top Module).
* **`sim/`**: `Traffic_Controller.circ` (The primary Logisim schematic file).
* **`docs/`**: Project report, state diagrams, and truth tables.

---
*This project was developed as part of a Digital Design & Computer Architecture curriculum.*
