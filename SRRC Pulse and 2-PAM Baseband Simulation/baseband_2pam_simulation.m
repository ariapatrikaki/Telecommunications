% Parameters
N = 50;        
T = 10^-2;      
over = 10;      
Ts = T/over;    
a = 0.5;        
A = 4;          

%Generate N bits 
b = (sign(randn(N,1))+1)/2;
X = bits_to_2PAM(b);
 
X_delta = zeros(length(X)*over, 1);
X_delta(1:over:end) = X / Ts;

% Time axis for impulse train
t_delta = (0:length(X_delta)-1) * Ts;

figure;
stem(t_delta, X_delta);
title('Impulse Train X_{\delta}(t)');
xlabel('Time (s)'); ylabel('Amplitude');

%Transmit Signal X(t) 
[phi, t_phi] = srrc_pulse(T, over, A, a);
X_t = conv(X_delta, phi) * Ts; % Convolution 

% Time axis for X(t) 
% Starts at t_delta(min) + t_phi(min)
t_X = (0:length(X_t)-1)*Ts + (t_delta(1) + t_phi(1));

figure;
plot(t_X, X_t);
title('Transmitted Baseband Signal X(t)');
xlabel('Time (s)'); ylabel('Amplitude');
grid on;

% Receiver Output Z(t) 
% Matched filter is phi(-t). Since SRRC is symmetric, phi(-t) = phi(t).
Z_t = conv(X_t, phi) * Ts;

% Time axis for Z(t)
t_Z = (0:length(Z_t)-1)*Ts + (t_X(1) + t_phi(1));

figure;
plot(t_Z, Z_t); hold on;
stem((0:N-1)*T, X); 
title('Matched Filter Output Z(t) and Original Symbols X_k');
legend('Z(t)', 'Original Symbols X_k');
xlabel('Time (s)'); grid on;
