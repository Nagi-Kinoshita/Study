clear

i=1;%変える
ipRGC=0.2;
Y=0.199;%変える
x=0.354;%ここの値を頑張って調整して、最終的なxyを実現する
y=0.2998;%ここの値を頑張って調整して、最終的なxyを実現する、最終的に作成できた時の値をメモする。そうすれば再現可能なので
%指定するのはipRGC(固定)、Y(可変)、x(可変)、y(可変)、150cd位に合わせる。ipRGC=0.16 0.18 0.2 0.22 0.24
writematrix(ipRGC,'ipRGC_object.csv');
rgb=readmatrix('rgb_data.csv');
spectrum=readmatrix('spectrum_data.csv');
XYZ_sens=readmatrix('XYZ_sens.csv');
u_v_prime=readmatrix('u_v_prime.csv');
Y_sum=0;
rgb_i=zeros([1 3]);
energy=zeros([1 391]);
for j=1:3
    rgb_i(j)=rgb(j,i);
end
XYZ_value=zeros([1 3]);
XYZ_value(2)=Y;
XYZ_value(1)=XYZ_value(2)*x/y;
XYZ_value(3)=XYZ_value(2)*(1-x-y)/y;
writematrix(XYZ_value,'XYZ_value.csv');
lb=zeros([1 3]);
ub=ones([1 3]);
rgb_value=fmincon(@find_rgb,rgb_i,[],[],[],[],lb,ub,@ipRGC_constraint_with_rgb);
for j=1:391
    energy(j)=rgb_value(1)*spectrum(10+j,1)+rgb_value(2)*spectrum(10+j,2)+rgb_value(3)*spectrum(10+j,3);
end
writematrix(energy,'energy_sum.csv');%ここの値もメモしてもいいかも
%ここまでで求めたい分光分布が決まる
%{
lb=zeros([1 22]);
ub=zeros([1 22]);
middle=zeros([1 22]);
for j=1:22
    ub(j)=3;
    middle(j)=0.3;
end
LED_intensity_scale=fmincon(@LED_to_energy,middle,[],[],[],[],lb,ub);
%}