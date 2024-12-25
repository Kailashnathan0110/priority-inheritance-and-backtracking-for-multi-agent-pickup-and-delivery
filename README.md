# Multi-Robot Warehouse Delivery without Collision using Priority Inheritance and Backtracking

## Overview

This project explores a decentralized approach to Multi-Agent Pickup and Delivery (MAPD) problems in automated warehouse environments. The solution leverages the **Priority Inheritance with Backtracking (PIBT)** algorithm to ensure collision-free navigation and efficient task completion for multiple robots in dynamic and congested environments.

Key features include:
- **Dynamic Task Allocation**: Robots are assigned tasks based on availability.
- **Priority Inheritance**: High-priority tasks take precedence to ensure smooth navigation.
- **Backtracking Mechanism**: Resolves deadlocks and complex collision scenarios.
- **Scalability**: Handles increasing agent density while maintaining performance.
- **MATLAB Simulations**: Validates algorithm effectiveness under different agent configurations and environments.

---

## Features

- **Division of Labor**: Inspired by natural systems, tasks are divided among robots to optimize efficiency.
- **Collision Avoidance**: Ensures robots do not occupy or swap positions simultaneously.
- **Dynamic Graph Representation**: Robots navigate a bi-connected graph representing the warehouse layout.
- **Performance Evaluation**: Metrics such as runtime and success rate demonstrate scalability and robustness.

---

## Key Algorithms

1. **Priority Inheritance**:
   - Temporarily elevates the priority of blocked robots to resolve deadlocks.
   - Ensures smooth navigation for high-priority tasks.

2. **Backtracking**:
   - Validates priority inheritance outcomes.
   - Guides robots to alternative routes if necessary.

3. **PIBT Framework**:
   - Combines localized prioritization with iterative decision-making.

---

## Simulation Setup

Simulations were conducted using MATLAB to evaluate the PIBT algorithm:
- **Environment**: A 10x10 or 50x50 grid representing the warehouse.
- **Agents**: Scenarios with 5 to 50 agents.
- **Tasks**: Randomly generated pickup and delivery assignments.
- **Metrics**:
  - **Runtime**: Measures algorithm efficiency.
  - **Success Rate**: Tracks completion rates across varying densities.

---

## Results

- **Scalability**: Linear runtime growth with agent count.
- **Collision-Free Navigation**: Successfully avoids collisions and deadlocks.
- **Dynamic Adaptation**: Efficient task reallocation and pathfinding in real-time.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/Multi-Robot-Delivery.git
