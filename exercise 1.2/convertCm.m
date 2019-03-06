function cm_value = convertCm( norm_value )
% CONVERTCM Converts given normalized sensor value into distance in cm. 
% 
% cm_value = CONVERTCM(norm_value)
% @PARAM
% norm_value - normalized sensor value which stands for proximity to
% object.
% @RETURN
% cm_value - converted distance to object in cm.
    cm_value=-1.3*log(norm_value)-1.3;
end

