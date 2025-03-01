clear
color_all=readmatrix("color_all.csv");
color_lum=readmatrix('LED_lum_data.csv');

%輝度絶対値＿倍率の差
variablePrefix = 'lum_abs_diff';
x=[0 45 90 135 180 225 270 315];
equation_abs_all=readmatrix("equation_abs_all.csv");
for i=1:8
    y(i)=equation_abs_all(i,1);
end
b=bar(x,y);
b.FaceColor = 'flat';
for i=1:8
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    b.CData(i,:) = color;
end
title('ipRGCの影響量')
xlabel('色相(degree)','FontSize',14);
ylabel('明るさ効果指数','FontSize',14);
saveas(gcf,'result_abs_diff.png');