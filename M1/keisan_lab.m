clear
LED_stim=zeros([1 22]);
LED_20_stim=readmatrix('LED_20_stim_low.csv');
XYZ_sens=readmatrix("XYZ_sens.csv");
X=zeros([5 4]);
Y=zeros([5 4]);
Z=zeros([5 4]);
syou=0;
amari=0;
Lum=400/683;
white_x=0.31382;
white_y=0.331;
white_X=Lum*white_x/white_y;
white_Y=Lum;
white_Z=Lum*(1-white_x-white_y)/white_y;
for i=1:20
    [syou,amari]=quorem(sym(i-1),sym(4));
    for j=1:391
        X(syou+1,amari+1)=X(syou+1,amari+1)+LED_20_stim(i,j)*XYZ_sens(1,j);
        Y(syou+1,amari+1)=Y(syou+1,amari+1)+LED_20_stim(i,j)*XYZ_sens(2,j);
        Z(syou+1,amari+1)=Z(syou+1,amari+1)+LED_20_stim(i,j)*XYZ_sens(3,j);
    end
    L(syou+1,amari+1)=116*Lab_f(Y(syou+1,amari+1)/white_Y)-16;
    a(syou+1,amari+1)=500*(Lab_f(X(syou+1,amari+1)/white_X)-Lab_f(Y(syou+1,amari+1)/white_Y));
    b(syou+1,amari+1)=200*(Lab_f(Y(syou+1,amari+1)/white_Y)-Lab_f(Z(syou+1,amari+1)/white_Z));
end

for i=1:5
    e(i)=sqrt((a(i,1)-a(i,4))^2+(b(i,1)-b(i,4))^2);
end
%writematrix(a,"low_a.csv");
%writematrix(b,"low_b.csv");
%{
uv=readmatrix("u_v_prime.csv");
for i=1:8
    u=uv(1,i);
    v=uv(2,i);
    xy(1,i)=(9*u)/(6*u-16*v+12);
    xy(2,i)=(4*v)/(6*u-16*v+12);
end
%}