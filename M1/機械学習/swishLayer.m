classdef swishLayer < nnet.layer.Layer
    methods
        function layer = swishLayer(name)
            % スーパークラスのコンストラクタを呼び出す
            layer.Name = name;
            layer.Description = 'Swish Activation Layer';
        end
        
        function Z = predict(layer, X)
            % Swishの前向き計算
            Z = X .* sigmoid(X);
        end
        
        function dLdX = backward(layer, X, Z, dLdZ, ~)
            % Swishの後ろ向き計算
            S = sigmoid(X);
            dLdX = dLdZ .* (S + X .* S .* (1 - S));
        end
    end
end

function S = sigmoid(X)
    S = 1 ./ (1 + exp(-X)); % シグモイド関数
end
