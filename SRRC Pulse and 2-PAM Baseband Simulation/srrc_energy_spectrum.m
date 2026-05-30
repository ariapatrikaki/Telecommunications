% Parameters
T = 10^-2;          
over = 10;          
A = 4;             
alphas = [0, 0.5, 1]; 
Nf = 2048;         

Ts = T / over;      
Fs = 1 / Ts;       
freq = linspace(-Fs/2, Fs/2 - Fs/Nf, Nf); 

% Initialize figures
fig1 = figure(); hold on; grid on;
fig2 = figure(); hold on; grid on;
colors = ['r', 'g', 'b'];

for i = 1:length(alphas)
    [phi, t] = srrc_pulse(T, over, A, alphas(i));
    Phi_F = fftshift(fft(phi, Nf)) * Ts; 
    ESD = abs(Phi_F).^2;       %|Phi(F)|^2
    
    % (a) Plot on a common linear plot 
    figure(fig1);
    plot(freq, ESD, colors(i));
    
    % (b) Plot on a common semilogy plot 
    figure(fig2);
    semilogy(freq, ESD, colors(i));
end

% Formatting Linear Plot
figure(fig1);
title('Energy Spectral Density |\Phi(F)|^2 (Linear)');
xlabel('Frequency (Hz)'); ylabel('Magnitude');
legend('a=0', 'a=0.5', 'a=1');

% Formatting Semilogy Plot
figure(fig2);
title('Energy Spectral Density |\Phi(F)|^2 (Semilogy)');
xlabel('Frequency (Hz)'); ylabel('Magnitude');
legend('a=0', 'a=0.5', 'a=1');


