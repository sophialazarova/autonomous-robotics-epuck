function [angle,dist] = getAngleDistanceTarget( target_location,current_location )
% GETANGLEDISTANCETOTARGET Calculates the distance and the angle to a target location
% based on the current location. 
% 
% [angle,dist] = GETANGLEDISTANCETOTARGET(target_location,current_location)
% @PARAM
% target_location - vector denoting the target location given in format (x,y)
% current_location - vector denoting the current location given in format (x,y)
% @RETURN
% [angle,dist] - vector containing the angle to target on first position
% and the distance to target on second.
    a = target_location(1)-current_location(1); % a side of the triangle
    b = target_location(2)-current_location(2); % b side of the triangle
    dist = sqrt(power(a,2)+power(b,2));
    
    angle = atan2(b,a);
end

