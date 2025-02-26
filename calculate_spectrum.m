LED_spectrum=readmatrix('LED_high_stim_spectrum.csv');
LED_20_stim=readmatrix("LED_high_stim.csv");
gamma=readmatrix('gamma.csv');
LED_stimulus_spectral_intensity=readmatrix("LED_stimulus_spectral_intensity.csv");
LED_stim=zeros([1 26]);
LED_stim_gamma=zeros([1 26]);
x=390:1:780;
spectrum=zeros([20 391]);
for i=1:20
    calib_spectrum=zeros([1 391]);
    for j=1:26
        LED_stim(j)=LED_20_stim(i,j);
        LED_stim_gamma(j)=100*((LED_stim(j)/100)^gamma(j));
    end
    for j=1:391
        for k=1:26
            spectrum(i,j)=spectrum(i,j)+LED_stim_gamma(k)*LED_stimulus_spectral_intensity(k,j)/10;
        end
        calib_spectrum(j)=LED_spectrum(i,j);
    end
    %{
    plot(x,spectrum)
    hold on
    plot(x,calib_spectrum)
    legend("設計値","測光値")
    filename="i="+i+".png";
    saveas(gcf,filename);
    hold off
    %}
end
lb=zeros([1 26]);
ub=ones([1 26])*20;
middle=ones([1 26])*3;
All_stim=zeros([25 26]);
object_spectrum_all=zeros([25 391]);
for i=1:5
    low1_spectrum=zeros([1 391]);
    low2_spectrum=zeros([1 391]);
    mid3_spectrum=zeros([1 391]);
    high4_spectrum=zeros([1 391]);
    high5_spectrum=zeros([1 391]);
    for j=1:391
        low1_spectrum(j)=spectrum(4*(i-1)+1,j);
        object_spectrum_all(5*(i-1)+1,j)=spectrum(4*(i-1)+1,j);
        high5_spectrum(j)=spectrum(4*(i-1)+4,j);
        object_spectrum_all(5*(i-1)+5,j)=spectrum(4*(i-1)+4,j);
    end
    for j=1:26
        ALL_stim(5*(i-1)+1,j)=LED_20_stim(4*(i-1)+1,j);
        ALL_stim(5*(i-1)+5,j)=LED_20_stim(4*(i-1)+4,j);
    end
    low2_spectrum=low1_spectrum+(high5_spectrum-low1_spectrum)/4;
    for j=1:391
        object_spectrum_all(5*(i-1)+2,j)=low2_spectrum(j);
    end
    writematrix(low2_spectrum,"object_spectrum.csv");
    LED_stim=fmincon(@spectrum2LED,middle,[],[],[],[],lb,ub);
    for j=1:26
        ALL_stim(5*(i-1)+2,j)=LED_stim(j);
    end

    mid3_spectrum=low1_spectrum+(high5_spectrum-low1_spectrum)*2/4;
    for j=1:391
        object_spectrum_all(5*(i-1)+3,j)=mid3_spectrum(j);
    end
    writematrix(mid3_spectrum,"object_spectrum.csv");
    LED_stim=fmincon(@spectrum2LED,middle,[],[],[],[],lb,ub);
    for j=1:26
        ALL_stim(5*(i-1)+3,j)=LED_stim(j);
    end

    high4_spectrum=low1_spectrum+(high5_spectrum-low1_spectrum)*3/4;
    for j=1:391
        object_spectrum_all(5*(i-1)+4,j)=high4_spectrum(j);
    end
    writematrix(high4_spectrum,"object_spectrum.csv");
    LED_stim=fmincon(@spectrum2LED,middle,[],[],[],[],lb,ub);
    for j=1:26
        ALL_stim(5*(i-1)+4,j)=LED_stim(j);
    end
end
writematrix(ALL_stim,"ALL_stim_high.csv");
writematrix(object_spectrum_all,"object_spectrum_high.csv");