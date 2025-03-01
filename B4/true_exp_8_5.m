clear

i=1;
scale=1;
magnification=[0.8,0.9,1,1.1,1.2];%ipRGCの倍率
Y=0.199;%変える
x=0.354;%ここの値を頑張って調整して、最終的なxyを実現する
y=0.2998;%ここの値を頑張って調整して、最終的なxyを実現する、最終的に作成できた時の値をメモする。そうすれば再現可能なので


LED_stim_all=readmatrix('LED_intensity_scale_all.csv');
for j=1:22
    LED_stim(j)=LED_stim_all(i,j);
end
LED_cell_out=calculate_cell_out(LED_stim);
ipRGC_object=LED_cell_out(5)*magnification(scale);
writematrix(ipRGC_object,'ipRGC_object.csv');
XYZ_value=zeros([1 3]);
XYZ_value(2)=Y;
XYZ_value(1)=XYZ_value(2)*x/y;
XYZ_value(3)=XYZ_value(2)*(1-x-y)/y;
writematrix(XYZ_value,'XYZ_value.csv');
lb=zeros([1 22]);
ub=5*ones([1 22]);
LED_adjust=fmincon(@XYZ_constraint,LED_stim,[],[],[],[],lb,ub,@ipRGC_constraint);

