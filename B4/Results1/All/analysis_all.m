files = dir('./*.csv');
file_name_cell_array={files.name};
separator='';
color_lum=readmatrix('LED_lum_data.csv');
FileName=char(file_name_cell_array(1));
data1_1=readmatrix(FileName);
FileName=char(file_name_cell_array(2));
data1_2=readmatrix(FileName);
FileName=char(file_name_cell_array(3));
data1_3=readmatrix(FileName);
FileName=char(file_name_cell_array(4));
data1_4=readmatrix(FileName);
FileName=char(file_name_cell_array(6));
data2_1=readmatrix(FileName);
FileName=char(file_name_cell_array(7));
data2_2=readmatrix(FileName);
FileName=char(file_name_cell_array(8));
data2_3=readmatrix(FileName);
FileName=char(file_name_cell_array(9));
data2_4=readmatrix(FileName);
FileName=char(file_name_cell_array(10));
data3_1=readmatrix(FileName);
FileName=char(file_name_cell_array(11));
data3_2=readmatrix(FileName);
FileName=char(file_name_cell_array(12));
data3_3=readmatrix(FileName);
FileName=char(file_name_cell_array(13));
data3_4=readmatrix(FileName);
FileName=char(file_name_cell_array(14));
data4_1=readmatrix(FileName);
FileName=char(file_name_cell_array(15));
data4_2=readmatrix(FileName);
FileName=char(file_name_cell_array(16));
data4_3=readmatrix(FileName);
FileName=char(file_name_cell_array(17));
data4_4=readmatrix(FileName);
FileName=char(file_name_cell_array(18));
data5_1=readmatrix(FileName);
FileName=char(file_name_cell_array(19));
data5_2=readmatrix(FileName);
FileName=char(file_name_cell_array(20));
data5_3=readmatrix(FileName);
FileName=char(file_name_cell_array(21));
data5_4=readmatrix(FileName);
FileName=char(file_name_cell_array(22));
data6_1=readmatrix(FileName);
FileName=char(file_name_cell_array(23));
data6_2=readmatrix(FileName);
FileName=char(file_name_cell_array(24));
data6_3=readmatrix(FileName);
FileName=char(file_name_cell_array(25));
data6_4=readmatrix(FileName);
data_ave=(data1_1+data1_2+data1_3+data1_4+data2_1+data2_2+data2_3+data2_4+data3_1+data3_2+data3_3+data3_4+data4_1+data4_2+data4_3+data4_4+data5_1+data5_2+data5_3+data5_4+data6_1+data6_2+data6_3+data6_4)/24;
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
lum_diff=zeros([1 40]);
color_all=readmatrix("color_all.csv");
color=zeros([1 3]);
for i=1:40
    lum_mag(i)=(150*data_ave(i))/color_lum(i);
    lum_diff(i)=150*data_ave(i)-color_lum(i);
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
    x(j,1)=ipRGC((i-1)*5+j)-ipRGC((i-1)*5+3);
end
for j=1:5
    y(j,1)=lum_mag((i-1)*5+j)-lum_mag((i-1)*5+3);
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
    axis([-0.06 0.06 -0.1 0.2])
    hold off
    saveas(gcf,'diff_45~180deg.png');
end
end
xlabel('diff from mid');
ylabel('P',"Rotation",0);
title("diff 225~360deg");
legend('225deg','270deg','315deg','360deg');
axis([-0.06 0.06 -0.1 0.2])
saveas(gcf,'diff_225~360deg.png');
hold off

for i=1:8
for j=1:5
    x(j,1)=ipRGC(5*(i-1)+j);
end
for j=1:5
    y(j,1)=lum_diff(5*(i-1)+j);
end
X=[x ones(length(x),1)];
b=regress(y,X);
lum(i,1)=b(1);
lum(i,2)=b(2);
lum_y(i)=b(1);
end
writematrix(lum,'lum_diff.csv');
x=[45 90 135 180 225 270 315 360];
bar(x,lum_y);
xlabel('色相');
ylabel('傾きの大きさ');
saveas(gcf,'lum_diff_all.png');
