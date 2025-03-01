function residual = gamma_calculate(gamma)
Absolute=[0 10 40 70 100];
j=readmatrix('number.csv');
measurement=readmatrix("Lum_measure.csv");%測定値
gamma_interpolation=zeros([1 5]);
gamma_error=zeros([1 5]);
residual=0;
for i=2:5
    gamma_interpolation(i)=measurement(5,j)*((Absolute(i)/Absolute(5))^gamma);%gamma補間値を求める
end
for i=2:4
    gamma_error(i)=(measurement(i,j)-gamma_interpolation(i))*100/gamma_interpolation(i);%誤差を求める
end
for i=2:4
    residual=residual+(gamma_error(i)^2);%誤差二乗和が求まる。これを最小化する。
end
end