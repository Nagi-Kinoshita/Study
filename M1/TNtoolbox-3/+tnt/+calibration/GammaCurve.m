classdef GammaCurve < handle
    % Color CAL II を利用してディスプレイのガンマ特性を測定する。
    % 利用方法の詳細は wiki 参照。
    properties
        step_size
        repetition_count
        output_folder_path

        values_to_measure

        correction_matrix

        window_id
        oval_rect

        raw_table
        fmt_table = cell(1, 3)
    end

    methods
        function self = GammaCurve()
            try
                self.query_settings();
                self.initialize_ptb();
                self.validate_values();
                self.draw_spot(zeros(1, 3));
                self.initialize_color_cal();
                self.measure();
                self.format();
                self.save();
                self.clean_up();
            catch err
                self.clean_up();
                rethrow(err);
            end
        end
    end

    methods (Access = private)
        function query_settings(self)
            self.step_size = 8;
            self.repetition_count = 3;
            self.output_folder_path = "./" + datestr(datetime(), "yyyy_mm_dd_HH_MM_SS");

            disp("測定パラメーターを選択してください。");
            disp("デフォルトの値を利用する場合は1を、パラメーターを変更したい場合は2を入力してください。");
            disp(" ");
            disp("1) デフォルト");
            disp("       ステップサイズ: " + string(self.step_size));
            disp("       計測回数: " + string(self.repetition_count));
            disp("       出力フォルダの相対パス: " + self.output_folder_path);
            disp(" ");
            disp("2) カスタム設定");
            disp(" ");
            switch input("tnt> ", "s")
            % default settings
            case "1"
                % do nothing
            % customize settings
            case "2"
                disp("パラメーターを設定します。");
                disp("デフォルトの値を利用する場合は何も入力せずにエンターキーを押してください。")
                disp("ステップサイズ (デフォルト: " + string(self.step_size) + ")");
                while true
                    ss = string(input("tnt> ", "s"));
                    if ss == ""
                        break;
                    end
                    ss = double(ss);
                    if isnan(ss)
                        disp("無効な入力です。有効な数値を入力してください。");
                        continue;
                    else
                        self.step_size = ss;
                        break;
                    end
                end

                disp("計測回数 (デフォルト: " + string(self.repetition_count) + ")");
                while true
                    rc = string(input("tnt> ", "s"));
                    if rc == ""
                        break;
                    end
                    rc = double(rc);
                    if isnan(rc)
                        disp("Invalid input.");
                        continue;
                    else
                        self.repetition_count = rc;
                        break;
                    end
                end

                disp("出力フォルダの相対パス (デフォルト: " + self.output_folder_path + ")")
                ofp = string(input("tnt> ", "s"));
                if ofp ~= ""
                    self.output_folder_path = ofp;
                end
            otherwise
                error("無効な入力です。1か2を入力してください。");
            end

            if ~isfolder(self.output_folder_path)
                mkdir(self.output_folder_path)
            end
        end

        function initialize_color_cal(self)
            try
                ColorCal2('DeviceInfo');
            catch
                error("Color CAL II を認識できません。Color CAL II を正しく接続してください。");
            end
            disp("Color CAL II を暗幕で覆い、エンターキーを押してください。");
            input("tnt> ", "s");
            % 何故か matlab の serialport オブジェクトを通じてゼロ較正しようとすると挙動がおかしくなるので、ここは ptb3 の機能を利用。
            while ~ColorCal2('ZeroCalibration')
                disp("ゼロ較正に失敗しました。");
                disp("Color CAL II をきちんと暗幕で覆った後、再度エンターキーを押してください。");
                input("tnt> ", "s");
            end
            disp("ゼロ較正に成功しました。");

            disp("Color CAL II を画面中央の正面に配置し、エンターキーを押してください。");
            input("tnt> ", "s");

            cor_mat = ColorCal2('ReadColorMatrix');
            self.correction_matrix = cor_mat(1:3, :);
        end

        function xyz = measure_by_color_cal(self)
            try
                s = ColorCal2('MeasureXYZ');
                xyz = self.correction_matrix * [s.x, s.y, s.z]';
            catch
                error("Color CAL II が測光に失敗しました。");
            end
        end

        function initialize_ptb(self)
            % give warning if the psychotoolbox is not based on OpenGL
            AssertOpenGL();
            PsychImaging('PrepareConfiguration');
            screen_id = max(Screen('Screens'));
            % increase precision of alpha-blending if possible.
            PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');

            [self.window_id, window_rect] = PsychImaging('OpenWindow', screen_id);
            Priority(MaxPriority(self.window_id));

            h = RectHeight(window_rect);
            self.oval_rect = CenterRect([0, 0, h, h] / 2, window_rect);
        end

        function draw_spot(self, spot_rgb)
            arguments
                self (1, 1) tnt.calibration.GammaCurve
                spot_rgb (1, 3) double
            end

            Screen('FillOval', self.window_id, spot_rgb, self.oval_rect);
            Screen('Flip', self.window_id);
        end

        function validate_values(self)
            % 指定した値が丸め込まれる場合がある。
            % PTB3側の処理で丸め込まれるので、切り捨てられたのか、切り上げられたのかを確認する。

            max_color = Screen('ColorRange', self.window_id);
            self.values_to_measure = 0:self.step_size:max_color;
            if self.values_to_measure(end) ~= max_color
                self.values_to_measure(end + 1) = max_color;
            end

            for i = 1:length(self.values_to_measure)
                Screen('FillRect', self.window_id, self.values_to_measure(i));
                Screen('Flip', self.window_id);
                vec = Screen('GetImage', self.window_id, [0, 0, 1, 1]);
                self.values_to_measure(i) = double(vec(1));
            end
            self.values_to_measure = unique(self.values_to_measure);

            max_str = string(self.values_to_measure(end));
            value_count_str = string(length(self.values_to_measure));
            disp("色の最大値は " + max_str + " です。");
            disp("計測するチャンネル強度は以下に示す0から" + max_str + "までの" + value_count_str + "段階です。");
            disp(join(string(self.values_to_measure), ", "));
            disp("エンターキーを押してください。");
            input("tnt>", "s");
        end

        function measure(self)
            value_count = length(self.values_to_measure);
            all_samples_count = 3 * self.repetition_count * value_count;

            color_name = ["R", "G", "B"];

            channel = repmat(string(missing()), all_samples_count, 1);
            digital = nan(all_samples_count, 1);
            x = nan(all_samples_count, 1);
            y = nan(all_samples_count, 1);
            z = nan(all_samples_count, 1);

            tic();
            i = 1;
            h = waitbar(0, "...");
            for r = 1:self.repetition_count
                for l = randperm(value_count)
                    for c = randperm(3)
                        msg = sprintf('[%d/%d] %s: %d', i, all_samples_count, color_name(c), self.values_to_measure(l));
                        if isvalid(h)
                            h = waitbar(i / all_samples_count, h, msg);
                        else
                            h = waitbar(i / all_samples_count, msg);
                        end

                        spot_rgb = zeros(3, 1);
                        spot_rgb(c) = self.values_to_measure(l);

                        self.draw_spot(spot_rgb);
                        xyz = self.measure_by_color_cal();
                        channel(i) = color_name(c);
                        digital(i) = self.values_to_measure(l);
                        x(i) = xyz(1);
                        y(i) = xyz(2);
                        z(i) = xyz(3);

                        i = i + 1;
                    end
                end
            end
            close(h);
            self.raw_table = table(channel, digital, x, y, z);
            toc();
        end

        function format(self)
            t = self.raw_table;
            rgb = ["R", "G", "B"];
            for i = 1:3
                % デジタルサンプル点を抽出
                rgb_idx = t.channel == rgb(i);
                digital = sort(unique(t{rgb_idx, "digital"}));

                % 輝度サンプルをデジタルサンプル点ごとに平均する
                y = nan(size(digital));
                for j = 1:length(digital)
                    d_idx = t.digital == digital(j);
                    y(j) = mean(t{rgb_idx & d_idx, "y"});
                end
                self.fmt_table{i} = table(digital, y);
            end
        end

        function save(self)
            writetable(self.raw_table, self.output_folder_path + "/raw_table.csv");

            r = self.fmt_table{1};
            g = self.fmt_table{2};
            b = self.fmt_table{3};
            writetable(r, self.output_folder_path + "/r.csv");
            writetable(g, self.output_folder_path + "/g.csv");
            writetable(b, self.output_folder_path + "/b.csv");

            gamma_converter = tnt.GammaConverter(r, g, b);
            gamma_converter.make_graph();
            save(self.output_folder_path + "/gamma_converter.mat", "gamma_converter");
        end

        function clean_up(~)
            ColorCal2('Close');
            Screen('CloseAll');
        end
    end
end
