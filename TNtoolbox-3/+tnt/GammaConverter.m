classdef GammaConverter
    % 輝度線形RGB色空間とディスプレイ上のデジタルRGB色空間を変換できる。
    %
    % どちらの色空間も0~1に正規化されているので、必要があれば適宜定数倍すること。
    % 一般的な各チャンネル8bitのディスプレイであれば、デジタルRGB値を255倍すれば良い。
    %
    % 作成方法1
    %   ガンマ測光プログラム(tnt.calibration.GammaCurve)によって自動生成されたものを利用する。
    %   構文
    %     gamma_converter = load("gamma_converter.mat").gamma_coverter;
    %
    % 作成方法2
    %   ガンマ測光プログラム(tnt.calibration.GammaCurve)の結果を表すデータから作成する。
    %   構文
    %     r = readtable("r.csv");
    %     g = readtable("g.csv");
    %     b = readtable("b.csv");
    %     gamma_converter = tnt.GammaConverter(r, g, b);
    %
    % 色変換
    %   2つのメソッドを利用して、線形RGB色空間とデジタルRGB色空間を変換できる。
    %   詳細については、メソッドのドキュメントを参照。
    %   例 digital_rgb = gamma_converter.linear_rgb_to_digital_rgb(linear_rgb);
    %      linear_rgb = gamma_converter.digital_rgb_to_linear_rgb(digital_rgb);
    properties (GetAccess = public, SetAccess = private)
        % RGB3つのチャンネルそれぞれにおける、デジタル値と輝度値の対応表をセルでまとめたもの。
        samples (3, 1) cell
        % ガンマ特性を65536段階にスプライン補完したもの
        splines (3, 65536) double = nan(3, 65536)
        % ガンマ特性にガンマ関数をフィッティングしたもの
        gamma_functions (3, 1) tnt.GammaFunction
    end

    properties (Constant)
        % スプライン補完の階調数
        resolution (1, 1) double = 65536;
    end

    methods (Static)
        function merged = merge_low_samples(sample, low_sample, joint_points)
            % 低輝度帯のガンマ特性を結合する。
            %
            % tnt.calibration.GammaCurveではColorCALIIと呼ばれる放射輝度計でディスプレイのガンマ特性
            % を測定するが、こちらは低輝度帯の測定精度が悪い。
            % この関数は、ColorCALIIの測定結果と低輝度帯を別の機器で正確に測定した結果を結合し、
            % 低輝度帯の変換精度を向上させる。
            %
            % 構文
            % merged = tnt.GammaConverter.merge_low_samples(sample, low_sample, joint_points)
            %
            % 引数
            %   sample:
            %     ColorCALIIの測定結果。
            %     "digital" と "y" のフィールドを持つテーブル変数で、ディスプレイのデジタル入力値と
            %     輝度の対応関係を表す。
            %     基本的には、tnt.calibration.GammaCurveで出力された r.csv, g.csv, b.csv の
            %     いずれかを読み込んだテーブル変数となる。
            %   low_sample:
            %     低輝度帯の測定結果。
            %     sampleと同じく、"digital"と"y"のフィールドを持つテーブル変数である。
            %   joint_points:
            %     2つのテーブルの結合点。
            %     2つのテーブルを結合するときに、デバイスによる測定輝度の差を補正する必要がある。
            %     その際に、値の差の補正を行うディスプレイのデジタル入力値を指定する。
            %     デフォルトでは [32, 40, 48] となっており、引数の省略が可能。
            %
            % 返り値
            %   merged:
            %     結合されたテーブル。tnt.GammaConverterのコンストラクターで引数とすることで、低輝度
            %     な色を高精度に変換できるようになる。
            arguments
                sample (:, :) table
                low_sample (:, :) table
                joint_points (1, :) double = [32, 40, 48]
            end
            sample = check_sample_table(sample);
            low_sample = check_sample_table(low_sample);

            if ~all(ismember(joint_points, sample.digital))
                warning("結合点に対応した測定データが sample に存在しません。スプライン補完で代用します。");
                s_y_jp = spline(sample.digital, sample.y, joint_points);
            else
                idx = ismember(sample.digital, joint_points);
                s_y_jp = sample{idx, "y"};
            end
            if ~all(ismember(joint_points, low_sample.digital))
                warning("結合点に対応した測定データが low_sample に存在しません。スプライン補完で代用します。");
                ls_y_jp = spline(low_sample.digital, low_sample.y, joint_points);
            else
                idx = ismember(low_sample.digital, joint_points);
                ls_y_jp = low_sample{idx, "y"};
            end

            coef = mean(s_y_jp ./ ls_y_jp);
            low_sample.y = coef * low_sample.y;

            low_idx = low_sample.digital <= max(joint_points);
            high_idx = sample.digital > max(joint_points);
            merged = [low_sample(low_idx, ["digital", "y"]); sample(high_idx, ["digital", "y"])];
        end
    end

    methods
        function self = GammaConverter(r, g, b)
            % ガンマ測光プログラムで生成される r.csv, g.csv, b.csv からインスタンス化する。
            %
            %
            % csvファイルはガンマ測光(tnt.calibration.GammaCurve)の出力に含まれている。
            % 2021_04_08_12_45_34
            % ├ gammaconverter.mat
            % ├ raw_table.csv
            % ├ r.csv
            % ├ g.csv
            % └ b.csv
            %
            % 構文
            %   r = readtable("r.csv");
            %   g = readtable("g.csv");
            %   b = readtable("b.csv");
            %   gamma_converter = tnt.GammaConverter(r, g, b);
            %
            % 引数
            %   r:
            %     ガンマ測光プログラム(tnt.calibration.GammaCurve)で生成される r.csv をテーブルとして
            %     読み込むことで得られる、ディスプレイのデジタル入力値と輝度の対応を示すテーブル変数。
            %     例えば r = readtable("table.csv"); のように読み込める。
            %     "digital" と "y" のフィールドを持っていなければならない。
            %   g: rに同様だが、Gチャンネルの結果を示す。
            %   b: rに同様だが、Bチャンネルの結果を示す。
            %
            % 返り値
            %   gamma_converter: このクラス(tnt.GammaConverter)のインスタンス。
            arguments
                r (:, :) table
                g (:, :) table
                b (:, :) table
            end

            % テーブルに必要なフィールドが存在するか確認する。
            self.samples = {r, g, b};
            for i = 1:3
                self.samples{i} = check_sample_table(self.samples{i});
            end

            % 以下の2行は冗長に見えるが、1行にまとめないこと。
            % まとめると gamma_functions の1番と2番が同じオブジェクトを参照してしまい
            % チャンネルごとにガンマ関数を最適化できなくなる。
            %
            % 参考ページ
            % https://jp.mathworks.com/help/matlab/matlab_oop/initializing-arrays-of-handle-objects.html
            % https://jp.mathworks.com/help/matlab/matlab_oop/specifying-properties.html#br18hyr
            gf(3) = tnt.GammaFunction();
            self.gamma_functions = gf;

            % チャンネルごとにフィッティングと補完を行う
            spline_queries = linspace(0, 1, self.resolution);
            rgb = ["R", "G", "B"];
            for i = 1:3
                digitals = self.samples{i}.digital;
                linears = self.samples{i}.y;
                % 輝度が単調増加していない場合は警告する。
                % 有機ELディスプレイの低輝度帯ではしばしば生じうる。
                % これは、計測機器の計測下限を下回ることがあるため。
                if ~issorted(linears)
                    warning('%sチャンネルの測定結果が振動しているので修正します。', rgb(i));
                    linears = make_monotonic(linears);
                end

                % フィッティングの前処理で正規化(0~1)する
                digitals = rescale(digitals);
                linears = rescale(linears);
                % フィッティングと補完
                self.gamma_functions(i).fit(digitals, linears);
                self.splines(i, :) = spline(digitals, linears, spline_queries);

                % スプライン補完の結果が単調増加となっていない場合は警告する。
                if ~issorted(self.splines(i, :))
                    warning('%sチャンネルのスプライン補完の結果が振動しているので修正します。', rgb(i));
                    self.splines(i, :) = make_monotonic(self.splines(i, :));
                end
            end
        end

        function make_graph(self)
            % このガンマ変換器の特性をグラフに示す。
            %
            % 初期化で指定されたRGB各チャンネルのサンプリング点と、
            % それらに対するガンマ関数フィッティング及びスプライン補完の結果をグラフに示す。
            f = figure;
            f.WindowState = "maximized";
            tiledlayout(2, 2);
            point_styles = ["ro", "go", "bo"];
            line_styles = ["r", "g", "b"];

            n_queries = linspace(0, 1, self.resolution);
            for i = 1:3
                digitals = self.samples{i}.digital;
                linears = self.samples{i}.y;

                queries = rescale(n_queries, min(digitals), max(digitals));
                l_min = min(linears);
                l_max = max(linears);

                n_digitals = rescale(digitals);
                n_linears = rescale(linears);

                % グラフに描画
                % 正規化前
                nexttile(1); hold on;
                plot(digitals, linears, point_styles(i));
                plot(queries, rescale(self.gamma_functions(i).digital_to_linear(queries), l_min, l_max), line_styles(i));
                nexttile(2); hold on;
                plot(digitals, linears, point_styles(i));
                plot(queries, rescale(self.splines(i, :), l_min, l_max), line_styles(i));

                % 正規化後
                nexttile(3); hold on;
                plot(n_digitals, n_linears, point_styles(i));
                plot(n_queries, self.gamma_functions(i).digital_to_linear(n_queries), line_styles(i));
                nexttile(4); hold on;
                plot(n_digitals, n_linears, point_styles(i));
                plot(n_queries, self.splines(i, :), line_styles(i));
            end

            % グラフの体裁を整える
            nexttile(1);
            title("ガンマ関数フィッティング");
            xlabel("デジタル入力値");
            ylabel("輝度 [cd/m^2]");
            legends = ["赤サンプル", "赤ガンマ関数", "緑サンプル", "緑ガンマ関数", ...
                    "青サンプル", "青ガンマ関数"];
            legend(legends, "Location", "northwest", "NumColumns", 2, "Orientation", "horizontal");
            set(gca, "FontSize", 16);

            nexttile(2);
            title("スプライン補完");
            xlabel("デジタル入力値");
            ylabel("輝度 [cd/m^2]");
            legends = ["赤サンプル", "赤スプライン補完", "緑サンプル", "緑スプライン補完", ...
                    "青サンプル", "青スプライン補完"];
            legend(legends, "Location", "northwest", "NumColumns", 2, "Orientation", "horizontal");
            set(gca, "FontSize", 16);

            nexttile(3);
            title("ガンマ関数フィッティング");
            xlabel("正規化されたデジタル入力値");
            ylabel("正規化された輝度");
            legends = ["赤サンプル", "赤ガンマ関数", "緑サンプル", "緑ガンマ関数", ...
                    "青サンプル", "青ガンマ関数"];
            legend(legends, "Location", "northwest", "NumColumns", 2, "Orientation", "horizontal");
            set(gca, "FontSize", 16);

            nexttile(4);
            title("スプライン補完");
            xlabel("正規化されたデジタル入力値");
            ylabel("正規化された輝度");
            legends = ["赤サンプル", "赤スプライン補完", "緑サンプル", "緑スプライン補完", ...
                    "青サンプル", "青スプライン補完"];
            legend(legends, "Location", "northwest", "NumColumns", 2, "Orientation", "horizontal");
            set(gca, "FontSize", 16);
        end

        function digital_rgb = linear_rgb_to_digital_rgb(self, linear_rgb, option)
            % 線形RGB色空間からデジタルRGB色空間に変換する。
            %
            % 構文
            %   digital_rgb = gamma_converter.linear_rgb_to_digital_rgb(linear_rgb, option)
            %
            % 引数
            %   gamma_converter:
            %     このクラス(tnt.GammaConverter)のインスタンス。
            %   linear_rgb:
            %     線形RGB色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            %     ディスプレイの色域で0~1に正規化されていて、
            %     0未満もしくは1より大きい値はディスプレイで呈示できない色であることを示す。
            %   option:
            %     変換方法を指定できる。
            %     指定できるのは "spline" と "gamma" の2種で、"spline" がデフォルトである。
            %     "spline" はガンマ特性をスプライン補完して得た曲線に基づいて変換する
            %     "gamma" はガンマ特性をガンマ関数(tnt.GammaFunction)でフィッティングして得た曲線に
            %     に基づいて変換する
            %
            % 返り値
            %   digital_rgb:
            %     ディスプレイ上のデジタルRGB色空間におけるデータ。
            arguments
                self (1, 1) tnt.GammaConverter
                linear_rgb
                option (1, 1) string {mustBeMember(option, ["spline", "gamma"])}= "spline"
            end

            if any(linear_rgb < 0 | linear_rgb > 1, "all")
                warning("色域外の色(0~1に収まっていない値)を変換しようとしています。");
                warning("0未満の値は0に、1より大きい値は1に丸め込まれます。");
                linear_rgb(linear_rgb < 0) = 0;
                linear_rgb(linear_rgb > 1) = 1;
            end

            switch option
            case "spline"
                digital_rgb = tnt.three_channel_convert(self, linear_rgb, @linear_rgb_to_digital_rgb_spline);
            case "gamma"
                digital_rgb = tnt.three_channel_convert(self, linear_rgb, @linear_rgb_to_digital_rgb_gamma);
            otherwise
                error("Can't be happened!");
            end
        end

        function linear_rgb = digital_rgb_to_linear_rgb(self, digital_rgb, option)
            % デジタルRGB色空間から線形RGB色空間に変換する。
            %
            % 構文
            %   linear_rgb = gamma_converter.linear_rgb_to_digital_rgb(linear_rgb)
            %
            % 引数
            %   gamma_converter:
            %     このクラス(tnt.GammaConverter)のインスタンス。
            %   digital_rgb:
            %     ディスプレイ上のデジタルRGB色空間におけるデータ。0~1に正規化されている。
            %     3xN行列またはMxNx3の画像を変換可能。
            %   option:
            %     変換方法を指定できる。
            %     指定できるのは "spline" と "gamma" の2種で、"spline" がデフォルトである。
            %     "spline" はガンマ特性をスプライン補完して得た曲線に基づいて変換する
            %     "gamma" はガンマ特性をガンマ関数(tnt.GammaFunction)でフィッティングして得た曲線に
            %     に基づいて変換する
            %
            % 返り値
            %   linear_rgb:
            %     線形RGB色空間のデータ。ディスプレイの色域で0~1に正規化されていて、
            %     0未満もしくは1より大きい値はディスプレイで呈示できない色であることを示す。
            arguments
                self (1, 1) tnt.GammaConverter
                digital_rgb
                option (1, 1) string {mustBeMember(option, ["spline", "gamma"])} = "spline"
            end

            if any(digital_rgb < 0 | digital_rgb > 1, "all")
                warning("色域外の色(0~1に収まっていない値)を変換しようとしています。");
                warning("0未満の値は0に、1より大きい値は1に丸め込まれます。");
                digital_rgb(digital_rgb < 0) = 0;
                digital_rgb(digital_rgb > 1) = 1;
            end

            switch option
            case "spline"
                linear_rgb = tnt.three_channel_convert(self, digital_rgb, @digital_rgb_to_linear_rgb_spline);
            case "gamma"
                linear_rgb = tnt.three_channel_convert(self, digital_rgb, @digital_rgb_to_linear_rgb_gamma);
            otherwise
                error("Can't be happened!");
            end
        end
    end
end

function checked_t = check_sample_table(t)
    fields = ["digital", "y"];
    vn = t.Properties.VariableNames;
    for j = 1:length(fields)
        if ~ismember(fields(j), vn)
            error('テーブルに必要なフィールド "%s" がありません', fields(j));
        end
    end
    checked_t = sortrows(t, "digital");
end

function d = make_monotonic(d)
    arguments
        d (1, :) double
    end

    for i = 1:(length(d) - 1)
        if d(i) >= d(i + 1)
            d(i + 1) = d(i) + eps;
        end
    end
end

function digital_rgb = linear_rgb_to_digital_rgb_spline(s, linear_rgb)
    arguments
        s (1, 1) tnt.GammaConverter
        linear_rgb (3, :) double
    end

    digital_rgb = zeros(size(linear_rgb));
    digital = linspace(0, 1, tnt.GammaConverter.resolution);
    for i = 1:3
        digital_rgb(i, :) = interp1(s.splines(i, :), digital, linear_rgb(i, :), "nearest");
    end
end

function linear_rgb = digital_rgb_to_linear_rgb_spline(s, digital_rgb)
    arguments
        s (1, 1) tnt.GammaConverter
        digital_rgb (3, :) double
    end

    linear_rgb = zeros(size(digital_rgb));
    digital = linspace(0, 1, tnt.GammaConverter.resolution);
    for i = 1:3
        linear_rgb(i, :) = interp1(digital, s.splines(i, :), digital_rgb(i, :), "nearest");
    end
end

function digital_rgb = linear_rgb_to_digital_rgb_gamma(s, linear_rgb)
    arguments
        s (1, 1) tnt.GammaConverter
        linear_rgb (3, :) double
    end

    digital_rgb = zeros(size(linear_rgb));
    for i = 1:3
        digital_rgb(i, :) = s.gamma_functions(i).linear_to_digital(linear_rgb(i, :));
    end
end

function linear_rgb = digital_rgb_to_linear_rgb_gamma(s, digital_rgb)
    arguments
        s (1, 1) tnt.GammaConverter
        digital_rgb (3, :) double
    end

    linear_rgb = zeros(size(digital_rgb));
    for i = 1:3
        linear_rgb(i, :) = s.gamma_functions(i).digital_to_linear(digital_rgb(i, :));
    end
end