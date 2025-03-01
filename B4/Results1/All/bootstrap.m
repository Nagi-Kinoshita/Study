clear 
files = dir('./*.csv');
file_name_cell_array={files.name};
FileName=char(file_name_cell_array(57));
diff1=readmatrix(FileName);
FileName=char(file_name_cell_array(58));
diff2=readmatrix(FileName);
FileName=char(file_name_cell_array(59));
diff3=readmatrix(FileName);
FileName=char(file_name_cell_array(60));
diff4=readmatrix(FileName);
FileName=char(file_name_cell_array(61));
diff5=readmatrix(FileName);
FileName=char(file_name_cell_array(62));
diff6=readmatrix(FileName);
%{
FileName=char(file_name_cell_array(34));
diff1=readmatrix(FileName);
FileName=char(file_name_cell_array(35));
diff2=readmatrix(FileName);
FileName=char(file_name_cell_array(36));
diff3=readmatrix(FileName);
FileName=char(file_name_cell_array(37));
diff4=readmatrix(FileName);
FileName=char(file_name_cell_array(38));
diff5=readmatrix(FileName);
FileName=char(file_name_cell_array(39));
diff6=readmatrix(FileName);
%}
%{
FileName=char(file_name_cell_array(41));
diff1=readmatrix(FileName);
FileName=char(file_name_cell_array(42));
diff2=readmatrix(FileName);
FileName=char(file_name_cell_array(43));
diff3=readmatrix(FileName);
FileName=char(file_name_cell_array(44));
diff4=readmatrix(FileName);
FileName=char(file_name_cell_array(45));
diff5=readmatrix(FileName);
FileName=char(file_name_cell_array(46));
diff6=readmatrix(FileName);
%}
prob=zeros([1 8]);
for k=1:8
    check=zeros([1 10000]);
    data(1)=diff1(k,1);
    data(2)=diff2(k,1);
    data(3)=diff3(k,1);
    data(4)=diff4(k,1);
    data(5)=diff5(k,1);
    data(6)=diff6(k,1);
    for i=1:10000
        a=0;
        for j=1:6
            rng(6*i+j)
           random_number=randperm(6);
           a=a+data(random_number(1));
       end
       if a>0
           check(i)=1;
       end
    end
    prob(k)=mean(check);
end