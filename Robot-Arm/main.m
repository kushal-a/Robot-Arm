clear
close all
clc
%%
n_links=6;
q = [0;0;0;0;0;0];
q_dot = [0;0;0;0;0;0];
q_dotdot = zeros(n_links,1);


l11 = 648.9/1000; l12 = 217.95/1000; 
l21 = 82/1000; l22 = 365.5/1000; 
l3 = 81.25/1000;  
l4 = 309/1000;
l5 = 42.25/1000;
l61 = 99/1000; l62 = 14.35/1000;

% theta d a alpha revolute; If it is revolute then 1, else prismatic 0
DH = @(q)[  pi/2        l11+q(1)    l12     0       0;
            -pi/2+q(2)  -l21        l22     0       1;
            pi/2+q(3)   -l3         0       -pi/2   1;
            q(4)        l4          0       pi/2    1;
            q(5)        0           0       -pi/2    1;
            -pi/2+q(6)  l5+l61      l62     0       1   ]; % DH Parameters

% read mass and inertia from xlsx and store it in a mat file
inertia = readmatrix('inertia.csv');

save('robot_description.mat','inertia','DH','l11','l12','l21','l22','l3','l4','l5','l61','l62')

torque6dof(q,q_dot,q_dotdot);

joint_limits=zeros(6,2); %column 1 contains lower limit and column 2 contains upper limit
joint_limits(1,:)=[0.0,0.6];
joint_limits(2,:)=[0,pi];
joint_limits(3,:)=[0,2*pi];
joint_limits(4,:)=[0,2*pi];
joint_limits(5,:)=[-1.8326,1.8326];
joint_limits(6,:)=[0,2*pi];       
task_space=[-0.5 0.5;0.15 0.55;0.5 1.2];  %define task space in every row column1 is lower and column2 is hihger limit

%% collision boxes description
f_c=zeros(3,n_links); %stores the framei to collision box distance vector in framei 
b_dim=zeros(3,n_links); %dimensions of the bounding box [lx;ly;lz] in framei
%link1
f_c(:,1)=[-218;-720*0.5+90;100]/1000;
b_dim(:,1)=[200;720;1200]/1000;

%link2
f_c(:,2)=[-399.5*0.5+17.25;0;0]/1000;
b_dim(:,2)=[399.5;52;52]/1000;

%link3
f_c(:,3)=[0;-59.5*0.5+17.25;0]/1000;
b_dim(:,3)=[49;59.5;42]/1000;

%link4
f_c(:,4)=[0;-249*0.5-35;0]/1000;
b_dim(:,4)=[50;249;50]/1000;

%link5
f_c(:,5)=[0;0;59.5*0.5-17.25]/1000;
b_dim(:,5)=[49;42;59.5]/1000;

%link6
f_c(:,6)=[-23.35;0;-97*0.5]/1000;
b_dim(:,6)=[109;84;97]/1000;

save('robot_description.mat','n_links','f_c','b_dim','-append')

%% visualize initial collision boxes
[T,A]=fk_for_ik(zeros(6,1),zeros(4,4));
Link_Frame=eye(4);
collision_boxes{n_links}=[];
for i=1:n_links
    collision_boxes{i}=collisionBox(b_dim(1,i),b_dim(2,i),b_dim(3,i));
    Link_Frame=Link_Frame*A(:,:,i);
    collision_boxes{i}.Pose=Link_Frame*[eye(3),f_c(:,i);0 0 0 1]; 
end
for j=1:n_links        
    show(collision_boxes{j})
    hold on
end
hold off
pause(0.1)