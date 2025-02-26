function a=calculate_mag(number)
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
x=[0.8;0.9;1;1.1;1.2];
data_ave=(data1+data2+data3+data4)/4;
data_criterion=zeros([1 8]);
for i=1:40
    lum_mag(i)=(data_ave(i)*150)/color_lum(i);
    if rem(i,5)==3
        data_criterion(((i-3)/5)+1)=lum_mag(i);
    end
end
filename=append('mag_',num2str(number),'.csv');
writematrix(data_criterion,filename);
y=zeros([5 1]);
for i=1:8
    for j=1:5
        y(j,1)=lum_mag(5*(i-1)+j);
    end
    X=[x ones(length(x),1)];
    b=regress(y,X);
    a(i,1)=b(1);
    a(i,2)=b(2);
end
end
