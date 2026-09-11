# Mano Basic Computer Architecture in VHDL

## Overview

This project implements a Mano Basic Computer architecture using VHDL.

The design is composed of several hardware modules that work together to implement the main components of a basic computer system, including the arithmetic logic unit, registers, memory, bus structure, multiplexer, and control unit.

The project was developed as a digital design and computer architecture study using VHDL and was tested in a virtualized development environment.

## Architecture

The system is organized around a common bus structure that connects the main registers and functional units.

The major components include:

- Arithmetic Logic Unit (ALU)
- Accumulator (AC)
- Address Register (AR)
- Program Counter (PC)
- Instruction Register (IR)
- Temporary Register (TR)
- Input Register (INPR)
- Output Register (OUTR)
- Memory
- Multiplexer (MUX)
- Common Bus
- Control Unit

## Main Components

### Arithmetic Logic Unit

The ALU performs arithmetic and logical operations required by the computer architecture.

The implementation includes logical operations such as:

- AND
- OR
- XOR

The ALU also includes multiplication functionality based on the Booth multiplication algorithm.

### Registers

The project contains individual VHDL modules for the main registers used by the Mano Basic Computer architecture.

These include:

- AC
- AR
- PC
- IR
- TR
- INPR
- OUTR

Each register is implemented as a separate VHDL module.

### Memory

The `Memory.vhd` module implements the memory component of the system.

The project also includes `MEMORY.mem`, which contains memory initialization data used by the design.

### Common Bus

The `BUS.vhd` module provides the common bus structure used to transfer data between the different components of the computer.

The `MUX.vhd` module is used as part of the data routing structure.

### Control Unit

The `kontrolUnitesi.vhd` module implements the control logic of the computer.

It coordinates the operations of the processor components and controls the data transfers and instruction execution process.

### Main Module

`Main.vhd` acts as the main integration module of the design.

It connects the major components of the computer architecture and provides the top-level structure of the system.

## Project Structure

    mano-basic-computer-vhdl/
    ├── AC.vhd
    ├── ALU.vhd
    ├── AR.vhd
    ├── BUS.vhd
    ├── INPR.vhd
    ├── IR.vhd
    ├── IR-Prosedur.vhd
    ├── kontrolUnitesi.vhd
    ├── LED_switch.vhd
    ├── Main.vhd
    ├── Memory.vhd
    ├── MUX.vhd
    ├── OUTR.vhd
    ├── PC.vhd
    ├── TR.vhd
    ├── veriyollu.vhd
    ├── MEMORY.mem
    ├── led.ucf
    ├── README.md
    └── .gitignore

## Development Environment

The project was developed using VHDL in a virtualized development environment with VirtualBox.

Xilinx ISE was used for FPGA design and simulation.

## FPGA Implementation

The project includes a UCF constraint file for FPGA pin assignments.

The `led.ucf` file contains the hardware constraint definitions used for the LED-related FPGA connections.

## Simulation and Testing

The individual VHDL modules were designed to work together as a complete basic computer architecture.

The project includes simulation-related files in the original development environment; generated simulation and build files are intentionally excluded from this repository to keep the source repository clean.

## Technologies

- VHDL
- Computer Architecture
- Digital Logic Design
- FPGA
- Xilinx ISE
- VirtualBox
- Hardware Description Languages

## Learning Outcomes

This project provided practical experience with:

- Computer architecture
- Digital logic design
- VHDL programming
- Hardware module design
- Register and memory organization
- ALU design
- Bus-based data transfer
- Control unit design
- FPGA-oriented development
- Hardware simulation

## Author

**Ebrar Özdemir**

Computer Engineering Student

Sakarya University of Applied Sciences

GitHub: [github.com/ebrarozdemir1](https://github.com/ebrarozdemir1)
