clear
format long
candela=400;
lum=candela/683;
uv=readmatrix("u_v_prime.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
ALL_coefficient_multi=readmatrix("ALL_coefficient_multi4.csv");
LED_stim_change=zeros([10 24]);


object_ipRGC_low=0.34;
object_ipRGC_high=0.51;
options = optimoptions('fmincon','MaxFunctionEvaluations', 1e+04,'ConstraintTolerance', 1e-12); 
i=1;
for j=1:10
    rng('shuffle');
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
    middle = randi([0, 8], 1, 24);
    X=0;Y=0;Z=0;ipRGC=0;
    
    writematrix(XYZ_value,'object_XYZ.csv');
    writematrix(object_ipRGC_low,'object_ipRGC.csv');
    %writematrix(object_ipRGC_high,'object_ipRGC.csv');
    
    LED_stim=fmincon(@LED2XYZ,middle,[],[],[],[],lb,ub,@ipRGC_constraint2,options);
    LED_stim_change(j,:)=LED_stim;
end
fprintf('Iteration %d: Y = %.4f, x = %.4f, y = %.4f, ipRGC_low = %.4f, ipRGC_high = %.4f\n', i, 400/683, x, y, 0.34, 0.51);
for k=1:10
    LED_stim_one=[LED_stim_change(k,:) 1];
    spectrum=LED_stim_one*(ALL_coefficient_multi');
    X=0;Y=0;Z=0;ipRGC=0;
    for j=1:391
        X=X+spectrum(j)*XYZ_sens(1,j);
        Y=Y+spectrum(j)*XYZ_sens(2,j);
        Z=Z+spectrum(j)*XYZ_sens(3,j);
        ipRGC=ipRGC+spectrum(j)*ipRGC_sens(j);
    end
    x=X/(X+Y+Z);
    y=Y/(X+Y+Z);
    fprintf('LED_stim_high: Y = %.4f, x = %.4f, y = %.4f, ipRGC = %.4f\n', Y, x, y, ipRGC);
end
x=390:1:780;
for k=1:10
    LED_stim_one=[LED_stim_change(k,:) 1];
    spectrum=LED_stim_one*(ALL_coefficient_multi');
    plot(x,spectrum)
    xlabel("波長")
    hold on
end
%writematrix(LED_stim_change,"LED_?deg_?.csv");