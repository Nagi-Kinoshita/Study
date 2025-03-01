clear
uv=readmatrix('u_v_prime.csv');
candela=400;
lum=candela/683;
Y=lum;
writematrix(lum,'lum_obj.csv');
ipRGC_max_min=zeros([2 8]);
mag=zeros([2 8]);
memo=zeros([4 33]);
for i=1:8
    u=uv(1,i);
    v=uv(2,i);
    x=(9*u)/(6*u-16*v+12);
    y=(4*v)/(6*u-16*v+12);
    XYZ_value=zeros([1 3]);
    XYZ_value(2)=Y;
    XYZ_value(1)=XYZ_value(2)*x/y;
    XYZ_value(3)=XYZ_value(2)*(1-x-y)/y;
    writematrix(XYZ_value,'XYZ_value.csv');
    lb=zeros([1 32]);
    ub=zeros([1 32]);
    middle=zeros([1 32]);
    for j=1:32
        ub(j)=20;
        middle(j)=1;
    end
    LED_intensity_min=fmincon(@ipRGC_min_design,middle,[],[],[],[],lb,ub,@XYZ_constraint);
    %LED_intensity_min=ga(@ipRGC_min_design,32,[],[],[],[],lb,ub,@XYZ_constraint);
    number=2*(i-1)+1
    LED_intensity_max=fmincon(@ipRGC_max_design,middle,[],[],[],[],lb,ub,@XYZ_constraint);
    %LED_intensity_max=ga(@ipRGC_max_design,32,[],[],[],[],lb,ub,@XYZ_constraint);
    number=2*i
    ipRGC_max_min(1,i)=-ipRGC_max_design(LED_intensity_max);
    ipRGC_max_min(2,i)=ipRGC_min_design(LED_intensity_min);
    for j=1:32
        memo(1,j)=LED_intensity_max(j);
        memo(2,j)=LED_intensity_min(j);
    end
end
writematrix(ipRGC_max_min,'ipRGC_max_min.csv');
%{
for i=1:8
    mag(1,i)=2*ipRGC_max_min(1,i)/(ipRGC_max_min(1,i)+ipRGC_max_min(2,i));
    mag(2,i)=2*ipRGC_max_min(2,i)/(ipRGC_max_min(1,i)+ipRGC_max_min(2,i));
end
writematrix(ipRGC_max_min,'ipRGC_range.csv');
%}