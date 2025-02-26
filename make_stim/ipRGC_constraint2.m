function [c,ceq] = ipRGC_constraint2(LED_stim)
    ALL_coefficient_multi=readmatrix("ALL_coefficient_multi4.csv");
    c=[];
    ipRGC_object=readmatrix('object_ipRGC.csv');
    ipRGC_sens=readmatrix("ipRGC_sens.csv");
    ipRGC_calculate=0;
    LED_stim_one=[LED_stim 1];
    spectrum=LED_stim_one*(ALL_coefficient_multi');

    for i=1:391
        ipRGC_calculate=spectrum(i)*ipRGC_sens(i)+ipRGC_calculate;
    end
    ceq(1)=(ipRGC_calculate-ipRGC_object)^2;
end