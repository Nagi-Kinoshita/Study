LED_intensity=readmatrix("ipRGC_63.csv");
standard=readmatrix("ipRGC_48.csv");
candela=400;
lum=candela/683;
Y=lum;
i=3;
for j=1:32
    LED_stim(j)=LED_intensity(i,j);
    LED_stim_standard(j)=standard(i,j);
end
calculate_cell_out(LED_stim_standard)
calculate_cell_out(LED_stim)
%LED_stim=LED_intensity_scale;

uv=readmatrix('u_v_prime.csv');
u=uv(1,i);
v=uv(2,i);
x=(9*u)/(6*u-16*v+12);
y=(4*v)/(6*u-16*v+12);
XYZ_value=zeros([1 3]);
XYZ_value(2)=Y;
XYZ_value(1)=XYZ_value(2)*x/y;
XYZ_value(3)=XYZ_value(2)*(1-x-y)/y;
XYZ_value
calculate_X_Y_Z_lum(LED_stim)
calculate_cell_out(LED_stim)


