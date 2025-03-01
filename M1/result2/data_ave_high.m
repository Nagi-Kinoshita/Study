function ave = data_ave_high(Directory_name)
originalDir = pwd;

cd(Directory_name);
files = dir('./*.csv');
file_name_cell_array={files.name};
FileName=char(file_name_cell_array(1));
data1=readmatrix(FileName);
FileName=char(file_name_cell_array(3));
data2=readmatrix(FileName);
FileName=char(file_name_cell_array(5));
data3=readmatrix(FileName);
FileName=char(file_name_cell_array(7));
data4=readmatrix(FileName);
ave=(data1+data2+data3+data4)/4;


cd(originalDir);

Lum=406.8643;
color_lum_high=readmatrix('data/LED_lum_data_high.csv');
ipRGC_high=readmatrix("data/ipRGC_high.csv");
color_all=readmatrix("data/color_all.csv");
for i=1:5
    for j=1:3
        color_high(i,j)=color_all(i+3,j)/255;
    end
end

for i=1:25
    lum_mag_high(i)=(Lum*ave(i))/color_lum_high(i);
end
for i=1:5
    for j=1:5
        x(j,1)=ipRGC_high(i,j);
        y(j,1)=lum_mag_high((i-1)*5+j);
    end
    X=[x ones(length(x),1)];
    b=regress(y,X);
    slope(i)=b(1);
end
hue=[135 180 225 270 315];
b=bar(hue,slope);
b.FaceColor = 'flat';
for i=1:5
    for j=1:3
        color(j)=color_high(i,j);
    end
    b.CData(i,:) = color;
end

Name=Directory_name+"のipRGC指数";
title(Name)
xlabel('色相(degree)','FontSize',14);
ylabel('ipRGC指数','FontSize',14);
filename=Name+'135~315.png';
saveas(gcf,filename);
end