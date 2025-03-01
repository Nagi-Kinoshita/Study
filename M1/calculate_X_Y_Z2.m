function output = calculate_X_Y_Z2(LED_stim)
gamma=readmatrix("gamma_second.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
spectrum=zeros([1 391]);
output=zeros([1 3]);
for i=1:24
    for j=1:391
        spectrum(j)=spectrum(j)+gamma(1,391*(i-1)+j)*((LED_stim(i)/100)^gamma(2,391*(i-1)+j));
    end
end
for i=1:391
    output(1)=output(1)+XYZ_sens(1,i)*spectrum(i);
    output(2)=output(2)+XYZ_sens(2,i)*spectrum(i);
    output(3)=output(3)+XYZ_sens(3,i)*spectrum(i);
end
end