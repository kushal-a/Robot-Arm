#!/usr/bin/python

import rospy
import numpy as np
from std_msgs.msg import Float32MultiArray
from geometry_msgs.msg import Quaternion
from tf.transformations import quaternion_multiply
from video_writer import VideoWriter


class TrajectoryPub:
    """
    subscribes to pose topic and moves camera_model accordingly
    """

    def __init__(self, trajectory='line', append='', write=True):
        rospy.init_node('trajectory_publisher')

        self.pub = rospy.Publisher('pose', Float32MultiArray, queue_size=60)
        self.rate = rospy.Rate(60)
        # self.filename = trajectory
        if write:
            self.my_writer = VideoWriter(trajectory+append, rostopic='/jlr/camera/image_raw')
            self.my_writer1 = VideoWriter(trajectory+'1'+append, rostopic='/jlr/camera1/image_raw')
        if trajectory == 'line':
            self.line_pub()
        elif trajectory == 'parallel_line':
            self.parallel_line_pub()
        elif trajectory == 'circle':
            self.circle_pub()
        elif trajectory == 'vert_circle':
            self.vert_circle_pub()
        elif trajectory == 'spline':
            self.spline()
        elif trajectory == 'sinus':
            self.sinus()
        # rospy.sleep(5)
        # self.my_writer.release()
        # self.my_writer1.release()

    def parallel_line_pub(self):
        X = np.linspace(1, -1, 600)
        msg = Float32MultiArray()
        for x in X:
            msg.data = [x, 1, 0, 1, 0, 0]
            self.pub.publish(msg)
            self.rate.sleep()

    def line_pub(self):
        X = np.linspace(3, 0.1, 600)
        msg = Float32MultiArray()
        for x in X:
            msg.data = [0, x, 0, 1, 0, 0, x/5]
            self.pub.publish(msg)
            self.rate.sleep()

    def circle_pub(self):
        T = np.linspace(np.pi, 0, 600)
        msg = Float32MultiArray()
        for t in T:
            msg.data = [np.cos(t), np.sin(t), 0, np.sin(t), -np.cos(t), 0, 0.1]
            self.pub.publish(msg)
            self.rate.sleep()

    def vert_circle_pub(self):
        T = np.linspace(np.pi/2, -np.pi/2, 600)
        msg = Float32MultiArray()
        for t in T:
            msg.data = [0, np.cos(t), np.sin(t), np.cos(t), 0, -np.sin(t), t/10]
            self.pub.publish(msg)
            self.rate.sleep()

    def sinus(self):
        T = np.linspace(0,8*np.pi, 2400)
        msg = Float32MultiArray()
        for t in T:
            msg.data = [(t**2)*np.sin(t)/(40*np.exp(t/3)), (t)*(np.sin(t)**2)/(40) + 0.2, np.cos(t)/7, np.cos(3*t)]
            self.pub.publish(msg)
            self.rate.sleep()

    def spline(self):
        X = np.linspace(1, 0.1, 600)
        msg = Float32MultiArray()
        for x in X:
            msg.data = [x**3 - 1.5*x**2, 3*x, 0.5*x**3-x, 1, 0, 0, x*(x-2)/4]
            self.pub.publish(msg)
            self.rate.sleep()



if __name__ == "__main__":
    common = 'yellow'
    my_pub = TrajectoryPub(append=common, write=True)
    # my_circle_pub = TrajectoryPub(trajectory='circle', append=common)
    # my_vert_circle_pub = TrajectoryPub(trajectory='vert_circle', append=common+'shift')
    # my_parallel_pub = TrajectoryPub(trajectory='parallel_line', append=common)
    # my_spline_pub = TrajectoryPub(trajectory='spline', append=common, write=True)
    # my_sinus_pub = TrajectoryPub(trajectory='sinus', append=common, write=True)
    rospy.sleep(5)

