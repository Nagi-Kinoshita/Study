LED_8_stim=readmatrix('LED_8_intensity.csv');
for i=1:8
    for j=1:32
        LED_stim(j)=LED_8_stim(i,j);
    end
    S_M_L_Rod_ipRGC_out=calculate_cell_out(LED_stim);
    X_Y_Z_lum=calculate_X_Y_Z_lum(LED_stim);
    S_out(i)=S_M_L_Rod_ipRGC_out(1);
    M_out(i)=S_M_L_Rod_ipRGC_out(2);
    L_out(i)=S_M_L_Rod_ipRGC_out(3);
    ipRGC_out(i)=S_M_L_Rod_ipRGC_out(5);
    X(i)=X_Y_Z_lum(1);
    Y(i)=X_Y_Z_lum(2);
    Z(i)=X_Y_Z_lum(3);
    Lum(i)=X_Y_Z_lum(4);
end
