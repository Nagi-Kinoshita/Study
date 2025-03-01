clear
color_all=readmatrix("color_all.csv");
color_lum=readmatrix('LED_lum_data.csv');

%{
%輝度倍率の差
lum_abs_diff1=calculate_diff(1);
lum_abs_diff2=calculate_diff(5);
lum_abs_diff3=calculate_diff(10);
lum_abs_diff4=calculate_diff(14);
lum_abs_diff5=calculate_diff(18);
variablePrefix = 'lum_abs_diff';
x=[45 90 135 180 225 270 315 360];
for i=1:8
    a=zeros([1 10000]);
    y(i)=(lum_abs_diff1(i,1)+lum_abs_diff2(i,1)+lum_abs_diff3(i,1)+lum_abs_diff4(i,1)+lum_abs_diff5(i,1))/5;
    data=[lum_abs_diff1(i,1) lum_abs_diff2(i,1) lum_abs_diff3(i,1) lum_abs_diff4(i,1) lum_abs_diff5(i,1)];%個人の傾き
    for j=1:10000
        for k=1:5
            rng(5*j+k);
            random_number=randperm(5);
            a(j)=a(j)+data(random_number(1))/5;            
        end
    end
    a_sort=sort(a);
    under_len(i)=y(i)-(a_sort(250)+a_sort(251))/2;
    upper_len(i)=(a_sort(9750)+a_sort(9751))/2-y(i);
end
bar(x,y);
hold on
errorbar(x,y,under_len,upper_len,"LineStyle","none")
hold on
for i=1:5
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
legend('','','被験者1','被験者2','被験者3','被験者4','被験者5','Location','northeastoutside')
saveas(gcf,'result_abs_diff.png');
%}

%輝度差
lum_diff1=calculate_lum(1);
lum_diff2=calculate_lum(5);
lum_diff3=calculate_lum(10);
lum_diff4=calculate_lum(14);
lum_diff5=calculate_lum(18);
variablePrefix = 'lum_diff';
x=[45 90 135 180 225 270 315 360];
for i=1:8
    a=zeros([1 10000]);
    y(i)=(lum_diff1(i,1)+lum_diff2(i,1)+lum_diff3(i,1)+lum_diff4(i,1)+lum_diff5(i,1))/5;
    data=[lum_diff1(i,1) lum_diff2(i,1) lum_diff3(i,1) lum_diff4(i,1) lum_diff5(i,1)];%個人の傾き
    for j=1:10000
        for k=1:5
            rng(5*j+k);
            random_number=randperm(5);
            a(j)=a(j)+data(random_number(1))/5;            
        end
    end
    a_sort=sort(a);
    under_len(i)=y(i)-(a_sort(250)+a_sort(251))/2;
    upper_len(i)=(a_sort(9750)+a_sort(9751))/2-y(i);
end
bar(x,y);
hold on
errorbar(x,y,under_len,upper_len,"LineStyle","none")
hold on
for i=1:5
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
legend('','','被験者1','被験者2','被験者3','被験者4','被験者5','Location','northeastoutside')
saveas(gcf,'result_lum_diff.png');

%{
result_number=[1 5 10 14 18];
variablePrefix='mag_';
mag_avg=zeros([1 8]);
for i=1:5
    variableName=[variablePrefix num2str(result_number(i))];
    filename=append(variableName,'.csv');
    data=readmatrix(filename);
    for j=1:8
        mag_avg(j)=mag_avg(j)+data(j)/6;
    end
end
writematrix(mag_avg,'mag_criterion_add.csv');
x=[45 90 135 180 225 270 315 360];
bar(x,mag_avg);
title('追加実験における基準色相の相対的明るさ(倍率)')
saveas(gcf,'mag_criterion_add.png')

variablePrefix='lum_';
lum_avg=zeros([1 8]);
for i=1:5
    variableName=[variablePrefix num2str(result_number(i))];
    filename=append(variableName,'.csv');
    data=readmatrix(filename);
    for j=1:8
        lum_avg(j)=lum_avg(j)+data(j)/6;
    end
end
writematrix(lum_avg,'lum_criterion_add.csv');
bar(x,lum_avg);
title('追加実験における基準色相の相対的明るさ(輝度差)')
saveas(gcf,'lum_criterion_add.png')
%}