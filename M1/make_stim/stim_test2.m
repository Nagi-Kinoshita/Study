clear
format long
candela=400;
lum=candela/683;
uv=readmatrix("u_v_prime.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
ALL_coefficient_multi=readmatrix("ALL_coefficient_multi2.csv");
LED_stim_all=readmatrix("LED_stim_all2.csv");


for i=1:8
    Y=lum;
    u=uv(1,i);
    v=uv(2,i);
    x=(9*u)/(6*u-16*v+12);
    y=(4*v)/(6*u-16*v+12);
    i
    fprintf('Object\n');
    fprintf('Y = %.5f ', Y);
    fprintf('x = %.5f ', x);
    fprintf('y = %.5f \n', y);
    
    LED_stim_low=LED_stim_all(2*(i-1)+1,:);
    LED_stim_one=[LED_stim_low 1];
    spectrum=LED_stim_one*(ALL_coefficient_multi');
    
    X=0;Y=0;Z=0;
    for j=1:391
        X=X+spectrum(j)*XYZ_sens(1,j);
        Y=Y+spectrum(j)*XYZ_sens(2,j);
        Z=Z+spectrum(j)*XYZ_sens(3,j);
    end
    x=X/(X+Y+Z);
    y=Y/(X+Y+Z);
    fprintf('Calculate_low_high\n');
    fprintf('Y = %.5f ', Y);
    fprintf('x = %.5f ', x);
    fprintf('y = %.5f \n', y);

    LED_stim_high=LED_stim_all(2*i,:);
    LED_stim_one=[LED_stim_high 1];
    spectrum=LED_stim_one*(ALL_coefficient_multi');
    
    X=0;Y=0;Z=0;
    for j=1:391
        X=X+spectrum(j)*XYZ_sens(1,j);
        Y=Y+spectrum(j)*XYZ_sens(2,j);
        Z=Z+spectrum(j)*XYZ_sens(3,j);
    end
    x=X/(X+Y+Z);
    y=Y/(X+Y+Z);
    fprintf('Y = %.5f ', Y);
    fprintf('x = %.5f ', x);
    fprintf('y = %.5f \n', y);
end