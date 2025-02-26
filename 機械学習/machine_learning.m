clear;

% データの読み込み
X_data_default = readmatrix("spectrum_output_data_simple.csv"); % 391個の説明変数
Y_data_default = readmatrix("LED_input_data_simple.csv"); % 26個の目的変数

X_data_transfer = readmatrix("spectrum_output_data_complex.csv");
Y_data_transfer = readmatrix("LED_input_data_complex.csv");

% 転移学習用データの分割
totalData = size(X_data_transfer, 1);
trainRatio = 0.7; % 70%をトレーニングデータに

% トレーニングデータとテストデータのインデックスを生成
trainIdx = 1:floor(totalData * trainRatio);
testIdx = (floor(totalData * trainRatio) + 1):totalData;

% データを分割
X_train = X_data_transfer(trainIdx, :);
Y_train = Y_data_transfer(trainIdx, :);
X_test = X_data_transfer(testIdx, :);
Y_test = Y_data_transfer(testIdx, :);

% 初期モデルの構築
inputSize = size(X_data_default, 2); % 分光データの次元（391）
outputSize = size(Y_data_default, 2); % LEDチャネルの数（26）

layers = [
    featureInputLayer(inputSize)
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(64)
    reluLayer
    fullyConnectedLayer(outputSize)
    regressionLayer];

% 初期モデルのトレーニングオプション設定
options = trainingOptions('adam', ...
    'MaxEpochs', 100, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', 0.001, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 30, ...
    'Verbose', 0); % 学習の進行状況を表示しない

% 初期モデルのトレーニング
net = trainNetwork(X_data_default, Y_data_default, layers, options);

% 転移学習のオプション設定
options_transfer = trainingOptions('adam', ...
    'MaxEpochs', 50, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', 0.0001, ... % 学習率を下げる
    'Verbose', 0); % 学習の進行状況を表示しない

% 転移学習のための履歴を保持
mseHistory_transfer = zeros(options_transfer.MaxEpochs, 1);
rSquaredHistory_transfer = zeros(options_transfer.MaxEpochs, 1);

% 転移学習の実施
for epoch = 1:options_transfer.MaxEpochs
    net = trainNetwork(X_train, Y_train, layers, options_transfer);
    
    % テストデータを用いた評価
    Y_pred_transfer = predict(net, X_test);
    
    % MSEの計算
    mseHistory_transfer(epoch) = mean(mean((Y_test - Y_pred_transfer).^2));
    
    % R²の計算
    ss_res = sum((Y_test - Y_pred_transfer).^2, 'all'); % Residual Sum of Squares
    ss_tot = sum((Y_test - mean(Y_test, 'all')).^2, 'all'); % Total Sum of Squares
    rSquaredHistory_transfer(epoch) = 1 - (ss_res / ss_tot); % R²
end

% 転移学習の評価結果をプロット
figure;
subplot(2, 1, 1);
plot(1:options_transfer.MaxEpochs, mseHistory_transfer, '-o');
xlabel('Epoch');
ylabel('Mean Squared Error (MSE)');
title('Epoch vs. MSE on Test Data (Transfer Learning)');
grid on;

subplot(2, 1, 2);
plot(1:options_transfer.MaxEpochs, rSquaredHistory_transfer, '-o');
xlabel('Epoch');
ylabel('R-squared (R²)');
title('Epoch vs. R-squared on Test Data (Transfer Learning)');
grid on;

