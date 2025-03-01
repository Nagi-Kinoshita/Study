clear
LED_40_stim=readmatrix('exp2_spectrum.csv');
L_sens=readmatrix("L_sens.csv");
M_sens=readmatrix("M_sens.csv");
S_sens=readmatrix("S_sens.csv");
Rod_sens=readmatrix("Rod_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
S_out=zeros([8 5]);
M_out=zeros([8 5]);
L_out=zeros([8 5]);
Rod_out=zeros([8 5]);
X=zeros([8 5]);
Y=zeros([8 5]);
Z=zeros([8 5]);
ipRGC_out=zeros([8 5]);
syou=0;
amari=0;
for i=1:40
    [syou,amari]=quorem(sym(i-1),sym(5));
    for j=1:391
        L_out(syou+1,amari+1)=L_out(syou+1,amari+1)+LED_40_stim(i,j)*L_sens(j);
        M_out(syou+1,amari+1)=M_out(syou+1,amari+1)+LED_40_stim(i,j)*M_sens(j);
        S_out(syou+1,amari+1)=S_out(syou+1,amari+1)+LED_40_stim(i,j)*S_sens(j);
        Rod_out(syou+1,amari+1)=Rod_out(syou+1,amari+1)+LED_40_stim(i,j)*Rod_sens(j);
        ipRGC_out(syou+1,amari+1)=ipRGC_out(syou+1,amari+1)+LED_40_stim(i,j)*ipRGC_sens(j);
        X(syou+1,amari+1)=X(syou+1,amari+1)+LED_40_stim(i,j)*XYZ_sens(1,j);
        Y(syou+1,amari+1)=Y(syou+1,amari+1)+LED_40_stim(i,j)*XYZ_sens(2,j);
        Z(syou+1,amari+1)=Z(syou+1,amari+1)+LED_40_stim(i,j)*XYZ_sens(3,j);
    end
end