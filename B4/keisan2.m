LED_stim=zeros([1 22]);
%LED_8_stim=readmatrix('LED_intensity_scale_all.csv');
%LED_8_stim=readmatrix('LED_intenisty_scale_all_new.csv');
%LED_8_stim=readmatrix('8_all_spectrum.csv');
LED_8_stim=readmatrix('ipRGC_48.csv');
cell_out=zeros([8 5]);
X_Y_Z_out=zeros([8 3]);
for i=1:8
    for j=1:22
        LED_stim(j)=LED_8_stim(i,j);
    end
    S_M_L_Rod_ipRGC_out=calculate_cell_out(LED_stim);
    X_Y_Z=calculate_X_Y_Z(LED_stim);
    for j=1:5
        cell_out(i,j)=S_M_L_Rod_ipRGC_out(j);
    end
    for j=1:3
        X_Y_Z_out(i,j)=X_Y_Z(j);
    end
end