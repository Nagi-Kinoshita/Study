clear
format long


i=1;
scale=2;


Y=0.23;%ここを調整する、上から順に調整したほうがよさそう。


LED_stim_all=readmatrix('LED_intensity_scale_all.csv');
gamma=readmatrix('gamma.csv');
LED_stim=zeros([1 22]);
LED_max=zeros([1 22]);
LED_min=zeros([1 22]);
LED_gamma=zeros([1 22]);
LED_max_gamma=zeros([1 22]);
LED_min_gamma=zeros([1 22]);
LED_interpolation=zeros([1 22]);
magnification=[0.8,0.9,1,1.1,1.2];%ipRGCの倍率
memo=zeros([8 22]);
LED_stim_max_min=readmatrix('adjust.csv');
for j=1:22
    LED_stim(j)=LED_stim_all(i,j);
    LED_max(j)=LED_stim_max_min(1,j);
    LED_min(j)=LED_stim_max_min(2,j);
end
for j=1:22
    LED_gamma(j)=100*((LED_stim(j)/100)^gamma(j));%gamma補正する
    LED_max_gamma(j)=100*((LED_max(j)/100)^gamma(j));
    LED_min_gamma(j)=100*((LED_min(j)/100)^gamma(j));
end
LED_cell_out=calculate_cell_out(LED_stim);
LED_max_out=calculate_cell_out(LED_max);
LED_min_out=calculate_cell_out(LED_min);
ipRGC_stim_max_min(1)=LED_cell_out(5);%基準となる刺激のipRGC強度の大きさを求める
ipRGC_stim_max_min(2)=LED_max_out(5);%ipRGC最大となるときのipRGCの大きさを求める
ipRGC_stim_max_min(3)=LED_min_out(5);%ipRGC最小となるときのipRGCの大きさを求める
if scale==1||2
    ipRGC_magnification=ipRGC_stim_max_min(1)*magnification(scale);
    part=(ipRGC_magnification-ipRGC_stim_max_min(1))/(ipRGC_stim_max_min(3)-ipRGC_stim_max_min(1));
    for k=1:22
        LED_interpolation(k)=LED_gamma(k)+part*(LED_min_gamma(k)-LED_gamma(k));
    end    
end  
if scale==4||5
    ipRGC_magnification=ipRGC_stim_max_min(1)*magnification(scale);
    part=(ipRGC_magnification-ipRGC_stim_max_min(1))/(ipRGC_stim_max_min(2)-ipRGC_stim_max_min(1));
    for k=1:22
        LED_interpolation(k)=LED_gamma(k)+part*(LED_max_gamma(k)-LED_gamma(k));
    end          
end
LED_default=zeros([1 22]);
for j=1:22
    LED_default(j)=100*((LED_interpolation(j)/100)^(1/gamma(j)));
end