function Abs = ipRGC_max_design(ipRGC_max_LED)
gamma=readmatrix("gamma.csv");
LED_stimulus_spectral_intensity=readmatrix("LED_stimulus_spectral_intensity.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
max_gamma=zeros([1 22]);
for i=1:22
    max_gamma(i)=100*((ipRGC_max_LED(i)/100)^gamma(i));%gamma変換をする
end
max_sum_energy=zeros([1 391]);
for i=1:391
    for j=1:22
        max_sum_energy(i)=max_sum_energy(i)+max_gamma(j)*LED_stimulus_spectral_intensity(j,i)/100;%分光分布を求める
    end
end
ipRGC_max_out=0;
for i=1:391
    ipRGC_max_out=ipRGC_max_out+max_sum_energy(i)*ipRGC_sens(i);%分光分布とipRGC感度の積をとることで、ipRGCの大きさを求める、最小の時も同様にする。
end
Abs=-ipRGC_max_out;
end