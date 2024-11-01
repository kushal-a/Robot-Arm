%% initial and final points
qi = [0;0;0;0;0;0];
qf = [0.75;pi/2;pi/2;pi/2;pi/2;pi/2];

% qf = [0;0;0;0;0;0];
% qi = [0.75;pi/2;pi/2;pi/2;pi/2;pi/2];

%% unit testing for functions
% [possible_directions_final_q] = generate_q_final_directions(qi, qf);
[waypoints] = path_planning(qi, qf);

%% obtain joint value sequences for trajectory with minimal energy
% tic
% [q, q_dot, q_ddot, time_sequence]=trajectory_planning_qfinal(qi,qf);
% toc
% success = visualize_trajectory(q);

% debug
% [energy] = calculate_trajectory_energy(time_sequence_final, q_final, q_dot_final, q_ddot_final);
% waypoints_debug = waypoints_final(:, 401:500) + 0.1
% [q_, q_dot, q_ddot, time_sequence] = plan_velocity_constant_profile(waypoints_debug)
%% defining timeseries objects for joint
% q_signal = timeseries(q,time_sequence); % meters, rad, rad, rad, rad, rad
% q_dot_signal = timeseries(q_dot,time_sequence); % m/s, rad/s, rad/s, rad/s, rad/s, rad/s
% q_ddot_signal = timeseries(q_ddot,time_sequence); % m/s^2, rad/s^2, rad/s^2, rad/s^2, rad/s^2 