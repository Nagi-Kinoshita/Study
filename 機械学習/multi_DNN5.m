%LED_input→cell
clear
X_data = readmatrix("LED_input_data_complex4.csv");
Y_data = readmatrix("spectrum_output_data_complex4.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
[row_count, ~] = size(Y_data);
cell_data=zeros([row_count 4]);

for i=1:row_count
    for j=1:391
        cell_data(i,1)=cell_data(i,1)+Y_data(i,j)*XYZ_sens(1,j);
        cell_data(i,2)=cell_data(i,2)+Y_data(i,j)*XYZ_sens(2,j);
        cell_data(i,3)=cell_data(i,3)+Y_data(i,j)*XYZ_sens(3,j);
        cell_data(i,4)=cell_data(i,4)+Y_data(i,j)*ipRGC_sens(j);
    end
end

train_ratio = 0.8;
train_size = round(row_count * train_ratio);

% Full connection or CNN
nettype = 2; % 1 Full 2 CNN

% 元のデータに追加
inputData = X_data;
outputData = cell_data;

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
        sequenceInputLayer(24, 'Name', 'input')                % 入力層（シーケンスデータの次元24）
        fullyConnectedLayer(64, 'Name', 'fc1')                % 隠れ層1（ノード数64）
        reluLayer('Name', 'relu1')                            % ReLU層1
        batchNormalizationLayer('Name', 'batchnorm1')         % Batch Normalization層1
        fullyConnectedLayer(32, 'Name', 'fc2')                % 隠れ層2（ノード数32）
        reluLayer('Name', 'relu2')                            % ReLU層2
        batchNormalizationLayer('Name', 'batchnorm2')         % Batch Normalization層2
        fullyConnectedLayer(4, 'Name', 'output')              % 出力層（ノード数4）
        regressionLayer('Name', 'regressionoutput')           % 回帰タスク用の出力層
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
    plot(1:4, Y_train_sample, 'o-', 'LineWidth', 1.5, 'DisplayName', 'Actual');
    hold on;
    plot(1:4, YPred_sample, 'x-', 'LineWidth', 1.5, 'DisplayName', 'Predicted');
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
    plot(1:4, Y_test_sample, 'o-', 'LineWidth', 1.5, 'DisplayName', 'Actual');
    hold on;
    plot(1:4, YPred_sample, 'x-', 'LineWidth', 1.5, 'DisplayName', 'Predicted');
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
