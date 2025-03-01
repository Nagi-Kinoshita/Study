clear
LED_stim=zeros([1 22]);
LED_stim_2=zeros([1 22]);
LED_20_stim=readmatrix("ALL_stim_low.csv");
S_out=zeros([8 5]);
M_out=zeros([8 5]);
L_out=zeros([8 5]);
Rod_out=zeros([8 5]);
X=zeros([8 5]);
Y=zeros([8 5]);
Z=zeros([8 5]);
ipRGC_out=zeros([8 5]);
ipRGC_magnification=zeros([8 5]);
syou=0;
amari=0;
XYZ=zeros([3 8]);
for i=1:25
    for j=1:26
        LED_stim(j)=LED_20_stim(i,j);
    end
    S_M_L_Rod_ipRGC_out=calculate_cell_out(LED_stim);
    X_Y_Z_lum=calculate_X_Y_Z_lum(LED_stim);
    [syou,amari]=quorem(sym(i-1),sym(5));
    S_out(syou+1,amari+1)=S_M_L_Rod_ipRGC_out(1);
    M_out(syou+1,amari+1)=S_M_L_Rod_ipRGC_out(2);
    L_out(syou+1,amari+1)=S_M_L_Rod_ipRGC_out(3);
    Rod_out(syou+1,amari+1)=S_M_L_Rod_ipRGC_out(4);
    ipRGC_out(syou+1,amari+1)=S_M_L_Rod_ipRGC_out(5);
    X(syou+1,amari+1)=X_Y_Z_lum(1);
    Y(syou+1,amari+1)=X_Y_Z_lum(2);
    Z(syou+1,amari+1)=X_Y_Z_lum(3);
    Lum(syou+1,amari+1)=X_Y_Z_lum(4);
    x(syou+1,amari+1)=X(syou+1,amari+1)/(X(syou+1,amari+1)+Y(syou+1,amari+1)+Z(syou+1,amari+1));
    y(syou+1,amari+1)=Y(syou+1,amari+1)/(X(syou+1,amari+1)+Y(syou+1,amari+1)+Z(syou+1,amari+1)); 
end

%{
writematrix(L_out,"Optimiz_L_low_data.csv");
writematrix(M_out,"Optimiz_M_low_data.csv");
writematrix(S_out,"Optimiz_S_low_data.csv");
writematrix(Rod_out,"Optimiz_Rod_low_data.csv");
writematrix(ipRGC_out,"Optimiz_ipRGC_low_data.csv");
writematrix(X,"Optimiz_X_low_data.csv");
writematrix(Y,"Optimiz_Y_low_data.csv");
writematrix(Z,"Optimiz_Z_low_data.csv");
writematrix(x,"Optimiz_x_color_low_data.csv");
writematrix(y,"Optimiz_y_color_low_data.csv");
%}