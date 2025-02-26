clear
datetime.setDefaultFormats('default','yyyy_MM_dd_HH_mm_ss')
datetime
%s=serialport("COM3",460800);
%configureTerminator(s,"CR");
candela=400;
lum=candela/683;
writematrix(lum,'lum_obj.csv');
Y=lum;
lb=zeros([1 26]);
ub=14*ones([1 26]);
middle=5*ones([1 26]);
LED_8_intensity=zeros([8 26]);
x=0.2717;%変える
y=0.253;%変える
ipRGC=0.46;%変える、最低値or最高値 　現在のを目安？Low... 0.32~0.57　High...0.46~0.7 
XYZ_value=zeros([1 3]);
XYZ_value(2)=Y;
XYZ_value(1)=XYZ_value(2)*x/y;
XYZ_value(3)=XYZ_value(2)*(1-x-y)/y;
writematrix(XYZ_value,'XYZ_value.csv');
writematrix(ipRGC,'ipRGC_object.csv');
LED_intensity_scale=ga(@XYZ_constraint2,26,[],[],[],[],lb,ub,@ipRGC_constraint);
%LED_intensity_scale=fmincon(@XYZ_constraint2,middle,[],[],[],[],lb,ub,@ipRGC_constraint);
%LED_intensity_scale=readmatrix("90degree_high.csv");
%stim_ASCII=make_ASCII(LED_intensity_scale);
%writeline(s,stim_ASCII)
%writematrix(LED_intensity_scale,"90degree_high_standard.csv")