#!/usr/bin/env python

# task: pointcloud exploration
from __future__ import print_function
from __future__ import division

from cv_function import   # add name of the fucntion from cv
from sensor_msgs.msg import Image

class socket_detector():
  def __init__(self):

    camera_topic = '/safesearch/complete'
    rospy.Subscriber(camera_topic, Image, self.pc2ImageCallback, queue_size=1)
    