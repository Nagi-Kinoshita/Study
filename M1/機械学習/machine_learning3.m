% データの読み込み
X_data_default = readmatrix("spectrum_output_data_simple.csv");
Y_data_default = readmatrix("LED_input_data_simple.csv");

X_data_transfer = readmatrix("spectrum_output_data_complex.csv");
Y_data_transfer = readmatrix("LED_input_data_complex.csv");

% トレーニング・テストデータの分割
splitRatio = 0.8;
numTrain = round(splitRatio * size(X_data_transfer, 1));
X_train = X_data_transfer(1:numTrain, :);
Y_train = Y_data_transfer(1:numTrain, :);
X_test = X_data_transfer(numTrain+1:end, :);
Y_test = Y_data_transfer(numTrain+1:end, :);

% 初期モデルの構築
inputSize = size(X_data_default, 2); 
outputSize = size(Y_data_default, 2);

layers = [
    featureInputLayer(inputSize)
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(64)
    reluLayer
    fullyConnectedLayer(outputSize)
    regressionLayer];

% トレーニングオプションの設定
maxEpochs = 50;
miniBatchSize = 32;
learningRate = 0.0001;

options = trainingOptions('adam', ...
    'MaxEpochs', 1, ...  % 1エポックごとにループを回すため1に設定
    'MiniBatchSize', miniBatchSize, ...
    'InitialLearnRate', learningRate, ...
    'Verbose', 0);

% R²値の計算
ss_res = sum((Y_test - Y_pred).^2, 'all'); % Residual Sum of Squares
ss_tot = sum((Y_test - mean(Y_test, 'all')).^2, 'all'); % Total Sum of Squares
r_squared = 1 - (ss_res / ss_tot); % R²

% MSEとR²の履歴を保持するための配列
mseHistory = zeros(maxEpochs, 1);
rSquaredHistory = zeros(maxEpochs, 1);

% 逐次学習と評価のループ
for epoch = 1:maxEpochs
    net = trainNetwork(X_train, Y_train, layers, options);
    Y_pred = predict(net, X_test);
    
    % MSEとR²を計算
    mseHistory(epoch) = mean(mean((Y_test - Y_pred).^2));
    ss_res = sum((Y_test - Y_pred).^2, 'all');
    ss_tot = sum((Y_test - mean(Y_test, 'all')).^2, 'all');
    rSquaredHistory(epoch) = 1 - (ss_res / ss_tot);
end

% 学習ステップに対するMSEとR²をプロット
figure;
subplot(2, 1, 1);
plot(1:maxEpochs, mseHistory, '-o');
xlabel('Epoch');
ylabel('Mean Squared Error (MSE)');
title('Epoch vs. MSE on Test Data');
grid on;

subplot(2, 1, 2);
plot(1:maxEpochs, rSquaredHistory, '-o');
xlabel('Epoch');
ylabel('R-squared (R²)');
title('Epoch vs. R-squared on Test Data');
grid on;
