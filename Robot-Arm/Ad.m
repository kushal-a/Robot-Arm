function X = Ad(T)
% returns adjoint of a transformation matrix
R = T(1:3,1:3);
p = T(1:3,4);
X = [R zeros(3,3);box3(p)*R R];
end