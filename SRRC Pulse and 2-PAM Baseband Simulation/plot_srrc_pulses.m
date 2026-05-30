% Parameters 
T = 10^-2; 
over = 10; 
A = 4; 

figure; 
hold on;

[phi, t] = srrc_pulse(T, over, A, 0);
plot(t, phi, 'r');

[phi, t] = srrc_pulse(T, over, A, 0.5);
plot(t, phi, 'g');

[phi, t] = srrc_pulse(T, over, A, 1);
plot(t, phi, 'b');

grid on;

legend('a=0', 'a=0.5', 'a=1');
xlabel('Time (sec)'); 
ylabel('\phi(t)');
title('SRRC Pulses for various roll-off factors');
