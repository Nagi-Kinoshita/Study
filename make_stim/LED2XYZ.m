function diff = LED2XYZ(LED_stim)
ALL_coefficient_multi=readmatrix("ALL_coefficient_multi4.csv");
object_XYZ=readmatrix("object_XYZ.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
LED_stim_one=[LED_stim 1];
spectrum=LED_stim_one*(ALL_coefficient_multi');
X_Y_Z(1)=0;
X_Y_Z(2)=0;
X_Y_Z(3)=0;

for i=1:391
    X_Y_Z(1)=X_Y_Z(1)+spectrum(i)*XYZ_sens(1,i);%分光分布と等色関数の積をとることでX、Y、Zの大きさを求める
    X_Y_Z(2)=X_Y_Z(2)+spectrum(i)*XYZ_sens(2,i);
    X_Y_Z(3)=X_Y_Z(3)+spectrum(i)*XYZ_sens(3,i);
end

diff=(X_Y_Z(1)-object_XYZ(1))^2+(X_Y_Z(2)-object_XYZ(2))^2+(X_Y_Z(3)-object_XYZ(3))^2;
diff=double(diff);
end