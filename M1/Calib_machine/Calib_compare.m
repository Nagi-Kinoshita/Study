clear
Calib_SR5000=readmatrix("Calib_SR5000.csv");
Calib_specbos=readmatrix("Calib_specbos.csv");
    for j=1:391
        SR5000_white(j)=Calib_SR5000(1,j);
        specbos_white(j)=Calib_specbos(1,j);
        mag_white(j)=SR5000_white(j)/specbos_white(j);
    end
writematrix(mag_white,"SR5000_divide_specbos_from_white.csv");
lambda=390:1:780;
plot(lambda,SR5000_white);
hold on
plot(lambda,specbos_white);
title("Calib EEW");
legend('SR5000','specbos','location','northwest')
xlim([390 780])
hold off
saveas(gcf,"White_stim.png");


for i=2:11
    for j=1:391
        SR5000_spectrum(j)=Calib_SR5000(i,j);
        specbos_spectrum(j)=Calib_specbos(i,j);
        SR5000_from_specbos(j)=specbos_spectrum(j)*mag_white(j);
    end
    plot(lambda,SR5000_spectrum);
    hold on
    plot(lambda,SR5000_from_specbos);
    title(i+" from white")
    legend('SR5000','SR5000 from specbos','location','northwest')
    xlim([390 780])
    hold off
    saveas(gcf,i+"_from_white.png");   
end

for i=2:11
    for j=1:391
        SR5000_spectrum(j)=Calib_SR5000(i,j);
        specbos_spectrum(j)=Calib_specbos(i,j);
        mag(i-1,j)=SR5000_spectrum(j)/specbos_spectrum(j);
    end
end
mag_ave=zeros([1 391]);
for i=1:10
    for j=1:391
        mag_ave(j)=mag_ave(j)+mag(i,j)/10;
    end
end
writematrix(mag,"SR5000_divide_specbos_from_some_color.csv");
lanbda=390:1:780;
for i=2:11
    for j=1:391
        SR5000_spectrum(j)=Calib_SR5000(i,j);
        specbos_spectrum(j)=Calib_specbos(i,j);
        SR5000_from_specbos(j)=specbos_spectrum(j)*mag_ave(j);
    end
    plot(lambda,SR5000_spectrum);
    hold on
    plot(lambda,SR5000_from_specbos);
    title(i+" from some color")
    legend('SR5000','SR5000 from specbos','location','northwest')
    xlim([390 780])
    hold off
    saveas(gcf,i+"_from_some_color.png");   
end

for i=1:201
    mag_comb(i)=mag_white(i);
end

for i=202:391
    mag_comb(i)=mag_ave(i);
end

writematrix(mag_comb,"mag_comb.csv")

for i=2:11
    for j=1:391
        SR5000_spectrum(j)=Calib_SR5000(i,j);
        specbos_spectrum(j)=Calib_specbos(i,j);
        SR5000_from_specbos(j)=specbos_spectrum(j)*mag_comb(j);
    end
    plot(lambda,SR5000_spectrum);
    hold on
    plot(lambda,SR5000_from_specbos);
    title(i+" from comb")
    legend('SR5000','SR5000 from specbos','location','northwest')
    xlim([390 780])
    hold off
    saveas(gcf,i+"_from_comb.png");   
end
