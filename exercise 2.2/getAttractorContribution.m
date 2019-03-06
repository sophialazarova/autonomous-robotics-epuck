function delta_phi_attr = getAttractorContribution( current_angle, target_angle )
% GETATTRACTORCONTRIBUTION Calculates the attractor contribution to the
% dynamical system.
% 
% delta_phi_attr = GETATTRACTORCONTRIBUTION(current_angle, target_angle)
% @PARAM
% current_angle - current angle(orientation) of the
% robot.
% target_angle - angle to target.
% @RETURN
% delta_phi_attr - attractor contribution.
    %%lambda value ? 0.5
    delta_phi_attr = -2.0*sin(current_angle-target_angle);
end

