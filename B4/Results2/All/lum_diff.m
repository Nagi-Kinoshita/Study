clear
lum_data=readmatrix('lum_8_5.csv');
memo=zeros([1 5]);
middle=zeros([1 8]);
min=zeros([1 8]);
max=zeros([1 8]);
for i=1:8
    for j=1:5
        lum_i(j)=lum_data(i,j);
    end
    x=sort(lum_i);
    a=100;
    for j=1:5
        min(i)=(x(j)-x(1))/x(j);
        max(i)=(x(5)-x(j))/x(j);
        if min(i)>max(i)
            if min(i)<a
                a=min(i);
                middle(i)=j;
            end
        else
            if max(i)<a
                a=max(i);
                middle(i)=j;
            end          
        end
    end
end

for i=1:8
    min(i)=(x(middle(i))-x(1))/x(middle(i));
    max(i)=(x(5)-x(middle(i)))/x(middle(i));
end
ave=(mean(min)+mean(max))/2;