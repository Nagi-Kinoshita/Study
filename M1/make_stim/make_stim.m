clear
candela=400;
lum=candela/683;
uv=readmatrix("u_v_prime.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
i=1;
Y=lum;
u=uv(1,i);
v=uv(2,i);
x=(9*u)/(6*u-16*v+12);
y=(4*v)/(6*u-16*v+12);    
XYZ_value=zeros([1 3]);
XYZ_value(2)=Y;
XYZ_value(1)=XYZ_value(2)*x/y;
XYZ_value(3)=XYZ_value(2)*(1-x-y)/y;
lb=zeros([1 391]);
ub=3*ones([1 391]);
middle=ones([1 391]);
X=0;Y=0;Z=0;ipRGC=0;

object_ipRGC=0.3;

writematrix(XYZ_value,'object_XYZ.csv');
writematrix(object_ipRGC,'object_ipRGC.csv');
spectrum=ga(@spectrum2XYZ,391,[],[],[],[],lb,ub,@ipRGC_constraint);
fprintf('Object');
fprintf('X = %.2f\n', XYZ_value(1));
fprintf('Y = %.2f\n', XYZ_value(2));
fprintf('Z = %.2f\n', XYZ_value(3));
fprintf('ipRGC = %.2f\n', object_ipRGC);

for i=1:391
    X=X+spectrum(i)*XYZ_sens(1,i);
    Y=Y+spectrum(i)*XYZ_sens(2,i);
    Z=Z+spectrum(i)*XYZ_sens(3,i);
    ipRGC=ipRGC+spectrum(i)*ipRGC_sens(i);
end
fprintf('Calculate');
fprintf('X = %.2f\n', X);
fprintf('Y = %.2f\n', Y);
fprintf('Z = %.2f\n', Z);
fprintf('ipRGC = %.2f\n', ipRGC);
spectrum_ones=[spectrum 1];

LED_stim=spectrum_ones*(ALL_coefficient_multi');
LED_stim



