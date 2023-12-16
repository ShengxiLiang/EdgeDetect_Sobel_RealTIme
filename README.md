# FPGA-based Real-time Edge Detection

## Project Overview

**Duration**: March 2023 - May 2023  
**Institution**: University of Electronic Science and Technology of China  
**Course**: High-Performance Computing Unit

This repository contains the work done for the FPGA-based Real-time Edge Detection project, which was part of the High-Performance Computing Unit course at UESTC. The project focused on optimizing the Sobel Filter's computing unit and evaluating FPGA logic resources with equivalent ASIC gates.


## Directory Structure

├── ip_repo
│   ├── vivado files and scripts
│   └── ...
├── report.docx
├── presentation.pdf
└── README.md


## Design Analysis

### Filter Module Area Analysis

At a working frequency of 25MHz, we successfully obtained the circuit layout of the convolution filter module based on the Sobel operator. The optimized total design area is 212265 µm² with a utilization rate of 47%, indicating a reasonable design size.

### Filter Module Power Analysis

The optimized filter module's total power consumption at a 25MHz working frequency is 8.16mW. The power distribution is well-balanced, indicating efficient power management in the design.

### Filter Module Delay Analysis

The maximum delay for the optimized filter module is 19.27ns at a 25MHz working frequency, which meets the operational requirements.

## Real-time Filtering Design with OV5640

In the camera real-time image filtering experiment, we used the Zynq PL and PS for data interaction. The camera model used was OV5640. The data flow is detailed in Section 4.1 of the project report.

## Challenges Encountered

The main issues encountered during the experiment, detailed in Section 4.2, included interfacing problems between the VIDEO INTO AXI-Stream IP and the Sobel processing data IP, and image overlap issues on the display screen.


Usage
Please refer to the scripts and documentation provided in the ip_repo directory to replicate the setup and use the FPGA-based system for edge detection.
