function avoidObstacleAlg(h,p1,p2,startAngle)
    lastPulsesNum = [0;0];
    currentAngle = startAngle;
    lastPlotPosition = p1;
    calibrated=[3500,3;3900,3;3700,3;3900,3;3900,3;4000,3;4000,3;4000,3];
    passedObsticle = false;
    notAtTarget=true;
    
    hold on
    xlim([0,270]);
    ylim([0,400]);
    while(notAtTarget)
        %%check if at target
        dist=sqrt(power(p2(1)-lastPlotPosition(1),2) + power(p2(2)-lastPlotPosition(2),2));
        if(dist<40)
            notAtTarget = false;
            kStop(h);
        end 
        
        %%
      
        angleToTarget=getAngle(p2,lastPlotPosition,currentAngle);
        if(angleToTarget >= degtorad(0) && angleToTarget < degtorad(2))
        sensorsReadings = kProximity(h);
        normValueFirst = normalizeInRange(sensorsReadings(1),calibrated(1,:));
        normValueEight = normalizeInRange(sensorsReadings(8),calibrated(8,:));
        convertedValue=convertCm((normValueFirst+normValueEight)/2);
            while(convertedValue>=4.3)
                dist=sqrt(power(p2(1)-lastPlotPosition(1),2) + power(p2(2)-lastPlotPosition(2),2));
                 if(dist<10)
                     notAtTarget = false;
                     kStop(h);
                     return;
                  end 
                plot(lastPlotPosition(1),lastPlotPosition(2),'o');
                drawnow
                xlim([0,270]);
                ylim([0,400]);
                xlabel('x (mm)');
                ylabel('y (mm)');
                sensorsReadings = kProximity(h);
                normValueFirst = normalizeInRange(sensorsReadings(1),calibrated(1,:));
                normValueEight = normalizeInRange(sensorsReadings(8),calibrated(8,:));
                convertedValue=convertCm((normValueFirst+normValueEight)/2);
                
                kSetSpeed(h,200,200);
                stats = updateMovementStatsStraight(h,lastPlotPosition, lastPulsesNum,currentAngle);
                lastPulsesNum = [stats(1);stats(2)];
                lastPlotPosition = [stats(3);stats(4)];
            end
            kSetSpeed(h,-100,100);
            anglethreshold=currentAngle+degtorad(60);
            while(~(currentAngle > anglethreshold-degtorad(2) && currentAngle<anglethreshold+degtorad(2)))
                kSetSpeed(h,-100,100);
                pathValues = kGetEncoders(h);
                distance=pathValues-lastPulsesNum;
                distancemm = computeDistancemm(distance);
                angle=distancemm(2)/26.5;
                currentAngle = wrapToPi(currentAngle+angle);
                lastPulsesNum = pathValues;
            end
            kSetSpeed(h,200,200);
            passedObsticle=true;
 
        elseif(passedObsticle==true)
            lastpulses = lastPulsesNum;
            while(1)
                  plot(lastPlotPosition(1),lastPlotPosition(2),'o');
        drawnow
            xlim([0,270]);
    ylim([0,400]);
                kSetSpeed(h,200,200);
                stats = updateMovementStatsStraight(h,lastPlotPosition, lastPulsesNum,currentAngle);
                lastPulsesNum = [stats(1);stats(2)];
                lastPlotPosition = [stats(3);stats(4)];
                if(lastPulsesNum(2) > lastpulses + 700)                   
                    passedObsticle=false;
                    kStop(h);
                    break;
                end
            end
        else         
            anglethreshold=currentAngle+angleToTarget;
            while(~(currentAngle > anglethreshold-degtorad(2) && currentAngle<anglethreshold+degtorad(2)))
                kSetSpeed(h,-100,100);
                  plot(lastPlotPosition(1),lastPlotPosition(2),'o');
        drawnow
            xlim([0,270]);
    ylim([0,400]);
                pathValues = kGetEncoders(h);
                distance=pathValues-lastPulsesNum;
                distancemm = computeDistancemm(distance);
                angle=distancemm(2)/26.5;
                currentAngle = wrapToPi(currentAngle+angle);
                lastPulsesNum = pathValues;
            end
            
        end
         
        pathValues=kGetEncoders(h);
        %%%calculate measures between old position and new position
        distance=pathValues-lastPulsesNum;
    end
        
end


function stats = updateMovementStatsStraight(h,lastPlotPosition, lastPulsesNum,currentAngle)
    pathValues = kGetEncoders(h);
    distance=pathValues-lastPulsesNum;
    distancemm = computeDistancemm(distance);
    egocentric = [distancemm(1)*cos(currentAngle), distancemm(1)*(sin(currentAngle))];
    allocentricRate = [lastPlotPosition(1)+egocentric(1), lastPlotPosition(2)+egocentric(2)];
    %%update values
    stats(1) = pathValues(1);
    stats(2) = pathValues(2);
    stats(3) = allocentricRate(1);
    stats(4) =allocentricRate(2);
end
function angle = getAngle(target,currentPosition,currentAngle)
    a = target(1)-currentPosition(1); % a side of the triangle
    b = target(2)-currentPosition(2); % b side of the triangle
    angleTemp = atan2(b,a); % angle between current position and target center
    angle=angleTemp-currentAngle; 
end

