function distance = computeDistancemm( distance_pulses )
    conversion_measure = 0.13;
    distance = [distance_pulses(1)*conversion_measure, distance_pulses(2)*conversion_measure];
end

