function diff = kinji_tyokusen_abs(equation)
i=readmatrix('i.csv');
LED_40_stim=readmatrix('LED_8_times_5_intensity2.csv');
diff=0;
x=zeros([1 5]);
LED_stim=zeros([1 22]);
ipRGC_abs=zeros([1 5]);
for j=1:5
    for k=1:22
        LED_stim(k)=LED_40_stim(5*(i-1)+j,k);
    end
    cell_out=calculate_cell_out(LED_stim);
    ipRGC_abs(j)=cell_out(5);
end
FileName=fileread('Filename.txt');
H_K=readmatrix(FileName);
for j=1:5
    diff=diff+(equation(1)*ipRGC_abs(j)+equation(2)-H_K(i,j))^2;
end
end