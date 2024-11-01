% theta(t), theta_dot(t), theta_ddot(t), series_t
% % waypoints, size: 6 x no of waypoints
function [q_, q_dot, q_ddot, time_sequence, speed, v] = plan_velocity_trapezoidal_profile(waypoints)

max_vel_revolute_joint = 0.0873; % 5deg/s
max_acc_revolute_joint = 0.3142; % 18 deg/s^2 0.3142
max_vel_prismatic_joint = 0.09; % to be on the safe side
max_acc_prismatic_joint = 0.08; % change this

max_vel_joints = [max_vel_prismatic_joint, max_vel_revolute_joint, max_vel_revolute_joint, max_vel_revolute_joint, max_vel_revolute_joint, max_vel_revolute_joint];
max_acc_joints = [max_acc_prismatic_joint, max_acc_revolute_joint, max_acc_revolute_joint, max_acc_revolute_joint, max_acc_revolute_joint, max_acc_revolute_joint];

no_of_waypoints = size(waypoints, 2);%endfvbnnv
final_q = waypoints(:, no_of_waypoints)';
initial_q = waypoints(:, 1)';

q_v = max_vel_joints ./ abs(final_q - initial_q);
q_a = max_acc_joints ./ abs(final_q - initial_q);

q_v(q_v>10) = 0;
q_a(q_a>10) = 0;

q_T = (q_a + (q_v .* q_v))./(q_v .* q_a);
q_T(isnan(q_T)) = 0;

[argvalue, argmaxindex] = max(q_T);

while 1
    
    % calculate the maximum time required to complete the traj
    T = (q_a(argmaxindex) + (q_v(argmaxindex) .* q_v(argmaxindex)))./(q_v(argmaxindex) .* q_a(argmaxindex));
    disp("T")
    disp(T)
    if isnan(T)
        error("no planning required, we are already at final position")
    end
    time_sequence = linspace(0, T, T);
    total_time_steps = size(time_sequence, 2);
    
    % define joint values , vel, acc
    q_ = zeros(6, total_time_steps);
    q_dot = zeros(6, total_time_steps);
    q_ddot = zeros(6, total_time_steps);
    
    % v: link frame velocities, speed: link frame speed
    v = zeros(3, total_time_steps, 6);
    speed = zeros(1, total_time_steps, 6);
    
    % calculate joint velocities
    for i=1:1:6
        if (i == argmaxindex)
            [q_(i, :), q_dot(i, :), q_ddot(i, :)] = trapezoidalTimeScaling(initial_q(i), final_q(i), q_v(i), q_a(i), T, time_sequence);
        elseif q_a(i) == 0
            q_(i, :) = zeros(1, total_time_steps);
            q_dot(i, :) = zeros(1, total_time_steps);
            q_ddot(i, :) = zeros(1, total_time_steps);
        else
            v_i = 0.5 * ( (q_a(i) * T) - (sqrt(q_a(i))*sqrt((q_a(i)*T*T) - 4)));
            [q_(i, :), q_dot(i, :), q_ddot(i, :)] = trapezoidalTimeScaling(initial_q(i), final_q(i), v_i, q_a(i), T, time_sequence);
        end
    end

    % calculate link frame velocties
    for j = 1:1:total_time_steps
    [v(:, j, 1), v(:, j, 2), v(:, j, 3), v(:, j, 4), v(:, j, 5), v(:, j, 6)] = calculate_frame_vel(q_(:, j), q_dot(:, j));
    end
    
    % calculate link frame speeds
    speed(1, :, :) = sqrt(sum(v.*v, 1));

    % check if all the speed is less than 0.1 m/s
    if all(speed < 0.1, "all")
        break
    else
        q_v(argmaxindex) = q_v(argmaxindex) - (0.005/(abs( final_q(argmaxindex) - initial_q(argmaxindex) ) ) );
    end
    
end

end