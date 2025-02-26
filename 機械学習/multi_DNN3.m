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

% トレーニングデータのプロット
figure;
scatter(x_train, y_train, 'o', 'LineWidth', 1.5);  % 散布図
hold on;
plot([min(x_train(:)), max(x_train(:))], [min(x_train(:)), max(x_train(:))], '--k', 'LineWidth', 1.5);  % y=x ライン
hold off;
xlabel('Actual Values (Train)');
ylabel('Predicted Values (Train)');
title('Training Data: Actual vs Predicted');
grid on;

% テストデータのプロット
figure;
scatter(x_test, y_test, 'o', 'LineWidth', 1.5);  % 散布図
hold on;
plot([min(x_test(:)), max(x_test(:))], [min(x_test(:)), max(x_test(:))], '--k', 'LineWidth', 1.5);  % y=x ライン
hold off;
xlabel('Actual Values (Test)');
ylabel('Predicted Values (Test)');
title('Test Data: Actual vs Predicted');
grid on;
%writematrix(ALL_coefficient,"ALL_coefficient_multi3.csv");

writematrix(Y_test,"Y_test.csv");
writematrix(Y_test_pred,"Y_test_pred.csv");
%