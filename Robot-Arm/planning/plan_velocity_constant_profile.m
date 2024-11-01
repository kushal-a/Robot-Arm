% waypoints, size: 6 x no of waypoints
function [q_, q_dot, q_ddot, time_sequence] = plan_velocity_constant_profile(waypoints)

max_vel_revolute_joint = 0.0873; % 5deg/s
max_vel_prismatic_joint = 0.09; % to be on the safe side
max_vel_joints = [max_vel_prismatic_joint, max_vel_revolute_joint, max_vel_revolute_joint, max_vel_revolute_joint, max_vel_revolute_joint, max_vel_revolute_joint];

no_of_waypoints = size(waypoints, 2);
q_diff = abs(waypoints(:, 1) - waypoints(:, no_of_waypoints));
[argvalue, argmaxindex] = max(q_diff);
argmaxvel = max_vel_joints(argmaxindex);

while 1
    % calculate time required by the joint that travels largest to reach its final position
    T = (abs(waypoints(argmaxindex, 1) - waypoints(argmaxindex, no_of_waypoints))) / argmaxvel;
    time_sequence = linspace(0, T, no_of_waypoints);
    
    % define joint values , vel, acc
    q_ = zeros(6, no_of_waypoints);
    q_dot = zeros(6, no_of_waypoints);
    q_ddot = zeros(6, no_of_waypoints);
    
    % v: link frame velocities, speed: link frame speed
    v = zeros(3, no_of_waypoints, 6);
    speed = zeros(1, no_of_waypoints, 6);

    % calculate joint velocities
    for i=1:1:6
        if (i == argmaxindex)
            argmaxvel = ((waypoints(i, no_of_waypoints) - waypoints(i, 1))) / T;
            q_(i, :) = argmaxvel * time_sequence + waypoints(i, 1);
            q_dot(i, :) = argmaxvel * ones(1, no_of_waypoints);
            q_ddot(i, :) = zeros(1, no_of_waypoints);
        else
            v_i = ((waypoints(i, no_of_waypoints) - waypoints(i, 1))) / T;
            if v_i > max_vel_joints(i)
                v_i = max_vel_joints(i);
            end
            q_(i, :) = v_i * time_sequence + waypoints(i, 1);
            q_dot(i, :) = v_i * ones(1, no_of_waypoints);
            q_ddot(i, :) = zeros(1, no_of_waypoints);
        end
    end

    % calculate link frame velocties
    for j = 1:1:no_of_waypoints
    [v(:, j, 1), v(:, j, 2), v(:, j, 3), v(:, j, 4), v(:, j, 5), v(:, j, 6)] = calculate_frame_vel(q_(:, j), q_dot(:, j));
    end
    
    % calculate link frame speeds
    speed(1, :, :) = sqrt(sum(v.*v, 1));
    
    % check if all the speed is less than 0.1 m/s
    if all(speed < 0.1, "all")
        break
    else
        argmaxvel = argmaxvel - (0.005);
    end
end

end