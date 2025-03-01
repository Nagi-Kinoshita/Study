LED_stim=readmatrix("ALL_stim_low2.csv");
object_spectrum=readmatrix("object_spectrum_low.csv");
calib_spectrum=readmatrix("Low_stim_spectrum2.csv");
gamma=readmatrix('gamma.csv');
LED_stimulus_spectral_intensity=readmatrix("LED_stimulus_spectral_intensity.csv");
spectrum_from_LED=zeros([25 391]);

for i=1:25
    for j=1:26
        LED_stim(j)=LED_stim(i,j);
        LED_stim_gamma(j)=100*((LED_stim(j)/100)^gamma(j));
    end
    for j=1:391
        for k=1:26
            spectrum_from_LED(i,j)=spectrum_from_LED(i,j)+LED_stim_gamma(k)*LED_stimulus_spectral_intensity(k,j)/10;
        end
    end
end
x=390:1:780;
spectrum=zeros([1 391]);
for i=1:5
    number=i;
    if i==5
        number=8;
    end
    for j=1:5
        for k=1:391
            spectrum(k)=object_spectrum(5*(i-1)+j,k);
        end
        plot(x,spectrum)
        hold on
    end
    titlename=(number-1)*45+"degree";
    title(titlename)
    xlabel("波長")
    legend("Low","Middle-low","Middle","Middle-high","High");
    filename="object_spectrum_"+(number-1)*45+"degree.png";
    saveas(gcf,filename);
    hold off

    for j=1:5
        for k=1:391
            spectrum(k)=spectrum_from_LED(5*(i-1)+j,k);
        end
        plot(x,spectrum)
        hold on
    end
    titlename=(number-1)*45+"degree";
    title(titlename)
    xlabel("波長")
    legend("Low","Middle-low","Middle","Middle-high","High");
    filename="LED_to_spectrum_"+(number-1)*45+"degree.png";
    saveas(gcf,filename);
    hold off

    for j=1:5
        for k=1:391
            spectrum(k)=calib_spectrum(5*(i-1)+j,k);
        end
        plot(x,spectrum)
        hold on
    end
    titlename=(number-1)*45+"degree";
    title(titlename)
    xlabel("波長")
    legend("Low","Middle-low","Middle","Middle-high","High");
    filename="calib_spectrum_"+(number-1)*45+"degree.png";
    saveas(gcf,filename);
    hold off 
end

%{
for i=1:25
    for k=1:391
        spectrum(k)=object_spectrum(i,k);
    end
    plot(x,spectrum)
    hold on
    for k=1:391
        spectrum(k)=spectrum_from_LED(i,k);
    end
    plot(x,spectrum)
    hold on
    for k=1:391
        spectrum(k)=calib_spectrum(i,k);
    end
    plot(x,spectrum)
    xlabel("波長")
    legend("目標分光分布","LED入力から求めた分光分布","測光値");
    filename=i+".png";
    saveas(gcf,filename);
    hold off 
end
%}
