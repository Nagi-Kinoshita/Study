clear
%LED_20_stim=readmatrix("object_spectrum_low.csv");
%LED_20_stim=readmatrix("LED_25_stim_low.csv");
%LED_20_stim=readmatrix("Low_stim_spectrum2.csv");
LED_20_stim=readmatrix("High_stim_spectrum2.csv");
L_sens=readmatrix("L_sens.csv");
M_sens=readmatrix("M_sens.csv");
S_sens=readmatrix("S_sens.csv");
Rod_sens=readmatrix("Rod_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
S_out=zeros([5 5]);
M_out=zeros([5 5]);
L_out=zeros([5 5]);
Rod_out=zeros([5 5]);
X=zeros([5 5]);
Y=zeros([5 5]);
Z=zeros([5 5]);
x=zeros([5 5]);
y=zeros([5 5]);
ipRGC_out=zeros([5 5]);
scotopic_Td=zeros([5 5]);
syou=0;
amari=0;
for i=1:25
    [syou,amari]=quorem(sym(i-1),sym(5));
    for j=1:391
        L_out(syou+1,amari+1)=L_out(syou+1,amari+1)+LED_20_stim(i,j)*L_sens(j);
        M_out(syou+1,amari+1)=M_out(syou+1,amari+1)+LED_20_stim(i,j)*M_sens(j);
        S_out(syou+1,amari+1)=S_out(syou+1,amari+1)+LED_20_stim(i,j)*S_sens(j);
        Rod_out(syou+1,amari+1)=Rod_out(syou+1,amari+1)+LED_20_stim(i,j)*Rod_sens(j);
        ipRGC_out(syou+1,amari+1)=ipRGC_out(syou+1,amari+1)+LED_20_stim(i,j)*ipRGC_sens(j);
        X(syou+1,amari+1)=X(syou+1,amari+1)+LED_20_stim(i,j)*XYZ_sens(1,j);
        Y(syou+1,amari+1)=Y(syou+1,amari+1)+LED_20_stim(i,j)*XYZ_sens(2,j);
        Z(syou+1,amari+1)=Z(syou+1,amari+1)+LED_20_stim(i,j)*XYZ_sens(3,j);
    end
    x(syou+1,amari+1)=X(syou+1,amari+1)/(X(syou+1,amari+1)+Y(syou+1,amari+1)+Z(syou+1,amari+1));
    y(syou+1,amari+1)=Y(syou+1,amari+1)/(X(syou+1,amari+1)+Y(syou+1,amari+1)+Z(syou+1,amari+1)); 
    scotopic_Td(syou+1,amari+1)=calculate_scotopic_Td(Y(syou+1,amari+1),Rod_out(syou+1,amari+1));
end
%{
writematrix(L_out,"Object_L_low_data.csv");
writematrix(M_out,"Object_M_low_data.csv");
writematrix(S_out,"Object_S_low_data.csv");
writematrix(Rod_out,"Object_Rod_low_data.csv");
writematrix(ipRGC_out,"Object_ipRGC_low_data.csv");
writematrix(X,"Object_X_low_data.csv");
writematrix(Y,"Object_Y_low_data.csv");
writematrix(Z,"Object_Z_low_data.csv");
writematrix(x,"Object_x_color_low_data.csv");
writematrix(y,"Object_y_color_low_data.csv");
%}
%{
writematrix(L_out,"Calib_L_low_data2.csv");
writematrix(M_out,"Calib_M_low_data2.csv");
writematrix(S_out,"Calib_S_low_data2.csv");
writematrix(Rod_out,"Calib_Rod_low_data2.csv");
writematrix(ipRGC_out,"Calib_ipRGC_low_data2.csv");
writematrix(X,"Calib_X_low_data2.csv");
writematrix(Y,"Calib_Y_low_data2.csv");
writematrix(Z,"Calib_Z_low_data2.csv");
writematrix(x,"Calib_x_color_low_data2.csv");
writematrix(y,"Calib_y_color_low_data2.csv");
%}
%{
writematrix(L_out,"Calib_L_high_data2.csv");
writematrix(M_out,"Calib_M_high_data2.csv");
writematrix(S_out,"Calib_S_high_data2.csv");
writematrix(Rod_out,"Calib_Rod_high_data2.csv");
writematrix(ipRGC_out,"Calib_ipRGC_high_data2.csv");
writematrix(X,"Calib_X_high_data2.csv");
writematrix(Y,"Calib_Y_high_data2.csv");
writematrix(Z,"Calib_Z_high_data2.csv");
writematrix(x,"Calib_x_color_high_data2.csv");
writematrix(y,"Calib_y_color_high_data2.csv");
%}