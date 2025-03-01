clear
files = dir('./*.csv');
file_name_cell_array={files.name};
separator='';
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
data1_ave=(data1_1+data1_2+data1_3+data1_4)/4;
data2_ave=(data2_1+data2_2+data2_3+data2_4)/4;
data3_ave=(data3_1+data3_2+data3_3+data3_4)/4;
data4_ave=(data4_1+data4_2+data4_3+data4_4)/4;
data5_ave=(data5_1+data5_2+data5_3+data5_4)/4;
data6_ave=(data6_1+data6_2+data6_3+data6_4)/4;
ipRGC=readmatrix('ipRGC_stim.csv');
color_all=readmatrix("color_all.csv");
color_lum=readmatrix('LED_lum_data.csv');
n=6;

%横軸が絶対値
x_graph=[0.11;0.12;0.13;0.14;0.15;0.16;0.17;0.18];
for i=1:40
    lum_mag(i)=(150*data_ave(i))/color_lum(i);
    lum_mag1(i)=(150*data1_ave(i))/color_lum(i);
    lum_mag2(i)=(150*data2_ave(i))/color_lum(i);
    lum_mag3(i)=(150*data3_ave(i))/color_lum(i);
    lum_mag4(i)=(150*data4_ave(i))/color_lum(i);
    lum_mag5(i)=(150*data5_ave(i))/color_lum(i);
    lum_mag6(i)=(150*data6_ave(i))/color_lum(i);
end
for i=1:8
    for j=1:5
        data=[lum_mag1(5*(i-1)+j) lum_mag2(5*(i-1)+j) lum_mag3(5*(i-1)+j) lum_mag4(5*(i-1)+j) lum_mag5(5*(i-1)+j) lum_mag6(5*(i-1)+j)];
        x_bar(j)=mean(data);
        variance(j)=var(data);
        x(j,1)=ipRGC((i-1)*5+j);
        y(j,1)=lum_mag((i-1)*5+j);
        y1(j)=lum_mag1((i-1)*5+j);
        y2(j)=lum_mag2((i-1)*5+j);
        y3(j)=lum_mag3((i-1)*5+j);
        y4(j)=lum_mag4((i-1)*5+j);
        y5(j)=lum_mag5((i-1)*5+j);
        y6(j)=lum_mag6((i-1)*5+j);
    end
    X=[x ones(length(x),1)];
    b=regress(y,X);
    equation_diff(i,1)=b(1);
    equation_diff(i,2)=b(2);
    X_graph=[x_graph ones(length(x_graph),1)];
    yCalc2 = X_graph*b;
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    plot(x_graph,yCalc2)
    hold on
    errorbar(x,y,1.96*sqrt(variance/n),1.96*sqrt(variance/n),"LineStyle","none")
    hold on
    scatter(x,y1);
    hold on
    scatter(x,y2);
    hold on
    scatter(x,y3);
    hold on
    scatter(x,y4);
    hold on
    scatter(x,y5);
    hold on
    scatter(x,y6);
    titlename=strjoin(["abs ",num2str(45*i),'deg'],separator);
    title(titlename);
    axis([0.11 0.18 0.7 1.6]);
    legend('近似直線','','被験者1','被験者2','被験者3','被験者4','被験者5','被験者6','Location','northeastoutside')
    xlabel('ipRGCの大きさ');
    ylabel('B_r',"Rotation",0);
    filename=strjoin(["abs_ave",num2str(45*i),'deg.png'],separator);
    saveas(gcf,filename);
    hold off
end
writematrix(equation_diff,'equation_abs_all.csv');

%横軸が倍率
x=[0.8;0.9;1;1.1;1.2];
x_graph=[0.7;0.8;0.9;1;1.1;1.2;1.3];
for i=1:8
    for j=1:5
        data=[lum_mag1(5*(i-1)+j) lum_mag2(5*(i-1)+j) lum_mag3(5*(i-1)+j) lum_mag4(5*(i-1)+j) lum_mag5(5*(i-1)+j) lum_mag6(5*(i-1)+j)];
        x_bar(j)=mean(data);
        variance(j)=var(data);
        y(j,1)=lum_mag((i-1)*5+j);
        y1(j)=lum_mag1((i-1)*5+j);
        y2(j)=lum_mag2((i-1)*5+j);
        y3(j)=lum_mag3((i-1)*5+j);
        y4(j)=lum_mag4((i-1)*5+j);
        y5(j)=lum_mag5((i-1)*5+j);
        y6(j)=lum_mag6((i-1)*5+j);
    end
    X=[x ones(length(x),1)];
    b=regress(y,X);
    equation_mag(i,1)=b(1);
    equation_mag(i,2)=b(2);
    X_graph=[x_graph ones(length(x_graph),1)];
    yCalc2 = X_graph*b;
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    plot(x_graph,yCalc2)
    hold on
    errorbar(x,y,1.96*sqrt(variance/n),1.96*sqrt(variance/n),"LineStyle","none")
    hold on
    scatter(x,y1);
    hold on
    scatter(x,y2);
    hold on
    scatter(x,y3);
    hold on
    scatter(x,y4);
    hold on
    scatter(x,y5);
    hold on
    scatter(x,y6);
    legend('近似直線','','被験者1','被験者2','被験者3','被験者4','被験者5','被験者6','Location','northeastoutside')
    titlename=strjoin(["lum diff",num2str(45*i),'deg'],separator);
    axis([0.7 1.3 0.7 1.6]);
    title(titlename);
    xlabel('中間刺激からの倍率');
    ylabel('B_r',"Rotation",0);
    filename=strjoin(["mag_ave",num2str(45*i),'deg.png'],separator);
    saveas(gcf,filename);
    hold off
%    Rsq3(i) = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);
end
writematrix(equation_mag,'equation_mag_all.csv');


%横軸が絶対値、縦軸が輝度差
x_graph=[0.11;0.12;0.13;0.14;0.15;0.16;0.17;0.18];
for i=1:40
    lum_diff(i)=(150*data_ave(i))-color_lum(i);
    lum_diff1(i)=(150*data1_ave(i))-color_lum(i);
    lum_diff2(i)=(150*data2_ave(i))-color_lum(i);
    lum_diff3(i)=(150*data3_ave(i))-color_lum(i);
    lum_diff4(i)=(150*data4_ave(i))-color_lum(i);
    lum_diff5(i)=(150*data5_ave(i))-color_lum(i);
    lum_diff6(i)=(150*data6_ave(i))-color_lum(i);
end
for i=1:8
    for j=1:5
        data=[lum_diff1(5*(i-1)+j) lum_diff2(5*(i-1)+j) lum_diff3(5*(i-1)+j) lum_diff4(5*(i-1)+j) lum_diff5(5*(i-1)+j) lum_diff6(5*(i-1)+j)];
        x_bar(j)=mean(data);
        variance(j)=var(data);
        x(j,1)=ipRGC((i-1)*5+j);
        y(j,1)=lum_diff((i-1)*5+j);
        y1(j)=lum_diff1((i-1)*5+j);
        y2(j)=lum_diff2((i-1)*5+j);
        y3(j)=lum_diff3((i-1)*5+j);
        y4(j)=lum_diff4((i-1)*5+j);
        y5(j)=lum_diff5((i-1)*5+j);
        y6(j)=lum_diff6((i-1)*5+j);
    end
    X=[x ones(length(x),1)];
    b=regress(y,X);
    equation_diff(i,1)=b(1);
    equation_diff(i,2)=b(2);
    X_graph=[x_graph ones(length(x_graph),1)];
    yCalc2 = X_graph*b;
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    plot(x_graph,yCalc2)
    hold on
    errorbar(x,y,1.96*sqrt(variance/n),1.96*sqrt(variance/n),"LineStyle","none")
    hold on
    scatter(x,y1);
    hold on
    scatter(x,y2);
    hold on
    scatter(x,y3);
    hold on
    scatter(x,y4);
    hold on
    scatter(x,y5);
    hold on
    scatter(x,y6);
    titlename=strjoin(["lum_diff_",num2str(45*i),'degree'],separator);
    title(titlename);
    legend('近似直線','','被験者1','被験者2','被験者3','被験者4','被験者5','被験者6','Location','northeastoutside')
    xlabel('ipRGCの大きさ');
    ylabel('L_d',"Rotation",0);
    filename=strjoin(["lum diff",num2str(45*i),'deg.png'],separator);
    saveas(gcf,filename);
    hold off
end
writematrix(equation_diff,'equation_diff_all.csv');


%{
FileName=char(file_name_cell_array(33));
diff1=readmatrix(FileName);
FileName=char(file_name_cell_array(34));
diff2=readmatrix(FileName);
FileName=char(file_name_cell_array(35));
diff3=readmatrix(FileName);
FileName=char(file_name_cell_array(36));
diff4=readmatrix(FileName);
FileName=char(file_name_cell_array(37));
diff5=readmatrix(FileName);
FileName=char(file_name_cell_array(38));
diff6=readmatrix(FileName);
for i=1:8
    y(i)=equation_diff(i,1);
    data=[diff1(i,1) diff2(i,1) diff3(i,1) diff4(i,1) diff5(i,1) diff6(i,1)];%個人の傾き
    x_bar(i)=mean(data);
    variance(i)=var(data);    
end
x=[45 90 135 180 225 270 315 360];
bar(x,y);
hold on
errorbar(x,y,1.96*sqrt(variance/6),1.96*sqrt(variance/6),"LineStyle","none")
xlabel('色相');
%ylabel('傾きの大きさ',"Rotation",0);
ylabel('傾きの大きさ');
saveas(gcf,'result_all.png');
%}