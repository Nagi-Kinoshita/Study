function diff = find_rgb(rgb_value)
    spectrum=readmatrix('spectrum_data.csv');
    XYZ_sens=readmatrix('XYZ_sens.csv');
    energy=zeros([1 391]);
    Y_sum=0;
    XYZ_sum=zeros([1 3]);
    XYZ_value=readmatrix('XYZ_value.csv');
    for j=1:391
        energy(j)=rgb_value(1)*spectrum(10+j,1)+rgb_value(2)*spectrum(10+j,2)+rgb_value(3)*spectrum(10+j,3);
    end
    for j=1:391
        XYZ_sum(1)=XYZ_sum(1)+energy(j)*XYZ_sens(1,j);
        XYZ_sum(2)=XYZ_sum(2)+energy(j)*XYZ_sens(2,j);
        XYZ_sum(3)=XYZ_sum(3)+energy(j)*XYZ_sens(3,j);
    end
    diff=(XYZ_sum(1)-XYZ_value(1))^2+(XYZ_sum(2)-XYZ_value(2))^2+(XYZ_sum(3)-XYZ_value(3))^2;
end