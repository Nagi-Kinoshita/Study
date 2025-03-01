clear
input_test=readmatrix("spectrum_output_data_complex3_test.csv");
output_test=readmatrix("LED_input_data_complex3_test.csv");
coefficient_multi=readmatrix("ALL_coefficient_multi.csv");

i=4184;
output_test(i,1)

input_i=input_test(i,:);
input_i=([input_i 1]);
output_i=zeros([1 24]);


for i=1:24
    for j=1:392
        output_i(i)=input_i(j)*coefficient_multi(i,j)+output_i(i);
    end
end
output_i(1)
