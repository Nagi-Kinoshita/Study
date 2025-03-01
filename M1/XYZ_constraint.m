function [c,ceq] = XYZ_constraint(LED_stim)
    c=0;
    XYZ_object=readmatrix('XYZ_value.csv');
    lum_object=readmatrix('lum_obj.csv');
    XYZlum_out=calculate_X_Y_Z_lum(LED_stim);
    ceq(1)=(XYZ_object(1)-XYZlum_out(1))^2+(XYZ_object(2)-XYZlum_out(2))^2+(XYZ_object(3)-XYZlum_out(3))^2+(lum_object-XYZlum_out(4))^2;
end