function diff = XYZ_constraint2(LED_stim)
    XYZ_object=readmatrix('XYZ_value.csv');
    lum_object=readmatrix('lum_obj.csv');
    XYZlum_out=calculate_X_Y_Z_lum(LED_stim);
    diff=(XYZ_object(1)-XYZlum_out(1))^2+(XYZ_object(2)-XYZlum_out(2))^2+(XYZ_object(3)-XYZlum_out(3))^2+(lum_object-XYZlum_out(4))^2;
end