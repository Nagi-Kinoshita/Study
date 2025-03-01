function make_8_standard(Y)
white_x=0.31382;
white_y=0.331;%D65 CIE 1964 10°測色標準観察者　
white_u_prime=(4*white_x)/(-2*white_x+12*white_y+3);
white_v_prime=(9*white_y)/(-2*white_x+12*white_y+3);
%distance=0.02;
spectrum_data=readmatrix('spectrum_data.csv');
rgb_converter = tnt.RgbConverter(spectrum_data);
XYZ_data=zeros([3 8]);
u_v_prime=zeros([2 8]);
xy=zeros([2 8]);
%{
while 1
    for i=1:8
        u_v_prime(1,i)=white_u_prime+distance*cos(i*pi/4);
        u_v_prime(2,i)=white_v_prime+distance*sin(i*pi/4);
        [XYZ_data(1,i),XYZ_data(3,i)]=make_XZ(u_v_prime(1,i),u_v_prime(2,i),Y);
        XYZ_data(2,i)=Y;
    end
    rgb_data = rgb_converter.xyz_to_linear_rgb(XYZ_data);
    [rgb_min,rgb_max]=bounds(rgb_data,"all");
    if(rgb_min<0||rgb_max>1)
        break;
    end
    writematrix(u_v_prime,'u_v_prime.csv');
    writematrix(XYZ_data,'XYZ_data.csv');
    writematrix(rgb_data,'rgb_data.csv');
    distance=distance+0.001;
end
%}
distance=0.055;
for i=1:8
    u_v_prime(1,i)=white_u_prime+distance*cos(i*pi/4);
    u_v_prime(2,i)=white_v_prime+distance*sin(i*pi/4);
    [XYZ_data(1,i),XYZ_data(3,i)]=make_XZ(u_v_prime(1,i),u_v_prime(2,i),Y);
    XYZ_data(2,i)=Y;
end
rgb_data = rgb_converter.xyz_to_linear_rgb(XYZ_data);
writematrix(u_v_prime,'u_v_prime.csv');
writematrix(XYZ_data,'XYZ_data.csv');
writematrix(rgb_data,'rgb_data.csv');
for i=1:8
    xy(1,i)=9*u_v_prime(1,i)/(6*u_v_prime(1,i)-16*u_v_prime(2,i)+12);
    xy(2,i)=4*u_v_prime(2,i)/(6*u_v_prime(1,i)-16*u_v_prime(2,i)+12);
end
writematrix(xy,'xy.csv');
end