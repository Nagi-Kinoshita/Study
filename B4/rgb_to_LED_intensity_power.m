clear


i=1;%変える
Y=0.199;%変える
x=0.354;%ここの値を頑張って調整して、最終的なxyを実現する
y=0.2998;%ここの値を頑張って調整して、最終的なxyを実現する、最終的に作成できた時の値をメモする。そうすれば再現可能なので


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
rgb_value=fmincon(@find_rgb,rgb_i,[],[],[],[],lb,ub);
for j=1:391
    energy(j)=rgb_value(1)*spectrum(10+j,1)+rgb_value(2)*spectrum(10+j,2)+rgb_value(3)*spectrum(10+j,3);
    Y_sum=Y_sum+energy(j)*XYZ_sens(2,j);
end
magnification=Y/Y_sum;
energy=magnification*energy;
writematrix(energy,'energy_sum.csv');%ここの値もメモしてもいいかも
lb=zeros([1 22]);
ub=zeros([1 22]);
middle=zeros([1 22]);
for j=1:22
    ub(j)=3;
    middle(j)=0.3;
end
LED_intensity_scale=ga(@LED_to_energy,22,[],[],[],[],lb,ub);
%LED_intensity_scale=fmincon(@LED_to_energy,middle,[],[],[],[],lb,ub);
%{
ASCII=make_ASCII(LED_intensity_scale);
format long
s=serialport("COM3",460800);
configureTerminator(s,"CR");
writeline(s,ASCII);
writematrix(LED_intensity_scale,'LED_memo.csv');
%}