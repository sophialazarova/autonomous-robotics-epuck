function stopBeforeObstacle(h, distance)
sensorsCurrentValues = [0;0;0;0;0;0;0;0];
calibrated=[3500,5;3900,5;3700,5;3900,5;3900,5;4000,5;4000,5;4000,5];
c=bar(sensorsCurrentValues);
    while(1)
    sensorsReadings = kProximity(h);
      for i=1:1:8
          mn=calibrated(i,:);
          convertedValue=convertCm(normalizeInRange(sensorsReadings(i),mn));
          sensorsCurrentValues(i)=convertedValue;
      end
      delete(c)
      c=bar(sensorsCurrentValues);
      xlabel('Sensor');
      ylabel('Distance to object (cm)');
      pause(0.02)
      drawnow limitrate
    normalizedValue=normalizeInRange((sensorsReadings(1)+sensorsReadings(2))/2,calibrated(8,:));
    convertedValue = convertCm(normalizedValue);
        if(convertedValue<distance+0.3)
            kStop(h);
            break;
        end
    end
end

