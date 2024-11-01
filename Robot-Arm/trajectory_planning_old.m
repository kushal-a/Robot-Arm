function [waypoints_final]=trajectory_planning(qi,qf)
    initial_q = qi;
    final_q = qf;
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
        q2d_=[1];
    end
    if(abs(initial_q(3)-final_q(3))<eps)
        q3d_=[1];
    end
    if(abs(initial_q(4)-final_q(4))<eps)
        q4d_=[1];
    end
    if(abs(initial_q(5)-final_q(5))<eps)
        q5d_=[1];
    end
    if(abs(initial_q(6)-final_q(6))<eps)
        q6d_=[1];
    end

    % setting up final_q for any given desired q and direction
    final_q=[final_q,final_q];
    for i=2:6
        if(final_q(i,1)<initial_q(i))
            final_q(i,1)=final_q(i,1)+2*pi;
        else
            final_q(i,2)=final_q(i,2)-2*pi;
        end
    end

    sampling_resolution = 100; %change the way you set sampling resolution
    waypoints_final=zeros(6,0); %store the final trajec in this, keep appending the waypoints to this
    waypoints_to_check=zeros(6,0);
    for q2d=q2d_
        for q3d=q3d_
            for q4d=q4d_
                for q5d=q5d_
                    for q6d=q6d_
                        s = linspace(0, 1, sampling_resolution);
                        waypoints_q1 = (final_q(1,1)-initial_q(1)) * s + initial_q(1);
                        waypoints_q2 = (final_q(2,q2d)-initial_q(2)) * s + initial_q(2);
                        waypoints_q3 = (final_q(3,q3d)-initial_q(3)) * s + initial_q(3);
                        waypoints_q4 = (final_q(4,q4d)-initial_q(4)) * s + initial_q(4);
                        waypoints_q5 = (final_q(5,q5d)-initial_q(5)) * s + initial_q(5);
                        waypoints_q6 = (final_q(6,q6d)-initial_q(6)) * s + initial_q(6);
                        waypoints_to_check=[waypoints_q1;waypoints_q2;waypoints_q3;waypoints_q4;waypoints_q5;waypoints_q6];

                        %check for collision free
                        collision=0;
                        for t=1:size(waypoints_to_check,2)
                            config = waypoints_to_check(:, t);
                            collision=self_collision_check(config);
                            if(collision)
                                break;
                            end
                        end                    
                        if(~collision)
                            %energy check
                            waypoints_final=waypoints_to_check; %change after energy code put in here
                        end
                    end
                end
            end
        end
    end
    %plannig end
    if(size(waypoints_final,2)==0)
        error('path coud not be found')
    end
end