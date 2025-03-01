function [c,ceq] = XYZ_constraint(LED_stim)
    c=0;
    XYZ_object=readmatrix('object_XYZ.csv');
    XYZ_sens=readmatrix("")
    ceq(1)=(XYZ_object(1)-XYZlum_out(1))^2+(XYZ_object(2)-XYZlum_out(2))^2+(XYZ_object(3)-XYZlum_out(3))^2+(lum_object-XYZlum_out(4))^2;
end