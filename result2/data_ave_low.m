function ave = data_ave_low(Directory_name)

originalDir = pwd;

cd(Directory_name);
files = dir('./*.csv');
file_name_cell_array={files.name};
FileName=char(file_name_cell_array(2));
data1=readmatrix(FileName);
FileName=char(file_name_cell_array(4));
data2=readmatrix(FileName);
FileName=char(file_name_cell_array(6));
data3=readmatrix(FileName);
FileName=char(file_name_cell_array(8));
data4=readmatrix(FileName);
ave=(data1+data2+data3+data4)/4;


cd(originalDir);

Lum=406.8643;
color_lum_low=readmatrix('data/LED_lum_data_low.csv');
ipRGC_low=readmatrix("data/ipRGC_low.csv");
color_all=readmatrix("data/color_all.csv");
for i=1:4
    for j=1:3
        color_low(i,j)=color_all(i,j)/255;
    end
end
for j=1:3
    color_low(5,j)=color_all(8,j)/255;
end

for i=1:25
    lum_mag_low(i)=(Lum*ave(i))/color_lum_low(i);
end

for i=1:5
    for j=1:5
        x(j,1)=ipRGC_low(i,j);
        y(j,1)=lum_mag_low((i-1)*5+j);
    end
    X=[x ones(length(x),1)];
    b=regress(y,X);
    slope(i)=b(1);
end
hue=[0 45 90 135 315];
b=bar(hue,slope);
b.FaceColor = 'flat';
for i=1:5
    for j=1:3
        color(j)=color_low(i,j);
    end
    b.CData(i,:) = color;
end
x=x+1;
Name=Directory_name+"のipRGC指数";
title(Name)
xlabel('色相(degree)','FontSize',14);
ylabel('ipRGC指数','FontSize',14);
filename=Name+'-45~135.png';
saveas(gcf,filename);
end



