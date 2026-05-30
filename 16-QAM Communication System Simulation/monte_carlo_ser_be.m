clear; close all; clc;

%% Parameters
N = 200;
K = 200;  % K times
Aamp = 1;

T = 10^(-3);
over = 10;
Ts = T/over;
F0 = 2000;

A = 4;
a = 0.5;

SNRdB_vec = 0:2:16;

[phi, t_phi] = srrc_pulse(T, over, A, a);

SER_exp = zeros(size(SNRdB_vec));
BER_exp = zeros(size(SNRdB_vec));

for i = 1:length(SNRdB_vec)

    SNRdB = SNRdB_vec(i);

    total_symbol_errors = 0;
    total_bit_errors = 0;

    total_symbols = K*N;
    total_bits = K*4*N;

    for kk = 1:K
        bits = randi([0 1], 1, 4*N);

        bitsI = bits(1:2*N);
        bitsQ = bits(2*N+1:end);

        XI_sym = bits_to_4PAM(bitsI, Aamp);
        XQ_sym = bits_to_4PAM(bitsQ, Aamp);

        % Pulse shaping
        XI_delta = 1/Ts * upsample(XI_sym, over);
        XQ_delta = 1/Ts * upsample(XQ_sym, over);

        XI_t = conv(XI_delta, phi) * Ts;
        XQ_t = conv(XQ_delta, phi) * Ts;

        t = t_phi(1) + (0:length(XI_t)-1)*Ts;

        % Modulation
        XI_mod = 2 * XI_t .* cos(2*pi*F0*t);
        XQ_mod = -2 * XQ_t .* sin(2*pi*F0*t);

        Xmod = XI_mod + XQ_mod;

        % Noise
        sigmaW2 = 10*Aamp^2 / (Ts * 10^(SNRdB/10));
        W = sqrt(sigmaW2) * randn(size(Xmod));

        Y = Xmod + W;

        % Demodulation
        YI_demod = Y .* cos(2*pi*F0*t);
        YQ_demod = Y .* (-sin(2*pi*F0*t));

        % Matched filter
        YI_mf = conv(YI_demod, phi) * Ts;
        YQ_mf = conv(YQ_demod, phi) * Ts;

        t_mf = t(1) + t_phi(1) + (0:length(YI_mf)-1)*Ts;

        % Sampling
        sample_times = (0:N-1)*T;
        sample_idx = zeros(1,N);

        for n = 1:N
            [~, sample_idx(n)] = min(abs(t_mf - sample_times(n)));
        end

        YI_samp = YI_mf(sample_idx);
        YQ_samp = YQ_mf(sample_idx);

        % Detection
        XI_est = detect_4PAM(YI_samp, Aamp);
        XQ_est = detect_4PAM(YQ_samp, Aamp);

        % Symbol errors
        symbol_errors = sum((XI_est ~= XI_sym) | (XQ_est ~= XQ_sym));
        total_symbol_errors = total_symbol_errors + symbol_errors;

        % Bit errors
        bitsI_est = PAM_4_to_bits(XI_est, Aamp);
        bitsQ_est = PAM_4_to_bits(XQ_est, Aamp);

        bits_est = [bitsI_est bitsQ_est];

        bit_errors = sum(bits_est ~= bits);
        total_bit_errors = total_bit_errors + bit_errors;
    end

    SER_exp(i) = total_symbol_errors / total_symbols;
    BER_exp(i) = total_bit_errors / total_bits;

end

%% Theoretical probabilities
SNRlin = 10.^(SNRdB_vec/10);
q_arg = sqrt(SNRlin/5);
Pdim = (3/2) * Q(q_arg);

SER_theory = 1 - (1 - Pdim).^2;
BER_theory_approx = (3/4) * Q(q_arg);

%% SER plot
figure;
semilogy(SNRdB_vec, SER_exp, 'o-', 'LineWidth', 1.5); hold on;
semilogy(SNRdB_vec, SER_theory, 's-', 'LineWidth', 1.5);
grid on;
xlabel('SNR_{dB}');
ylabel('Symbol Error Probability');
legend('Experimental SER', 'Theoretical SER');
title('Symbol error probability for 16-QAM');

%% BER plot
figure;
semilogy(SNRdB_vec, BER_exp, 'o-', 'LineWidth', 1.5); hold on;
semilogy(SNRdB_vec, BER_theory_approx, 's-', 'LineWidth', 1.5);
grid on;
xlabel('SNR_{dB}');
ylabel('Bit Error Probability');
legend('Experimental BER', 'Theoretical BER approximation');
title('Bit error probability for 16-QAM');