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
check6=zeros([1 10000]);
check7=zeros([1 10000]);
prob6=zeros([1 8]);
prob7=zeros([1 8]);
data6(1)=diff1(6,1);
data6(2)=diff2(6,1);
data6(3)=diff3(6,1);
data6(4)=diff4(6,1);
data6(5)=diff5(6,1);
data6(6)=diff6(6,1);
data7(1)=diff1(7,1);
data7(2)=diff2(7,1);
data7(3)=diff3(7,1);
data7(4)=diff4(7,1);
data7(5)=diff5(7,1);
data7(6)=diff6(7,1);
%{
for k=[1 2 3 4 5 8]
    data(1)=diff1(k,1);
    data(2)=diff2(k,1);
    data(3)=diff3(k,1);
    data(4)=diff4(k,1);
    data(5)=diff5(k,1);
    data(6)=diff6(k,1);
    for i=1:10000
        a=0;
        b=0;
        c=0;
        for j=1:6
           rng(6*i+j)
           random_number=randperm(6);
           a=a+data(random_number(1));
           b=b+data6(random_number(1));
           c=c+data7(random_number(1));
       end
       if b-a>0
           check6(i)=1;
       end
       if c-a>0
           check7(i)=1;
       end
    end
    prob6(k)=mean(check6);
    prob7(k)=mean(check7);
end
%}
prob=zeros([8 8]);
for i=1:8
    dataB(1)=diff1(i,1);
    dataB(2)=diff2(i,1);
    dataB(3)=diff3(i,1);
    dataB(4)=diff4(i,1);
    dataB(5)=diff5(i,1);
    dataB(6)=diff6(i,1);
    for j=i+1:8
        check=zeros([1 10000]);
        dataA(1)=diff1(j,1);
        dataA(2)=diff2(j,1);
        dataA(3)=diff3(j,1);
        dataA(4)=diff4(j,1);
        dataA(5)=diff5(j,1);
        dataA(6)=diff6(j,1);
        for k=1:10000
            a=0;
            b=0;
            for l=1:6
                rng(6*k+l)
                random_number=randperm(6);
                a=a+dataA(random_number(1));
                b=b+dataB(random_number(1));
            end
            if a-b>0
                check(k)=1;
            end
        end
        prob(j,i)=mean(check);
        prob(i,j)=1-prob(j,i);
    end
    prob(i,i)=NaN;
end