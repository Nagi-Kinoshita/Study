function output = calculate_X_Y_Z(LED_stim)
gamma=readmatrix("gamma_second.csv");
spectrum=zeros([1 391]);
for i=1:24
    for j=1:391
        spectrum(j)=spectrum(j)+gamma(1,391*(i-1)+j)*((LED_stim(i)/100)^gamma(2,391*(i-1)+j))
    end
end

end