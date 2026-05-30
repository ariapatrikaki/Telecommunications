# SRRC Pulse and 2-PAM Baseband Transmission Simulation

A MATLAB project for Telecommunication Systems I that studies Square-Root Raised Cosine (SRRC) pulses, their spectral properties, orthogonality, and their use in a simple 2-PAM baseband transmission system.

## Project Description

This exercise is divided into three main parts:

- **Part A:** SRRC pulse analysis
  - Generates SRRC pulses for different roll-off factors.
  - Plots the pulses in the time domain.
  - Computes and plots the energy spectral density using FFT.
  - Compares theoretical and practical bandwidth.

- **Part B:** Pulse orthogonality
  - Plots shifted SRRC pulses.
  - Computes products between pulses and shifted versions.
  - Numerically estimates the orthogonality integrals for different roll-off factors.

- **Part C:** 2-PAM baseband transmission
  - Generates random bits.
  - Maps bits to 2-PAM symbols.
  - Creates an impulse train.
  - Applies SRRC pulse shaping.
  - Simulates matched filtering at the receiver.
  - Compares sampled receiver output with the original transmitted symbols.