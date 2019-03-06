function stopBeforeObstacle(h, distance)
% STOPBEFOREOBSTACLE Stops the moving robot in a specified distance to an obstacle ahead. 
% 
% STOPBEFOREOBSTACLE(h, distance)
% @PARAM
% h - connection token
% distance - specifies in what distance before an obstacle the robot
% should stop. Given in centimeters.

current_proximity_values_cm = [0;0;0;0;0;0;0;0];
calibration_values = [3500,5;3900,5;3700,5;3900,5;3900,5;4000,5;4000,5;4000,5];
c=bar(current_proximity_values_cm);
    while(1)
        proximity_sensors_readings = kProximity(h);
          for i=1:1:8
              calibration_range_sensor_i = calibration_values(i,:);
              distance_cm = convertCm(normalizeInRange(proximity_sensors_readings(i),calibration_range_sensor_i));
              current_proximity_values_cm(i) = distance_cm;
          end
          delete(c)
          c=bar(current_proximity_values_cm);
          xlabel('Sensor');
          ylabel('Distance to object (cm)');
          pause(0.02)
          drawnow limitrate

        normalized_proximity_value = normalizeInRange((proximity_sensors_readings(1)+proximity_sensors_readings(2))/2,calibration_values(8,:));
        current_distance_cm = convertCm(normalized_proximity_value);
        if(current_distance_cm < distance+0.3)
            kStop(h);
            break;
        end
    end
end

