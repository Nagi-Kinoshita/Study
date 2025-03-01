lum_abs_diff1=calculate_diff(2);
lum_abs_diff2=calculate_diff(6);
lum_abs_diff3=calculate_diff(11);
lum_abs_diff4=calculate_diff(15);
lum_abs_diff5=calculate_diff(19);
lum_abs_diff6=calculate_diff(23);
ave=(lum_abs_diff1+lum_abs_diff2+lum_abs_diff3+lum_abs_diff4+lum_abs_diff5+lum_abs_diff6)/6;
for i=1:8
    x(i)=ave(i);
end
u_white=0.196;
v_white=0.470;
xy_data=readmatrix('xy_data.csv');
uv=zeros([2 40]);
H_K=zeros([1 40]);
separator='';
for i=1:40
    uv(1,i)=4*xy_data(1,i)/(-2*xy_data(1,i)+12*xy_data(2,i)+3);
    uv(2,i)=9*xy_data(2,i)/(-2*xy_data(1,i)+12*xy_data(2,i)+3);
end
La_pow=63.66^0.4495;
K=0.2717*(6.469+6.362*La_pow)/(6.469+La_pow);
for i=1:40
    u_color=uv(1,i);
    v_color=uv(2,i);
    theta=atan((v_color-v_white)/(u_color-u_white));
    q=-0.01585-0.03017*cos(theta)-0.04556*cos(2*theta)-0.02667*cos(3*theta)-0.00295*cos(4*theta)+0.14592*sin(theta)+0.05084*sin(2*theta)-0.019*sin(3*theta)-0.00764*sin(4*theta);
    part=((u_color-u_white)^2)+((v_color-v_white)^2);
    s_w=13*(part^(1/2));
    H_K(i)=0.4462*((1.3086+s_w*(-0.866*q+0.0872*K))^3);
end
for i=1:8
    y(i)=H_K(5*(i-1)+3);
end
color_all=readmatrix('color_all.csv')/256;
for i=1:8
    scatter(x(i),y(i),40,'MarkerEdgeColor',[color_all(i,1) color_all(i,2) color_all(i,3)],'MarkerFaceColor',[color_all(i,1) color_all(i,2) color_all(i,3)])
    hold on
end
xlabel('近似直線の傾き');
ylabel('Nayataniモデルで求めたH-K効果');
ax=gca;
ax.FontSize=13.5;
saveas(gcf,'Nayatani.png');
hold off
corrcoef(x,y)
