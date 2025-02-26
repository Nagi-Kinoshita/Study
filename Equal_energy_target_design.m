function Equal_energy_target_design(Target_Lum)
format long
XYZ_sens=readmatrix('XYZ_sens.csv');
color_function=zeros([1 391]);
for i=1:391
    color_function(i)=XYZ_sens(2,i);
end
color_function_use=0;
for i=1:391
    color_function_use=color_function_use+color_function(i);
end
Target_Energy=zeros([1 391]);
Target_Energy(1,1)=(Target_Lum/683)/color_function_use;
for i=1:390
    Target_Energy(1,i+1)=Target_Energy(1,1);
end
writematrix(Target_Energy,'Target_Energy.csv');
end