SPI Master & Slave Verification Pair (Verilog)
---------------------------------------------
A fully synthesizable Verilog implementation of an SPI (Serial Peripheral Interface) Master and Dummy Slave operating in SPI Mode 0. This project demonstrates full-duplex serial byte transmission and bi-directional verification using behavioral simulation.

📌 Project Overview
-------------------
The Serial Peripheral Interface (SPI) is a synchronous, four-wire serial communication protocol widely used to interface microcontrollers with memory, sensors, and displays.
This project implements a hardware SPI Master and an SPI Slave module operating in Mode 0 (CPOL = 0, CPHA = 0). 
The system enables simultaneous transmission and reception of an 8-bit data payload between both modules over a 4-wire serial bus.

🔑 Key Features
----------------
Full-Duplex Communication: Simultaneous sending and receiving of 8-bit data bytes.
SPI Mode 0 Operation:
  Clock Polarity (CPOL = 0): SCLK idles LOW.
  Clock Phase (CPHA = 0): Data sampled on the Rising Edge and shifted on the Falling Edge.
Parametric/Clean Module Separation: Separate Master and Slave modules communicating over hardware ports.
Integrated Testbench: Includes $dumpfile / $dumpvars execution for waveform output (.vcd format) and self-checking pass/fail reporting.

🛠️ System Architecture & Signals
---------------------------------
               +-------------------+                     +------------------+
               |                   |-------- CS -------->|                  |
               |                   |------- SCLK ------->|                  |
               |    SPI Master     |-------- MOSI ------->|    SPI Slave    |
               |                   |<------- MISO -------|                  |
               +-------------------+                     +------------------+

               
