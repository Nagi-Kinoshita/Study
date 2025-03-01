clear
format long
candela=400;
lum=candela/683;
uv=readmatrix("u_v_prime.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
ALL_coefficient_multi=readmatrix("ALL_coefficient_multi4.csv");
LED_stim_all=readmatrix("LED_stim_all.csv");


object_ipRGC_low=0.34;
object_ipRGC_high=0.51;
options = optimoptions('fmincon','MaxFunctionEvaluations', 1e+04,'ConstraintTolerance', 1e-12); 
for i=1:8
    Y=lum;
    u=uv(1,i);
    v=uv(2,i);
    x=(9*u)/(6*u-16*v+12);
    y=(4*v)/(6*u-16*v+12);    
    XYZ_value=zeros([1 3]);
    XYZ_value(2)=Y;
    XYZ_value(1)=XYZ_value(2)*x/y;
    XYZ_value(3)=XYZ_value(2)*(1-x-y)/y;
    lb=zeros([1 24]);
    ub=15*ones([1 24]);
    middle=2*ones([1 24]);
    X=0;Y=0;Z=0;ipRGC=0;
    
    writematrix(XYZ_value,'object_XYZ.csv');
    writematrix(object_ipRGC_low,'object_ipRGC.csv');
    
    LED_stim_low=fmincon(@LED2XYZ,middle,[],[],[],[],lb,ub,@ipRGC_constraint2,options);
    LED_stim_all(2*(i-1)+1,:)=LED_stim_low;

    writematrix(object_ipRGC_high,'object_ipRGC.csv');    
    LED_stim_high=fmincon(@LED2XYZ,middle,[],[],[],[],lb,ub,@ipRGC_constraint2,options);
    LED_stim_all(2*i,:)=LED_stim_high;
end
writematrix(LED_stim_all,"LED_stim_all4.csv")