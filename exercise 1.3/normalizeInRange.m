function normalized_value = normalizeInRange( value, range )
% NORMALIZEINRANGE Normalizes a value in the range [0,1] using a given a range of possible original values.
% 
% normalized_value = NORMALIZEINRANGE(value, range)
% @PARAM
% value - value to be normalized
% range - original range of possible values.
% @RETURN
% normalized_value - normalized value in the range [0,1] where 0 corresponds to the lowest possible value
% in the original range and 1 corresponds to the highest possible value in the original range.
    normalized_value=(value-range(2))/(range(1)-range(2));
end

