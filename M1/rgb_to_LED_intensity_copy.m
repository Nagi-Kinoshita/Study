function rgb_to_LED_intensity_copy(Y)
    XYZ_data=readmatrix('XYZ_data.csv');
    LED_intensity_scale_all=zeros([8 22]);
    XYZ_i=zeros([1 3]);
    for i=1:8
        for j=1:3
            XYZ_i(j)=XYZ_data(j,i);
        end
        writematrix(XYZ_i,'XYZ_i.csv');
        lb=zeros([1 22]);
        ub=zeros([1 22]);
        middle=zeros([1 22]);
        for j=1:22
            ub(j)=100;
            middle(j)=50;
        end
        LED_intensity_scale=fmincon(@XYZ_to_LED,middle,[],[],[],[],lb,ub);%所望のXYZ値になるようなLED強度を求める
        for j=1:22
            LED_intensity_scale_all(i,j)=LED_intensity_scale(j);
        end
    end
    writematrix(LED_intensity_scale_all,'LED_intensity_scale_all.csv')
    %以下白色光を作るプログラム
    Target_Lum=Y*683;
    Equal_energy_target_design(Target_Lum);
    lb=zeros([1 22]);
    ub=zeros([1 22]);
    medium=zeros([1 22]);
    for i=1:22
        ub(i)=100;
        medium(i)=50;
    end
    EEW=fmincon(@LED_light,medium,[],[],[],[],lb,ub,@Y_constraint);
    writematrix(EEW,'Equal_energy_white.csv');
end