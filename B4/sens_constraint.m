function [c,ceq] = sens_constraint(LED_intensity)
c=[];
LED_cell_out=calculate_cell_out(LED_intensity);
cell_object=readmatrix('cell_object.csv');
ceq=zeros([1 4]);
for i=1:3
    ceq(i)=(LED_cell_out(i)-cell_object(i))^2;   
end
ceq(4)=(LED_cell_out(5)-cell_object(5))^2;
end