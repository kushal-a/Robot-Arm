function [reachable_poses,count] = workspace(joint_limits)
<<<<<<< HEAD
    delta_theta=0.08;
=======
    delta_theta=0.1;
>>>>>>> 888f8852fbe2a5f6a71bbe3ec2d098280621ac13
    load('robot_description.mat')
    q2_=joint_limits(2,1):delta_theta:joint_limits(2,2);
    q3_=joint_limits(3,1):delta_theta:joint_limits(3,2);
    q4_=joint_limits(4,1):delta_theta:joint_limits(4,2);
    q5_=joint_limits(5,1):delta_theta:joint_limits(5,2);
    reachable_poses=zeros(6,size(q2_,2)*size(q3_,2)*size(q4_,2)*size(q5_,2));
    count=1;
    collision_boxes{n_links}=[];
    A=zeros(4,4,6);
    dh=DH(zeros(6,1));
    A(:,:,1)=transDH(dh(1,:));
    collision_boxes{1}=collisionBox(b_dim(1,1),b_dim(2,1),b_dim(3,1));
    collision_boxes{1}.Pose=A(:,:,1)*[eye(3),f_c(:,1);0 0 0 1];
    for q2=q2_
        tic
        dh=DH([0;q2;0;0;0;0]);
        A(:,:,2)=transDH(dh(2,:));
        Link_Frame=A(:,:,1)*A(:,:,2);
        collision_boxes{2}=collisionBox(b_dim(1,2),b_dim(2,2),b_dim(3,2));
        collision_boxes{2}.Pose=Link_Frame*[eye(3),f_c(:,2);0 0 0 1];
        if~(checkCollision(collision_boxes{1},collision_boxes{2}))
            for q3=q3_
                dh=DH([0;0;q3;0;0;0]);
                A(:,:,3)=transDH(dh(3,:));
                Link_Frame=A(:,:,1)*A(:,:,2)*A(:,:,3);
                collision_boxes{3}=collisionBox(b_dim(1,3),b_dim(2,3),b_dim(3,3));
                collision_boxes{3}.Pose=Link_Frame*[eye(3),f_c(:,3);0 0 0 1];
                if~(checkCollision(collision_boxes{1},collision_boxes{3}) || checkCollision(collision_boxes{2},collision_boxes{3}))
                    for q4=q4_   
                        dh=DH([0;0;0;q4;0;0]);
                        A(:,:,4)=transDH(dh(4,:));
                        Link_Frame=A(:,:,1)*A(:,:,2)*A(:,:,3)*A(:,:,4);
                        collision_boxes{4}=collisionBox(b_dim(1,4),b_dim(2,4),b_dim(3,4));
                        collision_boxes{4}.Pose=Link_Frame*[eye(3),f_c(:,4);0 0 0 1];
                        if~(checkCollision(collision_boxes{1},collision_boxes{4}) || checkCollision(collision_boxes{2},collision_boxes{4}) || checkCollision(collision_boxes{3},collision_boxes{4}))         
                            for q5=q5_
                                dh=DH([0;0;0;0;q5;0]);
                                A(:,:,5)=transDH(dh(5,:));
                                Link_Frame=A(:,:,1)*A(:,:,2)*A(:,:,3)*A(:,:,4)*A(:,:,5);
                                collision_boxes{5}=collisionBox(b_dim(1,5),b_dim(2,5),b_dim(3,5));
                                collision_boxes{5}.Pose=Link_Frame*[eye(3),f_c(:,5);0 0 0 1];
                                if~(checkCollision(collision_boxes{1},collision_boxes{5}) || checkCollision(collision_boxes{2},collision_boxes{5}) || checkCollision(collision_boxes{3},collision_boxes{5})|| checkCollision(collision_boxes{4},collision_boxes{5}))
                                    dh=DH([0;0;0;0;0;0]);
                                    A(:,:,6)=transDH(dh(6,:));
                                    Link_Frame=A(:,:,1)*A(:,:,2)*A(:,:,3)*A(:,:,4)*A(:,:,5)*A(:,:,6);
                                    collision_boxes{6}=collisionBox(b_dim(1,6),b_dim(2,6),b_dim(3,6));
                                    collision_boxes{6}.Pose=Link_Frame*[eye(3),f_c(:,6);0 0 0 1];                                    
                                    if~(checkCollision(collision_boxes{1},collision_boxes{6}) || checkCollision(collision_boxes{2},collision_boxes{6}) || checkCollision(collision_boxes{3},collision_boxes{6})|| checkCollision(collision_boxes{4},collision_boxes{6})||checkCollision(collision_boxes{5},collision_boxes{6}))
                                        reachable_poses(:,count)=[Link_Frame(1:3,4);Link_Frame(1:3,3)];
                                        count=count+1;
                                    end
                                end
                            end 
                        end              
                    end
                end
            end
        end
        toc
    end
end