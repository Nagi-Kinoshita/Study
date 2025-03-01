classdef DklConverter < tnt.RgbConverter
    % RgbConverterの色変換機能に加え、DKL色空間とLMS色空間の変換が行える。
    %
    % DKL色空間は色変換メソッドにおいて "dkl" という名前で表現される。
    % 例えば、DKL色空間からLMS色空間への変換には dkl_to_lms メソッドを利用する。
    %
    % このクラスを利用するには、以下の構文に従って DklConverter を作成する。
    %
    % 構文
    %   dkl_converter = tnt.DklConverter(spectrum_data, bg_rgb, cone_fundamentals);
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
    %   dkl_converter:
    %     DklConverterのインスタンス。
    properties (GetAccess = public, SetAccess = protected)
        % 背景の色をLMS色空間上で表現したもの。
        bg_lms

        % 錐体分光感度。以下の文字列で表される。
        %   "sp75": Smith-Pokorny, 1975
        %   "ss00": Stockman-Sharpe, 2000
        cone_fundamentals

        % 輝度に対するL錐体及びM錐体の重みの比を表す。
        dkl_lm_lum_weights

        % ディスプレイで表示可能な色域の最大値をDKL色空間上で表したもの。
        dkl_scale_factor
    end

    properties (Access = protected)
        m_cone_inc_to_dkl
        m_dkl_to_cone_inc

        m_cone_inc_to_cone_contrast
        m_cone_contrast_to_cone_inc
    end

    methods
        function self = DklConverter(rgbsr, bg_rgb, cone_fundamentals)
            % DklConverterをインスタンス化する。
            %
            % 構文
            %   dkl_converter = tnt.DklConverter(spectrum_data, bg_rgb, cone_fundamentals);
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
            %   dkl_converter:
            %     DklConverterのインスタンス。
            arguments
                rgbsr (:, :) double
                bg_rgb (3, 1) double
                cone_fundamentals (1, 1) string
            end

            self@tnt.RgbConverter(rgbsr);
            self.cone_fundamentals = cone_fundamentals;
            self.bg_lms = self.linear_rgb_to_lms(bg_rgb);

            switch self.cone_fundamentals
            case "sp75"
                [file_path, ~, ~] = fileparts(mfilename("fullpath"));
                cf = readmatrix(file_path + "/CMFs/cfSP1975_1nm.txt");
                % remove wavelength information 390-780nm
                T_cones = cf(11:401, 2:4)';
                xyz_judd = load("T_xyzJuddVos");
                S_cones = [390, 1, 391];
                T_Y = 683 * xyz_judd.T_xyzJuddVos(2,:);
                S_Y = xyz_judd.S_xyzJuddVos;
            case "ss00"
                ss2 = load("T_cones_ss2");
                ss2000 = load("T_ss2000_Y2");
                S_cones = ss2.S_cones_ss2;
                T_cones = ss2.T_cones_ss2;
                T_Y = 683 * ss2000.T_ss2000_Y2;
                S_Y = ss2000.S_ss2000_Y2;
            otherwise
                error("cone fundamentals option must be either of sp75 or ss00.");
            end

            T_Y = SplineCmf(S_Y, T_Y, S_cones);
            [self.m_cone_inc_to_dkl, self.dkl_lm_lum_weights] = ComputeDKL_M(self.bg_lms, T_cones, T_Y);
            self.m_dkl_to_cone_inc = inv(self.m_cone_inc_to_dkl);

            self.m_cone_contrast_to_cone_inc = diag(self.bg_lms);
            self.m_cone_inc_to_cone_contrast = diag(1./self.bg_lms);

            self.dkl_scale_factor = self.find_dkl_coeff_monitor();
        end

        function lms = dkl_to_lms(self, dkl)
            % DKL色空間からLMS色空間への変換
            %
            % 構文
            %   lms_data = dkl_converter.dkl_to_lms(dkl_data);
            %
            % 引数
            %   dkl_converter:
            %     このクラス(tnt.DklConverter)のインスタンス。
            %   dkl_data:
            %     DKL色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            %     データの順番は[輝度(Luminance); L-M軸; S軸]。
            %
            % 返り値
            %   lms_data:
            %     LMS色空間のデータ。
            arguments
                self (1, 1) tnt.DklConverter
                dkl (:, :, :) double
            end

            lms = tnt.three_channel_convert(self, dkl, @(s, d) s.bg_lms + s.m_dkl_to_cone_inc * d);
        end

        function dkl = lms_to_dkl(self, lms)
            % LMS色空間からDKL色空間への変換
            %
            % 構文
            %   dkl_data = dkl_converter.lms_to_dkl(lms_data);
            %
            % 引数
            %   dkl_converter:
            %     このクラス(tnt.DklConverter)のインスタンス。
            %   lms_data:
            %     LMS色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            %
            % 返り値
            %   dkl_data:
            %     DKL色空間のデータ。
            arguments
                self (1, 1) tnt.DklConverter
                lms (:, :, :) double
            end

            dkl = tnt.three_channel_convert(self, lms, @(s, d) s.m_cone_inc_to_dkl * (lms - s.bg_lms));
        end

        function rgb = lms_to_linear_rgb(self, lms)
            % LMS色空間から線形RGB色空間への変換
            %
            % 構文
            %   rgb_data = rgb_converter.lms_to_linear_rgb(lms_data);
            %
            % 引数
            %   rgb_converter:
            %     RgbConverterクラスのインスタンス。
            %   lms_data:
            %     LMS色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            %
            % 返り値
            %   rgb_data:
            %     線形RGB色空間のデータ。ディスプレイの色域で0~1に正規化されていて、
            %     0未満もしくは1より大きい値はディスプレイで呈示できない色であることを示す。
            arguments
                self (1, 1) tnt.DklConverter
                lms (:, : , :) double
            end
            rgb = lms_to_linear_rgb@tnt.RgbConverter(self, lms, self.cone_fundamentals);
        end

        function lms = linear_rgb_to_lms(self, rgb)
            % 線形RGB色空間からLMS色空間への変換
            %
            % 構文
            %   lms_data = rgb_converter.linear_rgb_to_lms(rgb_data);
            %
            % 引数
            %   rgb_converter:
            %     RgbConverterクラスのインスタンス。
            %   rgb_data:
            %     線形RGB色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            %     ディスプレイの色域で0~1に正規化されていて、
            %     0未満もしくは1より大きい値はディスプレイで呈示できない色であることを示す。
            %
            % 返り値
            %   lms_data:
            %     LMS色空間のデータ。
            arguments
                self (1, 1) tnt.DklConverter
                rgb (:, : , :) double
            end

            lms = linear_rgb_to_lms@tnt.RgbConverter(self, rgb, self.cone_fundamentals);
        end
    end

    methods (Access = private)
        function dkl_scale_factor = find_dkl_coeff_monitor(self)
            % TNT_FindDKLCoeff_Monitor (ver1.0.0)
            %
            % finds scaling coefficients of all three axes in DKL space based on monitor gamut.
            % this uses rgb range for criterion (0<rgb<1).
            %
            %
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Usage:
            %   DKLscalefactor = TNT_FindDKLCoeff_Monitor(DKLmat, ccmat, cc);
            %
            % Input:
            %   DKLmat:  DKL matrix created by TNT_ComputeDKL_M
            %   ccmat:   color conversion matrix created by TNT_makeccmatrix
            %   cc:      cone fundamentals: 'sp75'(Smith-Pokorny, 1975) or 'ss00' (Stockman-Sharpe, 2000)
            %
            % Output:
            %   DKLscalefactor:  coefficients for DKL scaling
            %
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            %
            % Created by Takehiro Nagai on 04/23/2020 (ver.1.0.0)
            %
            arguments
                self (1, 1) tnt.DklConverter
            end

            % Vector3 array: [+Lum, +lm, +s, -Lum, -lm, -s]
            unit = 0.1 * [eye(3), -1.0 * eye(3)];
            accumulating_dkl = zeros(3, 6);
            dkl_mask = [eye(3, "logical"), eye(3, "logical")];
            while true
                accumulating_dkl = accumulating_dkl + unit;

                acc_lms = self.dkl_to_lms(accumulating_dkl);
                acc_rgb = self.lms_to_linear_rgb(acc_lms);

                over_step_indices = repmat(min(acc_rgb) < 0 | max(acc_rgb) > 1, 3, 1) & abs(unit) >= 0.0000001;
                accumulating_dkl(over_step_indices) = accumulating_dkl(over_step_indices) - unit(over_step_indices);
                unit(over_step_indices) = 0.1 * unit(over_step_indices);

                if all(unit < 0.0000001, "all")
                    break;
                end
            end

            % [luminance-lm-s, pos-neg]
            gamut_limit = accumulating_dkl(dkl_mask);
            gamut_limit = abs(reshape(gamut_limit, [3, 2])) - 0.0001;

            % set rather smaller values
            dkl_scale_factor = diag(min(gamut_limit, [], 2) .* 0.99);
        end
    end
end