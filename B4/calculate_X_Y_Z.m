function X_Y_Z_out=calculate_X_Y_Z(LED_stim)
gamma=readmatrix("gamma.csv");
LED_stimulus_spectral_intensity=readmatrix("LED_stimulus_spectral_intensity.csv");
XYZ_sens=readmatrix('XYZ_sens.csv');
X_sens=zeros([1 391]);
Y_sens=zeros([1 391]);
Z_sens=zeros([1 391]);
for i=1:391
    X_sens(i)=XYZ_sens(1,i);
    Y_sens(i)=XYZ_sens(2,i);
    Z_sens(i)=XYZ_sens(3,i);
end
LED_stim_gamma=zeros([1 22]);
for i=1:22
    LED_stim_gamma(i)=100*((LED_stim(i)/100)^gamma(i));%gamma補正する
end
LED_stim_sum=zeros([1 391]);
for i=1:391
    for j=1:22
        LED_stim_sum(i)=LED_stim_sum(i)+LED_stim_gamma(j)*LED_stimulus_spectral_intensity(j,i)/100;%分光分布を求める
    end
end
X_Y_Z_out(1)=0;
X_Y_Z_out(2)=0;
X_Y_Z_out(3)=0;
for i=1:391
    X_Y_Z_out(1)=X_Y_Z_out(1)+LED_stim_sum(i)*X_sens(i);%分光分布と等色関数の積をとることでX、Y、Zの大きさを求める
    X_Y_Z_out(2)=X_Y_Z_out(2)+LED_stim_sum(i)*Y_sens(i);
    X_Y_Z_out(3)=X_Y_Z_out(3)+LED_stim_sum(i)*Z_sens(i);
end
end