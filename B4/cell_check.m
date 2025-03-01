data=readmatrix('main_exp_spectrum.csv');
S_sens=readmatrix("S_sens.csv");
M_sens=readmatrix("M_sens.csv");
L_sens=readmatrix("L_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
data_i=zeros([1 391]);
S=zeros([1 40]);
M=zeros([1 40]);
L=zeros([1 40]);
ipRGC=zeros([1 40]);
ipRGC2=zeros([8 5]);
ipRGC_mag=zeros([8 5]);
for i=1:40
    for j=1:391
        data_i(j)=data(i,j);
    end
    for j=1:391
        S(i)=S(i)+data_i(j)*S_sens(j);
        M(i)=M(i)+data_i(j)*M_sens(j);
        L(i)=L(i)+data_i(j)*L_sens(j);
        ipRGC(i)=ipRGC(i)+data_i(j)*ipRGC_sens(j);
    end
end
for i=1:8
    for j=1:5
        ipRGC2(i,j)=ipRGC(5*(i-1)+j);
    end
    for j=1:5
        ipRGC_mag(i,j)=ipRGC(5*(i-1)+j)/ipRGC(5*(i-1)+3);
    end
end