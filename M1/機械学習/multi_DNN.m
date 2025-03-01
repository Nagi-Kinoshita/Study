clear all;
rng('shuffle');

X_data = readmatrix("spectrum_output_data_complex3.csv");
Y_data = readmatrix("LED_input_data_complex3.csv");
[row_count, ~] = size(X_data);  % X_dataの行数を取得

ALL_coefficient = zeros(24, 392);
R_squared_values = zeros(1, 24);  % 決定係数を保存する配列
ALL_Y_pred=zeros([row_count,24]);

for i = 1:24
    
    % Yのi列目を抽出
    Y_data_column_i = Y_data(:, i);  
    
    % Xにバイアス項を追加
    X = [X_data ones(row_count, 1)];  
    
    % 重回帰分析の係数を計算
    coefficient = regress(Y_data_column_i, X);
    ALL_coefficient(i, :) = coefficient;
    
    % 決定係数 (R^2) の計算
    Y_pred = X * coefficient;  % 予測値
    ALL_Y_pred(:,i) = Y_pred;

    SS_res = sum((Y_data_column_i - Y_pred).^2);  % 残差平方和
    SS_tot = sum((Y_data_column_i - mean(Y_data_column_i)).^2);  % 全体平方和
    R_squared = 1 - (SS_res / SS_tot);  % 決定係数
    R_squared_values(i) = R_squared;  % 結果を格納
end
mean_R_squared = sum(R_squared_values) / 24;
fprintf('重回帰分析のみを行った際の平均決定係数: %.4f\n', mean_R_squared);
%writematrix(ALL_coefficient,"ALL_coefficient_multi.csv");

x = Y_data(:); % Y_data をベクトル化
y = ALL_Y_pred(:); % Y_pred をベクトル化
r = corrcoef(x, y);
fprintf('全体の相関係数: %.4f\n', r(1,2));

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
        fullyConnectedLayer(24, 'Name', 'fc_transfer4')    
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
        % 入力層：24次元の入力データ
        sequenceInputLayer(24, 'Normalization', 'none', 'Name', 'input')
    
        % 最初の全結合層
        fullyConnectedLayer(256, 'Name', 'fc1')  % 256ユニット
        batchNormalizationLayer('Name', 'bn_fc1')
        reluLayer('Name', 'relu_fc1')
    
        % 2番目の全結合層
        fullyConnectedLayer(128, 'Name', 'fc2')  % 128ユニット
        batchNormalizationLayer('Name', 'bn_fc2')
        reluLayer('Name', 'relu_fc2')
    
        % 出力層：目的変数が24個
        fullyConnectedLayer(24, 'Name', 'fc_output')  % 出力層
        regressionLayer('Name', 'output')
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

%% テストデータでの評価
YPred = predict(net, X_test1);
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
for sampleIndex = round(linspace(30,800,6))
    if nettype == 1
        X_train_sample = X_train1(sampleIndex, :);
        Y_train_sample = Y_train1(sampleIndex, :);
        YPred_sample = predict(net, X_train_sample);
    elseif nettype == 2
        X_train_sample = X_train1{sampleIndex};
        Y_train_sample = Y_train1{sampleIndex};
        YPred_sample = predict(net, X_train_sample);        
    end

    subplot(2,3,count)
    plot(1:24, Y_train_sample, 'o-', 'LineWidth', 1.5, 'DisplayName', 'Actual');
    hold on;
    plot(1:24, YPred_sample, 'x-', 'LineWidth', 1.5, 'DisplayName', 'Predicted');
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
for sampleIndex = round(linspace(2,10,6))
    if nettype == 1
        X_test_sample = X_test1(sampleIndex, :);
        Y_test_sample = Y_test1(sampleIndex, :);
        YPred_sample = predict(net, X_test_sample);
    elseif nettype == 2
        X_test_sample = X_test1{sampleIndex};
        Y_test_sample = Y_test1{sampleIndex};
        YPred_sample = predict(net, X_test_sample);        
    end

    subplot(2,3,count)
    plot(1:24, Y_test_sample, 'o-', 'LineWidth', 1.5, 'DisplayName', 'Actual');
    hold on;
    plot(1:24, YPred_sample, 'x-', 'LineWidth', 1.5, 'DisplayName', 'Predicted');
    xlabel('Output Dimension');
    ylabel('Value');
    title('Comparison of Actual and Predicted Values for a Test Sample');
    legend('Location', 'best');
    grid on;
    hold off;

    count = count+1;
end

%% トレーニングデータ全体のモデル予測値を取得
YPred_train = predict(net, X_train1);

% トレーニングデータ全体のラベルと予測値をまとめてプロット
figure;
hold on;
if nettype == 1
    plot(Y_train1(:), YPred_train(:), 'o', 'LineWidth', 1.5);
    plot([min(Y_train1(:)), max(Y_train1(:))], [min(Y_train1(:)), max(Y_train1(:))], '--k', 'LineWidth', 1.5);% y = x のラインを追加（完全一致の参照ライン）
elseif nettype == 2
    x = cell2mat(Y_train1);
    y = cell2mat(YPred_train);
    plot(x(:), y(:), 'o', 'LineWidth', 1.5);
    plot([min(y(:)), max(y(:))], [min(y(:)), max(y(:))], '--k', 'LineWidth', 1.5);% y = x のラインを追加（完全一致の参照ライン）

    r = corrcoef(x, y);
    fprintf('トレーニングデータにおける相関係数: %.4f\n', r(1,2));
end

xlabel('Actual Values (Training Data)');
ylabel('Predicted Values');
title('Comparison of Actual and Predicted Values for Training Data (All Dimensions Combined)');
grid on;
legend('Predictions', 'y = x line', 'Location', 'best');
hold off;



%% テストデータ全体のモデル予測値を取得
YPred_test = predict(net, X_test1);

% テストデータ全体のラベルと予測値をまとめてプロット
figure;
hold on;
if nettype == 1
    plot(Y_test(:), YPred_test(:), 'o', 'LineWidth', 1.5);
    plot([min(Y_test1(:)), max(Y_test1(:))], [min(Y_test1(:)), max(Y_test1(:))], '--k', 'LineWidth', 1.5); % y = x のラインを追加（完全一致の参照ライン）
elseif nettype == 2
    x = cell2mat(Y_test1);
    y = cell2mat(YPred_test);
    plot(x(:), y(:), 'o', 'LineWidth', 1.5);
    plot([min(y(:)), max(y(:))], [min(y(:)), max(y(:))], '--k', 'LineWidth', 1.5);% y = x のラインを追加（完全一致の参照ライン）

    r = corrcoef(x, y);
    fprintf('テストデータにおける相関係数: %.4f\n', r(1,2));
end

xlabel('Actual Values (Validation Data)');
ylabel('Predicted Values');
title('Comparison of Actual and Predicted Values for Test Data (All Dimensions Combined)');
grid on;
legend('Predictions', 'y = x line', 'Location', 'best');
hold off;


