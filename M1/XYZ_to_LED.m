function diff = XYZ_to_LED(LED_stim)
XYZ_data=readmatrix('XYZ_i.csv');
stim_XYZ=calculate_X_Y_Z(LED_stim);%LED強度→XYZ値を求めるプログラム
diff=0;
for i=1:3
    diff=diff+(XYZ_data(i)-stim_XYZ(i))^2;%目的のXYZ値と作成した光源のXYZ値の差が最小になるようにする。
end
end