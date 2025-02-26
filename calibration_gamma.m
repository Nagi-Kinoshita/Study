clear
s=serialport("COM3",460800);
configureTerminator(s,"CR");
LED_intensity=[10 40 70 100];
All_Rad=zeros([96 391]);
for i=1:24
    LED_stim=zeros([1 24]);
    for j=1:4
        LED_stim(i)=LED_intensity(j);
        ASCII=make_ASCII(LED_stim);
        writeline(s,ASCII);
        [CIEXY CIEUV Luminance Lambda Radiance irrad] = SpectroCALMakeSPDMeasurement("COM4",390, 780, 1, 1000, 5);
        All_Rad(4*(i-1)+j,:)=Radiance;
    end
end
%writematrix(All_Rad,"All_Rad.csv");