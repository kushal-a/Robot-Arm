function q = allInverseKinematics(Td)
    % Specific to this particular configuration of robot
    % Returns 4 solutions 6x1 matrix
    load robot_description.mat DH l11 l21 l22 l3 l4 l5 l61 l62
    dh = DH(zeros(6,1));
    function q_t = signs(s1,s2) % s1 is sign 1 or -1, s2 is also sign 1 or -1
        T66_ = [eye(3) [-l62;0;0]; 0 0 0 1];
        T06_ = Td*T66_;
        Q0 = T06_(1:3,4) - (l61+l5)*T06_(1:3,3);
        q_t(1) = Q0(3,1)-l11+l3+l21;
        X1 = transDH(dh(1,1:4)); % for calculating q2 and q3
        X1 = X1(1:3,4);
        Q1 = Q0 - X1;
        D = (-Q1(1)^2-Q1(2)^2+l22^2+l4^2)/(2*l22*l4);

        if(abs(D)>1+1e-2)
            disp(D)
            error('solution does not exist')        
        elseif(abs(D)>1)
            D=0.9999999*sign(D);
        end
        q_t(3) = atan2(s1*((1-D^2)^0.5),D);
        q_t(2) = atan2(Q1(2),Q1(1)) - atan2(-l4*sin(q_t(3)),l22-l4*cos(q_t(3)));

        % if sin(q(5))!=0;
        dh = DH([q_t(1);q_t(2);q_t(3);0;0;0]);
        T36 = Tinv(transDH(dh(1,1:4))*transDH(dh(2,1:4))*transDH(dh(3,1:4)))*Td;
        if(abs(T36(3,3)-1)>1e-5)
            q_t(5) = atan2(s2*(T36(1,3)^2+T36(2,3)^2)^0.5,T36(3,3));
            q_t(6) = atan2(T36(3,1)/sin(q_t(5)),T36(3,2)/sin(q_t(5)));
            q_t(4) = atan2(-T36(2,3)/sin(q_t(5)),-T36(1,3)/sin(q_t(5)));
        else
            q_t(5) = 0; % or pi but current configuration cannot go pi
            q_t(4) = 0; % set this to be zero
            
            q_t(6) = atan2( Td(2,1)*cos(q_t(2) + q_t(3)) - Td(1,1)*sin(q_t(2) + q_t(3)), Td(3,1));

        end
        
    end
    q = zeros(6,4);
    q(:,1) = signs(1,1);
    q(:,2) = signs(1,-1);
    q(:,3) = signs(-1,1);
    q(:,4) = signs(-1,-1);
end