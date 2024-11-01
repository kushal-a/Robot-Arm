#!/usr/bin/env python3

import rospy
from numpy import pi
from std_msgs.msg import Float64, Float32MultiArray

class JointCommander:
    def __init__(self):
        rospy.init_node('joint_commander')
        self.joint = []
        self.bias = [0, pi, 0, 0, 0, 0]
        self.flip = [1, 1, -1, 1, 1, -1]
        rospy.Subscriber('/jlr/joint_commands', Float32MultiArray, callback=self.callback)
        for i in range(6):
            self.joint.append(
                rospy.Publisher('/jlr23/joint'+str(i+1)+'_position_controller/command', Float64, queue_size=60))
        rospy.spin()

    def callback(self, msg):
        rospy.loginfo(f'received {msg.data}')
        commands = msg.data
        if len(commands) != 6:
            rospy.loginfo('len not 6')
            return
        for i in range(6):
            command = Float64(self.bias[i] + commands[i]*self.flip[i])
            self.joint[i].publish(command)

if __name__ == "__main__":
    JointCommander()
