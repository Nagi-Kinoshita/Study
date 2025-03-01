clear
LED_stim=zeros([1 22]);
LED_stim_2=zeros([1 22]);
%LED_40_stim=readmatrix('LED_8_times_5_intensity2.csv');
%LED_40_stim=readmatrix('LED_40_stim1_true.csv');

LED_40_stim=readmatrix('LED_8_times_5_intensity_ipRGC.csv');
%LED_40_stim=readmatrix('LED_8_times_5_intensity.csv');
%LED_40_stim_2=readmatrix('memo.csv');
%LED_8_stim=readmatrix('LED_intensity_scale_all.csv');
%LED_8_stim=readmatrix('LED_intensity_scale_all_new.csv');
S_out=zeros([8 5]);
M_out=zeros([8 5]);
L_out=zeros([8 5]);
Rod_out=zeros([8 5]);
X=zeros([8 5]);
Y=zeros([8 5]);
Y_2=zeros([8 5]);
Y_diff=zeros([8 5]);
Z=zeros([8 5]);
ipRGC_out=zeros([8 5]);
ipRGC_magnification=zeros([8 5]);
syou=0;
amari=0;
XYZ=zeros([3 8]);
luminance=zeros([1 40]);
for i=1:40
%for i=1:8
    for j=1:22
        LED_stim(j)=LED_40_stim(i,j);
        %LED_stim(j)=LED_8_stim(i,j);
        %LED_stim_2(j)=LED_40_stim_2(i,j);
    end
    S_M_L_Rod_ipRGC_out=calculate_cell_out(LED_stim);
    X_Y_Z=calculate_X_Y_Z(LED_stim);
    luminance(i)=calculate_lum(LED_stim)*683;
    %X_Y_Z_2=calculate_X_Y_Z(LED_stim_2);
    [syou,amari]=quorem(sym(i-1),sym(5));
    lum_all(syou+1,amari+1)=luminance(i);
    S_out(syou+1,amari+1)=S_M_L_Rod_ipRGC_out(1);
    M_out(syou+1,amari+1)=S_M_L_Rod_ipRGC_out(2);
    L_out(syou+1,amari+1)=S_M_L_Rod_ipRGC_out(3);
    Rod_out(syou+1,amari+1)=S_M_L_Rod_ipRGC_out(4);
    ipRGC_out(syou+1,amari+1)=S_M_L_Rod_ipRGC_out(5);
    X(syou+1,amari+1)=X_Y_Z(1);
    Y(syou+1,amari+1)=X_Y_Z(2);
    %Y_2(syou+1,amari+1)=X_Y_Z_2(2);
    Z(syou+1,amari+1)=X_Y_Z(3);
%    XYZ(1,i)=X_Y_Z(1);
%    XYZ(2,i)=X_Y_Z(2);
%    XYZ(3,i)=X_Y_Z(3);
    scotopic_Td(syou+1,amari+1)=calculate_scotopic_Td(Y(syou+1,amari+1),Rod_out(syou+1,amari+1));
end
%Y_diff=Y_2-Y;
%{
for i=1:40
    [syou,amari]=quorem(sym(i-1),sym(5));
    ipRGC_magnification(syou+1,amari+1)=ipRGC_out(syou+1,amari+1)/ipRGC_out(syou+1,3);
end
%}