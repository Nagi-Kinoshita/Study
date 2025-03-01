function diff = perfect(LED_intensity)
cell_calc=calculate_cell_out(LED_intensity);

ipRGC_obj=readmatrix('ipRGC_object.csv');

diff=(cell_calc(5)-ipRGC_obj)^2;
end