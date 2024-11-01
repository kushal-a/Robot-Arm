import cv2
import datetime
import numpy as np
import matplotlib.pyplot as plt
import torch
import torchvision
import math

green_boundary = [np.array([52,218,71]),np.array([66,255,255])]
red_boundary = [np.array([0,60,75]),np.array([55,255,255])]
yellow_boundary = [np.array([10,136,10]),np.array([40,255,255])]
blue_boundary = [np.array([112,221,62]),np.array([128,255,255])]
skyblue_boundary = [np.array([65,76,50]),np.array([95,255,255])]
boundary = [green_boundary,red_boundary,skyblue_boundary,blue_boundary]
# model = torch.hub.load('ultralytics/yolov5', 'custom', path='/Users/akshatkg/Desktop/Inter-IIT/last.pt', force_reload=True)
def coordinates(frame):

  a = datetime.datetime.now()
  # results = model(frame)
  b = datetime.datetime.now()
  delta = b - a
  # temp = np.array(results.xyxy[0][0])
  # image = frame[int(temp[1])-20:int(temp[3])+20,int(temp[0])-20:int(temp[2])+20,:]
  # %matplotlib inline
  # plt.imshow(image)
  # plt.show()
  # img = image.copy()
  img = frame.copy()
  hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
  points = []
  for m in range(len(boundary)):
    mask = cv2.inRange(hsv, boundary[m][0], boundary[m][1])
    si = cv2.bitwise_and(img,img, mask = mask)
    contours, hierarchy = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)
    cmax = np.array([])
    for contour in contours:
      if len(contour)>len(cmax):
        cmax = contour


    M = cv2.moments(cmax)
    if M['m00'] != 0:
      cx = int(M['m10']/M['m00'])
      cy = int(M['m01']/M['m00'])
      # print(type(points))
      points.append([cx,cy])
  points = np.array(points)
  # temp2 = np.array([int(temp[0])-20,int(temp[1])-20])
  # points = points + temp2

  # for n in range(len(points)):
  #   cv2.circle(frame, points[n], 1, (0, 0, 255), -1)
  # plt.imshow(frame)
  # plt.show()
  return points

# coordinates(frame)

count = 0

cap1 = cv2.VideoCapture('/Users/akshatkg/Desktop/Inter-IIT/stereo/line0.avi')
cap2 = cv2.VideoCapture('/Users/akshatkg/Desktop/Inter-IIT/stereo/line10.avi')
error_x = []
error_y = []
error_z = []
actual_x = []
actual_y = []
actual_z = []
obs_x = []
obs_y = []
obs_z = []

ret = True
while ret:
    ret, frame = cap1.read()
    ret, frame2 = cap2.read()

    if frame is None or frame2 is None:
        break
    # cv2.imshow('image', frame)
    count += 1
    if count < 240:
        continue
    height, width = frame.shape[:2]
    points1 = coordinates(frame)
    points2 = coordinates(frame2)

    print('points1: ',points1)
    print('points2: ',points2)
    if len(points1) == 4 and len(points2) == 4:
        # print(count)
        # frame = cv2.line(frame, (400, 0) , (400, 800), (255, 0, 0), 2)
        # frame = cv2.line(frame, (0, 400) , (800, 400), (255, 0, 0), 2)
        center_coordinates3 = (points1[0][0], points1[0][1])
        center_coordinates1 = (points1[1][0], points1[1][1])
        center_coordinates2 = (points1[2][0], points1[2][1])
        center_coordinates4 = (points1[3][0], points1[3][1])

        radius = 5
        img = cv2.circle(frame, center_coordinates3, radius, (255, 255, 255), 2)
        img = cv2.circle(img, center_coordinates1, radius, (255, 255, 255), 2)
        img = cv2.circle(img, center_coordinates2, radius, (255, 255, 255), 2)
        img = cv2.circle(img, center_coordinates4, radius, (255, 255, 255), 2)

        img2 = cv2.circle(frame2, center_coordinates3, radius, (255, 255, 255), 2)
        img2 = cv2.circle(img2, center_coordinates1, radius, (255, 255, 255), 2)
        img2 = cv2.circle(img2, center_coordinates2, radius, (255, 255, 255), 2)
        img2 = cv2.circle(img2, center_coordinates4, radius, (255, 255, 255), 2)


        # cv2.imshow('img', img)
        # cv2.waitKey(0)
        d = 110
        f = 476
		# coordinates in image frame
        u1l = points1[1][0]
        v1l = points1[1][1]
        u2l = points1[2][0]
        v2l = points1[2][1]
        u3l = points1[0][0]
        v3l = points1[0][1]
        u4l = points1[3][0]
        v4l = points1[3][1]

        u1r = points2[1][0]
        v1r = points2[1][1]
        u2r = points2[2][0]
        v2r = points2[2][1]
        u3r = points2[0][0]
        v3r = points2[0][1]
        u4r = points2[3][0]
        v4r = points2[3][1]


        T = 25
        zc1 = T*f/(u1l-u1r)
        zc2 = T*f/(u2l-u2r)
        zc3 = T*f/(u3l-u3r)
        zc4 = T*f/(u4l-u4r)

        xc1l = (u1l-width/2)*zc1/f
        yc1l = (v1l-height/2)*zc1/f

        xc2l = (u2l-width/2)*zc2/f
        yc2l = (v2l-height/2)*zc2/f

        xc3l = (u3l-width/2)*zc3/f
        yc3l = (v3l-height/2)*zc3/f

        xc4l = (u4l-width/2)*zc4/f
        yc4l = (v4l-height/2)*zc4/f

        xc1r = (u1r-width/2)*zc1/f
        yc1r = (v1r-height/2)*zc1/f

        xc2r = (u2r-width/2)*zc2/f
        yc2r = (v2r-height/2)*zc2/f

        xc3r = (u3r-width/2)*zc3/f
        yc3r = (v3r-height/2)*zc3/f

        xc4r = (u4r-width/2)*zc4/f
        yc4r = (v4r-height/2)*zc4/f

        xc1 = (xc1l + xc1r)/2
        xc2 = (xc2l + xc2r)/2
        xc3 = (xc3l + xc3r)/2
        xc4 = (xc4l + xc4r)/2

        yc1 = (yc1l + yc1r)/2
        yc2 = (yc2l + yc2r)/2
        yc3 = (yc3l + yc3r)/2
        yc4 = (yc4l + yc4r)/2






		# camera frame coordinates
        # m = -1*(u2-width/2)*0
		# print(d2/(u1-u4))
		# print(d/(v1-v2))
		#xc1 = (u1-width/2)*d2/(u4-u1)

        # xc2 = (u2-width/2)*d/(v2-v1)
        # zc2 = d*f/(v1-v2)
        # yc2 = (v2 - height/2)*d/(v1-v2)
        # print("xc2: ", xc2)
        # print("yc2: ", yc2)
        # print("zc2: ", zc2)
        # xc1 = xc2
        # yc1 = (v1 - height/2)*d/(v1-v2)
        # zc1 = zc2
        # print("xc1: ", xc1)
        # print("yc1: ", yc1)
        # print("zc1: ", zc1)
		# #xc4 = (u4-width/2)*d2/(u4-u1)
        # xc4 = (u4-width/2)*d/(v3-v4)
        # zc4 = d*f/(v4-v3)
        # yc4 = (v4 - height/2)*d/(v4-v3)
        # print("xc4: ", xc4)
        # print("yc4: ", yc4)
        # print("zc4: ", zc4)
        # xc3 = xc4
        # yc3 = (v3 - height/2)*d/(v4-v3)
        # zc3 = zc4
        # print("xc3: ", xc3)
        # print("yc3: ", yc3)
        # print("zc3: ", zc3)
		# print((xc1+xc2+xc3+xc4)/4, (yc1+yc2+yc3+yc4)/4, (zc1+zc2+zc3+zc4)/4)
        #x_obs = (xc1+xc2+xc3+xc4)/4 + (0.16*(xc1+xc2+xc3+xc4)/4)
        x_obs = (xc1+xc2+xc3+xc4)/4
        y_obs = (yc1+yc2+yc3+yc4)/4
        z_obs = (zc1+zc2+zc3+zc4)/4
        print(x_obs, y_obs, z_obs)

        n1 = [xc4 - xc3, yc4 - yc3, zc4 - zc3]
        n2 = [xc2 - xc3, yc2 - yc3, zc2 - zc3]

        costheta = (n1[0]*n2[0] + n1[1]*n2[1] + n1[2]*n2[2])/(math.sqrt(n1[0]*n1[0] + n1[1]*n1[1] + n1[2]*n1[2])*math.sqrt(n2[0]*n2[0] + n2[1]*n2[1] + n2[2]*n2[2]))
        theta_rad = math.acos(costheta)
        print('theta_rad: ',theta_rad)
        theta_deg = (theta_rad*180)/3.14159

        # nf = [(yc1-yc4)*(zc3-zc4) - (zc1-zc4)*(yc3-yc4), (zc1-zc4)*(xc3-xc4) - (xc1-xc4)*(zc3-zc4), (xc1-xc4)*(yc3-yc4) - (yc1-yc4)*(xc3-xc4)]


        v = 294 # cam speed mm/s
        t = (count-4)/30 # 30 fps video
        print(count)
        # x_act = 1000 - v*t
        # y_act = 0
        # z_act = -1000

        x_act = -11
        y_act = 0
        z_act = -3000 + v*t
        print(x_act, y_act, z_act)
		# absolute errors
        error_x.append(abs(x_obs - x_act))
        error_y.append(abs(y_obs - y_act))
        error_z.append(abs(z_obs-z_act))
        actual_x.append(x_act)
        actual_y.append(y_act)
        actual_z.append(z_act)
        obs_x.append(x_obs)
        obs_y.append(y_obs)
        obs_z.append(z_obs)
        # print(error_x)
        # print(error_y)
        # print(error_z)

        cv2.putText(img=img, text='x_actual: '+str(round(x_act, 2)), org=(15, 25), fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, color=(0, 255, 255),thickness=2)
        cv2.putText(img=img, text='y_actual: '+str(round(y_act, 2)), org=(15, 55), fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, color=(0, 255, 255),thickness=2)
        cv2.putText(img=img, text='z_actual: '+str(round(z_act, 2)), org=(15, 85), fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, color=(0, 255, 255),thickness=2)

        cv2.putText(img=img, text='x_observed: '+str(round(x_obs, 2)), org=(435, 25), fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, color=(0, 255, 255),thickness=2)
        cv2.putText(img=img, text='y_observed: '+str(round(y_obs, 2)), org=(435, 55), fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, color=(0, 255, 255),thickness=2)
        cv2.putText(img=img, text='z_observed: '+str(round(z_obs, 2)), org=(435, 85), fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, color=(0, 255, 255),thickness=2)

        cv2.putText(img=img, text='error_x: '+str(round(abs(x_obs - x_act), 2)), org=(15, 140), fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, color=(0, 255, 255),thickness=2)
        cv2.putText(img=img, text='error_y: '+str(round(abs(y_obs - y_act), 2)), org=(290, 140), fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, color=(0, 255, 255),thickness=2)
        cv2.putText(img=img, text='error_z: '+str(round(abs(z_obs-z_act), 2)), org=(540, 140), fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, color=(0, 255, 255),thickness=2)
        # cv2.imshow('img', img)
        # cv2.waitKey(0)
        filename = 'img'+str(count)+'.jpg'
        cv2.imwrite(filename, img)



# plt.plot(error_x)
# plt.show()
# plt.plot(error_y)
# plt.show()
# plt.plot(error_z)
# plt.show()

# Plotting both the curves simultaneously
plt.plot(actual_x, color='r', label='actual')
plt.plot(obs_x, color='g', label='observed')

# Naming the x-axis, y-axis and the whole graph
plt.xlabel("Frames")
plt.ylabel("X (mm)")
plt.title("X-coordinates in camera frame")
# Adding legend, which helps us recognize the curve according to it's color
plt.legend()
plt.show()

plt.plot(actual_y, color='r', label='actual')
plt.plot(obs_y, color='g', label='observed')

# Naming the x-axis, y-axis and the whole graph
plt.xlabel("Frames")
plt.ylabel("Y (mm)")
plt.title("Y-coordinates in camera frame")
# Adding legend, which helps us recognize the curve according to it's color
plt.legend()
plt.show()

plt.plot(actual_z, color='r', label='actual')
plt.plot(obs_z, color='g', label='observed')

# Naming the x-axis, y-axis and the whole graph
plt.xlabel("Frames")
plt.ylabel("Z (mm)")
plt.title("Z-coordinates in camera frame")
# Adding legend, which helps us recognize the curve according to it's color
plt.legend()
plt.show()
# plt.plot(error_x)
# plt.show()
# plt.plot(error_y)
# plt.show()
# plt.plot(error_z)
# plt.show()
    # imgname = os.path.join(IMAGES_PATH,str(count)+'.jpg')
    # cv2.imwrite(imgname, frame)
# assumptions - camera distortion is neglected, normal vectors of camera and charging plane are parallel to x-z plane

# function to display the coordinates of
# of the points clicked on the image
# def click_event(event, x, y, flags, params):
#
# 	# checking for left mouse clicks
# 	if event == cv2.EVENT_LBUTTONDOWN:
#
# 		# displaying the coordinates
# 		# on the Shell
# 		print(x, ' ', y)
#
# 		# displaying the coordinates
# 		# on the image window
# 		font = cv2.FONT_HERSHEY_SIMPLEX
# 		cv2.putText(img, str(x) + ',' +
# 					str(y), (x,y), font,
# 					1, (255, 0, 0), 2)
# 		cv2.imshow('image', img)
#
# 	# checking for right mouse clicks
# 	if event==cv2.EVENT_RBUTTONDOWN:
#
# 		# displaying the coordinates
# 		# on the Shell
# 		print(x, ' ', y)
#
# 		# displaying the coordinates
# 		# on the image window
# 		font = cv2.FONT_HERSHEY_SIMPLEX
# 		b = img[y, x, 0]
# 		g = img[y, x, 1]
# 		r = img[y, x, 2]
# 		cv2.putText(img, str(b) + ',' +
# 					str(g) + ',' + str(r),
# 					(x,y), font, 1,
# 					(255, 255, 0), 2)
#
# 		cv2.imshow('image', img)

# driver function
# if __name__=="__main__":

	# reading the image
	# img = cv2.imread('left3.png', 1)

	# height, width = img.shape[:2]
	# img = cv2.line(img, (960, 0) , (960, 1080), (255, 0, 0), 2)
	# img = cv2.line(img, (0, 540) , (1920, 540), (255, 0, 0), 2)
	# img = cv2.line(img, (0, 370) , (800, 370), (255, 0, 0), 2)
	# img = cv2.line(img, (0, 429) , (800, 429), (255, 0, 0), 2)
	# img = cv2.line(img, (686, 0) , (686, 800), (255, 0, 0), 2)
	# img = cv2.line(img, (725, 0) , (725, 800), (255, 0, 0), 2)
	# print("height: ", height)
	# print("width: ", width)
	# print(height/2, width/2)

	# displaying the image
	# cv2.imshow('image', img)

	# setting mouse handler for the image
	# and calling the click_event() function
	# cv2.setMouseCallback('image', click_event)
	# d = 110
	# d2 = 70 # distance in real life
	# #f = 536 # focal length of camera
	# f = 1377 # focal length of camera
	# # coordinates in image frame
	# u1 = 914
	# v1 = 772
	# u2 = 915
	# v2 = 941
	# u3 = 1024
	# v3 = 948
	# u4 = 1029
	# v4 = 770
	#
	# # camera frame coordinates
	#
	# print(d2/(u1-u4))
	# print(d/(v1-v2))
	# #xc1 = (u1-width/2)*d2/(u4-u1)
	# xc1 = (u1-width/2)*d/(v2-v1)
	# zc1 = d*f/(v1-v2)
	# yc1 = (v1 - height/2)*d/(v1-v2)
	# print("xc1: ", xc1)
	# print("yc1: ", yc1)
	# print("zc1: ", zc1)
	# xc2 = xc1
	# yc2 = (v2 - height/2)*d/(v1-v2)
	# zc2 = zc1
	# print("xc2: ", xc2)
	# print("yc2: ", yc2)
	# print("zc2: ", zc2)
	# #xc4 = (u4-width/2)*d2/(u4-u1)
	# xc4 = (u4-width/2)*d/(v3-v4)
	# zc4 = d*f/(v4-v3)
	# yc4 = (v4 - height/2)*d/(v4-v3)
	# print("xc4: ", xc4)
	# print("yc4: ", yc4)
	# print("zc4: ", zc4)
	# xc3 = xc4
	# yc3 = (v3 - height/2)*d/(v4-v3)
	# zc3 = zc4
	# print("xc3: ", xc3)
	# print("yc3: ", yc3)
	# print("zc3: ", zc3)
	# print((xc1+xc2+xc3+xc4)/4, (yc1+yc2+yc3+yc4)/4, (zc1+zc2+zc3+zc4)/4)
	# #temp center 3.125 1.2 -0.69
	# # port - 0.125, 0, -1.31
	# # left1 - 0.625, 0.2, -1.51
	# # left3 - 6.100917431192661 -200.12370933177476 -863.1399766218585
	#
	# # wait for a key to be pressed to exit
	# cv2.waitKey(0)
	#
	# # close the window
	# cv2.destroyAllWindows()
