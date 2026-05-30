function X = bits_to_4PAM(bit_seq, A)
    bit_seq = bit_seq(:).';
    bit_pairs = reshape(bit_seq, 2, []).';

    X = zeros(1, size(bit_pairs,1));

    for k = 1:size(bit_pairs,1)
        b1 = bit_pairs(k,1);
        b2 = bit_pairs(k,2);

        if b1 == 0 && b2 == 0
            X(k) = -3*A;
        elseif b1 == 0 && b2 == 1
            X(k) = -A;
        elseif b1 == 1 && b2 == 1
            X(k) = A;
        elseif b1 == 1 && b2 == 0
            X(k) = 3*A;
        end
    end
end