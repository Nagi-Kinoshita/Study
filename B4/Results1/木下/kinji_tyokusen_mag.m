function diff = kinji_tyokusen_mag(equation)
i=readmatrix('i.csv');
diff=0;
x=[0.8,0.9,1,1.1,1.2];
FileName=fileread('Filename.txt');
H_K=readmatrix(FileName);
for j=1:5
    diff=diff+(equation(1)*x(j)+equation(2)-H_K(i,j))^2;
end
end