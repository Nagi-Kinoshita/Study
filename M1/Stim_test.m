clear
format long
s=serialport("COM3",460800);
configureTerminator(s,"CR");
%setting=readmatrix("LED_8_times_5_intensity.csv");
%setting=readmatrix('Test_stim.csv');
setting=readmatrix("LED_8_times_5_intensity2.csv");
%setting=readmatrix("memo.csv");
%setting=readmatrix('LED_intensity_scale_all.csv');
%setting=readmatrix("LED_8_times_5_intensity_test.csv");
%setting=readmatrix("Kinoshita_result1_LED_stim.csv");
setting_i=zeros([1 22]);
%{
for i=1:40   
    for j=1:22
        setting_i(j)=setting(i,j);
    end
    setting_ASCII=make_ASCII(setting_i);
    writeline(s,setting_ASCII);
    pause(1);
end
%}
writeline(s,'pre0')
i=40;
for j=1:22
    setting_i(j)=setting(i,j);
end
setting_ASCII=make_ASCII(setting_i);
writeline(s,setting_ASCII);
pause(1);

