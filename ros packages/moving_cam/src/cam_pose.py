#!/usr/bin/python

import math
import rospy
import numpy as np
from gazebo_msgs.msg import ModelState
from gazebo_msgs.srv import SetModelState
from std_msgs.msg import Float32MultiArray
from geometry_msgs.msg import Quaternion
from tf.transformations import quaternion_multiply


class CamPose:
    """
    subscribes to pose topic and moves camera_model accordingly
    """

    def __init__(self, model_name='camera_model'):
        self.model_name = model_name
        rospy.init_node("camera_pose_publisher")
        # GAZEBO SERVICE
        rospy.wait_for_service('/gazebo/set_model_state')
        try:
            self.set_state = rospy.ServiceProxy(
                '/gazebo/set_model_state', SetModelState)
        except rospy.ServiceException:
            print('Service call failed')

        rospy.Subscriber('pose', Float32MultiArray, self.callback)
        rospy.spin()

    def callback(self, pose):
        pose = list(pose.data)
        if len(pose) == 3 or len(pose) == 4:
            x, y, z = pose[:3]
            pose = [x, y, z, y, -x, -z] + pose[3:]
        pose = np.array(pose)
        print(pose[:3])
        state_msg = ModelState()
        state_msg.model_name = self.model_name
        q = q_from_vector3D(pose[3:6])
        q = uncast_quaternion(q)
        if len(pose) == 7:
            q_0 = pose[3:6]*np.sin(pose[6]/2)
            q_0 = (*q_0, np.cos(pose[6]/2))
            print(q_0)
            q = quaternion_multiply(q, q_0)
        q = quaternion_multiply((0, 0, 0.717, -0.717), q)
        q = recast_quaternion(q)
        print(q)
        shift = [2.6569, -5.139, 4.2088]
        state_msg.pose.position.x = pose[0]+shift[0]
        state_msg.pose.position.y = pose[1]+shift[1]
        state_msg.pose.position.z = pose[2]+shift[2]
        state_msg.pose.orientation = q
        state_msg.reference_frame = 'car_with_charger_urdf'
        resp = self.set_state(state_msg)
        rospy.loginfo(resp)
        print(resp)

def recast_quaternion(quaternion):
    if quaternion is None:
        q = Quaternion(0, 0, 0, 1)
    elif (
        isinstance(quaternion, list)
        or isinstance(quaternion, tuple)
        or isinstance(quaternion, np.ndarray)
    ):
        q = Quaternion(*quaternion)
    elif isinstance(quaternion, Quaternion):
        q = quaternion
    else:
        print("Quaternion in incorrect format: ", type(quaternion))
        q = Quaternion(0, 0, 0, 1)
    return q

def uncast_quaternion(quaternion):
    if quaternion is None:
        q = (0, 0, 0, 1)
    elif (
        isinstance(quaternion, list)
        or isinstance(quaternion, tuple)
        or isinstance(quaternion, np.ndarray)
    ):
        q = tuple(quaternion)
    elif isinstance(quaternion, Quaternion):
        q = quaternion
        q = (q.x, q.y, q.z, q.w)  # lazy+readable code
    else:
        print("Quaternion in incorrect format: ", type(quaternion))
        q = (0, 0, 0, 1)
    return q

def q_from_vector3D(point):
    # http://lolengine.net/blog/2013/09/18/beautiful-maths-quaternion-from-vectors
    q = Quaternion()
    # calculating the half-way vector.
    u = [1, 0, 0]
    norm = np.linalg.norm(point)
    v = np.asarray(point) / norm
    if np.all(u == v):
        q.w = 1
        q.x = 0
        q.y = 0
        q.z = 0
    elif np.all(u == -v):
        q.w = 0
        q.x = 0
        q.y = 0
        q.z = 1
    else:
        half = [u[0] + v[0], u[1] + v[1], u[2] + v[2]]
        q.w = np.dot(u, half)
        temp = np.cross(u, half)
        q.x = temp[0]
        q.y = temp[1]
        q.z = temp[2]
    norm = math.sqrt(q.x * q.x + q.y * q.y + q.z * q.z + q.w * q.w)
    if norm == 0:
        norm = 1
    q.x /= norm
    q.y /= norm
    q.z /= norm
    q.w /= norm
    return q

if __name__ == "__main__":
    my_cam_pose = CamPose()
