function S_M_L_Rod_ipRGC_out=calculate_cell_out(LED_stim)
S_sens=readmatrix("S_sens.csv");
M_sens=readmatrix("M_sens.csv");
L_sens=readmatrix("L_sens.csv");
Rod_sens=readmatrix("Rod_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
ALL_coefficient_multi=readmatrix("ALL_coefficient_multi4.csv");
LED_stim_one=[LED_stim 1];
spectrum=LED_stim_one*(ALL_coefficient_multi');

S_M_L_Rod_ipRGC_out(1)=0;
S_M_L_Rod_ipRGC_out(2)=0;
S_M_L_Rod_ipRGC_out(3)=0;
S_M_L_Rod_ipRGC_out(4)=0;
S_M_L_Rod_ipRGC_out(5)=0;
for i=1:391
    S_M_L_Rod_ipRGC_out(1)=S_M_L_Rod_ipRGC_out(1)+spectrum(i)*S_sens(i);%分光分布と錐体感度の積をとることで、錐体反応の大きさを求める。
    S_M_L_Rod_ipRGC_out(2)=S_M_L_Rod_ipRGC_out(2)+spectrum(i)*M_sens(i);
    S_M_L_Rod_ipRGC_out(3)=S_M_L_Rod_ipRGC_out(3)+spectrum(i)*L_sens(i);
    S_M_L_Rod_ipRGC_out(4)=S_M_L_Rod_ipRGC_out(4)+spectrum(i)*Rod_sens(i);
    S_M_L_Rod_ipRGC_out(5)=S_M_L_Rod_ipRGC_out(5)+spectrum(i)*ipRGC_sens(i);
end
end