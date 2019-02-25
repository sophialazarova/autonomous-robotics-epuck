function obstcl_dyn( h, start_loc, target_loc, start_angle)

ROBOT_PROXIMITY_SENSORS_DIRECTIONS=[deg2rad(-15), deg2rad(-45), deg2rad(-90), deg2rad(-150), deg2rad(150), deg2rad(90), deg2rad(45), deg2rad(15)];
SPEED_CONST = 200;
notat_tar=true;
last_pos_pul = kGetEncoders(h);
current_loc_allo = start_loc;
current_angle = start_angle;
hold on
    while(notat_tar)
        %% calculate location & angle change
        new_pos_pul = kGetEncoders(h);
        delta_pos_allo = getDeltaPositionAllo(last_pos_pul, new_pos_pul, current_angle);

        %% update location and angle
        %delta_pos_allo
        current_angle = wrapToPi(current_angle + delta_pos_allo(3));
        current_loc_allo = current_loc_allo + [delta_pos_allo(1),delta_pos_allo(2)];
        plot(current_loc_allo(1),current_loc_allo(2),'o');
        drawnow
        
        %% get direction and distance to target
        angle_dist_tar = getAngleAndDistanceTarget(target_loc, current_loc_allo);
        
        %% get distance to obstacles
        dist_obstacles = getDistanceToObstcls(h);
        
        %% get angles to obstacles
        psi_obs = (ROBOT_PROXIMITY_SENSORS_DIRECTIONS+current_angle);
        
        %% calculate attractor contribution
        delta_phi_attr = getAttractorContribution(current_angle, angle_dist_tar(1));
        
        %% calculate repellor contribution
        delta_phi_repellors = getRepellorsContribution(dist_obstacles,psi_obs,current_angle);
        
        %% calculate joint attractor+repellor contribution
        delta_phi=delta_phi_attr+delta_phi_repellors;
        
        %% calculate speed
        %delta_phi_attr
        right_left_vel = getVelocities(delta_phi);
        
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

function delta_pos = getDeltaPositionAllo(oldpos_pul, newpos_pul, current_ang)
    DISTANCE_BTW_WHEELS = 53.0;
    delta_disp = newpos_pul-oldpos_pul;
    delta_disp_mm = [delta_disp(1)*0.13;delta_disp(2)*0.13]; %%0.13pul = 1mm
    
    delta_ang=((delta_disp_mm(2)-delta_disp_mm(1))/DISTANCE_BTW_WHEELS);

    %% chekc if moving straight
    if(delta_disp(1)==delta_disp(2))
      allo_loc = [delta_disp_mm(1)*cos(current_ang), delta_disp_mm(1)*(sin(current_ang))];
      
      delta_pos = [allo_loc(1), allo_loc(2), 0];
      return;
    end
    
    radius= ((((delta_disp_mm(1)+delta_disp_mm(2))/2.0)*DISTANCE_BTW_WHEELS)/(delta_disp_mm(2)-delta_disp_mm(1)));
    xego = radius*sin(delta_ang);
    yego = radius*(1-cos(delta_ang));
    xallo=xego*cos(current_ang)-yego*sin(current_ang);
    yallo=xego*sin(current_ang)+yego*cos(current_ang);

    delta_pos = [xallo, yallo, delta_ang];
end

function [angle,dist] = getAngleAndDistanceTarget(target,current_pos)
    a = target(1)-current_pos(1); % a side of the triangle
    b = target(2)-current_pos(2); % b side of the triangle
    dist = sqrt(power(a,2)+power(b,2));
    
    angle = atan2(b,a);
end

function delta_phi_attr = getAttractorContribution(current_angle, target_angle)
    %%lambda value ? 0.5
    delta_phi_attr = -2.0*sin(current_angle-target_angle);
end

function right_left_velocity = getVelocities(delta_phi)
    DISTANCE_BTW_WHEELS = 53.0;
    DELTA_T = 0.3;
    arc_len_r = delta_phi*DISTANCE_BTW_WHEELS/2; %%mm
    arc_len_l = -delta_phi*DISTANCE_BTW_WHEELS/2;
    
    %%include delta t 0.2??
    
    right_left_velocity = [arc_len_r/DELTA_T;arc_len_l/DELTA_T];
end

function distances_obstcl = getDistanceToObstcls(h)
    CALIBRATION_VALUES=[3500,3;3900,3;3700,3;3900,3;3900,3;4000,3;4000,3;4000,3];
    distances_obstcl = zeros(1,8);
    
    sensors_output = kProximity(h);
    for i=1:1:8
        range = CALIBRATION_VALUES(i,:);
        
        norm_proximity=(sensors_output(i)-range(2))/(range(1)-range(2));
        %proximity_cm =-1.3*log(normalizedValue)-1.3;
        distances_obstcl(1,i)=-1.3*log(norm_proximity)-1.3;
    end
end

function delta_phi_repellors = getRepellorsContribution(dist_obs, psi_obs, current_angle)
    BETA_1=8.6;
    BETA_2=6.2;
    delta_theta = degtorad(60); %%% ?
    DISTANCE_BTW_WHEELS = 53.0;

    %% calculate strength of repulsion
    lambda_obs = zeros(1,8);
    for i=1:1:8
        lambda_obs(i) =  BETA_1 * exp(-dist_obs(i) / BETA_2 );
    end
    %lambda_obs
    %sigma_obs = atan( (tan( delta_theta)/2) + (DISTANCE_BTW_WHEELS/2./ ( dist_obs + DISTANCE_BTW_WHEELS/2)));
    zeta = current_angle-psi_obs; 
    delta_phi_obs =  lambda_obs .* zeta .* exp(-(zeta.^2)./ (2 * (delta_theta^2)));
    
    delta_phi_repellors=sum(delta_phi_obs);
end
