#! /usr/bin/env python3

from __future__ import print_function
import rospy

import actionlib

import master.msg
# import architecture.msg

def port_detection_client(charging_port_detect):
    
    client = actionlib.SimpleActionClient('port_detect_action',master.msg.portdetectionAction)
    
    client.wait_for_server()
    
    goal = igvc_self_drive_gazebo.msg.cardetectionGoal(port_goal = charging_port_detect)
    # feedback = igvc_action_server.msg.stopBehaviourAction(flo)
    
    client.send_goal(goal)
    
    client.wait_for_result()
    rospy.loginfo("port_detection_client is running")
    rospy.spin()
    print(client.get_result())
    return client.get_result()
    # return client.get_result().success
    

if __name__ == '__main__':
    try:
        rospy.init_node('stop_line_action_client')
        result = upward_movement_client()
        print("result:", result)
    except rospy.ROSInterruptException:
        print("program interrupted before completion", file=sys.stderr)
