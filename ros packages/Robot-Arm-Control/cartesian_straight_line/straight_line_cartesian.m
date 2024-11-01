% Cartesian straight line trajectory energy calculation

% [0.25,pi/2,-pi/2,0,-pi/2,0]
% Td = [0.0000    1.0000         0   -0.3090;
%    -0.0000    0.0000    1.0000    0.7747;
%     1.0000   -0.0000    0.0000    0.7500;
%          0         0         0    1.0000];

% [0,pi/2,0,0,0,0]
% Td = [-0.0000   -1.0000   -0.0000   -0.0000;
%     0.0000    0.0000   -1.0000    0.1832;
%     1.0000   -0.0000    0.0000    0.5000;
%          0         0         0    1.0000;];

% [0,0,pi/4,0,0,0]
% Td = [0.0000    0.7071   -0.7071    0.0471;
%    -0.0000    0.7071    0.7071    0.5863;
%     1.0000   -0.0000    0.0000    0.5000;
%          0         0         0    1.0000];
% [0 pi/4 -pi/4 0 0 0]
% [0 0 -pi/4 0 0 0];
% [0 pi/2 -pi/4 0 0 0]
% [0 pi/2 -pi/3 0 pi/3 0]
%df = 0.3, 0.7417, -2.16, -1.57, -1.57, -1.426
qf = [0.3 0 -pi/4 0 0 0];
Td = forwardKinematicsAllJoints(qf);
Td = Td(:,:,6);
xf = Td(1:3, 4);

% qi 0 0 -pi/4 0 0 0
qi = zeros(6, 1);
Ti = forwardKinematicsAllJoints(qi);
Ti = Ti(:,:,end);
xi = Ti(1:3, 4);

% rotm2axang 
pf = Td(1:3,4);
Tif = Tinv(Ti)*Td;
Rif = Tif(1:3,1:3);

%% Generate discrete points (transformation matrices (4,4,n))
% Find out along which axis our initial frame has rotated and by how much
axangif = rotm2axang(Rif); % Axis angle (1,4) with (vector,angle)
vif = axangif(1:3); thetaif = axangif(4);

num_pts = 200;
% For now straight line, both in orientation and space
p = Ti(1:3,4)+(pf-Ti(1:3,4))*(0:1/(num_pts-1):1); % linspace(Ti(1:3,4),pf,num_pts), shape(3,num_pts)
theta = 0 + (thetaif-0)*(0:1/(num_pts-1):1); % linspace(0,thetaif,num_pts)

axang = zeros(num_pts,4);
axang(:,1:3) = axang(:,1:3)+vif;
axang(:,4) = theta';
Rot = axang2rotm(axang);

IKf = allInverseKinematics(Td);
Q = collision_check_IK(IKf); % Collision free 

joint_space_traversed = zeros(6,num_pts-1);
joint_space_traversed(:,1) = qi;

%% Calculate inverse kinematics for each discrete point (6,4,n)
for j=1:num_pts-1
       
    % Make Tdj for for next space
    Rotj = Ti(1:3,1:3)*Rot(:,:,j+1);
    Tdj = [Rotj,p(:,j+1); 0 0 0 1];
    % Calculate IK of first point
    IKj = allInverseKinematics(Tdj);
    % Find closest IK solution
    [argvalue,argmin] = min(vecnorm(IKj-joint_space_traversed(:,j)));
    q_closest = IKj(:,argmin);

    disp(string(j)+' '+ string(argvalue)+' '+argmin)

    if(argmin==1)
        disp(IKj)
        disp(vecnorm(IKj-joint_space_traversed(:,j)))
        disp(joint_space_traversed(:,j))
        disp(Tdj)
    end 
    
    % Check if closest IK solution is collision free
    if(self_collision_check(q_closest))
        error('Straight line path does not exist')
    end
    joint_space_traversed(:,j) = q_closest;
end
% visualize_trajectory(joint_space_traversed);

