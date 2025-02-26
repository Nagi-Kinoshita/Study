clear
% 開始時刻を記録
startTime = datetime('now');
disp(['開始時刻: ', datestr(startTime)]);
candela=400;
Y_400=candela/683;
s=serialport("COM3",460800);
configureTerminator(s,"CR");


LED_input_data_simple=zeros([26*21 26]);
spectrum_output_data_simple=zeros([26*21 391]);
row_index = 1;  % 行インデックスの初期化

for i=1:26
    i
    LED_stim_default=zeros([1 26]);
    LED_stim_default(i)=1;
    XYZ=calculate_X_Y_Z(LED_stim_default);
    LED_stim_default(i)=Y_400/XYZ(2);
    
    for j=0:20
        LED_stim=LED_stim_default*((j/100)+0.9);
        
        % LED_stimのベクトルデータをLED_input_data_simpleに上の行から入れる
        LED_input_data_simple(row_index, :) = LED_stim;
        
        stim_ASCII=make_ASCII(LED_stim);
        writeline(s,stim_ASCII);
        pause(4);
        
        Radiance=SpectroCALMakeSPDMeasurement();
        
        % Radianceのベクトルデータをspectrum_output_data_simpleに上の行から入れる
        spectrum_output_data_simple(row_index, :) = Radiance;
        
        row_index = row_index + 1;  % 行インデックスを更新
    end
    %pauseは各チャンネルを使用し続けているのではないので不必要
end
writematrix(LED_input_data_simple,"LED_input_data_simple.csv");
writematrix(spectrum_output_data_simple,"spectrum_output_data_simple.csv");

% 終了時刻を記録
endTime = datetime('now');
disp(['終了時刻: ', datestr(endTime)]);

% 所要時間を計算して表示
elapsedTime = endTime - startTime;
disp(['所要時間: ', char(elapsedTime)]);



