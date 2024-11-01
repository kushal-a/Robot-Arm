l11 = 648.9/1000; l12 = 196.12/1000; 
l21 = 82/1000; l22 = 315.5/1000; 
l3 = 81.25/1000;  
l4 = 259/1000;
l5 = 42.25/1000;
l61 = 99/1000; l62 = 14.35/1000;

% theta d a alpha revolute; If it is revolute then 1, else prismatic 0
DH = @(q)[  pi/2        l11+q(1)    l12     0       0;
            -pi/2+q(2)  -l21        l22     0       1;
            pi/2+q(3)   -l3         0       -pi/2   1;
            q(4)        l41         0       pi/2    1;
            q(5)        -l42        0       pi/2    1;
            pi/2+q(6)   l5+l61      l62     0       1   ]; % DH Parameters

% hold on
for q1 = 0:0.1:1
    for q2 = 0:pi/20:pi/2
        for q3 = 0:pi/20:pi/2
            for q4 = 0:pi/20:pi/2
                for q5 = 0:pi/20:pi/2
                    for q6 = 0:pi/20:pi/2
                        FK = forwardKinematicsAllJoints([q1;q2;q3;q4;q5;q6]);
                        plot3([0,FK(1,4,1),FK(1,4,2),FK(1,4,3),FK(1,4,4),FK(1,4,5),FK(1,4,6)], ...
                                [0,FK(2,4,1),FK(2,4,2),FK(2,4,3),FK(2,4,4),FK(2,4,5),FK(2,4,6)], ...
                                [0,FK(3,4,1),FK(3,4,2),FK(3,4,3),FK(3,4,4),FK(3,4,5),FK(3,4,6)])
                        xlim([-1 1]); ylim([-1 1]); zlim([0 1]);
                        title('Robot stick figure')
                        grid on
                        pause(0.001)
                    end
                end
            end
        end
    end
end
