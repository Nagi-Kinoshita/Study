Name="Nakajima";
files = dir('./*.csv');
file_name_cell_array={files.name};
separator='';
color_lum=readmatrix('LED_lum_data.csv');
FileName=char(file_name_cell_array(2));
data1=readmatrix(FileName);
FileName=char(file_name_cell_array(3));
data2=readmatrix(FileName);
FileName=char(file_name_cell_array(4));
data3=readmatrix(FileName);
FileName=char(file_name_cell_array(5));
data4=readmatrix(FileName);
data_ave=(data1+data2+data3+data4)/4;
H_K=zeros([8 5]);
mag=zeros([8 2]);
abs=zeros([8 2]);
diff=zeros([8 2]);
x=[0.8;0.9;1;1.1;1.2];
y=zeros([5 1]);
Rsq=zeros([1 8]);
Rsq2=zeros([1 8]);
Rsq3=zeros([1 8]);
lum_mag=zeros([1 40]);
color_all=readmatrix("color_all.csv");
color=zeros([1 3]);
for i=1:40
    lum_mag(i)=(150*data_ave(i))/color_lum(i);
    lum_mag1(i)=(150*data1(i))/color_lum(i);
    lum_mag2(i)=(150*data2(i))/color_lum(i);
    lum_mag3(i)=(150*data3(i))/color_lum(i);
    lum_mag4(i)=(150*data4(i))/color_lum(i);
end
for i=1:40
    [syou,amari]=quorem(sym(i-1),sym(5));
    H_K(syou+1,amari+1)=lum_mag(i);
end
writematrix(H_K,'lum_mag.csv');
for i=1:8
for j=1:5
    y(j,1)=lum_mag(5*(i-1)+j);
end
X=[ones(length(x),1) x];
b=X\y;
mag(i,1)=b(2);
mag(i,2)=b(1);
yCalc2 = X*b;
for j=1:3
    color(j)=color_all(i,j)/255;
end
scatter(x,y,'Color',color)
hold on
plot(x,yCalc2,'Color',color)
titlename=strjoin(["mag_",num2str(45*i),'deg'],separator);
title(titlename);
xlabel('mag');
ylabel('P',"Rotation",0);
filename=strjoin(["mag_ave_",num2str(45*i),'deg.png'],separator);
saveas(gcf,filename);
hold off
Rsq(i) = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);
end
filename=strjoin(['equation_mag_',Name,'.csv'],separator);
writematrix(mag,filename);

for i=1:8
for j=1:5
    y(j,1)=lum_mag(5*(i-1)+j);
end
X=[ones(length(x),1) x];
b=X\y;
yCalc2 = X*b;
for j=1:3
    color(j)=color_all(i,j)/255;
end
plot(x,yCalc2,'Color',color)
hold on
if i==4
    xlabel('mag');
    ylabel('P',"Rotation",0);
    title("mag 45~180deg");
    legend('45deg','90deg','135deg','180deg');
    hold off
    saveas(gcf,'mag_45~180deg.png');
end
end
xlabel('mag');
ylabel('P',"Rotation",0);
title("mag 225~360deg");
legend('225deg','270deg','315deg','360deg');
saveas(gcf,'mag_225~360deg.png');
hold off



ipRGC=readmatrix('ipRGC_stim.csv');
for i=1:8
for j=1:5
    x(j,1)=ipRGC(5*(i-1)+j);
end
for j=1:5
    y(j,1)=lum_mag(5*(i-1)+j);
    y1(j,1)=lum_mag1(5*(i-1)+j);
    y2(j,1)=lum_mag2(5*(i-1)+j);
    y3(j,1)=lum_mag3(5*(i-1)+j);
    y4(j,1)=lum_mag4(5*(i-1)+j);
end
X=[ones(length(x),1) x];
b=X\y;
abs(i,1)=b(2);
abs(i,2)=b(1);
yCalc2 = X*b;
for j=1:3
    color(j)=color_all(i,j)/255;
end
scatter(x,y1,'r');
hold on
scatter(x,y2,'b');
hold on
scatter(x,y3,'r');
hold on
scatter(x,y4,'b');
hold on
scatter(x,y,'Color',color)
hold on
plot(x,yCalc2,'Color',color)
titlename=strjoin(["abs_",num2str(45*i),'deg'],separator);
title(titlename);
xlabel('abs');
ylabel('P',"Rotation",0);
filename=strjoin(["abs_ave_",num2str(45*i),'deg.png'],separator);
saveas(gcf,filename);
hold off
Rsq2(i) = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);
end
filename=strjoin(['equation_abs_',Name,'.csv'],separator);
writematrix(abs,filename);

for i=1:8
for j=1:5
    x(j,1)=ipRGC(5*(i-1)+j);
end
for j=1:5
    y(j,1)=lum_mag(5*(i-1)+j);
end
X=[ones(length(x),1) x];
b=X\y;
yCalc2 = X*b;
for j=1:3
    color(j)=color_all(i,j)/255;
end
plot(x,yCalc2,'Color',color)
hold on
if i==4
    xlabel('abs');
    ylabel('P',"Rotation",0);
    title("abs 45~180deg");
    legend('45deg','90deg','135deg','180deg');
    hold off
    saveas(gcf,'abs_45~180deg.png');
end
end
xlabel('abs');
ylabel('P',"Rotation",0);
title("abs 225~360deg");
legend('225deg','270deg','315deg','360deg');
saveas(gcf,'abs_225~360deg.png');
hold off


for i=1:8
    for j=1:5
        x(j,1)=ipRGC((i-1)*5+j)-ipRGC((i-1)*5+3);
    end
    for j=1:5
        y(j,1)=lum_mag((i-1)*5+j)-lum_mag((i-1)*5+3);
        y1(j,1)=lum_mag1((i-1)*5+j)-lum_mag1((i-1)*5+3);
        y2(j,1)=lum_mag2((i-1)*5+j)-lum_mag2((i-1)*5+3);
        y3(j,1)=lum_mag3((i-1)*5+j)-lum_mag3((i-1)*5+3);
        y4(j,1)=lum_mag4((i-1)*5+j)-lum_mag4((i-1)*5+3);
    end
    X=[ones(length(x),1) x];
    b=X\y;
    yCalc2 = X*b;
    diff(i,1)=b(2);
    diff(i,2)=b(1);
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    scatter(x,y1);
    hold on
    scatter(x,y2);
    hold on
    scatter(x,y3);
    hold on
    scatter(x,y4);
    hold on
    scatter(x,y,'Color',color)
    hold on
    plot(x,yCalc2,'Color',color)
    titlename=strjoin(["diff_",num2str(45*i),'deg'],separator);
    title(titlename);
    xlabel('diff from mid');
    ylabel('P',"Rotation",0);
    filename=strjoin(["diff_ave",num2str(45*i),'deg.png'],separator);
    saveas(gcf,filename);
    hold off
    Rsq3(i) = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);
end
filename=strjoin(['equation_diff_',Name,'.csv'],separator);
writematrix(diff,filename);

for i=1:8
for j=1:5
    x(j,1)=ipRGC((i-1)*5+j)-ipRGC((i-1)*5+3);
end
for j=1:5
    y(j,1)=lum_mag(5*(i-1)+j);
end
X=[ones(length(x),1) x];
b=X\y;
yCalc2 = X*b;
for j=1:3
    color(j)=color_all(i,j)/255;
end
plot(x,yCalc2,'Color',color)
hold on
if i==4
    xlabel('diff from mid');
    ylabel('P',"Rotation",0);
    title("diff 45~180deg");
    legend('45deg','90deg','135deg','180deg');
    hold off
    saveas(gcf,'diff_45~180deg.png');
end
end
xlabel('diff from mid');
ylabel('P',"Rotation",0);
title("diff 225~360deg");
legend('225deg','270deg','315deg','360deg');
saveas(gcf,'diff_225~360deg.png');
hold off