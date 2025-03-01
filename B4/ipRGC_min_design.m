function Abs = ipRGC_min_design(ipRGC_min_LED)
gamma=readmatrix("gamma.csv");
LED_stimulus_spectral_intensity=readmatrix("LED_stimulus_spectral_intensity.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
min_gamma=zeros([1 22]);
for i=1:22
    min_gamma(i)=100*((ipRGC_min_LED(i)/100)^gamma(i));
end
min_sum_energy=zeros([1 391]);
for i=1:391
    for j=1:22
        min_sum_energy(i)=min_sum_energy(i)+min_gamma(j)*LED_stimulus_spectral_intensity(j,i)/100;
    end
end
ipRGC_min_out=0;
for i=1:391
    ipRGC_min_out=ipRGC_min_out+min_sum_energy(i)*ipRGC_sens(i);
end
Abs=ipRGC_min_out;
end