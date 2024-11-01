import cv2
import numpy as np
from matplotlib import pyplot as plt
import torch
import datetime
def CV(model,frame):
    '''
    Function return x,y,z of points from camera frame in the order of red, blue, green , skyblue (or yellow)
    '''

    model.conf = 0.5

    points = coordinates(model,frame)
    if points is None:
        return None
    if len(points) == 4:
        # print(count)
        # frame = cv2.line(frame, (400, 0) , (400, 800), (255, 0, 0), 2)
        # frame = cv2.line(frame, (0, 400) , (800, 400), (255, 0, 0), 2)
        center_coordinates3 = (points[0][0], points[0][1])
        center_coordinates1 = (points[1][0], points[1][1])
        center_coordinates2 = (points[2][0], points[2][1])
        center_coordinates4 = (points[3][0], points[3][1])

        radius = 5
        img = cv2.circle(frame, center_coordinates3, radius, (255, 255, 255), 2)
        img = cv2.circle(img, center_coordinates1, radius, (255, 255, 255), 2)
        img = cv2.circle(img, center_coordinates2, radius, (255, 255, 255), 2)
        img = cv2.circle(img, center_coordinates4, radius, (255, 255, 255), 2)

        d = 110
        f = 545
		# coordinates in image frame
        u1 = points[1][0]
        v1 = points[1][1]
        u2 = points[2][0]
        v2 = points[2][1]
        u3 = points[0][0]
        v3 = points[0][1]
        u4 = points[3][0]
        v4 = points[3][1]
        

        height, width = frame.shape[:2]
		# camera frame coordinates
        m = -1*(u2-width/2)*0
		# print(d2/(u1-u4))
		# print(d/(v1-v2))
		#xc1 = (u1-width/2)*d2/(u4-u1)
        xc2 = (u2-width/2)*d/(v2-v1) - m
        zc2 = d*f/(v1-v2)
        yc2 = (v2 - height/2)*d/(v1-v2)
        # print("xc2: ", xc2)
        # print("yc2: ", yc2)
        # print("zc2: ", zc2)
        xc1 = xc2
        yc1 = (v1 - height/2)*d/(v1-v2)
        zc1 = zc2
        # print("xc1: ", xc1)
        # print("yc1: ", yc1)
        # print("zc1: ", zc1)
		#xc4 = (u4-width/2)*d2/(u4-u1)
        xc4 = (u4-width/2)*d/(v3-v4) - m
        zc4 = d*f/(v4-v3)
        yc4 = (v4 - height/2)*d/(v4-v3)
        # print("xc4: ", xc4)
        # print("yc4: ", yc4)
        # print("zc4: ", zc4)
        xc3 = xc4
        yc3 = (v3 - height/2)*d/(v4-v3)
        zc3 = zc4
        # print("xc3: ", xc3)
        # print("yc3: ", yc3)
        # print("zc3: ", zc3)
		# print((xc1+xc2+xc3+xc4)/4, (yc1+yc2+yc3+yc4)/4, (zc1+zc2+zc3+zc4)/4)
        x_obs = (xc1+xc2+xc3+xc4)/4 + (0.16*(xc1+xc2+xc3+xc4)/4)
        y_obs = (yc1+yc2+yc3+yc4)/4
        z_obs = (zc1+zc2+zc3+zc4)/4
        # print(x_obs, y_obs, z_obs)

        allpoints = [[xc1,yc1,zc1],[xc2,yc2,zc2],[xc3,yc3,zc3],[xc4,yc4,zc4]]

        return allpoints

def coordinates(model,frame):
      
    # Getting the YOLO Detection
    results = model(frame)

    # Returning None if there is no detection in the image
    print(results.xyxy[0])
    if len(results.xyxy[0]) == 0:
        return None
    
    # Getting the resizing pixels
    temp = np.array(results.xyxy[0][0])
    c0 = c1 = c2 = c3 = 0
    x = frame.shape[1]
    y = frame.shape[0]

    
    c0 = min(int(temp[0]),20)
    c1 = min(int(temp[1]),20)
    c2 = min(x-int(temp[2]),20)
    c3 = min(y-int(temp[3]),20)


    
    # Cropping the Image
    image = frame[int(temp[1])-c1:int(temp[3])+c3,int(temp[0])-c0:int(temp[2])+c2,:]
    %matplotlib inline 
    plt.imshow(image)
    plt.show()
    imag = image.copy()

    ##### COLOR THRESHOLDING #####
    # Converting the image format into hsv
    hsv = cv2.cvtColor(imag, cv2.COLOR_BGR2HSV)
    points = []
    # Setting the HSV ranges for each colour
    green_boundary = [np.array([10,110,62]),np.array([170,255,255])]
    red_boundary = [np.array([0,60,75]),np.array([55,255,255])]
    # skyblue_boundary = [np.array([65,76,50]),np.array([95,255,255])]
    yellow_boundary = [np.array([10,136,10]),np.array([40,255,255])]
    blue_boundary = [np.array([110,115,62]),np.array([170,255,255])]
    boundary = [red_boundary,blue_boundary, green_boundary,yellow_boundary]

    # Thresholding for each colour
    for m in range(len(boundary)):
        mask = cv2.inRange(hsv, boundary[m][0], boundary[m][1])
        img = image.copy()
        si = cv2.bitwise_and(img,img, mask = mask)

        contours, hierarchy = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)

        # Finding the max contour
        cmax = np.array([])
        for contour in contours:
            if len(contour)>len(cmax):
                cmax = contour

        # Finding the centre of the max contour
        M = cv2.moments(cmax)
        if M['m00'] != 0:
            cx = int(M['m10']/M['m00'])
            cy = int(M['m01']/M['m00'])
            points.append([cx,cy])
    points = np.array(points)
    temp2 = np.array([c0,c1])
    points = points + temp2

    return points