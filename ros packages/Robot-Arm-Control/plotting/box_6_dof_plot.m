function []=box_6_dof_plot(q)
    load 'robot_description.mat' n_links b_dim f_c
    [~,A]=fk_for_ik(q,zeros(4,4));
    Link_Frame=eye(4);
    collision_boxes{n_links}=[];
    for i=1:n_links
        collision_boxes{i}=collisionBox(b_dim(1,i),b_dim(2,i),b_dim(3,i));
        Link_Frame=Link_Frame*A(:,:,i);
        collision_boxes{i}.Pose=Link_Frame*[eye(3),f_c(:,i);0 0 0 1]; 
    end
    
    for i=1:n_links
        hold on
        show(collision_boxes{i})
    end     
end