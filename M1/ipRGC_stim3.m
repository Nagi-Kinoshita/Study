matclear
candela=400;
lum=candela/683;
writematrix(lum,'lum_obj.csv');
Y=lum;
uv=readmatrix('u_v_prime.csv');

lb=zeros([1 26]);
ub=zeros([1 26]);
middle=zeros([1 26]);
LED_8_intensity=zeros([8 26]);
for j=1:26
    ub(j)=20;
    middle(j)=1;
end
options = optimoptions(@fmincon,'MaxFunctionEvaluations', 30000,'OptimalityTolerance', 1.0000e-04,'ConstraintTolerance',1.0000e-04)
i=8;
u=uv(1,i);
v=uv(2,i);
x=(9*u)/(6*u-16*v+12);
y=(4*v)/(6*u-16*v+12);    
XYZ_value=zeros([1 3]);
XYZ_value(2)=Y;
XYZ_value(1)=XYZ_value(2)*x/y;
XYZ_value(3)=XYZ_value(2)*(1-x-y)/y;
writematrix(XYZ_value,'XYZ_value.csv');
ipRGC=0.545;
writematrix(ipRGC,'ipRGC_object.csv');
for i=1:4
    LED_intensity_scale=fmincon(@XYZ_constraint2,middle,[],[],[],[],lb,ub,@ipRGC_constraint,options);
    for j=1:32
        LED_4_intensity(i,j)=LED_intensity_scale(j);
    end
    ipRGC=ipRGC+0.07;
    writematrix(ipRGC,'ipRGC_object.csv');
end
%writematrix(LED_4_intensity,"LED_4_intensity_3.csv");