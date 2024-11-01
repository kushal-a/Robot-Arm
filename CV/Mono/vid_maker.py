import cv2
import numpy as np
import glob

frameSize = (800, 800)

out = cv2.VideoWriter('parallel_video.avi',cv2.VideoWriter_fourcc(*'DIVX'), 30, frameSize)

for i in range(5,301):
    filename = 'img'+str(i)+'.jpg'
    img = cv2.imread(filename)
    out.write(img)

out.release()
