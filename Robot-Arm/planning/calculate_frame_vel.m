% return velocties at joints at given time t
% given q and q_dot,  size: 6 X no of waypoints
function [v1, v2, v3, v4, v5, v6] = calculate_frame_vel(q, q_dot)

[T,A]=fk_for_ik(q,zeros(4,4));
% disp(T)
% disp(A(:, :, 1)*A(:, :, 2)*A(:, :, 3)*A(:, :, 4)*A(:, :, 5)*A(:, :, 6))
R0_0 = eye(3);

T0_1 = A(:, :, 1);
R0_1 = T0_1(1:3, 1:3);
d0_1 = T0_1(1:3, 4);

T0_2 = A(:, :, 1)*A(:, :, 2);
R0_2 = T0_2(1:3, 1:3);
d0_2 = T0_2(1:3, 4);

T0_3 = A(:, :, 1)*A(:, :, 2)*A(:, :, 3);
R0_3 = T0_3(1:3, 1:3);
d0_3 = T0_3(1:3, 4);

T0_4 = A(:, :, 1)*A(:, :, 2)*A(:, :, 3)*A(:, :, 4);
R0_4 = T0_4(1:3, 1:3);
d0_4 = T0_4(1:3, 4);

T0_5 = A(:, :, 1)*A(:, :, 2)*A(:, :, 3)*A(:, :, 4)*A(:, :, 5);
R0_5 = T0_5(1:3, 1:3);
d0_5 = T0_5(1:3, 4);

R0_6 = T(1:3, 1:3);
d0_6 = T(1:3, 4);

base_z = [0 0 1]';
Jv1 = R0_0 * base_z;
Jv2 = [R0_0 * [0 0 1]' , cross(R0_1*base_z, d0_2 - d0_1)];
Jv3 = [R0_0 * [0 0 1]' , cross(R0_1*base_z, d0_3 - d0_1) , cross(R0_2*base_z, d0_3 - d0_2)];
Jv4 = [R0_0 * [0 0 1]' , cross(R0_1*base_z, d0_4 - d0_1) , cross(R0_2*base_z, d0_4 - d0_2) , cross(R0_3*base_z, d0_4 - d0_3)];
Jv5 = [R0_0 * [0 0 1]' , cross(R0_1*base_z, d0_5 - d0_1) , cross(R0_2*base_z, d0_5 - d0_2) , cross(R0_3*base_z, d0_5 - d0_3) , cross(R0_4*base_z, d0_5 - d0_4)];
Jv6 = [R0_0 * [0 0 1]' , cross(R0_1*base_z, d0_6 - d0_1) , cross(R0_2*base_z, d0_6 - d0_2) , cross(R0_3*base_z, d0_6 - d0_3) , cross(R0_4*base_z, d0_6 - d0_4) , cross(R0_5*base_z, d0_6 - d0_5)];

v1 = Jv1 * [q_dot(1)];
v2 = Jv2 * [q_dot(1) q_dot(2)]';
v3 = Jv3 * [q_dot(1) q_dot(2) q_dot(3)]';
v4 = Jv4 * [q_dot(1) q_dot(2) q_dot(3) q_dot(4)]';
v5 = Jv5 * [q_dot(1) q_dot(2) q_dot(3) q_dot(4) q_dot(5)]';
v6 = Jv6 * [q_dot(1) q_dot(2) q_dot(3) q_dot(4) q_dot(5) q_dot(6)]';

end