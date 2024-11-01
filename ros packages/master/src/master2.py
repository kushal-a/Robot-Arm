#!/usr/bin/env python3

from std_msgs.msg import Float32MultiArray, Bool
import rospy
import numpu as np
from utils import forwardKinematicsAllJoints
from sensor_msgs.msg import JointState


#s0: resting
#s1: just turn the eef towards the car [ joint 5 pi/2]
#s2: scanning, detecting port, and stopping [joint1: .7m up]

def master():
	def __init__(self):
		self.all_task_list = ["s0", "s1"]
		self.charging_trigger = False

		self.current_task = None

		self.currentbygazebo_eef_pose = None # 4X4 transformation matrix
		self.goalbycv_eef_pose = None # 4X4 transformation matrix #cv goals

		self.home_pose = [0, 0, 0, 0, 0, 0] # 4X4 Transformation matrix #inital pose
		self.turn_pose = [0, 0, 0, 0, np.pi/2, 0] # 4X4 Transformation
		self.scan_upper_limit_pose = None # 

		self.port_detected = False

		current_joint_state_topic = "/jlr23/joint_states"
		planning_T_final_topic = "/planning/T_final"

		self.joints_state_sub= rospy.Subscriber(current_joint_state_topic, JointState, self.current_joint_state_callback)
		self.planning_T_final_pub = rospy.Publisher(planning_T_final_topic, Float32MultiArray, queue_size=1)
		self.planning_T_final_pub_bool = False

		def current_joint_state_callback(self, msg):
			q = msg.Position
			self.currentbygazebo_eef_pose = forwardKinematicsAllJoints(q)

		def matrix_equivalency_comparision(mat1, mat2):
			return False


		def run(self):
			i = 0

			while(i < len(self.all_state_list)):
				self.current_task == self.all_state_list[i]

				if (self.current_task == "s0"):
					self.charging_trigger = True
					i = i + 1

				elif (self.current_task == "s1"):
					self.planning_goal = forwardKinematicsAllJoints(self.turn_pose)
					
					if(self.planning_T_final_pub_bool):
						msg = Float32MultiArray()
						msg.layout.dim[0].label = "height"
						msg.layout.dim[0].size = 4
						msg.layout.dim[0].stride = 4*4
						msg.layout.dim[1].label = "width"
						msg.layout.dim[1].size = 4
						msg.layout.dim[1].stride = 4
						msg.data = self.planning_goal
						self.planning_T_final_pub.publish(msg)

					if matrix_equivalency_comparision(currentbygazebo_eef_pose, self.planning_goal):
						i = i + 1
						break;


if __name__ == '__main__':
    try:
        rospy.init_node('master_node')
        master_instance = master()
        master_instance.run()
    except rospy.ROSInterruptException:
        print("program interrupted before completion", file=sys.stderr)







