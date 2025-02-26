function diff = LED_to_energy(LED_intensity)
    diff=0;
    LED_standard=readmatrix('energy_sum.csv');
    gamma=readmatrix("gamma.csv");
    LED_stimulus_spectral_intensity=readmatrix("LED_stimulus_spectral_intensity.csv");
    LED_intensity_gamma=zeros([1 32]);
    for i=1:32
        LED_intensity_gamma(i)=100*((LED_intensity(i)/100)^gamma(i));
    end
    LED_sum=zeros([1 391]);
    for i=1:391
        for j=1:32
            LED_sum(i)=LED_sum(i)+LED_intensity_gamma(j)*LED_stimulus_spectral_intensity(j,i)/100;
        end
        diff=diff+(LED_standard(i)-LED_sum(i))^2;
    end
end