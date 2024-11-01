%% define xf as transformation matrix   
% Td = forwardKinematicsAllJoints([0.75; pi/2; -pi/2; pi/4; -pi/4; 0])
Td1 = [ 
    0.0000    0.7071   -0.7071   -0.4089;
    0.7071    0.5000    0.5000    0.7142;
    0.7071   -0.5000   -0.5000    1.1752;
         0         0         0    1.0000];
qi1 = zeros(6, 1);

% Td2 = [ -0.8624    0.0795    0.5000   -0.1602;
%    -0.3624   -0.7866   -0.5000    0.3391;
%     0.3536   -0.6124    0.7071    0.6906;
%          0         0         0    1.0000];
% qi2 = zeros(6, 1);
% -
% Td3 = [    0.7392    0.2803    0.6124    0.3647;
%    -0.5732    0.7392    0.3536    0.8297;
%    -0.3536   -0.6124    0.7071    0.6805;
%          0         0         0    1.0000];
% qi3 = zeros(6, 1);

[q1, q1_dot, q1_ddot, time_sequence1, speed1, tau1, v1, energy1] = controller(Td1, qi1);

% success = visualize_trajectory(q);


