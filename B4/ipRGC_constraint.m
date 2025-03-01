function [c,ceq] = ipRGC_constraint(LED_stim)
    c=[];
    ipRGC_object=readmatrix('ipRGC_object.csv');
    LED_cell_out=calculate_cell_out(LED_stim);
    ceq(1)=(LED_cell_out(5)-ipRGC_object)^2;
end