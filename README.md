# Inverted Pendulum Control System

This repository contains the modeling, analysis, controller design and simulation of an inverted pendulum system developed for the Control Systems course.

## Project Overview

The inverted pendulum is a naturally unstable mechanical system widely used as a benchmark problem in control engineering.

The objective of this project is to obtain a mathematical model of the system, analyze its uncompensated behavior and design a control strategy capable of improving its dynamic response.

The project is divided into two main stages:

1. Open-loop analysis of the uncompensated inverted pendulum system.
2. Controller design, closed-loop analysis and simulation of the compensated control system.

## Project Stages

### Part 1 - Open-Loop Analysis

The first stage focuses on the mathematical modeling and analysis of the uncompensated system.

This stage includes:

* Mathematical modeling of the inverted pendulum.
* Transfer function representation.
* State-space representation.
* Time-domain response analysis.
* Impulse response.
* Step response.
* Root locus analysis.
* Frequency-domain analysis using Bode diagrams.
* Stability analysis of the open-loop system.

### Part 2 - Control System Design

The second stage focuses on the design and simulation of the control system.

This stage includes:

* Controller design.
* Closed-loop system analysis.
* Compensated root locus.
* Compensated Bode response.
* Time-domain response of the controlled system.
* Comparison between uncompensated and compensated responses.
* MATLAB simulations.
* Dynamic visualization of the inverted pendulum behavior.

## System Parameters

| Parameter | Description                   | Value     |
| --------- | ----------------------------- | --------- |
| M         | Cart mass                     | 0.75 kg   |
| m         | Pendulum mass                 | 0.33 kg   |
| L         | Pendulum length               | 0.30 m    |
| g         | Gravity acceleration          | 9.81 m/s² |
| bc        | Cart friction coefficient     | 0.01      |
| bp        | Pendulum friction coefficient | 0.01      |

## Repository Structure

```text
inverted-pendulum-control-system/
│
├── README.md
├── .gitignore
│
├── docs/
│   ├── report/
│   └── presentation/
│
├── Firmware/
│
├── images/
│   └── 3D_model/
│   └── Open loop/
│   └── Close loop/
│   └── state variables diagram/
│
├── part_1_open_loop_analysis/
│   ├── modeling/
│   ├── time_response/
│   ├── root_locus/
│   └── bode/
│
├── part_2_control_system_design/
│   ├── controller_design/
│   ├── compensated_system/
│   └── comparisons/
│
├── references/
│   └── bibliography.md
│
└── simulations/
    └── gifs/
```

## Main Analyses

The project includes the following control system analyses:

* Mathematical model derivation.
* Transfer function analysis.
* State-space model formulation.
* Controllability and observability verification.
* Time-domain response analysis.
* Root locus analysis.
* Bode diagram analysis.
* Open-loop and closed-loop comparison.
* Controller design and system compensation.
* MATLAB-based simulation and visualization.

## Tools Used

* MATLAB
* Simulink
* Control System Toolbox
* Visual Studio Code
* Git
* GitHub

## Authors

This project was developed by:

* Coña, Ezequiel - [@00glitched](https://github.com/00glitched)
* López, Emanuel - [@Emajack512](https://github.com/Emajack512)
* Macias, Alan - [@Macias225](https://github.com/Macias225)
* Michaut, Santiago

## Academic Context

Final integrative project for the Control Systems course.

Facultad de Ingeniería y Ciencias Agropecuarias
Universidad Nacional de San Luis

## References

* Ogata, K. *Modern Control Engineering*.
* Kuo, B. *Automatic Control Systems*.
* Course notes from Sistemas de Control UNSL FICA.
* MATLAB documentation for Control System Toolbox.

## License

This project is licensed under the MIT License.
# inverted-pendulum-control-system
Modeling, open-loop analysis, controller design and simulation of an inverted pendulum system.
