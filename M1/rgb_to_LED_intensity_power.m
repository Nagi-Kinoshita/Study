clear

candela=600;
lum=candela/683;
writematrix(lum,'lum_obj.csv');
Y=lum;
ipRGC=0.465;
mag=ipRGC*1;
writematrix(mag,'ipRGC_object.csv');
uv=readmatrix('u_v_prime.csv');

lb=zeros([1 32]);
ub=zeros([1 32]);
middle=zeros([1 32]);
LED_8_intensity=zeros([8 32]);
for j=1:32
    ub(j)=20;
    middle(j)=1;
end
%options = optimoptions(@fmincon,'MaxFunctionEvaluations', 30000,'OptimalityTolerance', 1.0000e-04,'ConstraintTolerance',1.0000e-04)
for i=1:8
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
    LED_intensity_scale=fmincon(@perfect,middle,[],[],[],[],lb,ub,@XYZ_constraint);
    %LED_intensity_scale=fmincon(@perfect,middle,[],[],[],[],lb,ub,@XYZ_constraint,options);
    %LED_intensity_scale=ga(@perfect,32,[],[],[],[],lb,ub,@XYZ_constraint);
    for j=1:32
        LED_8_intensity(i,j)=LED_intensity_scale(j);
    end
    %options = optimoptions(@ga,'FunctionTolerance', 1e-6)
    %LED_intensity_scale=ga(@perfect,32,[],[],[],[],lb,ub,@XYZ_constraint,options);
end
    %{
ASCII=make_ASCII(LED_intensity_scale);
format long
s=serialport("COM3",460800);
configureTerminator(s,"CR");
writeline(s,ASCII);
writematrix(LED_intensity_scale,'LED_memo.csv');
%}