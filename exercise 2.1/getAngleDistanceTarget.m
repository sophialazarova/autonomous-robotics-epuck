function [angle,dist] = getAngleDistanceTarget( target,current_pos )
    a = target(1)-current_pos(1); % a side of the triangle
    b = target(2)-current_pos(2); % b side of the triangle
    dist = sqrt(power(a,2)+power(b,2));
    
    angle = atan2(b,a);
end

