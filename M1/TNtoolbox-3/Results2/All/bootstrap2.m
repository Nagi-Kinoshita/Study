clear 
part1=calculate_diff(1);
part2=calculate_diff(5);
part3=calculate_diff(10);
part4=calculate_diff(14);
part5=calculate_diff(18);
part6=calculate_diff(22);

prob=zeros([8 8]);
for i=1:8
    dataB(1)=part1(i,1);
    dataB(2)=part2(i,1);
    dataB(3)=part3(i,1);
    dataB(4)=part4(i,1);
    dataB(5)=part5(i,1);
    dataB(6)=part6(i,1);
    for j=i+1:8
        check=zeros([1 10000]);
        dataA(1)=part1(j,1);
        dataA(2)=part2(j,1);
        dataA(3)=part3(j,1);
        dataA(4)=part4(j,1);
        dataA(5)=part5(j,1);
        dataA(6)=part6(j,1);
        for k=1:10000
            a=0;
            b=0;
            for l=1:6
                rng(6*k+l)
                random_number=randperm(6);
                a=a+dataA(random_number(1));
                b=b+dataB(random_number(1));
            end
            if a-b>0
                check(k)=1;
            end
        end
        if mean(check)>0.5
            prob(j,i)=(1-mean(check))*2;
        else
            prob(j,i)=mean(check)*2;
        end
        prob(i,j)=NaN;
    end
    prob(i,i)=NaN;
end
%writematrix(prob,'p_diff_mag.csv')
writematrix(prob,'p_diff_abs.csv')