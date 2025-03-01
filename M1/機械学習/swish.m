function y = swish(x)
    y = x ./ (1 + exp(-x));  % Swish活性化関数
end