data=readmatrix('LED_20_stim_low.csv');
S_sens=readmatrix("S_sens.csv");
M_sens=readmatrix("M_sens.csv");
L_sens=readmatrix("L_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
data_i=zeros([1 391]);
S=zeros([5,4]);
M=zeros([5,4]);
L=zeros([5,4]);
ipRGC=zeros([5,4]);
X=zeros([5 4]);
Y=zeros([5 4]);
Z=zeros([5 4]);
for i=1:20
    [syou,amari]=quorem(sym(i-1),sym(4));
    for j=1:391
        data_i(j)=data(i,j);
    end
    for j=1:391
        S(syou+1,amari+1)=S(syou+1,amari+1)+data_i(j)*S_sens(j);
        M(syou+1,amari+1)=M(syou+1,amari+1)+data_i(j)*M_sens(j);
        L(syou+1,amari+1)=L(syou+1,amari+1)+data_i(j)*L_sens(j);
        ipRGC(syou+1,amari+1)=ipRGC(syou+1,amari+1)+data_i(j)*ipRGC_sens(j);
        X(syou+1,amari+1)=X(syou+1,amari+1)+data_i(j)*XYZ_sens(1,j);
        Y(syou+1,amari+1)=Y(syou+1,amari+1)+data_i(j)*XYZ_sens(2,j);
        Z(syou+1,amari+1)=Z(syou+1,amari+1)+data_i(j)*XYZ_sens(3,j);      
    end
    
end