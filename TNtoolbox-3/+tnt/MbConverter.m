classdef MbConverter < tnt.DklConverter
    % tnt.DklConverterの色変換機能に加えて、L-MB色空間(輝度 + MacLeod-Boynton色度)とLMS色空間の変換が出来るクラス。
    %
    % L-MB色空間(輝度 + MacLeod-Boynton色度)は色変換メソッドにおいて "l_mb" という名前で表現される。
    % 例えば、LMS色空間からL-MB色空間への変換には lms_to_l_mb メソッドを利用する。
    %
    % このクラスを利用するには、以下の構文に従って MbConverter を作成する。
    %
    % 構文
    %   mb_converter = tnt.DklConverter(spectrum_data, bg_rgb, cone_fundamentals);
    %
    % 引数
    %   spectrum_data:
    %     分光分布のデータ。
    %     測定機器が SpectroCAL の場合、401行4列の行列でなければならない。
    %     401行は380~720nmの波長を1nm刻みに対応し、4列は赤、緑、青、黒に対応する。
    %     測定機器が PR-650 の場合、101行4列の行列でなければならない。
    %     101行は380~720nmの波長を4nm刻みに対応し、4列は赤、緑、青、黒に対応する。
    %   bg_rgb:
    %     背景の色を線形RGB色空間上で表したもの。
    %   cone_fundamentals:
    %     錐体分光感度。以下の2種のうちどちらかを文字列で指定する。
    %     "sp75": Smith-Pokorny, 1975
    %     "ss00": Stockman-Sharpe, 2000
    %
    % 返り値
    %   mb_converter:
    %     MbConverterのインスタンス。
    properties (GetAccess = public, SetAccess = protected)
        % 背景の色をL-MB色空間上で表現したもの。
        bg_l_mb

        % 輝度に対するL錐体及びM錐体の重みの比を表す。
        mb_lm_lum_weights

        % ディスプレイで表示可能な色域の最大値をMB色度で表したもの。
        mb_scale_factor
    end

    methods
        function self = MbConverter(rgbsr, bg_rgb, cone_fundamentals)
            % MbConverterをインスタンス化する。
            %
            % 構文
            %   mb_converter = tnt.DklConverter(spectrum_data, bg_rgb, cone_fundamentals);
            %
            % 引数
            %   spectrum_data:
            %     分光分布のデータ。
            %     測定機器が SpectroCAL の場合、401行4列の行列でなければならない。
            %     401行は380~720nmの波長を1nm刻みに対応し、4列は赤、緑、青、黒に対応する。
            %     測定機器が PR-650 の場合、101行4列の行列でなければならない。
            %     101行は380~720nmの波長を4nm刻みに対応し、4列は赤、緑、青、黒に対応する。
            %   bg_rgb:
            %     背景の色を線形RGB色空間上で表したもの。
            %   cone_fundamentals:
            %     錐体分光感度。以下の2種のうちどちらかを文字列で指定する。
            %     "sp75": Smith-Pokorny, 1975
            %     "ss00": Stockman-Sharpe, 2000
            %
            % 返り値
            %   mb_converter:
            %     MbConverterのインスタンス。
            arguments
                rgbsr double
                bg_rgb (3, 1) double
                cone_fundamentals (1, 1) string
            end

            self@tnt.DklConverter(rgbsr, bg_rgb, cone_fundamentals);
            self.mb_lm_lum_weights = self.dkl_lm_lum_weights ./ sum(self.dkl_lm_lum_weights);

            self.bg_l_mb = zeros(3,1);
            self.bg_l_mb(1, :) = self.mb_lm_lum_weights(1) * self.bg_lms(1) + self.mb_lm_lum_weights(2) .* self.bg_lms(2);
            self.bg_l_mb(2, :) = self.mb_lm_lum_weights(1) * self.bg_lms(1) ./ self.bg_l_mb(1);
            self.bg_l_mb(3, :) = mean(self.mb_lm_lum_weights) * self.bg_lms(3) ./ self.bg_l_mb(1);

            self.mb_scale_factor = self.find_mb_coeff_monitor();
        end

        function l_mb = lms_to_l_mb(self, lms)
            % LMS色空間からL-MB色空間への変換
            %
            % 構文
            %   l_mb_data = mb_converter.lms_to_l_mb(lms_data);
            %
            % 引数
            %   mb_converter:
            %     このクラス(tnt.MbConverter)のインスタンス。
            %   lms_data:
            %     LMS色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            %
            % 返り値
            %   l_mb_data:
            %     L-MB色空間のデータ。
            arguments
                self (1, 1) tnt.MbConverter
                lms (:, :, :) double
            end

            l_mb = tnt.three_channel_convert(self, lms, @lms_to_l_mb_inner);
        end

        function lms = l_mb_to_lms(self, l_mb)
            % L-MB色空間からLMS色空間への変換
            %
            % 構文
            %   lms_data = mb_converter.l_mb_to_lms(l_mb_data);
            %
            % 引数
            %   mb_converter:
            %     このクラス(tnt.MbConverter)のインスタンス。
            %   l_mb_data:
            %     L-MB色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            %
            % 返り値
            %   lms_data:
            %     LMS色空間のデータ。
            arguments
                self (1, 1) tnt.MbConverter
                l_mb (:, :, :) double
            end

            lms = tnt.three_channel_convert(self, l_mb, @l_mb_to_lms_inner);
        end
    end

    methods (Access = private)
        function mb_scale_factor = find_mb_coeff_monitor(self)
            % TNT_FindMBCoeff_Monitor (ver1.0.0)
            %
            % finds scaling coefficients of two chromatic axes (L-M and S) in L_MB space
            % based on monitor gamut.
            % this uses rgb range for criterion (0<rgb<1).
            %
            %
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Usage:
            %   MBscalefactor = TNT_FindMBCoeff_Monitor(MBmat, ccmat, cc);
            %
            % Input:
            %   MBmat:  MB matrix created by TNT_ComputeMB_M
            %   ccmat:  color conversion matrix created by TNT_makeccmatrix
            %   cc:     cone fundamentals: 'sp75'(Smith-Pokorny, 1975) or 'ss00' (Stockman-Sharpe, 2000)
            %
            % Output:
            %   MBscalefactor:  coefficients for MB scaling
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            %
            % Created by Takehiro Nagai on 04/24/2020 (ver.1.0.0)
            %
            arguments
                self (1, 1) tnt.MbConverter
            end

            % Vector3 array: [+M, +B, -M, -B]
            accumulating_l_mb = zeros(3, 4);
            accumulating_l_mb(1, :) = self.bg_l_mb(1);
            unit = 0.1 * [[0; 1; 0], [0; 0; 1], [0; -1; 0], [0; 0; -1]];
            l_mb_mask = unit ~= 0;
            while true
                accumulating_l_mb = accumulating_l_mb + unit;

                acc_lms = self.l_mb_to_lms(accumulating_l_mb);
                acc_rgb = self.lms_to_linear_rgb(acc_lms);

                over_step_indices = repmat(min(acc_rgb) < 0 | max(acc_rgb) > 1, 3, 1) & abs(unit) >= 0.0000001;
                accumulating_l_mb(over_step_indices) = accumulating_l_mb(over_step_indices) - unit(over_step_indices);
                unit(over_step_indices) = 0.1 * unit(over_step_indices);

                if all(unit < 0.0000001, "all")
                    break;
                end
            end

            gamut_limit = ones(3, 2);
            gamut_limit(2:3, :) = abs(reshape(accumulating_l_mb(l_mb_mask), [2, 2])) - 0.0001;

            % set rather smaller values
            mb_scale_factor = diag(min(gamut_limit, [], 2) .* 0.99);
        end
    end
end

function l_mb = lms_to_l_mb_inner(self, lms)
    arguments
        self (1, 1) tnt.MbConverter
        lms (3, :) double
    end

    l_mb = zeros(size(lms));

    % calculate luminance and MB values
    l_mb(1, :) = self.mb_lm_lum_weights(1) * lms(1, :) + self.mb_lm_lum_weights(2) * lms(2, :);
    l_mb(2, :) = self.mb_lm_lum_weights(1) * lms(1, :) ./ l_mb(1, :) - self.bg_l_mb(2);
    l_mb(3, :) = mean(self.mb_lm_lum_weights) * lms(3, :) ./ l_mb(1, :) - self.bg_l_mb(3);
end

function lms = l_mb_to_lms_inner(self, l_mb)
    arguments
        self (1, 1) tnt.MbConverter
        l_mb (3, :) double
    end

    lms = zeros(size(l_mb));

    % adjust to base MB space
    base_l_mb = l_mb;
    base_l_mb(2:3, :) = l_mb(2:3, :) + self.bg_l_mb(2:3);

    % calculate lms values
    lms(1, :) = base_l_mb(1, :) .* base_l_mb(2, :) / self.mb_lm_lum_weights(1);
    lms(2, :) = (base_l_mb(1, :) - lms(1, :) * self.mb_lm_lum_weights(1)) / self.mb_lm_lum_weights(2);
    lms(3, :) = base_l_mb(3, :) .* base_l_mb(1, :) / mean(self.mb_lm_lum_weights);
end