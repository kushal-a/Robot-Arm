ask = "Enter the type of input:";
type1 = " 1 for rotation matrix in end effector frame";
type2 = "2 for quaternions in end effector frame";
type3 = "3 for euler angles with sequence";
type4 = "4 for roll,pitch,yaw in end effector frame";
type5 = "5 for screw axis and angle in end effector frame";

prompt = ask + newline + type1 + type2 + type3 + type4 + type5;
x = input(prompt);