clear
standard=readmatrix("ipRGC_48.csv");
ipRGC=0.68;%ここを変える
writematrix(ipRGC,'ipRGC_object.csv');

lb=zeros([1 32]);
ub=zeros([1 32]);
middle=zeros([1 32]);
LED_8_intensity=zeros([8 32]);
for j=1:32
    ub(j)=20;
    middle(j)=1;
end
options = optimoptions(@fmincon,'MaxFunctionEvaluations', 30000,'OptimalityTolerance', 1.0000e-04,'ConstraintTolerance',1.0000e-04)
%for i=4:8
i=4;
    %{
    if 4<i&&i<8
        continue
    end
    %}
    for j=1:32
        LED_stim(j)=standard(i,j);
    end
    cell_out=calculate_cell_out(LED_stim);
    cell_out(5)=ipRGC;
    writematrix(cell_out,'cell_object.csv');
    LED_intensity_scale=fmincon(@sens_constraint,middle,[],[],[],[],lb,ub,@ipRGC_constraint,options);
    %LED_intensity_scale=fmincon(@perfect,middle,[],[],[],[],lb,ub,@XYZ_constraint,options);
    %LED_intensity_scale=ga(@perfect,32,[],[],[],[],lb,ub,@XYZ_constraint);
    for j=1:32
        LED_8_intensity(i,j)=LED_intensity_scale(j);
    end
    %options = optimoptions(@ga,'FunctionTolerance', 1e-6)
    %LED_intensity_scale=ga(@perfect,32,[],[],[],[],lb,ub,@XYZ_constraint,options);
%end
%writematrix(LED_8_intensity,"ipRGC_74.csv");%ここも変える