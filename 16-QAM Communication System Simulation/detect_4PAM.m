function est_X = detect_4PAM(Y, A)
    est_X = zeros(size(Y));

    for k = 1:length(Y)
        if Y(k) < -2*A
            est_X(k) = -3*A;
        elseif Y(k) >= -2*A && Y(k) < 0
            est_X(k) = -A;
        elseif Y(k) >= 0 && Y(k) < 2*A
            est_X(k) = A;
        else
            est_X(k) = 3*A;
        end
    end
end