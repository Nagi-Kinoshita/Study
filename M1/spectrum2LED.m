function diff=spectrum2LED(LED_stim)
    diff=0;
    spectrum=zeros([1 391]);
    gamma=readmatrix('gamma.csv');
    LED_stimulus_spectral_intensity=readmatrix("LED_stimulus_spectral_intensity.csv");
    object_spectrum=readmatrix("object_spectrum.csv");
    for j=1:26
        LED_stim_gamma(j)=100*((LED_stim(j)/100)^gamma(j));
    end
    for j=1:391
        for k=1:26
            spectrum(j)=spectrum(j)+LED_stim_gamma(k)*LED_stimulus_spectral_intensity(k,j)/10;
        end
        diff=diff+(object_spectrum(j)-spectrum(j))^2;
    end
end