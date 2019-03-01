%% main.m 
%% Invoke all exercise functions here. 
%% In order to test an exercise uncomment the section corresponding to it.

%% INITITAL PARAMETERS - START LOCATION AND TARGET LOCATION.
h = kOpenPort();
kSetEncoders(h,0,0)

p1 = [230,50];
p2 = [140,360];
angle_rad = degtorad(0);

%% EXERCISE A %%
%basic_mov(h);

%% EXERCISE B %%
%navigateToTargetAlg(h,p1,p2,angle_rad);

%% EXERCISE 1.1 %%
%trackLocationOdometry(h,[70,90],90);

%% SENSOR CALIBRATION SETTING %%
%% Obtains mean sensor reading across 100 trials for each distance.
%% Requires manually movement of test object to different distances from the robot
%% Plots the result from the calibration trial for the current sensor
% mean_std_values=0.0;
% mean_std_values(6,2) = 0.0;
% 
% for i=1:1:6
%    mean_std = calibrateIR(h,100,8);
%    for j=1:1:2
%    mean_std_values(i,j)=mean_std(j);
%    end
%    fprintf('pr');
% end
% 
% x =  [100,80,60,40,20,0];
% y_values=mean_std_values(:,1);
% y = y_values;
% err=mean_std_values(:,2);
% 
% errorbar(x,y,err)
% xlim([0 100]);
% xlabel('Distance in mm');
% ylabel('Sensor Readings');

%% EXERCISE 1.2 %%
%  kSetSpeed(h,100,100);
%  stopBeforeObstacle(h,4);

%% EXERCISE 1.3 %%
%avoidObstacleAlg(h,p1,p2,angle_rad);

%% EXERCISE 2.1 %%
%navigateToTargetDyn(h,p1,p2,rad);

%% EXERCISE 2.2 %%
avoidObstacleDyn(h,p1,p2,rad);


