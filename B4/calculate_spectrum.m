%LED_intensity_scale_all=readmatrix('LED_intensity_scale_all.csv');
LED_intensity_scale_all=readmatrix('LED_8_times_5_intensity_ipRGC.csv');
gamma=readmatrix('gamma.csv');
LED_stimulus_spectral_intensity=readmatrix("LED_stimulus_spectral_intensity.csv");
LED_stim=zeros([1 22]);
LED_stim_gamma=zeros([1 22]);
spectrum=zeros([40 391]);
%spectrum=zeros([1 391]);
XYZ=zeros([1 3]);
XYZ_all=zeros([3 8]);
for i=1:40
    for j=1:22
        LED_stim(j)=LED_intensity_scale_all(i,j);
        LED_stim_gamma(j)=100*((LED_stim(j)/100)^gamma(j));
    end
    for j=1:391
        for k=1:22
            spectrum(i,j)=spectrum(i,j)+LED_stim_gamma(k)*LED_stimulus_spectral_intensity(k,j)/100;
        end
    end
    XYZ=calculate_X_Y_Z(LED_stim);
    XYZ_all(1,i)=XYZ(1);
    XYZ_all(2,i)=XYZ(2);
    XYZ_all(3,i)=XYZ(3);
end
writematrix(spectrum,'40_stim_spectrum.csv');
%LED_stim=readmatrix('memo.csv');
%{
LED_stim=readmatrix('Equal_energy_white.csv');
for j=1:22
    LED_stim_gamma(j)=100*((LED_stim(j)/100)^gamma(j));
end
for j=1:391
    for k=1:22
        spectrum(j)=spectrum(j)+LED_stim_gamma(k)*LED_stimulus_spectral_intensity(k,j)/100;
    end
end
writematrix(spectrum,'memo.csv');
%} 