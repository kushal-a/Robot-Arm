#!/usr/bin/python

import cv2
import rospy
from sensor_msgs.msg import Image  # Image is the message type
from cv_bridge import CvBridge  # Package to convert between ROS and OpenCV Images

class VideoWriter:
    def __init__(self, name='vid', rostopic='/camera/image_raw', vid_type='avi'):

        self.br = CvBridge()
        if vid_type == 'mp4':
            self._name = name + '.mp4'
            self._fourcc = cv2.VideoWriter_fourcc(*'MP4V')
        else:
            self._name = name + '0.avi'
            self._fourcc = cv2.VideoWriter_fourcc(*'MJPG')
        self.writer = cv2.VideoWriter(self._name, self._fourcc, 30.0, (800, 800))

        rospy.Subscriber(rostopic, Image, self.callback)

    def callback(self, ros_img):
        frame = self.br.imgmsg_to_cv2(ros_img, desired_encoding='bgr8')
        self.writer.write(frame)

    def release(self):
        self.writer.release()

    def __del__(self):
        self.writer.release()

if __name__ == "__main__":
    rospy.init_node('video_writer', anonymous=True)
    my_writer = VideoWriter()
