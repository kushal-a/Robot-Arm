function [q, q_dot, q_ddot, time_sequence]=trajectory_planning(initial_q,final_q)
    if(size(final_q,1)~=6)
        error('pass qf as a column vector')
        return
    end

    initial_q(2:6)=mod(initial_q(2:6),2*pi);
    final_q(2:6)=mod(final_q(2:6),2*pi);
    eps=5*10^-3;

    q2d_=[1,2]; % 1 is for ccw direction and 2 for cw
    q3d_=[1,2];
    q4d_=[1,2];
    q5d_=[1,2];
    q6d_=[1,2];

    % if final pose and initial pose is within a limit there is no need to move that joint
    if(abs(initial_q(2)-final_q(2))<eps)
        q2d_=1;
    end
    if(abs(initial_q(3)-final_q(3))<eps)
        q3d_=1;
    end
    if(abs(initial_q(4)-final_q(4))<eps)
        q4d_=1;
    end
    if(abs(initial_q(5)-final_q(5))<eps)
        q5d_=1;
    end
    if(abs(initial_q(6)-final_q(6))<eps)
        q6d_=1;
    end

    % setting up final_q for any given desired q and direction
    final_q=[final_q,final_q];
    if(final_q(2:6,1)<initial_q(2:6))
        final_q(2:6,1)=final_q(2:6,1)+2*pi;
    else
        final_q(2:6,2)=final_q(2:6,2)-2*pi;
    end

    no_of_possible_paths = size(q2d_, 2) * size(q3d_, 2) * size(q4d_,2) * size(q5d_,2) * size(q6d_,2);
    path_lengths = zeros(1, no_of_possible_paths);
    possible_final_q = zeros(6, no_of_possible_paths);
    count = 0;
    tic
    for q2d=q2d_
        for q3d=q3d_
            for q4d=q4d_
                for q5d=q5d_
                    for q6d=q6d_
                        count = count + 1;
                        possible_final_q(:, count) = [final_q(1,1);
                                                    final_q(2,q2d);
                                                    final_q(3,q3d);
                                                    final_q(4,q4d);
                                                    final_q(5,q5d);
                                                    final_q(6,q6d)];
                        q_diff = possible_final_q(:, count) - initial_q;
                        %disp("qdiff:");
                        %disp(q_diff);
                        path_lengths(1, count) = sqrt(sum(q_diff .* q_diff));
                    end
                end
            end
        end
    end
    toc
    [path_lengths,sortIdx] = sort(path_lengths);
    % sort possible_final_q in the order of shortest path lengths
    possible_final_q = possible_final_q(:, sortIdx);

    sampling_ratio = 0.3579;
    waypoints_to_check=zeros(6,0);
    no_of_collision_free_paths = 0;

    for i=1:no_of_possible_paths
        disp("begin evaluating trajectories for collsion")
        sampling_resolution = path_lengths(i) / sampling_ratio;
        s = linspace(0, 1, sampling_resolution);
        waypoints_to_check = (possible_final_q(:, i) - initial_q) * s + initial_q;
        collision=0;
        disp("collision check")
        tic
        for t=1:size(waypoints_to_check,2)
            config = waypoints_to_check(:, t);
            collision=self_collision_check(config);
            if(collision)
                break;
            end
        end
        toc
        if(~collision)
            % do velocity planning
            disp("velocity planning")
            tic
            [q, q_dot, q_ddot, time_sequence] = plan_velocity_trapezoidal_profile(waypoints_to_check);
            toc
            % calculate tau, energy
            %[~, energy] = calculate_trajectory_energy(time_sequence, q, q_dot, q_ddot);
            no_of_collision_free_paths = no_of_collision_free_paths + 1;
            break;
        end
    end

if (no_of_collision_free_paths == 0)
    error('no collision free path found')
end

end