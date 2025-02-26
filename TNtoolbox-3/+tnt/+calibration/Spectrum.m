classdef Spectrum
    % SpecBos を利用してディスプレイの分光分布を測定する。
    % 利用方法の詳細は wiki 参照。
    properties
        custom_flag
        window_id
        max_color
        oval_rect
    end

    methods
        function self = Spectrum()
            try
                self = self.query_settings();
                self = self.initialize_ptb();
                self.present();
                Screen('CloseAll');
            catch err
                Screen('CloseAll');
                rethrow(err);
            end
        end
    end

    methods (Access = private)
        function self = query_settings(self)
            disp("1か2を入力して、呈示する色を選択してください。");
            disp("1) デフォルトの4色（赤緑青黒）");
            disp("2) 任意の色");
            switch input("tnt> ", "s")
            case "1"
                self.custom_flag = false;
            case "2"
                self.custom_flag = true;
            otherwise
                error("無効な入力です。1か2を入力してください。");
            end
        end

        function self = initialize_ptb(self)
            % give warning if the psychotoolbox is not based on OpenGL
            AssertOpenGL();
            PsychImaging('PrepareConfiguration');
            screen_id = max(Screen('Screens'));
            % increase precision of alpha-blending if possible.
            PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');

            [self.window_id, window_rect] = PsychImaging('OpenWindow', screen_id);
            Priority(MaxPriority(self.window_id));

            self.max_color = Screen('ColorRange', self.window_id);

            h = RectHeight(window_rect);
            self.oval_rect = CenterRect([0, 0, h, h] / 2, window_rect);
        end

        function draw_spot(self, spot_rgb)
            arguments
                self (1, 1) tnt.calibration.Spectrum
                spot_rgb (1, 3) double
            end

            Screen('FillOval', self.window_id, spot_rgb, self.oval_rect);
            Screen('Flip', self.window_id);
        end

        function present(self)
            rgbk = [eye(3), zeros(3, 1)] * self.max_color;
            counter = 0;
            while true
                if self.custom_flag
                    disp("RGB値を入力してください。");
                    try
                        in = input("tnt> [R, G, B] = ");
                        if ~all(isnumeric(in))
                            error("数値を入力してください。入力されたのは " + class(in) + " です。");
                        elseif ~all(size(in) == [1, 3])
                            error("サイズは 1x3 でなければなりません。");
                        end
                        in = double(in);
                        if any(isnan(in))
                            error("無効な数値が入力されました");
                        end
                    catch e
                        disp("エラー： " + e.message);
                        continue;
                    end
                    rgb = in';
                    msg = "指定された色を呈示中。";
                else
                    rgb = rgbk(:, counter + 1);
                    msg = "[R, G, B] = [" + join(string(rgb), ", ") + "] を呈示中。";
                end
                self.draw_spot(rgb);
                disp(msg);
                disp("エンターキーで次の色を呈示します。1を入力すると終了します。");
                if input("tnt> ", "s") == "1"
                    break;
                end

                counter = rem(counter + 1, 4);
            end
        end
    end
end
