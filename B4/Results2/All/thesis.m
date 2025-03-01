x=[166 198 190 152 127 106 106 128];
x=sort(x);
a=100;
for i=1:8
    min=(x(i)-x(1))/x(i);
    max=(x(8)-x(i))/x(i);
    if min>max
        if min<a
            a=min;
            middle=i;
        end
    else
        if max<a
            a=max;
            middle=i;
        end          
    end
end
i=5;
ave=0;
for j=1:8
    ave=ave+abs(x(i)-x(j))/(8*x(i));
end