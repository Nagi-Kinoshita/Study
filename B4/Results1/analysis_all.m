x=[0.8;0.9;1;1.1:1.2];
mag_data1=readmatrix(".csv");
mag_data2=readmatrix(".csv");
mag_ave=mag_data1+mag_data2+;
for i=1:8
    X=[x ones(length(x),1)];
    ycalc=X*mag_ave;
    plot(x,ycalc);
end