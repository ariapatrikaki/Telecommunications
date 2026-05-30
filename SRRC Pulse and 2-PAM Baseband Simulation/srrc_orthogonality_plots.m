%Parametres
T = 10^-2;  
over = 10;
A = 4;       
a = 0.5;      
k_values = 0:3;  

% Initialize figures
fig1 = figure(); hold on; grid on;
fig2 = figure(); hold on; grid on;
[phi, t] = srrc_pulse(T, over, A, a); 

for i = 1:length(k_values)
    k = k_values(i);
    shift_samples = k * over;

    phi_shift = [zeros(1, shift_samples), phi(1:end-shift_samples)];
    product = phi .* phi_shift;
    
    figure(fig1);
    plot(t, phi_shift, 'DisplayName', ['\phi(t-', num2str(k), 'T)']);

    figure(fig2);
    plot(t, product, 'DisplayName', ['\phi(t) \phi(t-', num2str(k), 'T)']);
end

% Formatting Plot
figure(fig1);
xlabel('Time (s)'); ylabel('Amplitude');
title('Signals \phi(t) and \phi(t-kT) (a=0.5)');
figure(fig2);
xlabel('Time (s)'); ylabel('Amplitude');
title('Product \phi(t)\phi(t-kT) (a=0.5)');
legend('show');

