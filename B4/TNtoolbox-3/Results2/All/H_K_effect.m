u_white=0.196;
v_white=0.470;
xy_data=readmatrix('xy_data.csv');
uv=zeros([2 40]);
H_K=zeros([1 40]);
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
writematrix(H_K,'H_K.csv');