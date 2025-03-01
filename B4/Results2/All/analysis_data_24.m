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

data1_ave=(data1_1+data1_2+data1_3+data1_4)/4;
data2_ave=(data2_1+data2_2+data2_3+data2_4)/4;
data3_ave=(data3_1+data3_2+data3_3+data3_4)/4;
data4_ave=(data4_1+data4_2+data4_3+data4_4)/4;
data5_ave=(data5_1+data5_2+data5_3+data5_4)/4;
data6_ave=(data6_1+data6_2+data6_3+data6_4)/4;
color_all=readmatrix("color_all.csv");
color_lum=readmatrix('LED_lum_data.csv');
n=6;

%横軸が絶対値
x=[0.16;0.18;0.2;0.22;0.24];
x_graph=[0.15;0.16;0.17;0.18;0.19;0.2;0.21;0.22;0.23;0.24;0.25];
cross_mag=readmatrix('axis_abs.csv');
for i=1:40
    lum_mag1(i)=(150*data1_ave(i))/color_lum(i);
    lum_mag2(i)=(150*data2_ave(i))/color_lum(i);
    lum_mag3(i)=(150*data3_ave(i))/color_lum(i);
    lum_mag4(i)=(150*data4_ave(i))/color_lum(i);
    lum_mag5(i)=(150*data5_ave(i))/color_lum(i);
    lum_mag6(i)=(150*data6_ave(i))/color_lum(i);
end
for i=1:8
    for j=1:5       
        a=zeros([1 10000]);
        data=[lum_mag1(5*(i-1)+j) lum_mag2(5*(i-1)+j) lum_mag3(5*(i-1)+j) lum_mag4(5*(i-1)+j) lum_mag5(5*(i-1)+j) lum_mag6(5*(i-1)+j)];
        x_bar(j)=mean(data);
        for k=1:10000
            for l=1:6
                rng(6*k+l)
                random_number=randperm(6);
                a(k)=a(k)+data(random_number(1))/6;
            end
        end
        a_sort=sort(a);
        under_len(j)=x_bar(j)-(a_sort(250)+a_sort(251))/2;
        upper_len(j)=(a_sort(9750)+a_sort(9751))/2-x_bar(j);        
        y1(j)=lum_mag1((i-1)*5+j);
        y2(j)=lum_mag2((i-1)*5+j);
        y3(j)=lum_mag3((i-1)*5+j);
        y4(j)=lum_mag4((i-1)*5+j);
        y5(j)=lum_mag5((i-1)*5+j);
        y6(j)=lum_mag6((i-1)*5+j);
        y(j)=(y1(j)+y2(j)+y3(j)+y4(j)+y5(j)+y6(j))/6;
    end
    x_all=[x,x,x,x,x,x];
    y_all=[y1,y2,y3,y4,y5,y6];
    p=polyfit(x_all,y_all,1);
    equation_diff(i,1)=p(1);
    equation_diff(i,2)=p(2);
    for j=1:11
        yCalc2=p(1)*x_graph(j)+p(2);
    end
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    errorbar(x,y,under_len,upper_len,"LineStyle","none",'LineWidth',3.2)
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
    hold on
    scatter(x,y,130,"filled")
    titlename=append(num2str(45*(i-1)),'degree');
    axis([0.15 0.25 cross_mag(i,1) cross_mag(i,2)])
    ax=gca;
    ax.FontSize=13.5;
    xticks(0.16:0.02:0.24)
    title(titlename,'FontSize',15);
    legend('','被験者1','被験者2','被験者3','被験者4','被験者5','被験者6','平均値','Location','northeastoutside')
    %legend('近似直線','','被験者1','被験者2','被験者3','被験者4','被験者5','被験者6','Location','northeastoutside')
    xlabel('ipRGC刺激量');
    ylabel('B_r',"Rotation",0);
    filename=strjoin(["abs_ave",num2str(45*(i-1)),'deg_without.png'],separator);
    saveas(gcf,filename);
    plot(x_graph,yCalc2,'Color',color,'LineWidth',4);
    legend('','被験者1','被験者2','被験者3','被験者4','被験者5','被験者6','平均値','近似直線','Location','northeastoutside')
    filename=strjoin(["abs_ave",num2str(45*(i-1)),'deg_with.png'],separator);
    saveas(gcf,filename);
    hold off
end
writematrix(equation_diff,'equation_abs_all.csv');