# 16-QAM Communication System Simulation

A MATLAB simulation of a complete 16-QAM digital communication system using two independent 4-PAM branches. The project includes Gray-coded symbol mapping, SRRC pulse shaping, carrier modulation, AWGN channel modeling, coherent demodulation, matched filtering, symbol detection, and Monte Carlo evaluation of SER and BER performance.

## Description

This exercise simulates the transmission and reception of a 16-QAM signal. The input bitstream is split into in-phase and quadrature branches, mapped to 4-PAM symbols, shaped using an SRRC pulse, modulated with orthogonal carriers, and transmitted through an AWGN channel. At the receiver, the signal is demodulated, filtered, sampled, and detected. The project also compares experimental SER and BER results with theoretical curves using Monte Carlo simulations.

## Notes

The simulation uses:
- 16-QAM as two independent 4-PAM systems
- Gray coding
- SRRC pulse shaping
- AWGN noise
- Mean error estimation over multiple Monte Carlo repetitions
