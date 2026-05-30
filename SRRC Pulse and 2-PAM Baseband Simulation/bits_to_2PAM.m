function X = bits_to_2PAM(b)
    X = zeros(size(b));
    X(b == 0) = 1;
    X(b == 1) = -1;
end
