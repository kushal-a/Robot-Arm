function [q, q_dot, q_ddot, time_sequence, speed, tau, v, energy] = controller(Td, qi)
% obtain all ik solution
q = allInverseKinematics(Td);
% perform collision check for IK
Q = collision_check_IK(q);
% perform collision in each direction for solution obtained in prev step
[final_waypoints] = path_planning(qi, Q);
% perform velocty planning
[q, q_dot, q_ddot, time_sequence, speed, v] = plan_velocity_trapezoidal_profile(final_waypoints);
% energy calculation
[tau, energy] = calculate_trajectory_energy(time_sequence, q, q_dot, q_ddot);

end

% T = forwardKinematicsAllJoints([0.2; pi/2; -pi/2; pi/2; -pi/4; 0])