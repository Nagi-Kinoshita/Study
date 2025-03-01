LED_40_stim=readmatrix('exp2_spectrum.csv');

L_sens=readmatrix("L_sens.csv");
Spectrum_dist=zeros([1 391]);
Spectrum_sens=zeros([1 391]);
for i=1:391
    Spectrum_dist(i)=LED_40_stim(1,i);
    Spectrum_sens(i)=L_sens(i);
end
x=(390:1:780);
plot(x,Spectrum_dist,'LineWidth',2.5);
xlabel('波長','FontSize',14)
axis([390 780 0 0.025])
saveas(gcf,'Spectrum.png');
plot(x,Spectrum_sens,'LineWidth',2.5);
xlabel('波長','FontSize',14)
axis([390 780 -0.1 1.1])
saveas(gcf,'L_sens.png')