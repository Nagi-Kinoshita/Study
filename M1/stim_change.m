%ALL_stim=readmatrix("ALL_stim_low.csv");
ALL_stim=readmatrix("ALL_stim_high.csv");
gamma=readmatrix("gamma.csv");
for i=1:5
    for j=1:26
        low1_stim(j)=ALL_stim(5*(i-1)+1,j);
        low1_stim_gamma(j)=100*((low1_stim(j)/100)^gamma(j));%gamma変換をする。
        high5_stim(j)=ALL_stim(5*(i-1)+5,j);
        high5_stim_gamma(j)=100*((high5_stim(j)/100)^gamma(j));%gamma変換をする。
    end
    low2_stim_gamma=low1_stim_gamma+(high5_stim_gamma-low1_stim_gamma)/4;
    for j=1:26
        ALL_stim(5*(i-1)+2,j)=100*((low2_stim_gamma(j)/100)^(1/gamma(j)));
    end
    mid3_stim_gamma=low1_stim_gamma+(high5_stim_gamma-low1_stim_gamma)*2/4;
    for j=1:26
        ALL_stim(5*(i-1)+3,j)=100*((mid3_stim_gamma(j)/100)^(1/gamma(j)));
    end    
    high4_stim_gamma=low1_stim_gamma+(high5_stim_gamma-low1_stim_gamma)*3/4;
    for j=1:26
        ALL_stim(5*(i-1)+4,j)=100*((high4_stim_gamma(j)/100)^(1/gamma(j)));
    end    
end
%writematrix(ALL_stim,"ALL_stim_low2.csv")
writematrix(ALL_stim,"ALL_stim_high2.csv")