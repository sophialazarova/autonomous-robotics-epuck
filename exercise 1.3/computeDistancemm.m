function distance = computeDistancemm( distance_pulses )
% COMPUTEDISTANCEMM Converts given distance in pulses into distance in mm. 
% 
% distance = COMPUTEDISTANCEMM(distance_pulses)
% @PARAM
% distance_pulses - distance in pulses
% @RETURN
% distance - converted distance in mm
    conversion_measure = 0.13;
    distance = [distance_pulses(1)*conversion_measure, distance_pulses(2)*conversion_measure];
end

