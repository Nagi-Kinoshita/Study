clear
color_all=readmatrix("color_all.csv");
colors=color_all/255;
x=[0.238 0.281 0.264 0.205 0.175 0.151 0.158 0.189];
y=[2.9155 0.6861 -0.4655 -0.0954 -0.0512 1.4301 3.0644 4.4399];
p=polyfit(x,y,1);
x_fit = linspace(0.15, 0.3, 100);
y_fit=polyval(p,x_fit);
plot(x_fit,y_fit,'LineWidth',3,'Color','r')
hold on
scatter(x,y,250,colors,"filled");
xlabel('L錐体刺激量','FontSize',14);
ylabel('明るさ効果指数','FontSize',14);
xlim([0.15 0.3]);
saveas(gcf,'L_ipRGC.png');
R=corrcoef(x, y);
disp('相関係数:');
disp(R);
hold off

x=[0.194 0.235 0.245 0.215 0.193 0.167 0.158 0.165];
y=[2.9155 0.6861 -0.4655 -0.0954 -0.0512 1.4301 3.0644 4.4399];
p=polyfit(x,y,1);
x_fit = linspace(0.15, 0.25, 100);
y_fit=polyval(p,x_fit);
plot(x_fit,y_fit,'LineWidth',3,'Color','g')
hold on
scatter(x,y,250,colors,"filled");
xlabel('M錐体刺激量','FontSize',14);
ylabel('明るさ効果指数','FontSize',14);
xlim([0.15 0.25]);
saveas(gcf,'M_ipRGC.png');
R=corrcoef(x, y);
disp('相関係数:');
disp(R);
hold off

x=[0.1332 0.0946 0.0715 0.0803 0.1119 0.1427 0.1626 0.1641];
y=[2.9155 0.6861 -0.4655 -0.0954 -0.0512 1.4301 3.0644 4.4399];
p=polyfit(x,y,1);
x_fit = linspace(0.07, 0.17, 100);
y_fit=polyval(p,x_fit);
plot(x_fit,y_fit,'LineWidth',3,'Color','b')
hold on
scatter(x,y,250,colors,"filled");
xlabel('S錐体刺激量','FontSize',14);
ylabel('明るさ効果指数','FontSize',14);
xlim([0.07 0.17]);
saveas(gcf,'S_ipRGC.png');
R=corrcoef(x, y);
disp('相関係数:');
disp(R);
hold off


