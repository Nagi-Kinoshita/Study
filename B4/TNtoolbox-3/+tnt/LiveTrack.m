classdef LiveTrack < handle
    properties
        device_type

        % calibration settings
        min_duration (1, 1) double {mustBePositive} = 1.2
        point_size (1, :) double {mustBePositive} = [1, 2, 4, 6, 10]
        fixation_threshold (1, 1) double {mustBePositive} = 3.1
        fixation_timeout (1, 1) double {mustBePositive} = 5
        saccade_time (1, 1) double {mustBePositive} = 0.5
    end

    methods (Static)
        function [w_mili, h_mili] = suggest_display_size(inch, screen_index)
            [w, h] = Screen('WindowSize', screen_index);
            aspect_ratio = w / h;
            h_mili = sqrt((inch * 25.4) ^ 2 / (1 + aspect_ratio ^ 2));
            w_mili = aspect_ratio * h_mili;
            disp("計算されたサイズ: " + string(w_mili) + " x " + string(h_mili) + " [mm]");
            warning("物理的なディスプレイサイズは実際に計測しましょう！");
        end

        function demo(view_distance, display_size)
            arguments
                view_distance (1, 1) double
                display_size (1, 2) double
            end
            try
                w = Screen('OpenWindow', max(Screen('Screens')));
                lt = tnt.LiveTrack();
                while true
                    disp("エンターを押した後、約10秒間カメラ映像が表示されます");
                    input("tnt> ", "s");
                    lt.display_video(w);

                    disp("エンターを押した後、キャリブレーションが始まります");
                    input("tnt> ", "s");
                    lt.calibrate(w, view_distance, display_size);

                    disp("エンターを押した後、視線位置が表示されます");
                    input("tnt> ", "s");
                    lt.display_eye_position(w);

                    disp("エンターキーを押すと終了します");
                    disp("もう一度デモを実行するには 1 を入力してください");
                    if input("tnt> ", "s") ~= "1"
                        break;
                    end
                end
            catch err
                Screen('CloseAll');
                rethrow(err)
            end
        end
    end

    methods
        function self = LiveTrack()
            guard = mutex_guard();
            assert(~guard, "すでにLiveTrackがインスタンス化されています");
            mutex_guard(true);
            self.device_type = crsLiveTrackInit();
            assert(self.device_type ~= 100, "デバイスが見つかりません");
        end

        function delete(~)
            mutex_guard(false);
            crs_assert(crsLiveTrackClose(), "LiveTrack用API終了");
            clear("crsLiveTrack", "crsLiveTrackGS");
        end

        function start(~, mode)
            arguments
                ~
                mode (1, 1) string {mustBeMember(mode, ["raw", "calibrated"])} = "calibrated"
            end
            switch mode
            case "raw"
                crs_assert(crsLiveTrackSetResultsTypeRaw(), "生データを取得するモードへの変更");
            case "calibrated"
                crs_assert(crsLiveTrackSetResultsTypeCalibrated(), "較正済データを取得するモードへの変更");
            otherwise
                error("Can't be happened!?");
            end
            crs_assert(crsLiveTrackStartTracking(), "トラッキング開始");
        end

        function stop(~)
            crs_assert(crsLiveTrackStopTracking(), "トラッキング終了");
        end

        function clear(~)
            crs_assert(crsLiveTrackClearDataBuffer(), "バッファをクリア");
        end

        function d = get_latest(~, max_count)
            [d, err] = crsLiveTrackGetLatestEyePosition(ceil(max_count));
            crs_assert(err, "直近のデータを取得");
        end

        function d = drain_buffer(~)
            [d, err] = crsLiveTrackGetBufferedEyePositions();
            crs_assert(err, "バッファ内のデータを取得");
        end

        function display_video(~, ptb_window, option)
            arguments
                ~
                ptb_window
                option.timeout (1, 1) double = 10
                option.video_device_index = []
                option.scale (1, 1) double = realmax
            end

            timer_start = GetSecs();
            v = Screen('OpenVideoCapture', ptb_window, option.video_device_index);
            Screen('StartVideoCapture', v, realmax, 1);
            [ww, wh] = Screen('WindowSize', ptb_window);
            while GetSecs() - timer_start < option.timeout
                t = Screen('GetCapturedImage', ptb_window, v);

                if t > 0
                    [tw, th] = Screen('WindowSize', t);
                    s = min([ww / tw, wh / th, realmax]);
                    rect = CenterRect(ScaleRect([0, 0, tw, th], s, s) , [0, 0, ww, wh]);

                    Screen('DrawTexture', ptb_window, t, [], rect);
                    Screen('Flip', ptb_window);
                    Screen('Close', t);
                end
            end
            Screen('StopVideoCapture', v);
            Screen('CloseVideoCapture', v);
            Screen('FillRect', ptb_window);
            Screen('Flip', ptb_window);
        end

        function [left, right, raw] = calibrate( ...
            self, ptb_window, view_distance, display_size, rectangle_area, option)
            arguments
                self
                ptb_window
                view_distance (1, 1) double
                display_size (1, 2) double
                rectangle_area = []
                option (1, 1) string {mustBeMember(option, ["left", "right", "both"])} = "both"
            end

            [w, h] = Screen('WindowSize', ptb_window);
            pixel_ratio = w / h;
            physical_ratio = display_size(1) / display_size(2);
            if abs(pixel_ratio - physical_ratio) > 0.01
                warning("指定されたディスプレイサイズが不適切な可能性があります");
            end
            vertical_pps = w / display_size(1);
            horizontal_pps = h / display_size(2);
            pixel_view_distance = mean([vertical_pps, horizontal_pps]) * view_distance;

            if isempty(rectangle_area)
                ps = self.adjusted_point_rects(w);
                shrink = RectWidth(ps(:, 1)') / 2;
                rectangle_area = InsetRect(Screen('Rect', ptb_window), shrink, shrink);
            end
            x1 = rectangle_area(RectLeft);
            x3 = rectangle_area(RectRight);
            y1 = rectangle_area(RectTop);
            y3 = rectangle_area(RectBottom);
            [x2, y2] = RectCenter(rectangle_area);
            gaze_points = [
                x1, x1, x1, x2, x2, x2, x3, x3, x3
                y1, y2, y3, y1, y2, y3, y1, y2, y3
            ];

            while true
                [left, right, raw] = self.get_fixations(ptb_window, gaze_points, option);

                left.error = NaN;
                if ~all(isnan(left.pupil))
                    left.error = crsLiveTrackCalibrateDevice( ...
                    "left", left.pupil, left.glint, gaze_points', pixel_view_distance);
                end

                right.error = NaN;
                if ~all(isnan(right.pupil))
                    right.error = crsLiveTrackCalibrateDevice( ...
                        "right", right.pupil, right.glint, gaze_points', pixel_view_distance);
                end

                disp("較正誤差");
                disp("左目: " + num2str(left.error) + ", 右目: " + num2str(right.error));
                if left.error >= 0.01 || right.error >= 0.01
                    warning("誤差が大きい（0.01以上）ので再度キャリブレーションを行うことを推奨します");
                end
                disp("エンターキーを押すと終了します");
                disp("もう一度キャリブレーションを実行するには 1 を入力してください");
                if input("tnt> ", "s") ~= "1"
                    break;
                end
            end
        end

        function display_eye_position(self, ptb_window, option)
            arguments
                self
                ptb_window
                option.timeout (1, 1) double = 20
                option.point_size (1, 1) = 10
                option.left_color (3, 1) = [1, 1, 0]'
                option.right_color (3, 1) = [0, 1, 1]'
            end

            eye_rect = option.point_size * 0.5 * [-1, -1, 1, 1];

            max_color = Screen('ColorRange', ptb_window);
            option.left_color = max_color * option.left_color;
            option.right_color = max_color * option.right_color;

            self.clear();
            self.start("calibrated");
            timer_start = GetSecs();
            while GetSecs() - timer_start < option.timeout
                d = self.get_latest(1);
                if isempty(d)
                    continue;
                end
                if d.tracked
                    position = d.mmPositions;
                    left_eye_rect = CenterRectOnPoint(eye_rect, position(1), position(2));
                    Screen('FillOval', ptb_window, option.left_color, left_eye_rect);
                end
                if d.trackedRight
                    position = d.mmPositionsRight;
                    right_eye_rect = CenterRectOnPoint(eye_rect, position(1), position(2));
                    Screen('FillOval', ptb_window, option.right_color, right_eye_rect);
                end

                if d.tracked || d.trackedRight
                    Screen('Flip', ptb_window);
                end
            end
            self.stop();

            Screen('FillRect', ptb_window);
            Screen('Flip', ptb_window);
        end
    end

    methods (Access = private)
        function [left, right, raw] = get_fixations(self, ptb_window, gaze_points, option)
            arguments
                self
                ptb_window
                gaze_points (2, :) double
                option (1, 1) string {mustBeMember(option, ["left", "right", "both"])}
            end

            [w, h] = Screen('WindowSize', ptb_window);
            assert(all(0 <= gaze_points(1, :) & gaze_points(1, :) < w), "指定された座標が範囲外です");
            assert(all(0 <= gaze_points(2, :) & gaze_points(2, :) < h), "指定された座標が範囲外です");

            switch option
            case "left"
                need_left = true;
                need_right = false;
            case "right"
                need_left = false;
                need_right = true;
            case "both"
                need_left = true;
                need_right = true;
            otherwise
                error("Can't be happened!");
            end

            data_size = size(gaze_points');
            left.pupil = nan(data_size);
            left.glint = nan(data_size);
            right.pupil = nan(data_size);
            right.glint = nan(data_size);

            raw = cell(9, 1);

            waitbar_handle = waitbar(0, "計測中");

            self.clear();
            self.start("raw");
            [~, ~, sample_rate, ~, ~, err] = crsLiveTrackGetCaptureConfig();
            crs_assert(err, "録画設定を取得");
            required_frames = ceil(sample_rate * self.min_duration);

            point_rects = self.adjusted_point_rects(w);
            max_color = Screen('ColorRange', ptb_window);
            colors = max_color * [zeros(3, 1), ones(3, 1), zeros(3, 1), ones(3, 1), zeros(3, 1)];
            points_count = size(gaze_points, 2);
            for i = 1:points_count
                msg = "計測中 (" + string(i) + "/" + string(points_count) + ")";
                if isvalid(waitbar_handle)
                    waitbar(i / points_count, waitbar_handle, msg);
                else
                    waitbar_handle = waitbar(i / points_count, msg);
                end

                rects = CenterRectOnPoint(point_rects, gaze_points(1, i), gaze_points(2, i));
                Screen('FillRect', ptb_window, max_color / 2);
                Screen('FillOval', ptb_window, colors, rects);
                Screen('Flip', ptb_window);

                self.clear();
                got_left = false;
                got_right = false;
                timer_start = GetSecs();
                while true
                    d = self.get_latest(required_frames);

                    waited_for_saccade = GetSecs() - timer_start > self.saccade_time;
                    % Left Eye
                    has_enough_frames = size(d.pupilPositions, 1) >= required_frames;
                    has_enough_data = nnz(d.tracked) > length(d.tracked) * 0.9;
                    if has_enough_frames && has_enough_data && waited_for_saccade && ~got_left
                        idx = logical(d.tracked);
                        vec = d.pupilPositions(idx, :) - d.glintPositions(idx, :);
                        max_dif = max(max(vec) - min(vec));
                        if max_dif < self.fixation_threshold
                            left.pupil(i, :) = median(d.pupilPositions);
                            left.glint(i, :) = median(d.glintPositions);
                            got_left = true;
                        end
                    end

                    % Right Eye
                    has_enough_frames = size(d.pupilPositionsRight, 1) >= required_frames;
                    has_enough_data = nnz(d.trackedRight) > length(d.trackedRight) * 0.9;
                    if has_enough_frames && has_enough_data && waited_for_saccade && ~got_right
                        idx = logical(d.trackedRight);
                        vec = d.pupilPositionsRight(idx, :) - d.glintPositionsRight(idx, :);
                        max_dif = max(max(vec) - min(vec));
                        if max_dif < self.fixation_threshold
                            right.pupil(i, :) = median(d.pupilPositionsRight);
                            right.glint(i, :) = median(d.glintPositionsRight);
                            got_right = true;
                        end
                    end

                    break_flag = false;
                    if (got_left || ~need_left) && (got_right || ~need_right)
                        break_flag = true;
                    elseif GetSecs() - timer_start > self.fixation_timeout
                        msg = string(self.fixation_timeout) + "秒経過したので計測がタイムアウトしました（";
                        if got_left
                            msg = msg + "左目成功、";
                        else
                            msg = msg + "左目失敗、";
                        end
                        if got_right
                            msg = msg + "右目成功）";
                        else
                            msg = msg + "右目失敗）";
                        end
                        warning(msg);
                        break_flag = true;
                    end
                    if break_flag
                        raw{i} = self.drain_buffer();
                        break;
                    end
                end
            end
            Screen('FillRect', ptb_window, max_color / 2);
            Screen('Flip', ptb_window);

            if isvalid(waitbar_handle)
                close(waitbar_handle);
            end
            self.stop();
            self.clear();
        end

        function ps = adjusted_point_rects(self, width_pixels)
            ps = width_pixels / 400 * fliplr(self.point_size) .* (0.5 * [-ones(2, 5); ones(2, 5)]);
        end
    end
end

function old = mutex_guard(new_guard)
    arguments
        new_guard = []
    end

    persistent guard
    if isempty(guard)
        guard = false;
    end

    old = guard;

    if ~isempty(new_guard)
        guard = new_guard;
    end
end

function crs_assert(returned_int, msg)
    assert(all(~logical(returned_int)), "LiveTrack> 次のタイミングでエラーが生じました：" + msg);
end