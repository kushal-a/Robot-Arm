import numpy as np

def transDH(dh):
    # return a transformation matrix going from frame i-1 to frame i
    # or representing a vector in frame i-1 from frame i
    # input dh is a vector of [theta,d,a,alpha] in radians
    
    T = ([[np.cos(dh[0]),  -np.sin(dh[0])*np.cos(dh[3]),  np.sin(dh[0])*np.sin(dh[3]),   dh[2]*np.cos(dh[0])],
            [np.sin(dh[0]),  np.cos(dh[0])*np.cos(dh[3]),   -np.cos(dh[0])*np.sin(dh[3]),  dh[2]*np.sin(dh[0])],
            [0,           np.sin(dh[3]),              np.cos(dh[3]),              dh[1]           ],
            [0,           0,                      0,                       1]])
    return T

def forwardKinematicsAllJoints(q):
    # This function takes in input as the joint angles and gives a (4,4,6)
    # array of joint transformations from frame zero to frame i (i=1:6)
    l11 = 648.9/1000; l12 = 267.95/1000; 
    l21 = 82/1000; l22 = 290/1000; 
    l3 = 111.25/1000;  
    l4 = 360/1000;
    l5 = 42.25/1000;
    l61 = 99/1000; l62 = 14.35/1000;

    DH = lambda q : np.array([  [np.pi/2,        l11+q[0,0],    l12,     0,       0],
            [-np.pi/2+q[1,0],  -l21,        l22,     0,       1],
            [np.pi/2+q[2,0],   -l3,         0,       -np.pi/2,   1],
            [q[3,0],        l4,          0,      np.pi/2,    1],
            [q[4,0],        0,           0,       -np.pi/2,   1],
            [-np.pi/2+q[5,0],  l5+l61,      l62,     0,       1]   ])
    
    dh = DH(q)


    T = np.eye(4)
    for j in range(6):
        T = T @ transDH(dh[j,:4])

    return T

def points_to_trans(w,x,y,z,qi):
    a = x-w
    b = z-w
    normal1 = np.cross(a,b)
    a = y-x
    b = w-x
    normal2 = np.cross(a,b)
    normal1 = normal1/np.linalg.norm(normal1)
    normal2 = normal2/np.linalg.norm(normal2)
    normal = (normal1+normal2)/2
    normal = (normal/np.linalg.norm(normal)).reshape((3,1))
    x_hat = (x-w)/np.linalg.norm(x-w)
    x_hat = x_hat.reshape((3,1))
    position = (w+x+y+z)/4
    position.reshape((3,1))
    y_hat = np.cross(normal.reshape((3,)),x_hat.reshape((3,))).reshape((3,1))
    print(x_hat,y_hat,normal)
    T6_d = np.zeros((4,4))
    T6_d[3,3] = 1
    T6_d[:3,:1] = x_hat
    T6_d[:3,1:2] = y_hat
    T6_d[:3,2:3] = normal
    print(T6_d)
    T06 = forwardKinematicsAllJoints(qi)
    T = T06 @ T6_d # multiply T66_ in middle
    return T

if __name__=='__main__':
    # points_to_trans(np.array([0,0,0]),np.array([1,0,0]),np.array([1,-1,0]),np.array([0,-1,0]),np.array([[0,0,0,0,0,0]]).T)
    
    print(np.round(forwardKinematicsAllJoints(np.zeros([6,1])),2))