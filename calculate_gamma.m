All_Rad=readmatrix("All_Rad.csv");
memo=zeros([1 4]);
gamma=zeros([2 391*24]);
gamma_out=zeros([1,2]);
middle=[0.2 1];
lb=[0 0];
ub=[0.3 5];
options = optimoptions('fmincon', 'Display', 'off');


for i=1:24
    i
    for j=1:391
        for k=1:4
            memo(k)=All_Rad(4*(i-1)+k,j);
        end
        writematrix(memo,"memo.csv");
        gamma_out=fmincon(@gamma_opt,middle,[],[],[],[],lb,ub,[],options);
        gamma(1,391*(i-1)+j)=gamma_out(1);
        gamma(2,391*(i-1)+j)=gamma_out(2);
    end
end
writematrix(gamma,"gamma_second.csv");