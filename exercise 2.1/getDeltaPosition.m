function delta_pos = getDeltaPosition( oldpos_pul, newpos_pul, current_ang )
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

