clear
close all
clc
cd ~/catkin_ws/src/Soft_robo_sim/MATLAB/ros_data/
%% initializing ROS and variables
global output_t completeState_t timeStep originalPose force_t sensor_t TimeStepCount
timeStep=0.5;
output_t=[];
force_t=[];
sensor_t=[];
completeState_t=[];
TimeStepCount=0;
rosshutdown
rosinit

% loading the configuration variables
load('../All_config_file_initializer/allShape/MeshVariables_finer.mat')

%subscribers
output_sub=rossubscriber("/actual_system/state","std_msgs/Float32MultiArray",@output_calllback,"DataFormat","struct");
CompleteState_sub=rossubscriber("/actual_system/complete_state","std_msgs/Float32MultiArray",@CompleteState_calllback,"DataFormat","struct");
sensor_sub=rossubscriber("/measured_deflection","std_msgs/Float32MultiArray",@Sensor_calllback,"DataFormat","struct");

%% publishers
force_pub=rospublisher("actual_system/force","std_msgs/Float32MultiArray","DataFormat","struct");
force_msg=rosmessage(force_pub);
force_msg.Data=single(zeros(1,size(ForceNodes,1)));
for i=1:size(ForceNodes,1)
    force_msg.Data(i)=-40;
end
force_msg.Data(1)=-20;
force_msg.Data(end)=-20;

for i=1:30
    send(force_pub,force_msg)
    pause(0.05)
end

%% plotting the complete state
deformation=zeros(size(originalPose));
deformation(:,1)=completeState_t(1:2:end,end);
deformation(:,2)=completeState_t(2:2:end,end);
deformedPose=originalPose+deformation;
%plot
figure
hold on
axis equal
colors=["#0072BD","#D95319","#EDB120","#7E2F8E","#77AC30","#4DBEEE","#A2142F"];
for i=1:size(faces,1)    
    plot(polyshape(deformedPose(faces(i,:),1),deformedPose(faces(i,:),2)),'FaceColor',colors(materialGroup(i,1)),'FaceAlpha',0.2)
end