function X = ad_twist(V)
% returns 6x6 matrix of matrix notation of twist
w = V(1:3); v = V(4:6);
w_m = box3(w);
X = [w_m zeros(3,3); box3(v) w_m];
end