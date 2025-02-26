clear

% データの読み込み
X_data = readmatrix("LED_input_data_complex4.csv");
Y_data = readmatrix("spectrum_output_data_complex4.csv");

% TN追加：ここでTrainとtestを分ける
train_ratio = 0.8;
[trainInd1, valInd1, testInd1] = dividerand(size(X_data, 1), train_ratio, (1-train_ratio)*3\5, (1-train_ratio)*2\5);

% データの分割（80%をトレーニング、20%をテストに使用（重回帰の場合はTest+Val））
X_train = X_data(trainInd1, :);
Y_train = Y_data(trainInd1, :);

X_test = X_data([valInd1,testInd1], :);
Y_test = Y_data([valInd1,testInd1], :);

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

%writematrix(ALL_coefficient,"ALL_coefficient.csv");

% トレーニングデータの相関係数の計算
x_train = Y_train(:);  % 実測値
y_train = Y_train_pred(:);  % 予測値

% 相関係数の計算
r_train = corrcoef(x_train, y_train);
fprintf('トレーニングデータにおける相関係数: %.8f\n', r_train(1, 2));

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
fprintf('テストデータにおける相関係数: %.8f\n', r_test(1, 2));

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
inputDataLED = X_data;
outputData = Y_data - ALL_Y_pred;

%% データ正規化: trainingで正規化範囲を設定→validationとtestにも適用（TN: ここでTrainとvalが再度分割されているのが気になる）
%% トレーニングデータのインデックスを取得: #ここTN削除→はじめにTrain,Val,Testに分割しておいてそれを再利用
%[trainInd1, valInd1, testInd1] = dividerand(size(inputData, 1), 0.8, 0.12, 0.08);

% トレーニングデータのみで正規化パラメータを計算 + 入出力千次元で共通の正規化パラメータ使用
tmp = inputDataLED(trainInd1, :);
inputPS.xmin = min(tmp(:)); % 全データの最小値
inputPS.xmax = max(tmp(:)); % 全データの最大値
tmp = outputData(trainInd1, :);
outputPS.xmin = min(tmp(:)); % 全データの最小値
outputPS.xmax = max(tmp(:)); % 全データの最大値

% mapminmax用の設定
% [inputDataTrainNorm, inputPS] = mapminmax(inputData(trainInd1, :)', 0, 1);
% [outputDataTrainNorm, outputPS] = mapminmax(outputData(trainInd1, :)', 0, 1);
inputDataLEDTrainNorm = normalize(inputDataLED(trainInd1, :)', inputPS.xmin, inputPS.xmax, 1);
inputDataTrainNorm = normalize(inputData(trainInd1, :)', inputPS.xmin, inputPS.xmax, 1); 
outputDataTrainNorm = normalize(outputData(trainInd1, :)', outputPS.xmin, outputPS.xmax, 1); 

% バリデーションデータとテストデータを同じパラメータで正規化
% inputDataValNorm = mapminmax('apply', inputData(valInd1, :)', inputPS);
% outputDataValNorm = mapminmax('apply', outputData(valInd1, :)', outputPS);
inputDataLEDValNorm = normalize(inputDataLED(valInd1, :)', inputPS.xmin, inputPS.xmax, 1);
inputDataValNorm = normalize(inputData(valInd1, :)', inputPS.xmin, inputPS.xmax, 1); 
outputDataValNorm = normalize(outputData(valInd1, :)', outputPS.xmin, outputPS.xmax, 1); 
 
% inputDataTestNorm = mapminmax('apply', inputData(testInd1, :)', inputPS);
% outputDataTestNorm = mapminmax('apply', outputData(testInd1, :)', outputPS);
inputDataLEDTestNorm = normalize(inputDataLED(testInd1, :)', inputPS.xmin, inputPS.xmax, 1);
inputDataTestNorm = normalize(inputData(testInd1, :)', inputPS.xmin, inputPS.xmax, 1); 
outputDataTestNorm = normalize(outputData(testInd1, :)', outputPS.xmin, outputPS.xmax, 1); 

% 転置して元の形状に戻す
X_train1 = inputDataTrainNorm';
Y_train1 = outputDataTrainNorm';
XLED_train1 = inputDataLEDTrainNorm';
X_val1 = inputDataValNorm';
Y_val1 = outputDataValNorm';
XLED_val1 = inputDataLEDValNorm';
X_test1 = inputDataTestNorm';
Y_test1 = outputDataTestNorm';
XLED_test1 = inputDataLEDTestNorm';

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

    XLED_train1 = num2cell(XLED_train1', 1);
    XLED_val1 = num2cell(XLED_val1', 1);
    XLED_test1 = num2cell(XLED_test1', 1);

    Y_train1 = num2cell(Y_train1', 1);
    Y_val1 = num2cell(Y_val1', 1);
    Y_test1 = num2cell(Y_test1', 1);

    Layers = [
        % 入力層（391次元のシーケンスデータ）
        sequenceInputLayer(24, 'Name', 'input')              

        % CNNのブロック1
        convolution1dLayer(5, 64, 'Padding', 'same', 'Name', 'conv1') % カーネルサイズ3, フィルタ数64
        reluLayer('Name', 'relu1')                                    % ReLU層
        batchNormalizationLayer('Name', 'batchnorm1')                 % Batch Normalization層

        % % CNNのブロック2
        % convolution1dLayer(3, 64, 'Padding', 'same', 'Name', 'conv2') % カーネルサイズ3, フィルタ数128
        % reluLayer('Name', 'relu2')                                    % ReLU層
        % batchNormalizationLayer('Name', 'batchnorm2')                 % Batch Normalization層
        % dropoutLayer(0.1, 'Name', 'dropout2')  % Dropout追加

        % 全結合層への変換
        fullyConnectedLayer(128, 'Name', 'fc0')                       % 全結合層 (ノード数256)
        reluLayer('Name', 'relu0')                                    % ReLU層
        batchNormalizationLayer('Name', 'batchnorm0')                 % Batch Normalization層

        % % 全結合層への変換
        % fullyConnectedLayer(256, 'Name', 'fc1')                       % 全結合層 (ノード数256)
        % reluLayer('Name', 'relu3')                                    % ReLU層
        % batchNormalizationLayer('Name', 'batchnorm3')                 % Batch Normalization層
        

        % 全結合層 (出力次元に対応)
        dropoutLayer(0.4, 'Name', 'dropout3')  % Dropout追加
        fullyConnectedLayer(391, 'Name', 'output')                    % 出力層 (ノード数391)
        regressionLayer('Name', 'regressionoutput')                   % 回帰タスク用の出力層
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
    'MaxEpochs', 10000, ...
    'MiniBatchSize', 128, ...  % 32
    'InitialLearnRate', 1e-2, ...  % 'InitialLearnRate', 1e-4, ...
    'Shuffle', 'every-epoch', ...
    'LearnRateSchedule', 'piecewise', ...      % 学習率を段階的に減少
    'LearnRateDropFactor', 0.999, ...            % 学習率の減少倍率（99%に減少）
    'LearnRateDropPeriod', 2, ...             % 2エポックごとに学習率を減少
    'ValidationData', {XLED_val1, Y_val1}, ...
    'ValidationFrequency', 20, ... % 50
    'ValidationPatience', 50, ... % 30 100回validationに改善が見られない場合に停止
    'Plots', 'training-progress', ...
    'Verbose', false);
end

%% 学習実行
net = trainNetwork(XLED_train1, Y_train1, Layers, options);

%% テストデータでの評価
YPred = predict(net, XLED_test1);
if nettype == 1
    testRMSE = sqrt(mean((YPred - Y_test1).^2, 'all'));
elseif nettype == 2
    tmp = cell2mat(YPred);
    YPred_m = reshape(tmp, length(YPred{1}), []);
    tmp = cell2mat(Y_test1);
    Y_test1_m = reshape(tmp, length(Y_test1{1}), []);    
    testRMSE = sqrt(mean((YPred_m - Y_test1_m).^2, 'all'));
end
fprintf('テストデータにおけるRMSE: %.4f\n', testRMSE);


%% トレーニングデータの実測値、予測値比較
figure('Name', 'Training');
count = 1;
for sampleIndex = round(linspace(30,length(X_train1),6))
    if nettype == 1
        X_train_sample = X_train1(sampleIndex, :);
        Y_train_sample = Y_train1(sampleIndex, :);
        YPred_sample = predict(net, X_train_sample);
    elseif nettype == 2
        X_train_sample = XLED_train1{sampleIndex};
        Y_train_sample = Y_train1{sampleIndex};
        YPred_sample = predict(net, X_train_sample); 

        % Y_train_sample = mapminmax('reverse', Y_train_sample, outputPS);
        % YPred_sample = mapminmax('reverse', YPred_sample, outputPS);    
        Y_train_sample = normalize(Y_train_sample, outputPS.xmin, outputPS.xmax, 2);
        YPred_sample = normalize(YPred_sample, outputPS.xmin, outputPS.xmax, 2);
    end

    subplot(2,3,count)
    plot(1:391, Y_train_sample, 'o-', 'LineWidth', 1.5, 'DisplayName', 'Actual');
    hold on;
    plot(1:391, YPred_sample, 'x-', 'LineWidth', 1.5, 'DisplayName', 'Predicted');
    xlabel('Output Dimension');
    ylabel('Value');
    title('Comparison of Actual and Predicted Values for a Training Sample');
    legend('Location', 'best');
    grid on;
    hold off;

    count = count+1;
end


%% テストデータの実測値、予測値比較
figure('Name', 'Test');
count = 1;
for sampleIndex = round(linspace(2,length(X_test1),6))
    if nettype == 1
        X_test_sample = X_test1(sampleIndex, :);
        Y_test_sample = Y_test1(sampleIndex, :);
        YPred_sample = predict(net, X_test_sample);
    elseif nettype == 2
        X_test_sample = XLED_test1{sampleIndex};
        Y_test_sample = Y_test1{sampleIndex};
        YPred_sample = predict(net, X_test_sample);

        % Y_test_sample = mapminmax('reverse', Y_test_sample, outputPS);
        % YPred_sample = mapminmax('reverse', YPred_sample, outputPS);
        Y_test_sample = normalize(Y_test_sample, outputPS.xmin, outputPS.xmax, 2);
        YPred_sample = normalize(YPred_sample, outputPS.xmin, outputPS.xmax, 2);        
    end

    subplot(2,3,count)
    plot(1:391, Y_test_sample, 'o-', 'LineWidth', 1.5, 'DisplayName', 'Actual');
    hold on;
    plot(1:391, YPred_sample, 'x-', 'LineWidth', 1.5, 'DisplayName', 'Predicted');
    xlabel('Output Dimension');
    ylabel('Value');
    title('Comparison of Actual and Predicted Values for a Test Sample');
    legend('Location', 'best');
    grid on;
    hold off;

    count = count+1;
end

%% トレーニングデータ全体のモデル予測値を取得
% x_pedestal = mapminmax('reverse', X_train1, inputPS);
x_pedestal = normalize(X_train1, inputPS.xmin, inputPS.xmax, 2);
% x_dif = mapminmax('reverse', Y_train1, outputPS);
x_dif = normalize(Y_train1, outputPS.xmin, outputPS.xmax, 2);
x_cell = cellfun(@(a, b) a + b, x_dif, x_pedestal, 'UniformOutput', false);
YPred_train = predict(net, XLED_train1);
% y_dif = mapminmax('reverse', YPred_train', outputPS);
y_dif = normalize(YPred_train', outputPS.xmin, outputPS.xmax, 2);
y_cell = cellfun(@(a, b) a + b, y_dif, x_pedestal, 'UniformOutput', false);

% トレーニングデータ全体のラベルと予測値をまとめてプロット
figure;
hold on;
if nettype == 1
    plot(Y_train1(:), YPred_train(:), 'o', 'LineWidth', 1.5);
    plot([min(Y_train1(:)), max(Y_train1(:))], [min(Y_train1(:)), max(Y_train1(:))], '--k', 'LineWidth', 1.5);% y = x のラインを追加（完全一致の参照ライン）
elseif nettype == 2
    %x = cell2mat(Y_train1);
    %y = cell2mat(YPred_train);
    x = cell2mat(x_cell);
    y = cell2mat(y_cell);    
    plot(x(:), y(:), 'o', 'LineWidth', 1.5);
    plot([min(y(:)), max(y(:))], [min(y(:)), max(y(:))], '--k', 'LineWidth', 1.5);% y = x のラインを追加（完全一致の参照ライン）

    r = corrcoef(x, y);
    fprintf('トレーニングデータにおける相関係数: %.8f\n', r(1,2));
end

xlabel('Actual Values (Training Data)');
ylabel('Predicted Values');
title('Comparison of Actual and Predicted Values for Training Data (All Dimensions Combined)');
grid on;
legend('Predictions', 'y = x line', 'Location', 'best');
hold off;



%% テストデータ全体のモデル予測値を取得
% x_pedestal = mapminmax('reverse', X_test1, inputPS);
x_pedestal = normalize(X_test1, inputPS.xmin, inputPS.xmax, 2);
% x_dif = mapminmax('reverse', Y_test1, outputPS);
x_dif = normalize(Y_test1, outputPS.xmin, outputPS.xmax, 2);
x_cell = cellfun(@(a, b) a + b, x_dif, x_pedestal, 'UniformOutput', false);
YPred_test = predict(net, XLED_test1);
% y_dif = mapminmax('reverse', YPred_test', outputPS);
y_dif = normalize(YPred_test', outputPS.xmin, outputPS.xmax, 2);
y_cell = cellfun(@(a, b) a + b, y_dif, x_pedestal, 'UniformOutput', false);

% テストデータ全体のラベルと予測値をまとめてプロット
figure;
hold on;
if nettype == 1
    plot(Y_test(:), YPred_test(:), 'o', 'LineWidth', 1.5);
    plot([min(Y_test1(:)), max(Y_test1(:))], [min(Y_test1(:)), max(Y_test1(:))], '--k', 'LineWidth', 1.5); % y = x のラインを追加（完全一致の参照ライン）
elseif nettype == 2
    x = cell2mat(x_cell);
    y = cell2mat(y_cell);
    plot(x(:), y(:), 'o', 'LineWidth', 1.5);
    plot([min(y(:)), max(y(:))], [min(y(:)), max(y(:))], '--k', 'LineWidth', 1.5);% y = x のラインを追加（完全一致の参照ライン）

    r = corrcoef(x, y);
    fprintf('テストデータにおける相関係数: %.8f\n', r(1,2));
end

xlabel('Actual Values (Validation Data)');
ylabel('Predicted Values');
title('Comparison of Actual and Predicted Values for Test Data (All Dimensions Combined)');
grid on;
legend('Predictions', 'y = x line', 'Location', 'best');
hold off;