clear
format long
candela=400;
lum=candela/683;
uv=readmatrix("u_v_prime.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
ALL_coefficient_multi=readmatrix("ALL_coefficient_multi2.csv");
LED_stim_all=readmatrix("LED_stim_all.csv");


i=7;
j=14;%書きたい行数
object_ipRGC=0.55;%0.34~or0.54

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
writematrix(object_ipRGC,'object_ipRGC.csv');
fprintf('Object\n');
fprintf('Y = %.5f\n', XYZ_value(2));
fprintf('x = %.5f\n', x);
fprintf('y = %.5f\n', y);
fprintf('ipRGC = %.5f\n', object_ipRGC);

options = optimoptions('fmincon','MaxFunctionEvaluations', 1e+04,'ConstraintTolerance', 1e-12); 
LED_stim=fmincon(@LED2XYZ,middle,[],[],[],[],lb,ub,@ipRGC_constraint2,options);



LED_stim_one=[LED_stim 1];
spectrum=LED_stim_one*(ALL_coefficient_multi');

for i=1:391
    X=X+spectrum(i)*XYZ_sens(1,i);
    Y=Y+spectrum(i)*XYZ_sens(2,i);
    Z=Z+spectrum(i)*XYZ_sens(3,i);
    ipRGC=ipRGC+spectrum(i)*ipRGC_sens(i);
end
x=X/(X+Y+Z);
y=Y/(X+Y+Z);
fprintf('Calculate\n');
fprintf('Y = %.5f\n', Y);
fprintf('x = %.5f\n', x);
fprintf('y = %.5f\n', y);
fprintf('ipRGC = %.5f\n', ipRGC);
spectrum_ones=[spectrum 1];

LED_stim_all(j,:)=LED_stim;
writematrix(LED_stim_all,"LED_stim_all.csv")