Y=30;
white_x=0.31382;
white_y=0.331;%D65 CIE 1964 10°測色標準観察者　
white_u_prime=(4*white_x)/(-2*white_x+12*white_y+3);
white_v_prime=(9*white_y)/(-2*white_x+12*white_y+3);
distance=0.02;
spectrum_data=readmatrix('spectrum_data.csv');
rgb_converter = tnt.RgbConverter(spectrum_data);
XYZ_data=zeros([3 6]);
u_v_prime=zeros([2 6]);
xy=zeros([2 6]);
uv_hozon=zeros([2 6]);
while 1
    for i=1:6
        u_v_prime(1,i)=white_u_prime+distance*cos(i*pi/6);
        u_v_prime(2,i)=white_v_prime+distance*sin(i*pi/6);
        [XYZ_data(1,i),XYZ_data(3,i)]=make_XZ(u_v_prime(1,i),u_v_prime(2,i),Y);
        XYZ_data(2,i)=Y;
    end
    rgb_data = rgb_converter.xyz_to_linear_rgb(XYZ_data);
    [rgb_min,rgb_max]=bounds(rgb_data,"all");
    if(rgb_min<0||rgb_max>1)
        break;
    end
    uv_hozon=u_v_prime;
    distance=distance+0.001;
end
Y=0.2;
for i=1:6
    [XYZ_data(1,i),XYZ_data(3,i)]=make_XZ(uv_hozon(1,i),uv_hozon(2,i),Y);
    XYZ_data(2,i)=Y;    
end
    LED_intensity_scale_all=zeros([6 22]);
    XYZ_i=zeros([1 3]);
    for i=1:6
        for j=1:3
            XYZ_i(j)=XYZ_data(j,i);
        end
        writematrix(XYZ_i,'XYZ_i.csv');
        lb=zeros([1 22]);
        ub=zeros([1 22]);
        middle=zeros([1 22]);
        for j=1:22
            ub(j)=5;
            middle(j)=0.5;
        end
        LED_intensity_scale=fmincon(@XYZ_to_LED,middle,[],[],[],[],lb,ub);%所望のXYZ値になるようなLED強度を求める
        for j=1:22
            LED_intensity_scale_all(i,j)=LED_intensity_scale(j);
        end
    end
    writematrix(LED_intensity_scale_all,'Test_stim.csv');