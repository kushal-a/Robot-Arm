function J = Jacobian(q)
    load robot_description.mat l4 l5 l61 l62
    % This is highly specific for our robot
    q1 = q(1); q2 = q(2); q3 = q(3); q4 = q(4); q5 = q(5); q6 = q(6);
    J(1:3,1) = [0;0;1];
    J(1:3,2) = [(l5 + l61)*(cos(q2)*cos(q5)*sin(q3) + cos(q3)*cos(q5)*sin(q2) + cos(q2)*cos(q3)*cos(q4)*sin(q5) - cos(q4)*sin(q2)*sin(q3)*sin(q5)) + l4*sin(q2 + q3) - l22*sin(q2) + l62*sin(q6)*(cos(q2)*sin(q3)*sin(q5) + cos(q3)*sin(q2)*sin(q5) - cos(q2)*cos(q3)*cos(q4)*cos(q5) + cos(q4)*cos(q5)*sin(q2)*sin(q3)) - l62*cos(q2 + q3)*cos(q6)*sin(q4);
                (l5 + l61)*(cos(q5)*sin(q2)*sin(q3) - cos(q2)*cos(q3)*cos(q5) + cos(q2)*cos(q4)*sin(q3)*sin(q5) + cos(q3)*cos(q4)*sin(q2)*sin(q5)) - l4*cos(q2 + q3) + l22*cos(q2) - l62*sin(q6)*(cos(q2)*cos(q3)*sin(q5) - sin(q2)*sin(q3)*sin(q5) + cos(q2)*cos(q4)*cos(q5)*sin(q3) + cos(q3)*cos(q4)*cos(q5)*sin(q2)) - l62*sin(q2 + q3)*cos(q6)*sin(q4);
                0];
    J(1:3,3) = [(l5 + l61)*(cos(q2)*cos(q5)*sin(q3) + cos(q3)*cos(q5)*sin(q2) + cos(q2)*cos(q3)*cos(q4)*sin(q5) - cos(q4)*sin(q2)*sin(q3)*sin(q5)) + l4*sin(q2 + q3) + l62*sin(q6)*(cos(q2)*sin(q3)*sin(q5) + cos(q3)*sin(q2)*sin(q5) - cos(q2)*cos(q3)*cos(q4)*cos(q5) + cos(q4)*cos(q5)*sin(q2)*sin(q3)) - l62*cos(q2 + q3)*cos(q6)*sin(q4);
                (l5 + l61)*(cos(q5)*sin(q2)*sin(q3) - cos(q2)*cos(q3)*cos(q5) + cos(q2)*cos(q4)*sin(q3)*sin(q5) + cos(q3)*cos(q4)*sin(q2)*sin(q5)) - l4*cos(q2 + q3) - l62*sin(q6)*(cos(q2)*cos(q3)*sin(q5) - sin(q2)*sin(q3)*sin(q5) + cos(q2)*cos(q4)*cos(q5)*sin(q3) + cos(q3)*cos(q4)*cos(q5)*sin(q2)) - l62*sin(q2 + q3)*cos(q6)*sin(q4);
                0];
    J(1:3,4) = [ - sin(q2 + q3)*(l62*cos(q4)*cos(q6) + l5*sin(q4)*sin(q5) + l61*sin(q4)*sin(q5) - l62*cos(q5)*sin(q4)*sin(q6));
                cos(q2 + q3)*l62*cos(q4)*cos(q6) + l5*sin(q4)*sin(q5) + l61*sin(q4)*sin(q5) - l62*cos(q5)*sin(q4)*sin(q6);
                l5*cos(q4)*sin(q5) + l61*cos(q4)*sin(q5) - l62*cos(q6)*sin(q4) - l62*cos(q4)*cos(q5)*sin(q6)];
    J(1:3,5) = [(l5 + l61)*(cos(q2)*cos(q3)*sin(q5) - sin(q2)*sin(q3)*sin(q5) + cos(q2)*cos(q4)*cos(q5)*sin(q3) + cos(q3)*cos(q4)*cos(q5)*sin(q2)) + l62*sin(q6)*(cos(q5)*sin(q2)*sin(q3) - cos(q2)*cos(q3)*cos(q5) + cos(q2)*cos(q4)*sin(q3)*sin(q5) + cos(q3)*cos(q4)*sin(q2)*sin(q5));
                (l5 + l61)*(cos(q2)*sin(q3)*sin(q5) + cos(q3)*sin(q2)*sin(q5) - cos(q2)*cos(q3)*cos(q4)*cos(q5) + cos(q4)*cos(q5)*sin(q2)*sin(q3)) - l62*sin(q6)*(cos(q2)*cos(q5)*sin(q3) + cos(q3)*cos(q5)*sin(q2) + cos(q2)*cos(q3)*cos(q4)*sin(q5) - cos(q4)*sin(q2)*sin(q3)*sin(q5));
                sin(q4)*(l5*cos(q5) + l61*cos(q5) + l62*sin(q5)*sin(q6))];
    J(1:3,6) = [l62*cos(q2)*sin(q3)*sin(q4)*sin(q6) - l62*cos(q2)*cos(q3)*cos(q6)*sin(q5) + l62*cos(q3)*sin(q2)*sin(q4)*sin(q6) + l62*cos(q6)*sin(q2)*sin(q3)*sin(q5) - l62*cos(q2)*cos(q4)*cos(q5)*cos(q6)*sin(q3) - l62*cos(q3)*cos(q4)*cos(q5)*cos(q6)*sin(q2);
                l62*sin(q2)*sin(q3)*sin(q4)*sin(q6) - l62*cos(q2)*cos(q6)*sin(q3)*sin(q5) - l62*cos(q3)*cos(q6)*sin(q2)*sin(q5) - l62*cos(q2)*cos(q3)*sin(q4)*sin(q6) - l62*cos(q4)*cos(q5)*cos(q6)*sin(q2)*sin(q3) + l62*cos(q2)*cos(q3)*cos(q4)*cos(q5)*cos(q6);
                 - l62*cos(q4)*sin(q6) - l62*cos(q5)*cos(q6)*sin(q4)];
end