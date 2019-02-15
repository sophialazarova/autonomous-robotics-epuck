function avoid_obstacle(h,p1,p2,startAngle)
sensorsCurrentValues = [0;0;0;0;0;0;0;0];
calibrated=[3500,3;3900,3;3700,3;3900,3;3900,3;4000,3;4000,3;4000,3];
currentAngle=startAngle;
lastPulsesNum = [0;0];
lastPlotPosition = p1;
isFinalDestReached=0;
didMakeATurn=0;

% 
% c = getDistance(p1,p2);
% angle = getAngle(p1, p2, startAngle);
% impulses = getImpulsesRotation(angle);
% arcLength = getArcLength(angle, 26.5);
% 
% if(arcLength ~= 0) 
%     rotate(h, impulses, arcLength);
% end
% 
% speed = getSpeed(0.8, c);
% impulsesForward = getImpulsesForward(c);
%moveForward(h, impulsesForward, speed);

%kSetSpeed(h,speed,speed);
    while(1)
    angle = getAngle(lastPlotPosition, p2, currentAngle);
    impulses = getImpulsesRotation(angle);
    arcLength = getArcLength(angle, 26.5);
    impulsesMetric = kGetEncoders(h);

    if(arcLength ~= 0) 
        rotate(h, impulses, arcLength, abs(impulsesMetric(2)));
    end
    currentAngle=currentAngle+angle;
    kSetSpeed(h,200,200);
    isFinalDestReached=0;
        while(1)
            %%%calculate measures between old position and new position
            pathValues=kGetEncoders(h);
            distance=pathValues-lastPulsesNum;
            distancemm = convertPulsesTomm(distance);

            %%update current position on straight line
            egocentric=[distancemm(1)*cos(currentAngle), distancemm(1)*(sin(currentAngle))];
            allocentricRate=[lastPlotPosition(1)+egocentric(1), lastPlotPosition(2)+egocentric(2)];
            %%update values
            lastPulsesNum=pathValues;
            lastPlotPosition=allocentricRate;

            %%calculate for two front sensors
            sensorsReadings = kProximity(h);
            sensorsReadings2 = kProximity(h);
            normValueFirst = normalize(sensorsReadings(1),calibrated(1,:));
            normValueEight = normalize(sensorsReadings(8),calibrated(8,:));
            convertedValue=convertTocm((normValueFirst+normValueEight)/2);
            if(convertedValue<4.3)
                %% object ahead, turn away
                impulses = getImpulsesRotation(degtorad(60));
                arcLength = getArcLength(angle, 26.5);
                lastPositionBeforeRotation=kGetEncoders(h);
                if (sensorsReadings(1)>sensorsReadings(8))
                   kSetSpeed(h,-40,40);
                   while(1)
                       encoders=kGetEncoders(h);
                       if (abs(encoders(2))>impulses+abs(lastPositionBeforeRotation(2)))
                          moveForward(h,encoders(2)+20,200);
                          currentAngle=currentAngle+degtorad(60);
                          isFinalDestReached=1;
                           break;
                       end
                   end
                else
                   kSetSpeed(h,40,-40);
                   while(1)
                       encoders=kGetEncoders(h);
                       if (abs(encoders(1))>impulses+abs(lastPositionBeforeRotation(1)))
                           moveForward(h,encoders(2)+20,200);
                           currentAngle=currentAngle+degtorad(-60);
                           isFinalDestReached=1;
                           break;
                       end
                   end
                end
            end
            bottomBorder = p2-10;
            upperBorder = p2+10;
            lastPlotPosition
            if ((lastPlotPosition(1)>bottomBorder(1) && lastPlotPosition(2)>bottomBorder(2)) && (lastPlotPosition(1)<topBorder(1) && lastPlotPosition(2)<topBorder(2)))
                kStop();
                didMakeATurn=1;
                break;
            end
            if(isFinalDestReached==1)
                break;
            end
        end
        if(didMakeATurn==1)
            break;
        end
    end
end

function normalizedValue = normalize(value,range)
normalizedValue=(value-range(2))/(range(1)-range(2));
end

function result = convertTocm(normalizedValue)
result=-1.3*log(normalizedValue)-1.3;
end



%%%%1
function c = getDistance(p1,p2)
a = abs(p1(1)-p2(1)); % a side of the triangle
b = abs(p1(2)-p2(2)); % b side of the triangle
c = sqrt(power(a,2) + power(b,2));
end

function res = getAngle(p1,p2, startAngle)
a = p2(1)-p1(1); % a side of the triangle
b = p2(2)-p1(2); % b side of the triangle
angleTemp = atan2(b,a); % angle between current position and target center
res=angleTemp-startAngle; 
end

function res = getImpulsesRotation(angle)
radius = 26.5; % radius of vehicle cirle
arcLengthmm = getArcLength(angle, radius);
res = 7.69*arcLengthmm; %7.69imp = 1mm 
end

function res = getArcLength(angle, radius)
res = angle*radius; %mm
end

function rotate(h, impulses, distance, startMetric)
speed = getSpeed(0.2, distance);
 kSetSpeed(h,-speed,speed);
    while (1)
    passedImpulses = kGetEncoders(h);
        if (abs(passedImpulses(1)) > startMetric+impulses)
            return;
        end
    end
end

function res = getSpeed(time, distance)
res = distance/time;
end

function moveForward(h, distance, speed)
kSetSpeed(h, speed, speed)
    while(1)
        passedImpulses = kGetEncoders(h);
        abs(passedImpulses(1));
        if(abs(passedImpulses(1)) > distance)
            return;
        end
    end
end

function res = getImpulsesForward(distancemm)
res = distancemm*7.69;
end

function dist = convertPulsesTomm(distance)
impulsTomm = 0.13;
dist = [distance(1)*impulsTomm, distance(2)*impulsTomm];
end