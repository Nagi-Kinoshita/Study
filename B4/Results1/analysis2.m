files = dir('./*.csv');
file_name_cell_array={files.name};
separator='';
color_lum=readmatrix('LED_lum_data.csv');
FileName=char(file_name_cell_array(7));
data1=readmatrix(FileName);
FileName=char(file_name_cell_array(10));
data2=readmatrix(FileName);
FileName=char(file_name_cell_array(13));
data3=readmatrix(FileName);
FileName=char(file_name_cell_array(16));
data4=readmatrix(FileName);
data_ave=(data1+data2+data3+data4)/4;
H_K=zeros([8 5]);
mag1=zeros([40 1]);
mag2=zeros([40 1]);
mag3=zeros([40 1]);
mag4=zeros([40 1]);
x=zeros([20 1]);
for i=1:4
    x(i,1)=0.8;
end
for i=5:8
    x(i,1)=0.9;
end
for i=9:12
    x(i,1)=1;
end
for i=13:16
    x(i,1)=1.1;
end
for i=17:20
    x(i,1)=1.2;
end
for i=1:40
    [syou,amari]=quorem(sym(i-1),sym(5));
    H_K(syou+1,amari+1)=(150*data_ave(i))/color_lum(i);
end
FileName="H_K.csv";
writematrix(H_K,FileName);
i=1;
y=zeros([20 1]);
for j=0:4
    y(j*4+1)=data1(j+1);
    y(j*4+2)=data2(j+1);
    y(j*4+3)=data3(j+1);
    y(j*4+4)=data4(j+1);
end
