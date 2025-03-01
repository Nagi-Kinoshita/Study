function rgb_to_LED_intensity(Y)
    rgb=readmatrix('rgb_data.csv');
    spectrum=readmatrix('spectrum_data.csv');
    XYZ_sens=readmatrix('XYZ_sens.csv');
    LED_intensity_scale_all=zeros([8 22]);
    for i=1:8
        Y_sum=0;
        rgb_i=zeros([1 3]);
        for j=1:3
            rgb_i(j)=rgb(j,i);
        end
        energy=zeros([1 391]);
        for j=1:391
            energy(j)=rgb_i(1)*spectrum(10+j,1)+rgb_i(2)*spectrum(10+j,2)+rgb_i(3)*spectrum(10+j,3);
            Y_sum=Y_sum+energy(j)*XYZ_sens(2,j);
        end
        magnification=Y/Y_sum;
        energy=magnification*energy;
        writematrix(energy,'energy_sum.csv');
        lb=zeros([1 22]);
        ub=zeros([1 22]);
        middle=zeros([1 22]);
        for j=1:22
            ub(j)=100;
            middle(j)=50;
        end
        %LED_intensity_scale=ga(@LED_to_energy,22,[],[],[],[],lb,ub);
        LED_intensity_scale=fmincon(@LED_to_energy,middle,[],[],[],[],lb,ub);
        for j=1:22
            LED_intensity_scale_all(i,j)=LED_intensity_scale(j);
        end
    end
    writematrix(LED_intensity_scale_all,'LED_intensity_scale_all.csv')
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