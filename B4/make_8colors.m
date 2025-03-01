clear
Y=20;
%{
lb=0.8;
ub=1.2;
gamma=zeros([1 22]);
for i=1:22
    writematrix(i,'number.csv');
    gamma(i)=fmincon(@gamma_calculate,1,[],[],[],[],lb,ub);%398nm~698nmのgamma値を誤差二乗和を最小化する形で1つずつ求める(1つずつにしたのは最適化しやすくするため）
end
writematrix(gamma,'gamma.csv');
%}
n=0
make_8_standard(Y);%基準となる8色を求める
%{
n=1
rgb_to_LED_intensity(Y);
%rgb_to_LED_intensity_copy(Y);
n=2
x=make_8_times_5_stim
%}


