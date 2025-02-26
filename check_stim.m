i=8;

LED_stim_all=readmatrix('LED_intensity_scale_all.csv');
object=readmatrix('memo.csv');
LED_stim=zeros([1 22]);
LED_object=zeros([1 22]);
for j=1:22
    LED_stim(j)=LED_stim_all(i,j);
    LED_object(j)=object(i,j);
%    LED_max(j)=LED_stim_max_min(1,j);
%    LED_min(j)=LED_stim_max_min(2,j);
end

LED_cell=calculate_cell_out(LED_stim);
LED_cell(5)=LED_cell(5)*1.2;
object_cell=calculate_cell_out(LED_object);
LED_cell
object_cell