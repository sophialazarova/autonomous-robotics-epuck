function trackLocationOdometry(h,initial_position,initial_orientation_degrees)

%%%%%FIXED PROGRAM%%%%%
%DO NOT CHANGE OR USE ANY VARIABLES HERE
global curInterval
global timeStamp
global curCommandCode
global movementCounter
curInterval = [];
timeStamp = [];
curCommandCode = [];
movementCounter = 0;
isStillMoving = true;
%%%%%END FIXED PROGRAM%%%%%

lastPulsesNum = [0;0];
currentAngle = degtorad(initial_orientation_degrees);
lastPlotPosition = initial_position;

pointer = rectangle('Position',[lastPlotPosition(1),lastPlotPosition(2),20,20]);
pointer.EdgeColor = 'none';
pointer.FaceColor = 'blue';
axis equal

ylim([0 400])

%%%%%FIXED PROGRAM%%%%%
%DO NOT CHANGE OR USE ANY VARIABLES HERE   
    while(isStillMoving)        
        isStillMoving = randomMovement(h);
        %%%%%END FIXED PROGRAM%%%%%

        pathValues=kGetEncoders(h);
        %%%calculate measures between old position and new position
        distance_pulses=pathValues-lastPulsesNum;
        distancemm = computeDistancemm(distance_pulses);
        
       % pathValues
        if (distance_pulses(1)==distance_pulses(2))
        %%print path%
        trace = rectangle('Position',[lastPlotPosition(1),lastPlotPosition(2),5,5]);
        trace.FaceColor = 'red';
        trace.EdgeColor = 'none';
        %%egocentric
        egocentric = [distancemm(1)*cos(currentAngle), distancemm(1)*(sin(currentAngle))];
        allocentricRate = [lastPlotPosition(1)+egocentric(1), lastPlotPosition(2)+egocentric(2)];
        pointer.Position = [allocentricRate(1), allocentricRate(2),15,20];
        %%update values
        lastPulsesNum = pathValues;
        lastPlotPosition = allocentricRate;
        drawnow limitrate
        
        elseif (distance_pulses(1)==-distance_pulses(2))
        angle=distancemm(2)/26.5;
        %update values
        currentAngle = currentAngle+angle;
        lastPulsesNum = pathValues;
        
        drawnow limitrate    
        
        else
        %% print path %%
        trace = rectangle('Position',[lastPlotPosition(1),lastPlotPosition(2),5,5]);
        trace.FaceColor = 'red';
        trace.EdgeColor = 'none';
        angle=((distancemm(2)-distancemm(1))/53.0);
        radius= ((((distancemm(1)+distancemm(2))/2.0)*53.0)/(distancemm(2)-distancemm(1)));
        xego = radius*sin(angle);
        yego = radius*(1-cos(angle));
        xallo=xego*cos(currentAngle)-yego*sin(currentAngle);
        yallo=xego*sin(currentAngle)+yego*cos(currentAngle);
        %% lastPlotPosition
        newPosition = [lastPlotPosition(1)+xallo, lastPlotPosition(2)+yallo];
        pointer.Position = [newPosition(1), newPosition(2),15,20];
        %% update
        lastPulsesNum = pathValues;
        lastPlotPosition = newPosition;
        currentAngle = currentAngle+angle;
        drawnow limitrate 
        end
    end
end

