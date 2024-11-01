function T = points_to_trans(w,x,y,z)
    a = x-w;
    b = z-w;
    normal1 = cross(a,b);
    a = y-x;
    b = -a;
    normal2 = cross(a,b);
    normal1 = normal1/norm(normal1);
    normal2 = normal2/norm(normal2);
    normal = (normal1+normal2)/2;
    normal = normal/norm(normal);
    x_hat = (x-w)/norm(x-w);
    position = (w+x+y+z)/4;
    y_hat = cross(normal,x_hat);
    T6_d = [x_hat' y_hat' normal' position';0 0 0 1];
    T06 = forwardKinematicsAllJoints(qi);
    T06 = T06(:,:,6);
    T = T06*T6_d; % multiply T66_ in middle
end

