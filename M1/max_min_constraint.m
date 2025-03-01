function [c,ceq] = max_min_constraint(LED_stim)
c=[];
ceq=zeros([1 6]);
max_or_min_S_M_L_Rod_ipRGC_out=calculate_cell_out(LED_stim);
EEW_S_M_L_Rod_ipRGC_out=readmatrix('EEW_S_M_L_Rod_ipRGC_out.csv');
%Rodを除外するならi=1:3にすればよい
for i=1:3
    ceq(i)=(max_or_min_S_M_L_Rod_ipRGC_out(i)-EEW_S_M_L_Rod_ipRGC_out(i))^2;%LMS錐体の反応の大きさについて、基準刺激と作成した刺激で差が最小になるようにする。
end
end