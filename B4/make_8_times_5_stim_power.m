clear


%i=3;
%scale=4;
%Y=0.3;

LED_stim_all=readmatrix('LED_intensity_scale_all_ipRGC.csv');
LED_stim=zeros([1 22]);
magnification=[0.8,0.9,1,1.1,1.2];%ipRGCの倍率
memo=zeros([40 22]);
lb=zeros([1 22]);
ub=5*ones([1 22]);
LED_default=0.5*ones([1 22]);
for i=1:8
    for j=1:22
        LED_stim(j)=LED_stim_all(i,j);
    end
    for scale=1:5
        if scale==3
            for j=1:22
                memo(5*(i-1)+scale,j)=LED_stim(j);
            end
        else
            LED_cell_out=calculate_cell_out(LED_stim);
            %writematrix(Y,'Y.csv');
            LED_cell_out(5)=LED_cell_out(5)*magnification(scale);
            writematrix(LED_cell_out,'cell_object.csv');
            LED_adjust=fmincon(@Y_constraint,LED_default,[],[],[],[],lb,ub,@sens_constraint);
            %LED_adjust=ga(@Y_constraint,22,[],[],[],[],lb,ub,@sens_constraint);
            for j=1:22
                memo(5*(i-1)+scale,j)=LED_adjust(j);
            end
        end
    end
end
writematrix(memo,'LED_8_times_5_intensity_ipRGC_test.csv');