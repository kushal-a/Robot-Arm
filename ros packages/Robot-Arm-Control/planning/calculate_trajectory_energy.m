% requires time_sequence [1 X size(time_sequence)]
% q_dot [6 X size(time_sequence)]
% tau [ 6 X size(time_sequence)]
function [tau, energy] = calculate_trajectory_energy(time_sequence, q, q_dot, q_ddot)
total_time_steps = size(time_sequence, 2);
tau = zeros(6, total_time_steps);
for i = 1:1:total_time_steps
    q_i = q(:, i);
    q_i_dot = q_dot(:, i);
    q_i_ddot = q_ddot(:, i);
    tau(:, i) = torque6dof(q_i, q_i_dot, q_i_ddot);
end

energy_steps = zeros(1, total_time_steps);
for i = 1:1:total_time_steps
    if i == 1
        time_step_i = time_sequence(i)-0;
    else
        time_step_i = time_sequence(i)-time_sequence(i-1);
    end
    % disp("time step i:")
    % disp(time_step_i)
    energy_steps(i) = abs(tau(:, i)' * q_dot(:, i)) * time_step_i;
    % disp("energy step i:")
    % disp(energy_steps(i))
end
energy = sum(energy_steps);
end