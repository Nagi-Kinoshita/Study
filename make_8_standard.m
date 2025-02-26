function make_8_standard(Y)
u_v_prime=readmatrix('u_v_prime.csv');
for i=1:8
    [XYZ_data(1,i),XYZ_data(3,i)]=make_XZ(u_v_prime(1,i),u_v_prime(2,i),Y);
    XYZ_data(2,i)=Y;
end
writematrix(XYZ_data,'XYZ_data.csv');
end