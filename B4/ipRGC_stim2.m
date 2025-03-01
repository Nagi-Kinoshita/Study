candela=400;
lum=candela/683;
writematrix(lum,'lum_obj.csv');
Y=lum;
ipRGC=0.48;
mag=ipRGC*1;
writematrix(mag,'ipRGC_object.csv');
uv=readmatrix('u_v_prime.csv');

lb=zeros([1 22]);
ub=zeros([1 22]);
middle=zeros([1 22]);
LED_8_intensity=zeros([8 22]);
for j=1:22
    ub(j)=20;
    middle(j)=1;
end
options = optimoptions(@fmincon,'MaxFunctionEvaluations', 30000,'OptimalityTolerance', 1.0000e-04,'ConstraintTolerance',1.0000e-04)
for i=1:8
    if 4<i&&i<8
        continue
    end
    u=uv(1,i);
    v=uv(2,i);
    %writematrix(ipRGC,'ipRGC_object.csv');
    x=(9*u)/(6*u-16*v+12);
    y=(4*v)/(6*u-16*v+12);
    
    XYZ_value=zeros([1 3]);
    XYZ_value(2)=Y;
    XYZ_value(1)=XYZ_value(2)*x/y;
    XYZ_value(3)=XYZ_value(2)*(1-x-y)/y;
    writematrix(XYZ_value,'XYZ_value.csv');
    LED_intensity_scale=fmincon(@perfect,middle,[],[],[],[],lb,ub,@XYZ_constraint,options);
    %LED_intensity_scale=fmincon(@perfect,middle,[],[],[],[],lb,ub,@XYZ_constraint,options);
    %LED_intensity_scale=ga(@perfect,32,[],[],[],[],lb,ub,@XYZ_constraint);
    for j=1:22
        LED_8_intensity(i,j)=LED_intensity_scale(j);
    end
    %options = optimoptions(@ga,'FunctionTolerance', 1e-6)
    %LED_intensity_scale=ga(@perfect,32,[],[],[],[],lb,ub,@XYZ_constraint,options);
end
writematrix(LED_8_intensity,"ipRGC_48.csv");