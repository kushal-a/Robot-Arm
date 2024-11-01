% possible_directions_final_q ~ size: 6 X 32
function [possible_directions_final_q] = generate_q_final_directions(initial_q, final_q)

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
possible_directions_final_q = zeros(6, no_of_possible_paths);

count = 0;
for q2d=q2d_
    for q3d=q3d_
        for q4d=q4d_
            for q5d=q5d_
                for q6d=q6d_
                    count = count + 1;
                    possible_directions_final_q(:, count) = [final_q(1,1);
                                                             final_q(2,q2d);
                                                             final_q(3,q3d);
                                                             final_q(4,q4d);
                                                             final_q(5,q5d);
                                                             final_q(6,q6d)];
                end
            end
        end
    end
end

end