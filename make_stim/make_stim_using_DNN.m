clear

% データの読み込み
X_data = readmatrix("LED_input_data_complex4.csv");
Y_data = readmatrix("spectrum_output_data_complex4.csv");

% データの分割（80%をトレーニング、20%をテストに使用）
[row_count, ~] = size(X_data);
train_ratio = 0.8;
train_size = round(row_count * train_ratio);

X_train = X_data(1:train_size, :);
Y_train = Y_data(1:train_size, :);

X_test = X_data(train_size+1:end, :);
Y_test = Y_data(train_size+1:end, :);

% トレーニングデータで重回帰分析
train_row_count = size(X_train, 1);
ALL_coefficient = zeros(size(Y_train, 2), size(X_train, 2) + 1);
Y_train_pred = zeros(size(Y_train));

for i = 1:size(Y_train, 2)
    Y_train_column_i = Y_train(:, i);
    X_train_bias = [X_train, ones(train_row_count, 1)];  % バイアス項を追加
    coefficient = regress(Y_train_column_i, X_train_bias);
    ALL_coefficient(i, :) = coefficient;

    % トレーニングデータの予測値
    Y_train_pred(:, i) = X_train_bias * coefficient;
end

% トレーニングデータの相関係数の計算
x_train = Y_train(:);  % 実測値
y_train = Y_train_pred(:);  % 予測値

% 相関係数の計算
r_train = corrcoef(x_train, y_train);
fprintf('トレーニングデータにおける相関係数: %.4f\n', r_train(1, 2));

% テストデータでの予測
test_row_count = size(X_test, 1);
Y_test_pred = zeros(size(Y_test));

for i = 1:size(Y_test, 2)
    X_test_bias = [X_test, ones(test_row_count, 1)];  % バイアス項を追加
    Y_test_pred(:, i) = X_test_bias * ALL_coefficient(i, :)';
end

% テストデータの相関係数の計算
x_test = Y_test(:);  % 実測値
y_test = Y_test_pred(:);  % 予測値

% 相関係数の計算
r_test = corrcoef(x_test, y_test);
fprintf('テストデータにおける相関係数: %.4f\n', r_test(1, 2));

% 予測結果を格納する行列を初期化
ALL_Y_pred = zeros(size(Y_data)); % サイズ: 1748×391

for i = 1:size(X_data, 1) % 各サンプルに対してループ
    % X_data(i, :) に1を追加（サイズ: 1×26）
    X_with_bias = [X_data(i, :), 1]; % 行ベクトルの最後に1を追加

    % Y_dataを予測
    ALL_Y_pred(i, :) = X_with_bias * ALL_coefficient'; % 行ベクトル×転置行列
end

% Full connection or CNN
nettype = 2; % 1 Full 2 CNN

% 元のデータに追加
inputData = ALL_Y_pred;
outputData = Y_data;

%% データ正規化: trainingで正規化範囲を設定→validationとtestにも適用
% トレーニングデータのインデックスを取得
[trainInd1, valInd1, testInd1] = dividerand(size(inputData, 1), 0.8, 0.12, 0.08);

% トレーニングデータのみで正規化パラメータを計算
[inputDataTrainNorm, inputPS] = mapminmax(inputData(trainInd1, :)', 0, 1);
[outputDataTrainNorm, outputPS] = mapminmax(outputData(trainInd1, :)', 0, 1);

% バリデーションデータとテストデータを同じパラメータで正規化
inputDataValNorm = mapminmax('apply', inputData(valInd1, :)', inputPS);
outputDataValNorm = mapminmax('apply', outputData(valInd1, :)', outputPS);

inputDataTestNorm = mapminmax('apply', inputData(testInd1, :)', inputPS);
outputDataTestNorm = mapminmax('apply', outputData(testInd1, :)', outputPS);

% 転置して元の形状に戻す
X_train1 = inputDataTrainNorm';
Y_train1 = outputDataTrainNorm';
X_val1 = inputDataValNorm';
Y_val1 = outputDataValNorm';
X_test1 = inputDataTestNorm';
Y_test1 = outputDataTestNorm';

%% アーキテクチャ定義
if nettype == 1
    % Full connection
    Layers = [
        featureInputLayer(391, 'Normalization', 'none')
        fullyConnectedLayer(512, 'Name', 'fc0')    
        leakyReluLayer('Name', 'relu0')
        batchNormalizationLayer
        fullyConnectedLayer(256, 'Name', 'fc1')
        leakyReluLayer('Name', 'relu1')
        batchNormalizationLayer
        fullyConnectedLayer(128, 'Name', 'fc_transfer1')
        leakyReluLayer('Name', 'relu_transfer1')
        batchNormalizationLayer    
        % dropoutLayer(0.2)  % 20%のドロップアウト率で追加
        fullyConnectedLayer(64, 'Name', 'fc_transfer2')
        leakyReluLayer('Name', 'relu_transfer2')
        fullyConnectedLayer(32, 'Name', 'fc_transfer3')
        leakyReluLayer('Name', 'relu_transfer3')
        fullyConnectedLayer(91, 'Name', 'fc_transfer4')    
        regressionLayer('Name', 'output')];

elseif nettype == 2
    % CNN（波長間相関をはじめに捉える：帰納バイアス使用）
    % データの転置（featureInputに対応させるため）

    X_train1 = num2cell(X_train1', 1);
    X_val1 = num2cell(X_val1', 1);
    X_test1 = num2cell(X_test1', 1);

    Y_train1 = num2cell(Y_train1', 1);
    Y_val1 = num2cell(Y_val1', 1);
    Y_test1 = num2cell(Y_test1', 1);
    Layers = [
        sequenceInputLayer(391, 'Name', 'input')                % 入力層（シーケンスデータの次元391）
        fullyConnectedLayer(128, 'Name', 'fc1')                % 隠れ層1（ノード数例:128）
        reluLayer('Name', 'relu1')                             % ReLU層1
        batchNormalizationLayer('Name', 'batchnorm1')          % Batch Normalization層1
        fullyConnectedLayer(128, 'Name', 'fc2')                % 隠れ層2（ノード数例:128）
        reluLayer('Name', 'relu2')                             % ReLU層2
        batchNormalizationLayer('Name', 'batchnorm2')          % Batch Normalization層2
        fullyConnectedLayer(391, 'Name', 'output')             % 出力層（ノード数391）
        regressionLayer('Name', 'regressionoutput')            % 回帰タスク用の出力層
    ];

end

%% 学習用のオプション設定
if nettype == 1 % full
options = trainingOptions('adam', ...
    'MaxEpochs', 1000, ...
    'MiniBatchSize', 32, ...
    'InitialLearnRate', 1e-4, ...
    'Shuffle', 'every-epoch', ...
    'LearnRateSchedule', 'piecewise', ...      % 学習率を段階的に減少
    'LearnRateDropFactor', 0.99, ...            % 学習率の減少倍率（99%に減少）
    'LearnRateDropPeriod', 2, ...             % 2エポックごとに学習率を減少
    'ValidationData', {X_val1, Y_val1}, ...
    'ValidationFrequency', 50, ...
    'ValidationPatience', 100, ... % 100回validationに改善が見られない場合に停止
    'Plots', 'training-progress', ...
    'Verbose', false);
elseif nettype == 2 % CNN
options = trainingOptions('adam', ...
    'MaxEpochs', 1000, ...
    'MiniBatchSize', 32, ...  % 32
    'InitialLearnRate', 1e-4, ...  % 'InitialLearnRate', 1e-4, ...
    'Shuffle', 'every-epoch', ...
    'LearnRateSchedule', 'piecewise', ...      % 学習率を段階的に減少
    'LearnRateDropFactor', 0.99, ...            % 学習率の減少倍率（99%に減少）
    'LearnRateDropPeriod', 2, ...             % 2エポックごとに学習率を減少
    'ValidationData', {X_val1, Y_val1}, ...
    'ValidationFrequency', 50, ...
    'ValidationPatience', 100, ... % 30回validationに改善が見られない場合に停止
    'Plots', 'training-progress', ...
    'Verbose', false);
end

%% 学習実行
net = trainNetwork(X_train1, Y_train1, Layers, options);
save('network.mat','net');
format long
candela=400;
lum=candela/683;
uv=readmatrix("u_v_prime.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
LED_stim_change=zeros([10 24]);


object_ipRGC_low=0.34;
object_ipRGC_high=0.51;
options = optimoptions('fmincon','MaxFunctionEvaluations', 1e+04,'ConstraintTolerance', 1e-12); 
i=1;
for j=1:10
    rng('shuffle');
    Y=lum;
    u=uv(1,i);
    v=uv(2,i);
    x=(9*u)/(6*u-16*v+12);
    y=(4*v)/(6*u-16*v+12);    
    XYZ_value=zeros([1 3]);
    XYZ_value(2)=Y;
    XYZ_value(1)=XYZ_value(2)*x/y;
    XYZ_value(3)=XYZ_value(2)*(1-x-y)/y;
    lb=zeros([1 24]);
    ub=15*ones([1 24]);
    middle = randi([0, 8], 1, 24);
    X=0;Y=0;Z=0;ipRGC=0;
    
    writematrix(XYZ_value,'object_XYZ.csv');
    writematrix(object_ipRGC_high,'object_ipRGC.csv');
    %writematrix(object_ipRGC_low,'object_ipRGC.csv');
    
    LED_stim=fmincon(@LED2XYZ_DNN,middle,[],[],[],[],lb,ub,@ipRGC_constraint2_DNN,options);
    LED_stim_change(j,:)=LED_stim;
end
fprintf('Iteration %d: Y = %.4f, x = %.4f, y = %.4f, ipRGC_low = %.4f, ipRGC_high = %.4f\n', i, 400/683, x, y, 0.34, 0.51);
for k=1:10
    LED_stim_one=[LED_stim_change(k,:) 1];
    spectrum=LED_stim_one*(ALL_coefficient_multi');
    X=0;Y=0;Z=0;ipRGC=0;
    for j=1:391
        X=X+spectrum(j)*XYZ_sens(1,j);
        Y=Y+spectrum(j)*XYZ_sens(2,j);
        Z=Z+spectrum(j)*XYZ_sens(3,j);
        ipRGC=ipRGC+spectrum(j)*ipRGC_sens(j);
    end
    x=X/(X+Y+Z);
    y=Y/(X+Y+Z);
    fprintf('LED_stim_high: Y = %.4f, x = %.4f, y = %.4f, ipRGC = %.4f\n', Y, x, y, ipRGC);
end
x=390:1:780;
for k=1:10
    LED_stim_one=[LED_stim_change(k,:) 1];
    spectrum=LED_stim_one*(ALL_coefficient_multi');
    plot(x,spectrum)
    xlabel("波長")
    hold on
end
%writematrix(LED_stim_change,"LED_?deg_?.csv");