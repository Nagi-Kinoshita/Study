function diff=Y_constraint(LED_stim)
%Y=readmatrix('Y.csv');
XYZ=calculate_X_Y_Z(LED_stim);
%diff=(Y-XYZ(2))^2;
diff=-XYZ(2);
end