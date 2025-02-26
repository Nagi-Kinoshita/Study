function x=make_8_times_5_stim
LED_stim_all=readmatrix('LED_intensity_scale_all_ipRGC.csv');%先ほど求めた基準となる8色を呈示するLED強度、8×22
x=1;
LED_stim=zeros([1 22]);
lb=zeros([1 22]);
ub=zeros([1 22]);
for j=1:22
    ub(j)=100;
end
separator='';
for i=1:8
    for j=1:22
        LED_stim(j)=LED_stim_all(i,j);
    end
    LED_cell_out=calculate_cell_out(LED_stim);%基準となる刺激のSML錐体、ipRGCの反応の大きさを計算する。
    writematrix(LED_cell_out,'EEW_S_M_L_Rod_ipRGC_out.csv');
    LED_max=fmincon(@ipRGC_max_design,LED_stim,[],[],[],[],lb,ub,@max_min_constraint);%ipRGCが最大、ただしLMS錐体の反応は同じ大きさになるようなLED強度を求める。
    LED_min=fmincon(@ipRGC_min_design,LED_stim,[],[],[],[],lb,ub,@max_min_constraint);%ipRGCが最小、ただしLMS錐体の反応は同じ大きさになるようなLED強度を求める。
    LED_max_out=calculate_cell_out(LED_max);
    LED_min_out=calculate_cell_out(LED_min);
    ipRGC_stim_max_min(1)=LED_cell_out(5);%基準となる刺激のipRGC強度の大きさを求める
    ipRGC_stim_max_min(2)=LED_max_out(5);%ipRGC最大となるときのipRGCの大きさを求める
    ipRGC_stim_max_min(3)=LED_min_out(5);%ipRGC最小となるときのipRGCの大きさを求める
    filename=strjoin(["ipRGC_stim_max_min_",num2str(i*45),"deg.csv"],separator);
    writematrix(ipRGC_stim_max_min,filename);
end