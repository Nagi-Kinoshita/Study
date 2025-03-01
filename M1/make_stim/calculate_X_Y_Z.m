function X_Y_Z_out=calculate_X_Y_Z(LED_stim)
ALL_coefficient_multi=readmatrix("ALL_coefficient_multi4.csv");
XYZ_sens=readmatrix('XYZ_sens.csv');
X_sens=zeros([1 391]);
Y_sens=zeros([1 391]);
Z_sens=zeros([1 391]);
for i=1:391
    X_sens(i)=XYZ_sens(1,i);
    Y_sens(i)=XYZ_sens(2,i);
    Z_sens(i)=XYZ_sens(3,i);
end
LED_stim_one=[LED_stim 1];
spectrum=LED_stim_one*(ALL_coefficient_multi');
X_Y_Z_out(1)=0;
X_Y_Z_out(2)=0;
X_Y_Z_out(3)=0;
for i=1:391
    X_Y_Z_out(1)=X_Y_Z_out(1)+spectrum(i)*X_sens(i);%分光分布と等色関数の積をとることでX、Y、Zの大きさを求める
    X_Y_Z_out(2)=X_Y_Z_out(2)+spectrum(i)*Y_sens(i);
    X_Y_Z_out(3)=X_Y_Z_out(3)+spectrum(i)*Z_sens(i);
end
end