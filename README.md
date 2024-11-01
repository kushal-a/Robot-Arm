# InterIIT MidPrep: Robotic Charging Challenge

- ### Assumptions:
1. Custom socket manufacturing
2. Servo control forevery motor
3. Neglecting friction losees in torque calculation
4. Four leds at the four cotrner of the charging socket on the car

- ### Power consumption for charging cycle ~ 70 J
- The mounting point wrt task space is shown in `/results/planning/workspace.png`.
- The working model of simscape environment animation is in `/results/simscape/videos/simscapeModel.avi`.
- MATLAB 3D world render showing complete cycle animation is in `/results/simscape/videos/MATLAB3D.avi`.
- Bill of materials is in `/CAD and analysis/Bill of Materials/`.
- Power consumption for multiple trajectories and the trajectory plots is in `/results/planning/energy_consumption_for_join_space_trajectories.png`.
- Pictures of the CAD model are present in `/results/CAD/`.

### The Submission zip has this structure

## 1. `Code files`

- Planning
- CV
- Simulation

### Planning
- The folder `Robot-Arm-Control` contains MATLAB files used for path planning and robot arm characterization.
- `main.m` is used to initialize the robot DH parameters and collision boxes.
- `/RobotKinematics` contains files for forward and inverse kinematics, collision detection and transformation matrices.
- `/planning` contains files for joint space planning, energy computation and velocity planning.
- `/cartesian_straight_line` contains files used for straight line path in cartesian coordinates.
- `/torque_files` contains files used for computing torques for any configuration and kinematics.
- `/plotting` contains all the scripts used for generating plots.

### CV
- Load the `best.pt` weight file using the command ```model = torch.hub.load('ultralytics/yolov5', 'custom', path = {Path to 'best.pt' file} , force_reload=True)```
 - `/CV.py` It is a function which takes a loaded model, frame of the video and outputs coordinates of 4 points wrt to camera frame that has to be preloaded.
 - Monocular camera trajecrtory obtaining depths of 4 key point in mm
 - `/Monocular` contains all the files for location estimation for circle, straight line and parallel using stereo and monocular estimations respectively. These codes were used to generate plots and animations to verify position and orientation results. Assumption: normal vectors of plane of charging port and camera plane are coplanar.
 - `Stereo/stereo_depth_sift.py` is the pipeline for the stereo depth estimation. Feature matching is done on the resized image using YOLO model using SIFT algorithm to calculate depth of the keypoints.
 - `Stereo/stereo.py` Feature matching is done using color thresholding and pose estimation of all keypoints is being done.



### Simulation
- `/Simscape Simulation` contains all the models and the dependent files for simulating the trajectory of the robot arm from any initial point to final point, where initial point is the current coniguration of the robot in joint space and desired/final point is provided as a transformation matrix from ground frame at the base of link 1 to desired pose.
- In order to initiate the simulation, update the initial and final desired positions in `waypointGeneration.m` file. After running this script, run the `finalSimscapeModel.slx` model.
- The remaining files and folders contains the supporting files and models for running the Simscape model.
- The simulink model also launches the MATLAB 3D world, which was used for visualization and generating images for training the YOLO detection model.

## 2. `CAD and Analysis`
This folder has the main assembly file named `Solid model/jlr_robotic_charging_station.STEP` . The FEM results are included in `FEMSimulation(Ansys)` folder. The BOM and the supporting docs are available in `bill of materials`.

## 3. `Results`
All the animation and plots are contained in the respective folders.

