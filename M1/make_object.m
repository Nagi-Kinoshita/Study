function diff = make_object(LED_intensity)
XYZ=calculate_X_Y_Z(LED_intensity);
XYZ_object=readmatrix('XYZ_value.csv');
diff=((XYZ(1)-XYZ_object(1))^2)+((XYZ(2)-XYZ_object(2))^2)+((XYZ(3)-XYZ_object(3))^2);
end