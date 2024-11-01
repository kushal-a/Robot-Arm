function T = transDH(dh)
    % return a transformation matrix going from frame i-1 to frame i
    % or representing a vector in frame i-1 from frame i
    % input dh is a vector of [theta,d,a,alpha] in radians
    
    T = [   cos(dh(1))  -sin(dh(1))*cos(dh(4))  sin(dh(1))*sin(dh(4))   dh(3)*cos(dh(1));
            sin(dh(1))  cos(dh(1))*cos(dh(4))   -cos(dh(1))*sin(dh(4))  dh(3)*sin(dh(1));
            0           sin(dh(4))              cos(dh(4))              dh(2)           ;
            0           0                       0                       1];
end