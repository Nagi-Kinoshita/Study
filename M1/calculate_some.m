spectrum=readmatrix('spectrum.csv');
L_sens=readmatrix('L_sens.csv');
M_sens=readmatrix('M_sens.csv');
S_sens=readmatrix('S_sens.csv');
ipRGC_sens=readmatrix("ipRGC_sens.csv");
XYZ_sens=readmatrix('XYZ_sens.csv');
X_sens=zeros([1 391]);
Y_sens=zeros([1 391]);
Z_sens=zeros([1 391]);
for i=1:391
    X_sens(i)=XYZ_sens(1,i);
    Y_sens(i)=XYZ_sens(2,i);
    Z_sens(i)=XYZ_sens(3,i);
end
L_out=0;M_out=0;S_out=0;ipRGC_out=0;X=0;Y=0;Z=0;
for i=1:391
    L_out=L_out+spectrum(i)*L_sens(i);
    M_out=M_out+spectrum(i)*M_sens(i);
    S_out=S_out+spectrum(i)*S_sens(i);
    ipRGC_out=ipRGC_out+spectrum(i)*ipRGC_sens(i);
    X=X+spectrum(i)*X_sens(i);
    Y=Y+spectrum(i)*Y_sens(i);
    Z=Z+spectrum(i)*Z_sens(i);
end
