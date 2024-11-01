function E = exp_matrix3(A,t)
E = eye(3) + sin(t)*A+(1-cos(t))*A^2;
end