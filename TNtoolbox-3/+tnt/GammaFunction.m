classdef GammaFunction < handle
    % ガンマ関数 G
    % 4つの定数と1つの学習バラメーターからなる関数であり、その数式は以下である。
    % L = G(j) = L_min + (L_max - L_min) * (max([j - j_th, 0]) / (j_max - j_th)) ^ g
    %   関数
    %       G: ガンマ関数
    %   入力
    %       j: ディスプレイの入力値
    %   出力
    %       L: ディスプレイの輝度
    %   学習パラメーター
    %       g: ガンマ値
    %   定数
    %       L_min: ディスプレイの最小輝度
    %       L_max: ディスプレイの最大輝度
    %       j_max: ディスプレイの最大入力値
    %       j_th: ディスプレイの入力値の閾値(threshold)
    %
    % 以下にLaTeX形式の数式を示す。
    % $$
    % L = G(j) = L_{\text{min}} + (L_{\text{max}} - L_{\text{min}})\left(\frac{\max(j - j_{\text{th}}, 0)}{(j_{\text{max}} - j_{\text{th}})}\right)^{g}
    % $$

    properties
        % ガンマ値
        g (1, 1) double

        % ディスプレイの入力値の閾値
        j_th (1, 1) double


        % ディスプレイの最小輝度
        l_min (1, 1) double

        % ディスプレイの最大輝度
        l_max (1, 1) double

        % ディスプレイの最大入力値
        j_max (1, 1) double
    end

    methods
        function self = GammaFunction()
            self.g = 2.2;
            self.l_min = 0;
            self.l_max = 1;
            self.j_max = 1;
            self.j_th = 0;
        end

        function fit(self, digital, linear)
            arguments
                self (1, 1) tnt.GammaFunction
                digital (1, :) double
                linear (1, :) double
            end

            function e = square_error(x)
                self.g = x;

                linear_hat = self.digital_to_linear(digital);

                e = sum((linear_hat - linear) .^ 2);
            end

            g_init = 2.2;
            x = fminsearch(@square_error, g_init);

            self.g = x;
        end

        function digital = linear_to_digital(self, linear)
            arguments
                self (1, 1) tnt.GammaFunction
                linear (1, :) double
            end

            digital = self.j_th + (((linear - self.l_min) ./ (self.l_max - self.l_min))  ...
                .^ (1 / self.g)) .* (self.j_max - self.j_th);
        end

        function linear = digital_to_linear(self, digital)
            arguments
                self (1, 1) tnt.GammaFunction
                digital (1, :) double
            end

            z = zeros(1, length(digital));
            linear = self.l_min + (self.l_max - self.l_min) ...
                 * (max([digital - self.j_th; z]) ./ (self.j_max - self.j_th)) .^ self.g;
        end
    end
end
