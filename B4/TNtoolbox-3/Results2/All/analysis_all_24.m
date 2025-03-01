clear
color_all=readmatrix("color_all.csv");
color_lum=readmatrix('LED_lum_data.csv');

%輝度絶対値＿倍率の差
lum_abs_diff1=calculate_diff(1);
lum_abs_diff2=calculate_diff(5);
lum_abs_diff3=calculate_diff(10);
lum_abs_diff4=calculate_diff(14);
lum_abs_diff5=calculate_diff(18);
lum_abs_diff6=calculate_diff(22);
variablePrefix = 'lum_abs_diff';
x=[0 45 90 135 180 225 270 315];
for i=1:8
    a=zeros([1 10000]);
    y(i)=(lum_abs_diff1(i,1)+lum_abs_diff2(i,1)+lum_abs_diff3(i,1)+lum_abs_diff4(i,1)+lum_abs_diff5(i,1)+lum_abs_diff6(i,1))/6;
    data=[lum_abs_diff1(i,1) lum_abs_diff2(i,1) lum_abs_diff3(i,1) lum_abs_diff4(i,1) lum_abs_diff5(i,1) lum_abs_diff6(i,1)];%個人の傾き
    for j=1:10000
        for k=1:6
            rng(6*j+k);
            random_number=randperm(6);
            a(j)=a(j)+data(random_number(1))/6;            
        end
    end
    a_sort=sort(a);
    under_len(i)=y(i)-(a_sort(250)+a_sort(251))/2;
    upper_len(i)=(a_sort(9750)+a_sort(9751))/2-y(i);
end
b=bar(x,y);
b.FaceColor = 'flat';
for i=1:8
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    b.CData(i,:) = color;
end
hold on
errorbar(x,y,under_len,upper_len,"LineStyle","none")
hold on
for i=1:6
    variableName=[variablePrefix num2str(i)];
    data=eval(variableName);
    for j=1:8
        y(j)=data(j,1);
    end
    scatter(x,y)
    hold on
end
hold off
xlabel('色相(degree)');
ylabel('近似直線の傾き');
legend('','','被験者1','被験者2','被験者3','被験者4','被験者5','被験者6','Location','northeastoutside')
saveas(gcf,'result_abs_diff.png');