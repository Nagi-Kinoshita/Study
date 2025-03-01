Y=20;
rgb=readmatrix('rgb_data.csv');
spectrum=readmatrix('spectrum_data.csv');
XYZ_sens=readmatrix('XYZ_sens.csv');
u_v_prime=readmatrix('u_v_prime.csv');
LED_intensity_scale_all=zeros([8 22]);
Y_sum=zeros([1 8]);
X_Y_Z_sum=zeros([3 8]);
xy_calculate=zeros([2 8]);
xy_data=zeros([2 8]);
for i=1:8
    rgb_i=zeros([1 3]);
    for j=1:3
        rgb_i(j)=rgb(j,i);
    end
    energy=zeros([1 391]);
    for j=1:391
        energy(j)=rgb_i(1)*spectrum(10+j,1)+rgb_i(2)*spectrum(10+j,2)+rgb_i(3)*spectrum(10+j,3);%もらった分光分布が380~780だったので最初の10個を都バス
        X_Y_Z_sum(1,i)=X_Y_Z_sum(1,i)+energy(j)*XYZ_sens(1,j);
        X_Y_Z_sum(2,i)=X_Y_Z_sum(2,i)+energy(j)*XYZ_sens(2,j);
        X_Y_Z_sum(3,i)=X_Y_Z_sum(3,i)+energy(j)*XYZ_sens(3,j);
    end
    xy_calculate(1,i)=X_Y_Z_sum(1,i)/(X_Y_Z_sum(1,i)+X_Y_Z_sum(2,i)+X_Y_Z_sum(3,i));
    xy_calculate(2,i)=X_Y_Z_sum(2,i)/(X_Y_Z_sum(1,i)+X_Y_Z_sum(2,i)+X_Y_Z_sum(3,i));
    xy_data(1,i)=9*u_v_prime(1,i)/(6*u_v_prime(1,i)-16*u_v_prime(2,i)+12);
    xy_data(2,i)=4*u_v_prime(2,i)/(6*u_v_prime(1,i)-16*u_v_prime(2,i)+12);
end