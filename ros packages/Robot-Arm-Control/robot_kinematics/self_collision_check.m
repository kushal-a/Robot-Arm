function[collision]= self_collision_check(q)
    load('robot_description.mat')
    collision_boxes{n_links}=[];
    [T,A]=fk_for_ik(q,zeros(4,4));
    Link_Frame=eye(4);
    for i=1:n_links
        collision_boxes{i}=collisionBox(b_dim(1,i),b_dim(2,i),b_dim(3,i));
        Link_Frame=Link_Frame*A(:,:,i);
        collision_boxes{i}.Pose=Link_Frame*[eye(3),f_c(:,i);0 0 0 1]; 
    end
    for i=1:(n_links-1)
        for j=(i+1):n_links
            if(checkCollision(collision_boxes{i},collision_boxes{j}))
                collision=1;
                return
            end
        end
    end
    collision=0;
end