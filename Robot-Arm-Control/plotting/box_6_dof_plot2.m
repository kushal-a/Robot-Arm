function []=box_6_dof_plot2(q, trans, station)
    load 'robot_description.mat' n_links b_dim f_c
    [~,A]=fk_for_ik(q,zeros(4,4));
    Link_Frame=eye(4);
    collision_boxes{n_links}=[];
    for i=1:n_links
        collision_boxes{i}=collisionBox(b_dim(1,i),b_dim(2,i),b_dim(3,i));
        Link_Frame=Link_Frame*A(:,:,i);
        collision_boxes{i}.Pose=Link_Frame*[eye(3),f_c(:,i);0 0 0 1]; 
    end
    hold on
    colors = ["red", "green", "blue", "yellow", "cyan", "magenta"];
%     faces = [1,2,6,5; 1,2,3,4; 2,3,7,6; 3,4,8,7; 4,1,5,6; 5,6,7,8];
    faces = [1,2,6,5; 1,2,4,3; 2,4,8,6; 4,3,7,8; 3,1,5,7; 5,6,8,7];
    vertices = zeros([n_links,8,3]);
    for j=2:n_links  
        counter = 1;
        
        center_box = collision_boxes{j}.Pose(1:3,4);
        
        for z = [-1,1]
            for x = [-1,1]
                for y = [-1,1]
                    
                    vertices(j,counter,:) =(center_box + ...
                                            collision_boxes{j}.Pose(1:3,1)*collision_boxes{j}.X*x/2 + ...
                                            collision_boxes{j}.Pose(1:3,3)*collision_boxes{j}.Z*z/2 + ...
                                            collision_boxes{j}.Pose(1:3,2)*collision_boxes{j}.Y*y/2)';
                    counter  = counter + 1;
%         show(collision_boxes{j});
                end
            end
        end
        patch('Faces',faces,'Vertices',squeeze(vertices(j,:,:)), 'Facecolor', colors(j), "FaceAlpha", trans)
    end

    if (station == 1)
        counter = 1;
        center_box = collision_boxes{1}.Pose(1:3,4);
        for z = [-1,1]
            for x = [-1,1]
                for y = [-1,1]
                    
                    vertices_station(counter, :) =(center_box + ...
                                            collision_boxes{1}.Pose(1:3,1)*collision_boxes{1}.X*x/2 + ...
                                            collision_boxes{1}.Pose(1:3,3)*collision_boxes{1}.Z*z + ...
                                            collision_boxes{1}.Pose(1:3,2)*collision_boxes{1}.Y*y/2)';
                    counter  = counter + 1;
        %         show(collision_boxes{j});
                end
            end
        end    
        patch('Faces',faces,'Vertices',squeeze(vertices_station), 'Facecolor', colors(1), "FaceAlpha", 1)
    
    end



end