%% EXERCISE 2 - PATRIKAKI ARISTEA
clear; close all; clc;

% parameters
T     = 10^-3;
over  = 10;
Ts    = T/over;
Fs    = 1 / Ts; 
A     = 4;
a     = 0.5;
Nf    = 4096;

%% A.1 
[phi, t_phi] = srrc_pulse(T, over, A, a);
F = (-Nf/2:Nf/2-1)*(Fs/Nf);
Phi = Ts*fftshift(fft(phi, Nf));
ESD_phi = abs(Phi).^2;

figure;
semilogy(F, ESD_phi); grid on;
xlabel('f (Hz)'); ylabel('|\Phi(F)|^2');
title('ESD of SRRC pulse');

%% A.2
N     = 100;  % Number of bits
bits  = randi([0 1], 1, N);  % Generate N independent equiprobable bits

% Mapping
Xn = 1 - 2*bits;

[phi, t_phi] = srrc_pulse(T, over, A, a);

Lx = (N-1)*over + length(phi);  % Length of the final waveform in samples

% Initialize waveform
x = zeros(1, Lx);

% X(t) = sum Xn * phi(t - nT)
for n = 0:N-1
    start_index = n*over + 1;
    end_index = start_index + length(phi) - 1;
    
    x(start_index:end_index) = x(start_index:end_index) + Xn(n+1)*phi;
end

t_x = (0:Lx-1)*Ts + t_phi(1);  % Time axis for X(t)

figure;
plot(t_x, x); grid on;
xlabel('t (sec)'); ylabel('X(t)');

%% A.3 
Fs = 1/Ts; 
Ttotal = length(x) * Ts;    % Total duration

% Frequency axis from -Fs/2 to Fs/2
F = (-Nf/2:Nf/2-1) * Fs/Nf;

% Fourier transform of X(t)
X_F = Ts * fftshift(fft(x, Nf));

% Periodogram
PX = abs(X_F).^2 / Ttotal;

% Plot
figure;
plot(F, PX); grid on;
xlabel('f (Hz)'); ylabel('P_X(F)');
title('Periodogram of one realization of X(t) (linear scale)');

% semilogy
figure;
semilogy(F, PX); grid on;
xlabel('f (Hz)'); ylabel('P_X(F)');
title('Periodogram of one realization of X(t) (semilogy scale)');

%% A.3 - b

K = 500;
PX_sum = zeros(1, Nf);

for k = 1:K
    
    bits = randi([0 1], 1, N);
    Xn = 1 - 2*bits;
    
    x = zeros(1, Lx);
    
    for n = 0:N-1
        start_index = n*over + 1;
        end_index = start_index + length(phi) - 1;
        
        x(start_index:end_index) = x(start_index:end_index) + Xn(n+1)*phi;
    end
    
    X_F = Ts * fftshift(fft(x, Nf));
    PX = abs(X_F).^2 / Ttotal;
    
    PX_sum = PX_sum + PX;
end

PX_est = PX_sum / K;

Phi = Ts * fftshift(fft(phi, Nf));
SX_theory = (1 / T) * abs(Phi).^2;

figure;
semilogy(F, PX_est);
hold on;
semilogy(F, SX_theory, '--');
grid on;

xlabel('f (Hz)');
ylabel('PSD');
title('2-PAM PSD estimate and theory');
legend('Estimated PSD, K = 500', 'Theoretical PSD');

%% A.4 - 4-PAM waveform

% Generate N independent equiprobable bits
bits = randi([0 1], 1, N);

% Number of 4-PAM symbols
Nsym4 = N/2;

% Initialize 4-PAM symbol sequence
Xn4 = zeros(1, Nsym4);

% Mapping
for n = 1:Nsym4
    
    b1 = bits(2*n - 1);
    b2 = bits(2*n);
    
    if b1 == 0 && b2 == 0
        Xn4(n) = 3;
    elseif b1 == 0 && b2 == 1
        Xn4(n) = 1;
    elseif b1 == 1 && b2 == 1
        Xn4(n) = -1;
    elseif b1 == 1 && b2 == 0
        Xn4(n) = -3;
    end
end

% Construct 4-PAM waveform
Lx4 = (Nsym4 - 1)*over + length(phi);
x4 = zeros(1, Lx4);

for n = 0:Nsym4-1
    start_index = n*over + 1;
    end_index = start_index + length(phi) - 1;
    
    x4(start_index:end_index) = x4(start_index:end_index) + Xn4(n+1)*phi;
end

% Time axis for 4-PAM waveform
t_x4 = (0:Lx4-1)*Ts + t_phi(1);

Ttotal4 = length(x4) * Ts;

% Fourier transform of x4
X4_F = Ts * fftshift(fft(x4, Nf));

% Periodogram
PX4 = abs(X4_F).^2 / Ttotal4;

%% PSD estimation by averaging K periodograms

K = 500;
PX4_sum = zeros(1, Nf);

for k = 1:K
    
    % Generate new random bits
    bits = randi([0 1], 1, N);
    
    % Convert bits to 4-PAM symbols
    Xn4 = zeros(1, Nsym4);
    
    for n = 1:Nsym4
        
        b1 = bits(2*n - 1);
        b2 = bits(2*n);
        
        if b1 == 0 && b2 == 0
            Xn4(n) = 3;
        elseif b1 == 0 && b2 == 1
            Xn4(n) = 1;
        elseif b1 == 1 && b2 == 1
            Xn4(n) = -1;
        elseif b1 == 1 && b2 == 0
            Xn4(n) = -3;
        end
    end
    
    % Construct 4-PAM waveform
    x4 = zeros(1, Lx4);
    
    for n = 0:Nsym4-1
        start_index = n*over + 1;
        end_index = start_index + length(phi) - 1;
        
        x4(start_index:end_index) = x4(start_index:end_index) + Xn4(n+1)*phi;
    end
    
    % Fourier transform
    X4_F = Ts * fftshift(fft(x4, Nf));
    
    % Periodogram
    PX4 = abs(X4_F).^2 / Ttotal4;
    
    % Add to sum
    PX4_sum = PX4_sum + PX4;
end

% Estimated PSD
PX4_est = PX4_sum / K;

% Theoretical PSD for 4-PAM
sigma2_X4 = 5;
Phi = Ts * fftshift(fft(phi, Nf));
SX4_theory = (sigma2_X4 / T) * abs(Phi).^2;

% plot
figure;
semilogy(F, PX4_est); hold on;
semilogy(F, SX4_theory, '--');
grid on;

xlabel('f (Hz)'); ylabel('PSD');
title('4-PAM PSD estimate and theory');
legend('Estimated PSD, 4-PAM', 'Theoretical PSD, 4-PAM');

%% A.5 2-PAM with Tprime = 2T, same Ts
T5    = 2*T;         
over5 = 2*over;

Ts    = T5/over5;
Fs    = 1 / Ts; 

% Frequency axis from -Fs/2 to Fs/2
F = (-Nf/2:Nf/2-1) * Fs/Nf;

% New SRRC pulse for T'
[phi5, t_phi5] = srrc_pulse(T5, over5, A, a);

% Lengths
Lphi5 = length(phi5);
Lx5 = (N-1)*over5 + Lphi5;

% One realization
bits = randi([0 1], 1, N);

% 2-PAM mapping
Xn = 1 - 2*bits;

% Construct waveform
x5 = zeros(1, Lx5);

for n = 0:N-1
    start_index = n*over5 + 1;
    end_index = start_index + Lphi5 - 1;
    
    x5(start_index:end_index) = x5(start_index:end_index) + Xn(n+1)*phi5;
end

Ttotal5 = length(x5)*Ts;

% Periodogram
X5_F = Ts * fftshift(fft(x5, Nf));
PX5 = abs(X5_F).^2 / Ttotal5;

figure;
semilogy(F, PX5);
grid on;
xlabel('f (Hz)');
ylabel('P_X(F)');
title('Periodogram of one realization, T'' = 2T');

%% A.5 - PSD estimation by averaging K periodograms

K = 500;
PX5_sum = zeros(1, Nf);

for k = 1:K
    
    % Generate new random bits
    bits = randi([0 1], 1, N);
    
    % 2-PAM mapping
    Xn = 1 - 2*bits;
    
    % Construct waveform
    x5 = zeros(1, Lx5);
    
    for n = 0:N-1
        start_index = n*over5 + 1;
        end_index = start_index + Lphi5 - 1;
        
        x5(start_index:end_index) = x5(start_index:end_index) + Xn(n+1)*phi5;
    end
    
    % Fourier transform
    X5_F = Ts * fftshift(fft(x5, Nf));
    
    % Periodogram
    PX5 = abs(X5_F).^2 / Ttotal5;
    
    % Add to sum
    PX5_sum = PX5_sum + PX5;
end

% Estimated PSD
PX5_est = PX5_sum / K;

% Theoretical PSD for T' = 2T
Phi5 = Ts * fftshift(fft(phi5, Nf));
SX5_theory = (1 / T5) * abs(Phi5).^2;

figure;
semilogy(F, PX5_est);
hold on;
semilogy(F, SX5_theory, '--');
grid on;

xlabel('f (Hz)'); ylabel('PSD');
title('2-PAM PSD for T'' = 2T estimate and theory');
legend('Estimated PSD, T'' = 2T', 'Theoretical PSD, T'' = 2T');

%% Compare PSD of A.3 and A.5

figure;
semilogy(F, SX_theory);
hold on;
semilogy(F, SX5_theory);
grid on;

xlabel('f (Hz)');
ylabel('S_X(f)');
title('Theoretical PSD comparison for T=T and T''=2T');
legend('T', 'T'' = 2T');

%% B.1 Five realizations
F0 = 10;
TsB = 10^-2;
t_axis = 0:TsB:5/F0;

figure; hold on; grid on;
for m = 1:5
    X = randn;
    Phi = 2*pi*rand;
    Y = X*cos(2*pi*F0*t_axis + Phi);
    plot(t_axis, Y);
end

xlabel('t (sec)'); ylabel('Y(t)');
title('5 realizations of Y(t)');