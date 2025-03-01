clear
files = dir('./*.csv');
file_name_cell_array={files.name};
separator='';
FileName=char(file_name_cell_array(5));
data1_1=readmatrix(FileName);
FileName=char(file_name_cell_array(2));
data1_2=readmatrix(FileName);
FileName=char(file_name_cell_array(3));
data1_3=readmatrix(FileName);
FileName=char(file_name_cell_array(4));
data1_4=readmatrix(FileName);

FileName=char(file_name_cell_array(9));
data2_1=readmatrix(FileName);
FileName=char(file_name_cell_array(6));
data2_2=readmatrix(FileName);
FileName=char(file_name_cell_array(7));
data2_3=readmatrix(FileName);
FileName=char(file_name_cell_array(8));
data2_4=readmatrix(FileName);

FileName=char(file_name_cell_array(14));
data3_1=readmatrix(FileName);
FileName=char(file_name_cell_array(11));
data3_2=readmatrix(FileName);
FileName=char(file_name_cell_array(12));
data3_3=readmatrix(FileName);
FileName=char(file_name_cell_array(13));
data3_4=readmatrix(FileName);

FileName=char(file_name_cell_array(18));
data4_1=readmatrix(FileName);
FileName=char(file_name_cell_array(15));
data4_2=readmatrix(FileName);
FileName=char(file_name_cell_array(16));
data4_3=readmatrix(FileName);
FileName=char(file_name_cell_array(17));
data4_4=readmatrix(FileName);

FileName=char(file_name_cell_array(22));
data5_1=readmatrix(FileName);
FileName=char(file_name_cell_array(19));
data5_2=readmatrix(FileName);
FileName=char(file_name_cell_array(20));
data5_3=readmatrix(FileName);
FileName=char(file_name_cell_array(21));
data5_4=readmatrix(FileName);

FileName=char(file_name_cell_array(26));
data6_1=readmatrix(FileName);
FileName=char(file_name_cell_array(23));
data6_2=readmatrix(FileName);
FileName=char(file_name_cell_array(24));
data6_3=readmatrix(FileName);
FileName=char(file_name_cell_array(25));
data6_4=readmatrix(FileName);

for i=1:40
    data_ave(i)=(data1_1(i)+data1_2(i)+data1_3(i)+data1_4(i)+data2_1(i)+data2_2(i)+data2_3(i)+data2_4(i)+data3_1(i)+data3_2(i)+data3_3(i)+data3_4(i)+data4_1(i)+data4_2(i)+data4_3(i)+data4_4(i)+data5_1(i)+data5_2(i)+data5_3(i)+data5_4(i)+data6_1(i)+data6_2(i)+data6_3(i)+data6_4(i))/24;
end
data1_ave=(data1_1+data1_2+data1_3+data1_4)/4;
data2_ave=(data2_1+data2_2+data2_3+data2_4)/4;
data3_ave=(data3_1+data3_2+data3_3+data3_4)/4;
data4_ave=(data4_1+data4_2+data4_3+data4_4)/4;
data5_ave=(data5_1+data5_2+data5_3+data5_4)/4;
data6_ave=(data6_1+data6_2+data6_3+data6_4)/4;
color_all=readmatrix("color_all.csv");
color_lum=readmatrix('LED_lum_data.csv');
for i=1:40
    lum_mag(i)=(150*data_ave(i))/color_lum(i);
    lum_mag1(i)=(150*data1_ave(i))/color_lum(i);
    lum_mag2(i)=(150*data2_ave(i))/color_lum(i);
    lum_mag3(i)=(150*data3_ave(i))/color_lum(i);
    lum_mag4(i)=(150*data4_ave(i))/color_lum(i);
    lum_mag5(i)=(150*data5_ave(i))/color_lum(i);
    lum_mag6(i)=(150*data6_ave(i))/color_lum(i);
end
ipRGC=[0.16 0.18 0.2 0.22 0.24];
x=[0;45;90;135;180;225;270;315];
%{
for i=1:5
    for j=1:8
        a=zeros([1 10000]);
        data=[lum_mag1(5*(j-1)+i) lum_mag2(5*(j-1)+i) lum_mag3(5*(j-1)+i) lum_mag4(5*(j-1)+i) lum_mag5(5*(j-1)+i) lum_mag6(5*(j-1)+i)];
        y(j)=mean(data);
        y1(j)=lum_mag1(5*(j-1)+i);
        y2(j)=lum_mag2(5*(j-1)+i);
        y3(j)=lum_mag3(5*(j-1)+i);
        y4(j)=lum_mag4(5*(j-1)+i);
        y5(j)=lum_mag5(5*(j-1)+i);
        y6(j)=lum_mag6(5*(j-1)+i);
        for k=1:10000
            for l=1:6
                rng(6*k+l)
                random_number=randperm(6);
                a(k)=a(k)+data(random_number(1))/6;
            end
        end
        a_sort=sort(a);
        under_len(j)=y(j)-(a_sort(250)+a_sort(251))/2;
        upper_len(j)=(a_sort(9750)+a_sort(9751))/2-y(j);
    end
    b=bar(x,y);
    hold on
    b.FaceColor = 'flat';
    for k=1:8
        for j=1:3
            color(j)=color_all(k,j)/255;
        end
        b.CData(k,:) = color;
    end
    errorbar(x,y,under_len,upper_len,"LineStyle","none")
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
    ylim([0 2.5]);
    number=ipRGC(i);
    titlename=append('ipRGC=',num2str(number));
    title(titlename);
    ax=gca;
    ax.FontSize=13;
    legend('','','被験者1','被験者2','被験者3','被験者4','被験者5','被験者6','Location','northeastoutside')
    xlabel('色相(degree)');
    ylabel('H-K',"Rotation",0);
    filename=append('H_K_lum_mag_ipRGC=',num2str(ipRGC(i)),'.png');
    saveas(gcf,filename);
    hold off
end
%}
%{
w=[0.5 0 0 0 0.25];
for i=1:5
    if i==1||i==5
        for j=1:8
            data=[lum_mag1(5*(j-1)+i) lum_mag2(5*(j-1)+i) lum_mag3(5*(j-1)+i) lum_mag4(5*(j-1)+i) lum_mag5(5*(j-1)+i) lum_mag6(5*(j-1)+i)];
            y(j)=mean(data);
        end
        b=bar(x,y,w(i));
        hold on
   end
end
title('ipRGC=0.16,0.24');
ax=gca;
ax.FontSize=13;
legend('ipRGC=1.6','ipRGC=2.4','Location','northeastoutside')
xlabel('色相(degree)');
ylabel('B_r',"Rotation",0);
saveas(gcf,'H_K_lum_mag_Overlaid.png');
%}
%{
for i=1:8
    for j=1:5
        y(j)=lum_mag((i-1)*5+j);
    end
    corrcoef(ipRGC,y)
end
%}
ipRGC_append=zeros([1 30]);
for i=1:8
    for j=1:5
        for k=1:6
            ipRGC_append(6*(j-1)+k)=ipRGC(j);
        end
        y(6*(j-1)+1)=lum_mag1(5*(i-1)+j);
        y(6*(j-1)+2)=lum_mag2(5*(i-1)+j);
        y(6*(j-1)+3)=lum_mag3(5*(i-1)+j);
        y(6*(j-1)+4)=lum_mag4(5*(i-1)+j);
        y(6*(j-1)+5)=lum_mag5(5*(i-1)+j);
        y(6*(j-1)+6)=lum_mag6(5*(i-1)+j);
    end
    corrcoef(ipRGC_append,y)
end