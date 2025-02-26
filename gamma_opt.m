function diff = gamma_opt(gamma)
LED_intensity=[10 40 70 100];
Rad=readmatrix("memo.csv");
Rad_calc=zeros([1 4]);
diff=0;
for i=1:4
    Rad_calc(i)=gamma(1)*((LED_intensity(i)/100)^gamma(2));
    diff=diff+(100*(Rad(i)-Rad_calc(i))/Rad_calc(i))^2;
end
end

