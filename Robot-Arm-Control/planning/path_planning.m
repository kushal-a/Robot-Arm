function [final_waypoints] = path_planning(initial_q, collision_free_ik_solutions)

num_collision_free_ik_solutions = size(collision_free_ik_solutions, 2);
possible_directions_final_config = zeros(6, 0);

for i = 1:num_collision_free_ik_solutions
%     disp("iterate")
    final_q = collision_free_ik_solutions(:, i);
%     disp(final_q)
    possible_directions_final_config = [possible_directions_final_config, generate_q_final_directions(initial_q, final_q)];   
end


num_possible_paths = size(possible_directions_final_config, 2);
q_diff = possible_directions_final_config - initial_q;
disp(size(q_diff))
path_lengths = sqrt(sum(q_diff .* q_diff));


[path_lengths,sortIdx] = sort(path_lengths);
disp(path_lengths)
% sort possible_final_q in the order of shortest path lengths
possible_final_q = possible_directions_final_config(:, sortIdx);
disp(size(possible_final_q))

sampling_ratio = 0.3579;
waypoints_to_check=zeros(6,0);
no_of_collision_free_paths = 0;

for i=1:num_possible_paths
%     disp("begin evaluating trajectories for collsion")
    sampling_resolution = path_lengths(i) / sampling_ratio;
    s = linspace(0, 1, sampling_resolution);
    waypoints_to_check = (possible_final_q(:, i) - initial_q) * s + initial_q;
    collision=0;
%     disp("collision check")
    for t=1:size(waypoints_to_check,2)
        config = waypoints_to_check(:, t);
        collision=self_collision_check(config);
        if(collision)
            break;
        end
    end
    if(~collision)
        final_waypoints = waypoints_to_check;
        break;
    end
    
end

end
