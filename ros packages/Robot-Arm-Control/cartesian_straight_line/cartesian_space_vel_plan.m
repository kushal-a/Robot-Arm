function [q_, q_dot, q_ddot] = cartesian_space_vel_plan(xi, xf, joint_space_traversed)

% joint_space_traversed = joint_space_traversed(:, 1:199);

max_vel_eef = 0.0026; %m/s
max_acc_eef = 0.05;

no_of_waypoints = size(joint_space_traversed, 2)
norm(xf - xi)
s_vel_max = max_vel_eef / norm(xf - xi)
s_acc_max = max_acc_eef / norm(xf - xi)

s_vel_max(s_vel_max>10) = 0
s_acc_max(s_acc_max>10) = 0

T = (s_acc_max + (s_vel_max * s_vel_max))/(s_vel_max * s_acc_max)
T(isnan(T)) = 0;
IT = 1;
while 1
    disp("iteration")
    disp(IT);

    % calculate the maximum time required to complete the traj
    T = (s_acc_max + (s_vel_max * s_vel_max)) / (s_vel_max * s_acc_max);
    disp("T")
    disp(T)
    if isnan(T)
        error("no planning required, we are already at final position")
    end
    time_sequence = linspace(0, T, no_of_waypoints)
    disp("time sequence")
    
    % define joint values , vel, acc
    q_ = zeros(6, no_of_waypoints);
    q_dot = zeros(6, no_of_waypoints);
    q_ddot = zeros(6, no_of_waypoints);
    
    % v: link frame velocities, speed: link frame speed
    v = zeros(3, no_of_waypoints, 6);
    speed = zeros(1, no_of_waypoints, 6);
    
    s = zeros(1, no_of_waypoints);
    s_dot = zeros(1, no_of_waypoints);
    s_ddot = zeros(1, no_of_waypoints);

    % calculate eef velocities
    for i=1:no_of_waypoints
        t = time_sequence(i);
    
        if (t >= 0) && (t <= s_vel_max/s_acc_max)
            s(i) = s_acc_max* t * t / 2;
            s_dot(i) = s_acc_max* t;
            s_ddot(i) = s_acc_max;
    
        elseif (t > s_vel_max/s_acc_max) && (t <= T - (s_vel_max/s_acc_max))
            s(i) = t* s_vel_max - (s_vel_max*s_vel_max/(2*s_acc_max));
            s_dot(i) = s_vel_max;
            s_ddot(i) = 0;
    
        elseif (t > T - (s_vel_max/s_acc_max)) && (t <= T)
            s(i) = -1 * ( (s_acc_max*s_acc_max*(T-t)*(T-t)) + (2*s_vel_max*s_vel_max) - (2*T*s_acc_max*s_vel_max) )/(2*s_acc_max);
            s_dot(i) = s_acc_max* (T - t);
            s_ddot(i) = -1 * s_acc_max;
    
        else % t>T
            s(i) = 1;
            s_dot(i) = 0;
            s_ddot(i) = 0;
        end
    end
    
    x = xi + (xf-xi) *s;
    x_dot = (xf-xi) * s_dot;
    x_ddot = (xf-xi) * s_ddot;
    disp("x")
    %disp(x)

    time_step = time_sequence(2) - time_sequence(1)
    disp("time step")
    disp(time_step)
    % calculate joint velocities
    for i=1:6
        q_(i, :) = joint_space_traversed(i, :);
    
        temp_vel = diff(joint_space_traversed(i,:))/time_step;
        temp_acc = diff(joint_space_traversed(i,:), 2)/time_step;
    
        q_dot(i, 1:no_of_waypoints-1) = temp_vel;
        q_ddot(i, 2:no_of_waypoints-1) = temp_acc;
    
        q_dot(i, no_of_waypoints) = temp_vel(end);
        q_ddot(i, no_of_waypoints) = temp_acc(end);
        q_ddot(i, 1) = temp_acc(1);
    end


    % calculate link frame velocties
    for j = 1:1:no_of_waypoints
        [v(:, j, 1), v(:, j, 2), v(:, j, 3), v(:, j, 4), v(:, j, 5), v(:, j, 6)] = calculate_frame_vel(q_(:, j), q_dot(:, j));
    end
    
    % calculate link frame speeds
    speed(1, :, :) = sqrt(sum(v.*v, 1))

    % check if all the speed is less than 0.1 m/s
    if all(speed < 0.1, "all")
        disp("yes!!")
        break
    else
        s_vel_max = s_vel_max - (0.0001);
    end
    IT = IT + 1;
    
end

end
