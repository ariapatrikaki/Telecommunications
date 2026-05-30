% Παράμετροι
T = 10^-2;  
over = 10;
Ts = T/over;
A = 4;       
a_values = [0, 0.5, 1]; 
k_values = 0:3;  

for j = 1:length(a_values)
    a = a_values(j);
    [phi, t] = srrc_pulse(T, over, A, a);

    fprintf(['_______________________________' ...
             '\nResults for a = %.1f \n'], a);

    for i = 1:length(k_values)
        k = k_values(i);
        shift_samples = k * over;

        phi_shift = [zeros(1, shift_samples), phi(1:end-shift_samples)];
        product = phi .* phi_shift;
        
        integral_val = sum(product) * Ts;
        
        fprintf('k = %d: Intergral = %.4f\n', k, integral_val);
    end
end