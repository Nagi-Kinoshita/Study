function [c,ceq] = ipRGC_constraint(spectrum)
    c=[];
    ipRGC_object=readmatrix('object_ipRGC.csv');
    ipRGC_sens=readmatrix("ipRGC_sens.csv");
    ipRGC_calculate=0;
    for i=1:391
        ipRGC_calculate=spectrum(i)*ipRGC_sens(i)+ipRGC_calculate;
    end
    ceq(1)=(ipRGC_calculate-ipRGC_object)^2;
end