clear

% データの読み込み
X_data_simple = readmatrix("spectrum_output_data_simple.csv");
Y_data_simple = readmatrix("LED_input_data_simple.csv");

X_data_complex = readmatrix("spectrum_output_data_complex.csv");
Y_data_complex = readmatrix("LED_input_data_complex.csv");

X_data = [X_data_simple; X_data_complex];
Y_data = [Y_data_simple; Y_data_complex];

% データの分割 (80%訓練、20%テスト)
cv = cvpartition(size(X_data, 1), 'HoldOut', 0.2); % ランダムに分割
idx = cv.test;

X_train = X_data(~idx, :);
Y_train = Y_data(~idx, :);
X_test = X_data(idx, :);
Y_test = Y_data(idx, :);

% 入力データと出力データの次元数を定義
inputSize = size(X_train, 2);   % 391
outputSize = size(Y_train, 2);  % 26

% ニューラルネットワークのアーキテクチャ定義
layers = [
    featureInputLayer(inputSize)        % 入力層
    fullyConnectedLayer(128)            % 隠れ層1 (128ユニット)
    reluLayer                           % 活性化関数
    fullyConnectedLayer(64)             % 隠れ層2 (64ユニット)
    reluLayer                           % 活性化関数
    fullyConnectedLayer(32)             % 隠れ層3 (32ユニット)
    reluLayer                           % 活性化関数
    fullyConnectedLayer(outputSize)     % 出力層 (26ユニット)
    regressionLayer                     % 回帰用レイヤ
];

% トレーニングオプションの設定
options = trainingOptions('adam', ...
    'MaxEpochs', 100, ...
    'MiniBatchSize', 32, ...
    'InitialLearnRate', 0.001, ...
    'ValidationData', {X_test, Y_test}, ...
    'ValidationFrequency', 10, ...
    'Plots', 'training-progress', ...
    'Verbose', false);

% ニューラルネットワークのトレーニング
net = trainNetwork(X_train, Y_train, layers, options);

% テストデータを使用して予測
Y_pred = predict(net, X_test);

% 精度評価
mse_value = mean((Y_test - Y_pred).^2, 'all');   % MSE (平均二乗誤差)
mae_value = mean(abs(Y_test - Y_pred), 'all');   % MAE (平均絶対誤差)
r_squared_value = 1 - (sum((Y_test - Y_pred).^2, 'all') / sum((Y_test - mean(Y_test, 1)).^2, 'all')); % R² (決定係数)

% 結果の表示
fprintf('Mean Squared Error (MSE): %.4f\n', mse_value);
fprintf('Mean Absolute Error (MAE): %.4f\n', mae_value);
fprintf('R-squared (R²): %.4f\n', r_squared_value);