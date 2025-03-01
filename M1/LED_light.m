function Residual = LED_light(EEW)
format long
gamma=readmatrix("gamma.csv");
LED_stim=readmatrix("LED_stimulus_spectral_intensity.csv");
Target_Energy=readmatrix("Target_Energy.csv");
gamma_correction_strength=zeros([1 26]);
for i=1:26
    gamma_correction_strength(i)=100*(EEW(i)/100)^gamma(i);
end
equal_energy_stim=zeros([1 391]);
for i=1:391
    for j=1:26
        equal_energy_stim(i)=equal_energy_stim(i)+gamma_correction_strength(j)*LED_stim(j,i)/10;
    end
end
Residual=0;
for i=1:391
    Residual=Residual+(Target_Energy(i)-equal_energy_stim(i))^2;
end
end