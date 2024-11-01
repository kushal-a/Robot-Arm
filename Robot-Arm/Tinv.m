function inv = Tinv(T)
    R = T(1:3,1:3);
    inv = [R' -R'*T(1:3,4); 0 0 0 1];
end