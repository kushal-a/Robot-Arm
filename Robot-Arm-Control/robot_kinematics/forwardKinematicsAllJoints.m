function T = forwardKinematicsAllJoints(q)
    % This function takes in input as the joint angles and gives a (4,4,6)
    % array of joint transformations from frame zero to frame i (i=1:6)
    load robot_description.mat DH;
    dh = DH(q);

    A = zeros(4,4,6);
    T = zeros(4,4,6)+eye(4);
    for i=1:6
        A(:,:,i) = transDH(dh(i,:)); % A represent tranformation from link i-1 to link i
        for j=1:i
            T(:,:,i) = T(:,:,i)*A(:,:,j);
        end
    end
end