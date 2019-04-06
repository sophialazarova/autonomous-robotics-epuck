
Autonomous Robotics Lab Exercises

Tasks solved during the Autonomous Robotics Lab class at the Ruhr University
Exercises are implemented for e-puck robots.

For more information on the implementation check the reports folder.

TASKS
-----------------------------------------

Task A: Basic movement commands
Problem: Let the robot drive from the starting position to the target on a
printout of the first environment. The trajectory of the robot has
to remain within the dashed area and may not touch any obstacles. (Hint:
Set wheel speeds, pause, repeat.)

Task B: Kinematics
Problem: We now have an environment without obstacles, where the starting and end position can be varied (Figure 2). Write a program that brings
the robot from an arbitrary starting position to an arbitrary end position.
The program should get the coordinates (e.g., in millimeters) of the starting
position and end position as well as the initial orientation (e.g., in degrees)
of the robot as parameters. The coordinates should be expressed relative to
the global (allocentric) coordinate frame as defined in the printout. The final
orientation of the robot does not matter.

1 CONTROLLING THE ROBOT
Task 1.1: Odometry
Problem: Write a program that displays the current position and previous
path of the robot in a live plot. Choose an appropriate coordinate system
and starting position for your plot. You will receive a program from us that
will control the robot. This means that you will not know what commands
are being sent to the robot.

Task 1.2: Detecting obstacles with sensors
Problem: If we introduce obstacles into the environment the
robot will need to estimate their location to appropriately avoid them. In
this task you will evaluate how the robot’s infrared sensors react to obstacles
and how sensor information may be used for robot control. Systematically
analyze how a single infrared sensor reacts to a single obstacle at different
distances while the robot remains still. Take multiple measurements and
analyze the mean as well as standard deviation for each distance. Visualize
your findings in a plot. Repeat the analysis for an obstacle made of a different
material.
Use your knowledge about the sensor behavior to implement a function that
converts the sensor readings into an approximation of the distance between
the robot and an obstacle (for example, in cm). Verify your conversion
through a live-plot of the measured distances while the robot is standing
still. Write a program that makes the robot drive forward and reliably stops
it once an obstacle is observed at a distance of 2 cm (4 cm).

Task 1.3: Obstacle avoidance
Problem: Write a program that makes the robot drive from a starting position
to an end position, while avoiding an obstacle in the environment. While navigating the
environment, the robot may not touch the obstacle. Do not hard-code the
obstacle’s position into your program. Instead, use the infrared sensors to
detect when the robot is close to an obstacle and then avoid it by changing
course. The robot has to reach the target after avoiding the obstacle. (It is
fine if the robot drives off the paper for a while.) Track the robot’s position
in a live plot.
Make the obstacle avoidance dependent on the position of the obstacle, that
is, if the obstacle is right in the middle of the robot’s path, avoid it more
strongly than if it is off to the side of the path.

2 ATTRACTOR DYNAMICS
Task 2.1: Target approach
Problem: You will now solve the problem of section B again, but this time,
using an attractor dynamics approach.
Write an attractor dynamics that rotates the robot on the spot toward the
target. Use a sine dynamics that is defined over the orientation of the robot.
Once turning on the spot works, add a constant forward speed to drive the
robot to the target while turning.

Task 2.2: Obstacle avoidance
Problem: Extend your program so that the robot can avoid obstacles while it
is driving toward the target. The robot should still move forward and turn at
the same time. Additionally, it should be repelled from obstacles and avoid
them in smooth trajectories. Solve the obstacle avoidance by modifying the
dynamical system you have implemented for the last problem.
