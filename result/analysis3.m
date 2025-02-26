clear
files = dir('./*.csv');
file_name_cell_array={files.name};
separator='';
data1_low=data_ave_low(2);%個人の傾きはここで求める？
data1_high=data_ave_high(1);
data2_low=data_ave_low(12);
data2_high=data_ave_high(11);
data3_low=data_ave_low(20);
data3_high=data_ave_high(19);
color_lum_low=readmatrix('LED_lum_data_low.csv');
color_lum_high=readmatrix('LED_lum_data_high.csv');
ipRGC_low=readmatrix("ipRGC_low.csv");
ipRGC_high=readmatrix('ipRGC_high.csv');
color_all=readmatrix("color_all.csv");
n=6;
Lum=406.8643;
for i=1:20
    lum_mag1_low(i)=(Lum*data1_low(i))/color_lum_low(i);
    lum_mag1_high(i)=(Lum*data1_high(i))/color_lum_high(i);
    lum_mag2_low(i)=(Lum*data2_low(i))/color_lum_low(i);
    lum_mag2_high(i)=(Lum*data2_high(i))/color_lum_high(i);
    lum_mag3_low(i)=(Lum*data3_low(i))/color_lum_low(i);
    lum_mag3_high(i)=(Lum*data3_high(i))/color_lum_high(i);
end

%low
x_graph_low=0.3:0.02:0.6;
for i=1:5
    % 初期化
    color = zeros(1, 3);
    for j=1:3
        color(j) = color_all(i, j) / 255;
    end
    
    x = zeros(1, 4);
    y = zeros(1, 4);
    under_len = zeros(1, 4);
    upper_len = zeros(1, 4);

    % 計算部分
    for j=1:4
        a = zeros(1, 10000);
        data = [lum_mag1_low(4*(i-1)+j), lum_mag2_low(4*(i-1)+j), lum_mag3_low(4*(i-1)+j)];
        x_bar(j) = mean(data);
        for k=1:10000
            for l=1:3
                rng(3*k+l)
                random_number = randperm(3);
                a(k) = a(k) + data(random_number(1)) / 3;
            end
        end
        a_sort = sort(a);
        under_len(j) = x_bar(j) - (a_sort(250)+a_sort(251))/2;
        upper_len(j) = (a_sort(9750)+a_sort(9751))/2 - x_bar(j);    
        x(j) = ipRGC_low(i, j);
        y1(j) = lum_mag1_low((i-1)*4+j);
        y2(j) = lum_mag2_low((i-1)*4+j);
        y3(j) = lum_mag3_low((i-1)*4+j);
        y(j) = (y1(j)+y2(j)+y3(j)) / 3;
    end

    % プロット部分
    x_all = [x, x, x];
    y_all = [y1, y2, y3];
    p = polyfit(x_all, y_all, 1);
    equation_diff_low(i, 1) = p(1);
    equation_diff_low(i, 2) = p(2);
    slope(i) = p(1);

    errorbar(x, y, under_len, upper_len, 'LineStyle', 'none', 'Color', [0 0 1], 'LineWidth', 3.2);
    hold on;
    scatter(x, y1);
    scatter(x, y2);
    scatter(x, y3);
    scatter(x, y, 130, 'blue', 'filled');
    
    yCalc2_low = zeros(size(x_graph_low));
    for j = 1:length(x_graph_low)
        yCalc2_low(j) = p(1) * x_graph_low(j) + p(2);
    end
    plot(x_graph_low, yCalc2_low, 'Color', color, 'LineWidth', 4);

    % ラベルやタイトル
    xlabel('ipRGC刺激量');
    ylabel('B_r', "Rotation", 0);
    legend('', '被験者1', '被験者2', '被験者3', '平均値', '近似直線', 'Location', 'northeastoutside');

    j = i - 1;
    if i == 5
        j = 7;
    end
    degree = 45 * j;
    titlename = degree + "degree";
    title(titlename, 'FontSize', 15);
    filename = degree + "degree_low.png";
    saveas(gcf, filename);
    hold off;
end


for i=1:4
    for j=1:3
        color_low(i,j)=color_all(i,j)/255;
    end
end
for j=1:3
    color_low(5,j)=color_all(8,j)/255;
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
title("全ての被験者の結果")
xlabel('色相(degree)','FontSize',14);
ylabel('ipRGC指数','FontSize',14);
saveas(gcf,"全ての被験者の結果-45~135.png");
writematrix(equation_diff_low,'equation_abs_low.csv');
hold off

%high
x_graph_high=0.45:0.02:0.75;
for i=1:5
    for j=1:4
        x(j)=ipRGC_high(i,j);
        y1(j)=lum_mag1_high((i-1)*4+j);
        y2(j)=lum_mag2_high((i-1)*4+j);
        y3(j)=lum_mag3_high((i-1)*4+j);
    end
    x_all=[x,x,x];
    y_all=[y1,y2,y3];    
    p=polyfit(x_all,y_all,1);
    equation_diff_high(i,1)=p(1);
    equation_diff_high(i,2)=p(2);
    slope(i)=p(1);
    scatter(x,y1);
    hold on
    scatter(x,y2);
    hold on;
    scatter(x,y3);
    hold on;
    for j=1:length(x_graph_high)
        yCalc2_high(j)=p(1)*x_graph_high(j)+p(2);
    end
    plot(x_graph_high,yCalc2_high)
    xlabel('ipRGC刺激量');
    ylabel('B_r',"Rotation",0);
    legend('被験者1','被験者2','被験者3','近似直線','Location','northeastoutside')
    j=i+2;
    degree=45*j;
    titlename=degree+"degree";
    title(titlename,'FontSize',15);
    filename=degree+"degree_high.png";
    saveas(gcf,filename);
    hold off
end
for i=1:5
    for j=1:3
        color_high(i,j)=color_all(i+3,j)/255;
    end
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
title("全ての被験者の結果")
xlabel('色相(degree)','FontSize',14);
ylabel('ipRGC指数','FontSize',14);
saveas(gcf,"全ての被験者の結果135~315.png");
writematrix(equation_diff_high,'equation_abs_high.csv');