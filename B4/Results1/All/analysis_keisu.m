files = dir('./*.csv');
file_name_cell_array={files.name};
separator='';
color_lum=readmatrix('LED_lum_data.csv');
data4_1=0;data4_2=0;data4_3=0;data4_4=0;
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
%{
FileName=char(file_name_cell_array(14));
data4_1=readmatrix(FileName);
FileName=char(file_name_cell_array(15));
data4_2=readmatrix(FileName);
FileName=char(file_name_cell_array(16));
data4_3=readmatrix(FileName);
FileName=char(file_name_cell_array(17));
data4_4=readmatrix(FileName);
%}
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
data_ave=(data1_1+data1_2+data1_3+data1_4+data2_1+data2_2+data2_3+data2_4+data3_1+data3_2+data3_3+data3_4+data4_1+data4_2+data4_3+data4_4+data5_1+data5_2+data5_3+data5_4+data6_1+data6_2+data6_3+data6_4)/20;
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
end

ipRGC=readmatrix('ipRGC_stim.csv');
i=1;
for j=1:5
    x(j,1)=ipRGC((i-1)*5+j)-ipRGC((i-1)*5+3);
end
for j=1:5
    y(j,1)=lum_mag((i-1)*5+j)-lum_mag((i-1)*5+3);
end
X=[ones(length(x),1) x];
b=regress(y,X);
yCalc2 = X*b;
resid=y-yCalc2;
ci = bootci(1000,{@(bootr)regress(yCalc2+bootr,X),resid},'Type','normal');
slopes = b(2:end)';
lowerBarLengths = slopes-ci(1,2:end);
upperBarLengths = ci(2,2:end)-slopes;
errorbar(1,slopes,lowerBarLengths,upperBarLengths)
xlim([0 5])
title('Coefficient Confidence Intervals')
%{
    scatter(x,y)
    hold on
    plot(x,yCalc2)
    titlename=strjoin(["diff_",num2str(45*i),'deg'],separator);
    title(titlename);
    xlabel('diff from mid');
    ylabel('P',"Rotation",0);
    filename=strjoin(["diff_ave",num2str(45*i),'deg.png'],separator);
    saveas(gcf,filename);
    hold off
    Rsq3(i) = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);
%}
data1_ave=(data1_1+data1_2+data1_3+data1_4)/4;
data2_ave=(data2_1+data2_2+data2_3+data2_4)/4;
data3_ave=(data3_1+data3_2+data3_3+data3_4)/4;
data5_ave=(data5_1+data5_2+data5_3+data5_4)/4;
data6_ave=(data6_1+data6_2+data6_3+data6_4)/4;
data=zeros([1 5]);
n=5;%データ数
for i=1:8
    data=[data1_ave(i) data2_ave(i) data3_ave(i) data5_ave(i) data6_ave(i)];
    x_bar=mean(data);
    variance=var(data);
    scatter(x,y)
    hold on
    plot(x,yCalc2)
    titlename=strjoin(["diff_",num2str(45*i),'deg'],separator);
    title(titlename);
    xlabel('diff from mid');
    ylabel('P',"Rotation",0);
    filename=strjoin(["diff_ave",num2str(45*i),'deg.png'],separator);
    saveas(gcf,filename);
    hold off
    Rsq3(i) = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);
end