clear; close all; clc;

%% Parameters
N = 200;
Aamp = 1;              % PAM amplitude A
T = 1e-3;
over = 10;
Ts = T/over;
Fs = 1/Ts;
A = 4;              
a = 0.5;

Nf = 4096;
F = (-Nf/2:Nf/2-1) * Fs/Nf;

%% SRRC pulse
[phi, t_phi] = srrc_pulse(T, over, A, a);

%% 1. Generate 4N random bits
bits = randi([0 1], 1, 4*N);

%% 3. Split bits and map to 4-PAM
bitsI = bits(1:2*N);
bitsQ = bits(2*N+1:end);

XI_sym = bits_to_4PAM(bitsI, Aamp);
XQ_sym = bits_to_4PAM(bitsQ, Aamp);

%% 4. Pulse shaping

XI_delta = zeros(1, over*length(XI_sym));
XQ_delta = zeros(1, over*length(XQ_sym));

XI_delta(1:over:end) = XI_sym;
XQ_delta(1:over:end) = XQ_sym;

XI_delta = XI_delta / Ts;
XQ_delta = XQ_delta / Ts;

XI_t = conv(XI_delta, phi) * Ts;
XQ_t = conv(XQ_delta, phi) * Ts;

t = t_phi(1) + (0:length(XI_t)-1)*Ts;

figure;
plot(t, XI_t); grid on;
xlabel('t (s)'); ylabel('X_I(t)');
title('In-phase pulse-shaped waveform');

figure;
plot(t, XQ_t); grid on;
xlabel('t (s)'); ylabel('X_Q(t)');
title('Quadrature pulse-shaped waveform');

%% Periodogram of X_I(t)

XI_f = Ts * fftshift(fft(XI_t, Nf));
Ttotal = length(XI_t) * Ts;
PXI = abs(XI_f).^2 / Ttotal;

figure;
semilogy(F, PXI);
grid on;
xlabel('f (Hz)');
ylabel('Periodogram');
title('Periodogram of X_I(t)');

%% Periodogram of X_Q(t)

XQ_f = Ts * fftshift(fft(XQ_t, Nf));
Ttotal = length(XQ_t) * Ts;
PXQ = abs(XQ_f).^2 / Ttotal;

figure;
semilogy(F, PXQ);
grid on;
xlabel('f (Hz)');
ylabel('Periodogram');
title('Periodogram of X_Q(t)');



%% 5. Modulation

F0 = 2000;             % 2 kHz

XI_mod = 2 * XI_t .* cos(2*pi*F0*t);
XQ_mod = -2 * XQ_t .* sin(2*pi*F0*t);

%% Plot X_I^mod(t)

figure;
plot(t, XI_mod);
grid on;
xlabel('t (sec)');
ylabel('X_I^{mod}(t)');
title('Modulated in-phase signal');

%% Plot X_Q^mod(t)

figure;
plot(t, XQ_mod);
grid on;
xlabel('t (sec)');
ylabel('X_Q^{mod}(t)');
title('Modulated quadrature signal');

%% Periodogram of X_I^mod(t)

XI_mod_f = Ts * fftshift(fft(XI_mod, Nf));
Ttotal = length(XI_mod) * Ts;
PXI_mod = abs(XI_mod_f).^2 / Ttotal;

figure;
semilogy(F, PXI_mod);
grid on;
xlabel('f (Hz)');
ylabel('Periodogram');
title('Periodogram of X_I^{mod}(t)');

%% Periodogram of X_Q^mod(t)

XQ_mod_f = Ts * fftshift(fft(XQ_mod, Nf));
Ttotal = length(XQ_mod) * Ts;
PXQ_mod = abs(XQ_mod_f).^2 / Ttotal;

figure;
semilogy(F, PXQ_mod);
grid on;
xlabel('f (Hz)');
ylabel('Periodogram');
title('Periodogram of X_Q^{mod}(t)');

%% 6. Channel input signal

Xmod = XI_mod + XQ_mod;

%% Plot X^mod(t)

figure;
plot(t, Xmod);
grid on;
xlabel('t (sec)');
ylabel('X^{mod}(t)');
title('Channel input signal X^{mod}(t)');

%% Periodogram of X^mod(t)

Xmod_f = Ts * fftshift(fft(Xmod, Nf));
Ttotal = length(Xmod) * Ts;
PXmod = abs(Xmod_f).^2 / Ttotal;

figure;
semilogy(F, PXmod);
grid on;
xlabel('f (Hz)');
ylabel('Periodogram');
title('Periodogram of X^{mod}(t)');

%% 8. AWGN noise

SNRdB = 20;

sigmaW2 = 10*Aamp^2 / (Ts * 10^(SNRdB/10));
W = sqrt(sigmaW2) * randn(size(Xmod));

Y = Xmod + W;

%% Verification of noise variance and SNR

sigmaN2 = Ts * sigmaW2 / 2;
SNR_check = 10*log10((10*Aamp^2)/(2*sigmaN2));

fprintf('Defined SNRdB = %.2f dB\n', SNRdB);
fprintf('sigmaW2 = %.4e\n', sigmaW2);
fprintf('sigmaN2 = %.4e\n', sigmaN2);
fprintf('SNR from formula = %.2f dB\n', SNR_check);


%% 9. Receiver demodulation
YI_demod = Y .* cos(2*pi*F0*t);
YQ_demod = Y .* (-sin(2*pi*F0*t));

%% Plot I branch
figure;
plot(t, YI_demod);
grid on;
xlabel('t (sec)');
ylabel('Y_I(t)');
title('I branch after multiplication with cos(2\piF_0t)');

%% Plot Q branch
figure;
plot(t, YQ_demod);
grid on;
xlabel('t (sec)');
ylabel('Y_Q(t)');
title('Q branch after multiplication with -sin(2\piF_0t)');

%% Periodogram of I branch
YI_demod_f = Ts * fftshift(fft(YI_demod, Nf));
Ttotal = length(YI_demod) * Ts;
PYI_demod = abs(YI_demod_f).^2 / Ttotal;

figure;
semilogy(F, PYI_demod);
grid on;
xlabel('f (Hz)');
ylabel('Periodogram');
title('Periodogram of I branch after demodulation');

%% Periodogram of Q branch
YQ_demod_f = Ts * fftshift(fft(YQ_demod, Nf));
Ttotal = length(YQ_demod) * Ts;
PYQ_demod = abs(YQ_demod_f).^2 / Ttotal;

figure;
semilogy(F, PYQ_demod);
grid on;
xlabel('f (Hz)');
ylabel('Periodogram');
title('Periodogram of Q branch after demodulation');

%% 10. Matched filters

YI_mf = conv(YI_demod, phi) * Ts;
YQ_mf = conv(YQ_demod, phi) * Ts;

t_mf = t(1) + t_phi(1) + (0:length(YI_mf)-1)*Ts;

figure;
plot(t_mf, YI_mf);
grid on;
xlabel('t (sec)');
ylabel('Y_I after MF');
title('I branch after matched filter');

figure;
plot(t_mf, YQ_mf);
grid on;
xlabel('t (sec)');
ylabel('Y_Q after MF');
title('Q branch after matched filter');

%% Periodogram of I branch after matched filter
YI_mf_f = Ts * fftshift(fft(YI_mf, Nf));
Ttotal = length(YI_mf) * Ts;
PYI_mf = abs(YI_mf_f).^2 / Ttotal;

figure;
semilogy(F, PYI_mf);
grid on;
xlabel('f (Hz)');
ylabel('Periodogram');
title('Periodogram of I branch after matched filter');

%% Periodogram of Q branch after matched filter
YQ_mf_f = Ts * fftshift(fft(YQ_mf, Nf));
Ttotal = length(YQ_mf) * Ts;
PYQ_mf = abs(YQ_mf_f).^2 / Ttotal;

figure;
semilogy(F, PYQ_mf);
grid on;
xlabel('f (Hz)');
ylabel('Periodogram');
title('Periodogram of Q branch after matched filter');

%% 11. Sampling

delay = 2*A*over;              % total delay of TX SRRC + matched filter

sample_idx = delay + 1 : over : delay + N*over;

YI_samp = YI_mf(sample_idx);
YQ_samp = YQ_mf(sample_idx);

scatterplot(YI_samp + 1j*YQ_samp);
title('Received 16-QAM constellation after matched filtering');

%% 12. Detection
XI_est = detect_4PAM(YI_samp, Aamp);
XQ_est = detect_4PAM(YQ_samp, Aamp);

%% 13. Symbol errors for 16-QAM
symbol_errors = sum((XI_est ~= XI_sym) | (XQ_est ~= XQ_sym));
SER = symbol_errors / N;

fprintf('Number of 16-QAM symbol errors = %d out of %d symbols\n', symbol_errors, N);
fprintf('Symbol Error Rate = %.5f\n', SER);

%% 14. Convert detected symbols back to bits
bitsI_est = PAM_4_to_bits(XI_est, Aamp);
bitsQ_est = PAM_4_to_bits(XQ_est, Aamp);

bits_est = [bitsI_est bitsQ_est];

%% 15. Bit errors
bit_errors = sum(bits_est ~= bits);
BER = bit_errors / length(bits);

fprintf('Number of bit errors = %d out of %d bits\n', bit_errors, length(bits));
fprintf('Bit Error Rate = %.5f\n', BER);