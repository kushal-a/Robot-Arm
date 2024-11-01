"""**SIFT**"""

import cv2
import numpy as np
from matplotlib import pyplot as plt
import torch
import datetime

vidLeft = cv2.VideoCapture('/content/line0.avi')
vidRight = cv2.VideoCapture('/content/line1.avi')

model = torch.hub.load('ultralytics/yolov5', 'custom', path = 'best.pt' , force_reload=True)

actual = np.linspace(3, 0.1, 300)
count = 0
depths = np.ones(300)*3

frame_width = int(vidLeft.get(3))
frame_height = int(vidLeft.get(4))
   
size = (frame_width, frame_height)

# Below VideoWriter object will create
# a frame of above defined The output 
# is stored in 'filename.avi' file.
result = cv2.VideoWriter('final_output.avi', 
                         cv2.VideoWriter_fourcc(*'MJPG'),
                         10, size)

def yolo(frame):
  a = datetime.datetime.now()
  results = model(frame)
  # print(results)
  b = datetime.datetime.now()
  delta = b - a
  try:
    temp = np.array(results.xyxy[0][0])
    image = frame[int(temp[1])-20:int(temp[3])+20,int(temp[0])-20:int(temp[2])+20,:]
    cv2.imwrite('im.jpg',image)
  except Exception as e:
    return -1
  return temp


def coordinates2(frame1,frame2):

  a = datetime.datetime.now()
  results = model(frame1)
  # print(results)
  b = datetime.datetime.now()
  delta = b - a
  try:
    temp1 = np.array(results.xyxy[0][0])
    img1 = frame1[int(temp1[1])-20:int(temp1[3])+20,int(temp1[0])-20:int(temp1[2])+20,:]
  except Exception as e:
    return -1, -1

  sift = cv2.xfeatures2d.SIFT_create()

  ## Create flann matcher
  FLANN_INDEX_KDTREE = 1  # bug: flann enums are missing
  flann_params = dict(algorithm = FLANN_INDEX_KDTREE, trees = 5)
  #matcher = cv2.FlannBasedMatcher_create()
  matcher = cv2.FlannBasedMatcher(flann_params, {})

  gray1 = cv2.cvtColor(img1, cv2.COLOR_BGR2GRAY)
  kpts1, descs1 = sift.detectAndCompute(gray1,None)

  a = datetime.datetime.now()
  results = model(frame2)
  # print(results)
  b = datetime.datetime.now()
  delta = b - a
  try:
    temp2 = np.array(results.xyxy[0][0])
    img2 = frame2[int(temp2[1])-20:int(temp2[3])+20,int(temp2[0])-20:int(temp2[2])+20,:]
  except Exception as e:
    return -1


  gray2 = cv2.cvtColor(img2, cv2.COLOR_BGR2GRAY)
  kpts2, descs2 = sift.detectAndCompute(gray2,None)

  ## Ratio test
  matches = matcher.knnMatch(descs1, descs2, 2)
  matchesMask = [[0,0] for i in range(len(matches))]

  points1 = []
  points2 = []

  for i, (m1,m2) in enumerate(matches):
      if m1.distance < 0.7 * m2.distance:
          matchesMask[i] = [1,0]
          ## Notice: How to get the index
          pt1 = kpts1[m1.queryIdx].pt
          pt2 = kpts2[m1.trainIdx].pt
          points1.append(pt1)
          points2.append(pt2)
          # print(i, pt1,pt2 )



  points1 = np.array(points1)
  temp1 = np.array([int(temp1[0])-20,int(temp1[1])-20])
  points1 = points1 + temp1

  points2 = np.array(points2)
  temp2 = np.array([int(temp2[0])-20,int(temp2[1])-20])
  points2 = points2 + temp2

  return points1, points2

# left_coordinates = coordinates(imgLeft)
# right_coordinates = coordinates(imgRight)

count=0
vidLeft = cv2.VideoCapture('line0.avi')
vidRight = cv2.VideoCapture('line1.avi')

actual = np.linspace(3, 0.1, 300)
count = 0
depths = np.ones(300)*3
bias = 0.044-0.03819858837284849

while True:

  ret1, frame1 = vidLeft.read() 
  ret2, frame2 = vidRight.read() 

  if(count < 200):
 
    count = count + 1
    continue


  if not ret1:
    print("d")
    break
  if not ret2:
    print("d2")
    break


  left_coordinates,right_coordinates = coordinates2(frame1,frame2)
  # print(left_coordinates)
  # print(right_coordinates)

  if type(left_coordinates) ==int:
    continue

  disparities = []

  for i in range(len(left_coordinates)):
    disparities = np.array(left_coordinates[:,0]) - np.array(right_coordinates[:,0])

  print(disparities)


  a = disparities
  ## REMOVE OUTLIERS
  mean = np.mean(a)
  std_dev = np.std(a)
  # 3. Normalize array around 0
  zero_based = abs(a - mean)
  # 4. Define maximum number of standard deviations
  max_deviations = 1
  # 5. Access only non-outliers using Boolean Indexing
  no_outliers = a[zero_based < max_deviations * std_dev]
  print(no_outliers)

  disparities = no_outliers

  # print("disparities",disparities)

  baseline = 25
  # pixelsize = 1
  # focalpixel = 1368.536
  focalpixel = 476.7
  depth = []
  # disparities = [1]



  for i in range(len(disparities)): 
    dist = ((focalpixel*baseline)/(abs(disparities[i])))
  # print(dist) 

  depth.append(dist)

  depth = np.array(depth)
  depth = np.mean(depth)/1000
  depth+=bias
  # actualdepth = 1316
  print(depth)
  depths[count] = depth
  frame1 =np.squeeze(model(frame1).render())
  cv2.putText(frame1, "Actual Depth:" + str(actual[count]), (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0, 255, 255), 2, cv2.LINE_AA)
  cv2.putText(frame1, "Measured Depth:" + str(depth), (10, 60), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0, 255, 255), 2, cv2.LINE_AA)
  cv2.putText(frame1, "Error in Depth:" + str(np.abs(actual[count] - depth)), (10, 90), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0, 255, 255), 2, cv2.LINE_AA)

  # Screen reflection #############################################################
  # cv2.imshow('Hand Gesture Recognition', image)
  # cv2.imwrite()
  result.write(frame1)
  count = count + 1


vidLeft.release()
result.release()

# Commented out IPython magic to ensure Python compatibility.
import matplotlib.pyplot as plt
import numpy as np
actual = np.linspace(3, 0.1, 300)
# print(actual)
predict = depths
frames = np.linspace(0, 300, 300)
# %matplotlib inline
plt.plot(frames[260:290],actual[260:290], label = "Actual Depths")
plt.plot(frames[260:290],predict[260:290], label = "Measured Depths")

# plt.plot(actual[260:290],predict[260:290])

# plt.plot(frames,actual)
# plt.plot(frames,predict)

# naming the x axis
plt.xlabel('Frames')
# naming the y axis
plt.ylabel('Depths(m)')
  
# giving a title to my graph
plt.title('Actual VS Measured Depths in StereoVision')
plt.legend()

plt.show()

# np.mean(actual[260:290] - predict[260:290])