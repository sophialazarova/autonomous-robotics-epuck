function navigateToTargetDyn( h, start_loc, target_loc, start_angle)

SPEED_CONST = 200;
notat_tar=true;
last_pos_pul = kGetEncoders(h);
current_loc_allo = start_loc;
current_angle = start_angle;
hold on
    while(notat_tar)
        %% calculate location & angle change
        new_pos_pul = kGetEncoders(h);
        delta_pos_allo = getDeltaPosition(last_pos_pul, new_pos_pul, current_angle);

        %% update location and angle
        %delta_pos_allo
        current_angle = current_angle + delta_pos_allo(3);
        current_loc_allo = current_loc_allo + [delta_pos_allo(1),delta_pos_allo(2)];
        plot(current_loc_allo(1),current_loc_allo(2),'o');
        drawnow
        
        %% get direction and distance to target
        angle_dist_tar = getAngleDistanceTarget(target_loc, current_loc_allo);
        
        %% calculate attractor contribution
        delta_phi_attr = getAttractorContribution(current_angle, angle_dist_tar(1));
        
        %% calculate speed
        %delta_phi_attr
        right_left_vel = getVelocities(delta_phi_attr);
        
        %% apply speed
        %right_left_vel
        kSetSpeed(h,right_left_vel(2)+SPEED_CONST, right_left_vel(1)+SPEED_CONST);
        
        %% update pulse tracking variable
        last_pos_pul = new_pos_pul;
        
        %% check if target is reached
        dist_to_tar=sqrt(power(target_loc(1)-current_loc_allo(1),2) + power(target_loc(2)-current_loc_allo(2),2));
        if(dist_to_tar<20)
            notat_tar = false;
            kStop(h);
        end 
    end
end

