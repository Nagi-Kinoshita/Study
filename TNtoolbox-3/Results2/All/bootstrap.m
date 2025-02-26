clear 

part1=calculate_diff(1);
part2=calculate_diff(5);
part3=calculate_diff(10);
part4=calculate_diff(14);
part5=calculate_diff(18);
part6=calculate_diff(22);
prob=zeros([1 8]);
for k=1:8
    check=zeros([1 10000]);
    data(1)=part1(k,1);
    data(2)=part2(k,1);
    data(3)=part3(k,1);
    data(4)=part4(k,1);
    data(5)=part5(k,1);
    data(6)=part6(k,1);
    for i=1:10000
        a=0;
        for j=1:5
            rng(6*i+j)
            random_number=randperm(5);
            a=a+data(random_number(1));
        end
        if a>0
            check(i)=1;
        end
    end
    prob(k)=mean(check);
end