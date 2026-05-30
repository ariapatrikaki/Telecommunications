# PAM Signal PSD Analysis and Stochastic Process Simulation

A MATLAB project for Telecommunication Systems I that studies the spectral behavior of baseband PAM waveforms and simple stochastic processes. The exercise includes SRRC pulse generation, 2-PAM and 4-PAM waveform construction, periodogram-based PSD estimation, comparison with theoretical PSD curves, and analysis of a random-phase sinusoidal process.

## Project Description

This project is divided into two main parts:

- **Part A:** Simulation and spectral analysis of baseband PAM signals.
  - Generates an SRRC pulse.
  - Constructs 2-PAM and 4-PAM waveforms.
  - Computes periodograms using FFT and `fftshift`.
  - Estimates PSD by averaging many independent realizations.
  - Compares experimental PSD estimates with theoretical PSD formulas.
  - Studies the effect of doubling the symbol period on signal bandwidth.

- **Part B:** Simulation and theoretical analysis of a stochastic process.
  - Generates multiple realizations of a random-phase sinusoidal process.
  - Studies its mean, autocorrelation, stationarity, and power spectral density.