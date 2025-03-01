function S_M_L_Rod_ipRGC_out=calculate_cell_out(LED_stim)
gamma=readmatrix("gamma.csv");
LED_stimulus_spectral_intensity=readmatrix("LED_stimulus_spectral_intensity.csv");
S_sens=readmatrix("S_sens.csv");
M_sens=readmatrix("M_sens.csv");
L_sens=readmatrix("L_sens.csv");
Rod_sens=readmatrix("Rod_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
LED_stim_gamma=zeros([1 22]);
for i=1:22
    LED_stim_gamma(i)=100*((LED_stim(i)/100)^gamma(i));%gamma変換をする。
end
LED_stim_sum=zeros([1 391]);
for i=1:391
    for j=1:22
        LED_stim_sum(i)=LED_stim_sum(i)+LED_stim_gamma(j)*LED_stimulus_spectral_intensity(j,i)/100;%390nm~780nmの分光分布を求める。
    end
end
S_M_L_Rod_ipRGC_out(1)=0;
S_M_L_Rod_ipRGC_out(2)=0;
S_M_L_Rod_ipRGC_out(3)=0;
S_M_L_Rod_ipRGC_out(4)=0;
S_M_L_Rod_ipRGC_out(5)=0;
for i=1:391
    S_M_L_Rod_ipRGC_out(1)=S_M_L_Rod_ipRGC_out(1)+LED_stim_sum(i)*S_sens(i);%分光分布と錐体感度の積をとることで、錐体反応の大きさを求める。
    S_M_L_Rod_ipRGC_out(2)=S_M_L_Rod_ipRGC_out(2)+LED_stim_sum(i)*M_sens(i);
    S_M_L_Rod_ipRGC_out(3)=S_M_L_Rod_ipRGC_out(3)+LED_stim_sum(i)*L_sens(i);
    S_M_L_Rod_ipRGC_out(4)=S_M_L_Rod_ipRGC_out(4)+LED_stim_sum(i)*Rod_sens(i);
    S_M_L_Rod_ipRGC_out(5)=S_M_L_Rod_ipRGC_out(5)+LED_stim_sum(i)*ipRGC_sens(i);
end
end