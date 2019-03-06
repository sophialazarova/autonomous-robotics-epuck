function right_left_velocity = getVelocities( delta_phi )
% GETVELOCITIES Calculates the current velocities based on delta_phi
% obtained from the dynamical contributions.
% 
% right_left_velocity = GETVELOCITIES(delta_phi)
% @PARAM
% delta_phi - angular displacement resulting from the dynamics.
% @RETURN
% right_left_velocity - vector containing the calculated velocities of the right and left
% wheels respectively on first and second position.
    DISTANCE_BTW_WHEELS = 53.0;
    DELTA_T = 0.3;
    arc_len_r = delta_phi*DISTANCE_BTW_WHEELS/2; %%mm
    arc_len_l = -delta_phi*DISTANCE_BTW_WHEELS/2;
    
    %%include delta t 0.2??
    
    right_left_velocity = [arc_len_r/DELTA_T;arc_len_l/DELTA_T];
end

