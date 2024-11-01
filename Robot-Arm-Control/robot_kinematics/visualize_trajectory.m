function [success]=visualize_trajectory(waypoints)
% timestamp(1,n), waypoints(6,n)
    load('robot_description.mat')
    collision_boxes{n_links}=[];
    for t=1:size(waypoints,2)
        config = waypoints(:, t);
        [T,A]=fk_for_ik(config,zeros(4,4));
        Link_Frame=eye(4);
        for i=1:n_links
            collision_boxes{i}=collisionBox(b_dim(1,i),b_dim(2,i),b_dim(3,i));
            Link_Frame=Link_Frame*A(:,:,i);
            collision_boxes{i}.Pose=Link_Frame*[eye(3),f_c(:,i);0 0 0 1]; 
        end
        for j=1:n_links     
            ylim([-0.1 1.3])
            xlim([-0.8,0.8])
            zlim([0.1 1.2])
            show(collision_boxes{j})
            hold on
        end
        hold off
        pause(0.001)
    end
    success=1;
end
    