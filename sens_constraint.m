function diff = sens_constraint(LED_intensity)
LED_cell_out=calculate_cell_out(LED_intensity);
cell_object=readmatrix('cell_object.csv');
diff=(LED_cell_out(1)-cell_object(1))^2+(LED_cell_out(2)-cell_object(2))^2+(LED_cell_out(3)-cell_object(3))^2;
end