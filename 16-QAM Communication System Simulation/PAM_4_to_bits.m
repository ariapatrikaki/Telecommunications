function est_bit = PAM_4_to_bits(X, A)
    est_bit = zeros(1, 2*length(X));

    for k = 1:length(X)
        if X(k) == -3*A
            bit_pair = [0 0];
        elseif X(k) == -A
            bit_pair = [0 1];
        elseif X(k) == A
            bit_pair = [1 1];
        elseif X(k) == 3*A
            bit_pair = [1 0];
        end
        est_bit(2*k-1 : 2*k) = bit_pair;
    end
end