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
Rsq1_1=zeros([1 8]);
Rsq1_2=zeros([1 8]);
for i=1:40
    [syou,amari]=quorem(sym(i-1),sym(5));
    H_K(syou+1,amari+1)=(150*data_ave(i))/color_lum(i);
end
FileName="H_K.csv";
writelines(FileName,'Filename.txt');
writematrix(H_K,FileName);

equation_all=zeros([8 2]);
equation=zeros([1 2]);
start=zeros([1 2]);
for i=1:8
    writematrix(i,'i.csv');
    [equation,Rsq1_1(i)]=fminunc(@kinji_tyokusen_mag,start);
    equation_all(i,1)=equation(1);
    equation_all(i,2)=equation(2);
end
writematrix(equation_all,'equation_mag.csv');
for i=1:8
    writematrix(i,'i.csv');
    [equation,Rsq1_2(i)]=fminunc(@kinji_tyokusen_abs,start);
    equation_all(i,1)=equation(1);
    equation_all(i,2)=equation(2);
end
writematrix(equation_all,'equation_abs.csv');