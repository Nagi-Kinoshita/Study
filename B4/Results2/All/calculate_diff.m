function a=calculate_diff(number)
files = dir('./*.csv');
file_name_cell_array={files.name};
FileName=char(file_name_cell_array(number));
data1=readmatrix(FileName);
FileName=char(file_name_cell_array(number+1));
data2=readmatrix(FileName);
FileName=char(file_name_cell_array(number+2));
data3=readmatrix(FileName);
FileName=char(file_name_cell_array(number+3));
data4=readmatrix(FileName);
color_lum=readmatrix('LED_lum_data.csv');
data_ave=(data1+data2+data3+data4)/4;
ipRGC=[1.6;1.8;2;2.2;2.4];
for i=1:40
    lum_diff(i)=data_ave(i)*150/color_lum(i);
end
for i=1:8
    for j=1:5
        x(j,1)=ipRGC(j,1);
        y(j,1)=lum_diff(5*(i-1)+j)-lum_diff(5*(i-1)+3);
    end
    X=[x ones(length(x),1)];
    b=regress(y,X);
    a(i,1)=b(1);
    a(i,2)=b(2);
end
[q,~]=quorem(sym(number),sym(4));
q_int=double(q);
filename=append('lum_abs_participants',num2str(q_int+1),'.csv');
writematrix(a,filename);
end