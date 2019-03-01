function delta_phi_attr = getAttractorContribution( current_angle, target_angle )
    %%lambda value ? 0.5
    delta_phi_attr = -4.0*sin(current_angle-target_angle);
end

