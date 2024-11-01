function [reachable_poses,count] = workspace(joint_limits)
    delta_theta=0.2;
	q2_=joint_limits(2,1):delta_theta:joint_limits(2,2);
    q3_=joint_limits(2,1):delta_theta:joint_limits(2,2);
    q4_=joint_limits(2,1):delta_theta:joint_limits(2,2);
    q5_=joint_limits(2,1):delta_theta:joint_limits(2,2);
    reachable_poses=zeros(6,size(q2_,2)*size(q3_,2)*size(q4_,2)*size(q5_,2));
    count=1;
    for q2=q2_
        for q3=q3_
            for q4=q4_            
                for q5=q5_
                    [T,A]=fk_for_ik([0;q2;q3;q4;q5;0],zeros(4,4));
                    if~(self_collision_check_(A))                        
                        count=count+1;
                        reachable_poses(:,count)=[T(1:3,end);T(1:3,3)];
                    end
                end               
            end
        end
    end
end