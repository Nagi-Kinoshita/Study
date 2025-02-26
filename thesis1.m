%stim_spectrum=readmatrix('exp1_stim.csv');
stim_spectrum=readmatrix('exp2_stim.csv');
XYZ_sens=readmatrix('XYZ_sens.csv');
Y_sens=zeros([1 391]);
for i=1:391
    Y_sens(i)=XYZ_sens(2,i);
end
ipRGC_sens=readmatrix('ipRGC_sens.csv');
Y=zeros([8 5]);
ipRGC=zeros([8 5]);
ipRGC_magnification=zeros([8 5]);
for i=1:40
    i
    [syou,amari]=quorem(sym(i-1),sym(5));
    for j=1:391
        Y(syou+1,amari+1)=Y(syou+1,amari+1)+stim_spectrum(i,j)*Y_sens(j);
        ipRGC(syou+1,amari+1)=ipRGC(syou+1,amari+1)+stim_spectrum(i,j)*ipRGC_sens(j);
    end
end
for i=1:40
    [syou,amari]=quorem(sym(i-1),sym(5));
    ipRGC_magnification(syou+1,amari+1)=ipRGC(syou+1,amari+1)/ipRGC(syou+1,3);
end
%writematrix(Y,'Y_exp1.csv');
%writematrix(ipRGC,'ipRGC_exp1.csv');
%writematrix(Y,'Y_exp2.csv');
%writematrix(ipRGC,'ipRGC_exp2.csv');
a=zeros([1 8]);
ipRGC_comp=zeros([8 5]);
for i=1:8
    for j=1:5
        a(i)=a(i)+ipRGC_out(i,j)/ipRGC(i,j);
    end
    a(i)=a(i)/5;
    for j=1:5
        ipRGC_comp(i,j)=ipRGC(i,j)*a(i);
    end
end