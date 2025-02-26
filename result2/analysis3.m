clear
separator='';
data1_low=data_ave_low("result_watanabe");%個人の傾きはここで求める？
data1_high=data_ave_high("result_watanabe");

data2_low=data_ave_low("result_oda");
data2_high=data_ave_high("result_oda");

color_lum_low=readmatrix('data/LED_lum_data_low.csv');
color_lum_high=readmatrix('data/LED_lum_data_high.csv');
ipRGC_low=readmatrix("data/ipRGC_low.csv");
color_all=readmatrix("data/color_all.csv");
ipRGC_low=readmatrix("data/ipRGC_low.csv");
ipRGC_high=readmatrix('data/ipRGC_high.csv');
n=6;
Lum=406.8643;
for i=1:25
    lum_mag1_low(i)=(Lum*data1_low(i))/color_lum_low(i);
    lum_mag1_high(i)=(Lum*data1_high(i))/color_lum_high(i);
    lum_mag2_low(i)=(Lum*data2_low(i))/color_lum_low(i);
    lum_mag2_high(i)=(Lum*data2_high(i))/color_lum_high(i);%追加する
end

%low
x_graph_low=0.3:0.02:0.6;
for i=1:5
    for j=1:5
        x(j)=ipRGC_low(i,j);
        y1(j)=lum_mag1_low((i-1)*5+j);
        y2(j)=lum_mag2_low((i-1)*5+j);%追加する
    end
    x_all=[x,x];%変える
    y_all=[y1,y2];%変える    
    p=polyfit(x_all,y_all,1);
    equation_diff_low(i,1)=p(1);
    equation_diff_low(i,2)=p(2);
    slope(i)=p(1);
    scatter(x,y1);
    hold on
    scatter(x,y2);
    hold on;%追加する
    for j=1:length(x_graph_low)
        yCalc2_low(j)=p(1)*x_graph_low(j)+p(2);
    end
    plot(x_graph_low,yCalc2_low)
    xlabel('ipRGC刺激量');
    ylabel('B_r',"Rotation",0);
    legend('被験者1','被験者2','近似直線','Location','northeastoutside')%追加する
    j=i-1;
    if i==5
        j=7;
    end
    degree=45*j;
    titlename=degree+"degree";
    title(titlename,'FontSize',15);
    filename=degree+"degree_low.png";
    saveas(gcf,filename);
    hold off
end
for i=1:4
    for j=1:3
        color_low(i,j)=color_all(i,j)/255;
    end
end
for j=1:3
    color_low(5,j)=color_all(8,j)/255;
end
hue=[0 45 90 135 -45];
b=bar(hue,slope);
b.FaceColor = 'flat';
for i=1:4
    for j=1:3
        color(j)=color_low(i,j);
    end
    b.CData(i+1,:) = color;
end
i=5;
for j=1:3
    color(j)=color_low(i,j);
end
b.CData(1,:) = color;
title("全ての被験者の結果")
xlabel('色相(degree)','FontSize',14);
ylabel('ipRGC指数','FontSize',14);
saveas(gcf,"全ての被験者の結果-45~135.png");
writematrix(equation_diff_low,'equation_abs_low.csv');
hold off




%high
x_graph_high=0.45:0.02:0.75;
for i=1:5
    for j=1:3
        color_high(i,j)=color_all(i+3,j)/255;
    end
end
for i=1:5
    for j=1:3
        color(j) = color_all(i+3,j) / 255;
    end
    for j=1:5
        x(j)=ipRGC_high(i,j);
        y1(j)=lum_mag1_high((i-1)*5+j);
        y2(j)=lum_mag2_high((i-1)*5+j);%追加する
        
        y(j)=(y1(j)+y2(j))/2;
    end

    % 95%信頼区間の計算
    stderr = std([y1; y2], 0, 1) / sqrt(2); % 標準誤差
    ci = 1.96 * stderr; % 95%信頼区間

    x_all=[x,x];%追加する
    y_all=[y1,y2];%追加する   
    p=polyfit(x_all,y_all,1);
    equation_diff_high(i,1)=p(1);
    equation_diff_high(i,2)=p(2);
    slope(i)=p(1);
    scatter(x,y1);
    hold on
    scatter(x,y2);%追加する
    hold on;
    scatter(x, y, 130, 'blue', 'filled')
    hold on

    errorbar(x, y, ci, 'LineStyle', 'none', 'Color', 'black', 'LineWidth', 1.5);
    hold on;

    for j=1:length(x_graph_high)
        yCalc2_high(j)=p(1)*x_graph_high(j)+p(2);
    end
    plot(x_graph_high,yCalc2_high, 'Color', color, 'LineWidth', 4)
    xlabel('ipRGC刺激量');
    ylabel('B_r',"Rotation",0);
    legend('被験者1','被験者2','平均値','','近似直線','Location','northeastoutside')
    j=i+2;
    degree=45*j;
    titlename=degree+"degree";
    title(titlename,'FontSize',15);
    filename=degree+"degree_high.png";
    saveas(gcf,filename);
    hold off
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

