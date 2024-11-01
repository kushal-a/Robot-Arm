% main_node 
clear
close all
clc

% initializing ROS and variables
rosshutdown
rosinit

% load the configuration variables by running the main file
run('main.m')

%% Subscribers
% Subscribe to topic to get qi and make a callback which stores this as global variable
initial_q = rossubscriber("topic_name","std_msgs/Float32MultiArray",@store_initial_q,"DataFormat","struct");
% Subscriber to get Td and store as a global variable