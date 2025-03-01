function luminance = calculate_lum(LED_stim)
gamma=readmatrix("gamma.csv");
LED_stimulus_spectral_intensity=readmatrix("LED_stimulus_spectral_intensity.csv");
lum_sens=readmatrix("luminance.csv");
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
luminance=0;
for i=1:391
    luminance=luminance+LED_stim_sum(i)*lum_sens(i);
end
end