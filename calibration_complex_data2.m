clear
% 開始時刻を記録
startTime = datetime('now');
disp(['開始時刻: ', datestr(startTime)]);

candela=400;
Y_400=candela/683;
s=serialport("COM3",460800);
configureTerminator(s,"CR");

LED_input_data_complex=readmatrix("LED_input_data_complex2.csv");
spectrum_output_data_complex=readmatrix("spectrum_output_data_complex2.csv");
[row_count, ~] = size(LED_input_data_complex);  % 行数を取得
row_index = row_count + 1;  % 新しいデータの行インデックスを開始

LED_stim=zeros([1 26]);

% 前回の休憩時間を追跡するための変数
lastBreakTime = startTime;

% メインループ
while(1)
    % 現在時刻を基にシードを設定
    rng('shuffle');
    LED_stim_first = 15 * rand(1, 26);  % 小数第5桁までの乱数生成
    for i=1:3
        LED_stim_first(i)=0;
    end
    for i=23:26
        LED_stim_first(i)=0;
    end

    % XYZを計算
    XYZ = calculate_X_Y_Z(LED_stim_first);

    % LED_stimをXYZ(2)で正規化
    LED_stim = LED_stim_first * Y_400 / XYZ(2);

    % LED_stimを0.9~1.1の範囲でランダムにスケーリング
    scale_factor = 0.9 + (1.1 - 0.9) * rand();
    LED_stim = LED_stim * scale_factor;

    % LED_stimのベクトルデータをLED_input_data_complexに追加
    LED_input_data_complex(row_index, :) = LED_stim;

    % シリアル通信でデータを送信
    stim_ASCII = make_ASCII(LED_stim);
    writeline(s, stim_ASCII);
    pause(4);

    % Radiance測定
    Radiance = SpectroCALMakeSPDMeasurement();

    % Radianceデータをspectrum_output_data_complexに追加
    spectrum_output_data_complex(row_index, :) = Radiance;

    % 行インデックスを更新
    row_index = row_index + 1;

    % 現在時刻を取得し、前回の休憩から30分経過したか確認
    currentTime = datetime('now');
    elapsedMinutes = minutes(currentTime - lastBreakTime);

    % 30分以上経過していれば休憩を挿入
    if elapsedMinutes >= 30
        disp(['30分経過したため休憩を挿入します。時刻: ', datestr(currentTime)]);
        pause(300);  % 5分間のポーズ
        % 最後の休憩時間を更新
        lastBreakTime = currentTime;
    end

    % PsychtoolboxでEnterキーが押されたか確認し、押されたらループを抜ける
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown && keyCode(KbName('Return'))
        disp('Enterキーが押されたため、ループを終了します。');
        break;
    end
end

% データをCSVファイルに書き込み
writematrix(LED_input_data_complex, "LED_input_data_complex2.csv");
writematrix(spectrum_output_data_complex, "spectrum_output_data_complex2.csv");

% 終了時刻を記録
endTime = datetime('now');
disp(['終了時刻: ', datestr(endTime)]);

% 所要時間を計算して表示
elapsedTime = endTime - startTime;
disp(['所要時間: ', char(elapsedTime)]);