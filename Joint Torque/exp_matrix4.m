function E = exp_matrix4(A,t)
Sw_m = A(1:3,1:3);
Sv = A(1:3,4);
E12 = (eye(3)*t+(1-cos(t))*Sw_m+(t-sin(t))*Sw_m^2)*Sv;
E = [exp_matrix3(Sw_m,t) E12; 0 0 0 1];
end