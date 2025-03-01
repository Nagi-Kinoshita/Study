%{
function diff = XYZ_constraint(LED_stim)
    XYZ_object=readmatrix('XYZ_value.csv');
    XYZ_out=calculate_X_Y_Z(LED_stim);
    diff=(XYZ_object(1)-XYZ_out(1))^2+(XYZ_object(2)-XYZ_out(2))^2+(XYZ_object(3)-XYZ_out(3))^2;
end
%}

function [c,ceq] = XYZ_constraint(LED_stim)
    c=0;
    XYZ_object=readmatrix('XYZ_value.csv');
    XYZ_out=calculate_X_Y_Z(LED_stim);
    ceq(1)=(XYZ_object(1)-XYZ_out(1))^2+(XYZ_object(2)-XYZ_out(2))^2+(XYZ_object(3)-XYZ_out(3))^2;
end