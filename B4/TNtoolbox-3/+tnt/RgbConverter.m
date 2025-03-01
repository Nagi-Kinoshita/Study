classdef RgbConverter
    % 色変換用クラス
    % 線形RGB色空間と各種色空間(LMS色空間、CIE 1931 XYZ色空間、Judd modified XYZ色空間)を変換できる。
    %
    % それぞれの色空間の変換は 「色空間名_to_色空間名」のメソッドを利用して行える。
    % ただし、各種色空間名は以下の文字列によって表される。
    %   linear_rgb: 線形RGB色空間(ディスプレイの色域で0から1に正規化されている)
    %   lms: LMS色空間
    %   xyz: CIE 1931 XYZ色空間
    %   xyzj: Judd modified XYZ色空間
    %
    % 例: CIE 1931 XYZ色空間から線形RGB色空間への変換。
    %   rgb_converter = tnt.RgbConverter(spectrum_data);
    %   rgb_data = rgb_converter.xyz_to_linear_rgb(xyz_data);
    % 全てのメソッドにおいて変換できるデータは、3xNの行列かMxNx3の画像のみである。
    % ※spectrum_dataは分光分布の測定結果のデータである(wikiの測光を参照)。
    %
    %
    % このクラスを利用するには、測定結果のデータ(spectrum_data)を指定し、RgbConverterを作成する。
    %
    % 構文
    %   rgb_converter = tnt.RgbConverter(spectrum_data);
    %
    % 引数
    %   spectrum_data:
    %     分光分布のデータ。
    %     測定機器が SpectroCAL の場合、401行4列の行列でなければならない。
    %     401行は380~720nmの波長の1nm刻みに対応し、4列は赤、緑、青、黒に対応する。
    %     測定機器が PR-650 の場合、101行4列の行列でなければならない。
    %     101行は380~720nmの波長の4nm刻みに対応し、4列は赤、緑、青、黒に対応する。
    %
    %  返り値
    %    rgb_converter: RgbConverter(このクラスのインスタンス)
    properties (Access = public)
        lmsk
        lms2rgb
        rgb2lms

        sslmsk
        sslms2rgb
        rgb2sslms

        xyzjk
        xyzj2rgb
        rgb2xyzj

        xyzk
        xyz2rgb
        rgb2xyz
    end

    methods
        function self = RgbConverter(spectrum_data)
            % 測定結果のデータ(spectrum_data)を指定し、RgbConverterを作成する。
            %
            % 構文
            %   rgb_converter = tnt.RgbConverter(spectrum_data);
            %
            % 引数
            %   spectrum_data:
            %     分光分布のデータ。
            %     測定機器が SpectroCAL の場合、401行4列の行列でなければならない。
            %     401行は380~720nmの波長の1nm刻みに対応し、4列は赤、緑、青、黒に対応する。
            %     測定機器が PR-650 の場合、101行4列の行列でなければならない。
            %     101行は380~720nmの波長の4nm刻みに対応し、4列は赤、緑、青、黒に対応する。
            %
            %  返り値
            %    rgb_converter: RgbConverter(このクラスのインスタンス)
            arguments
                spectrum_data (:, :) double
            end

            % load color matching functions
            [file_path, ~, ~] = fileparts(mfilename("fullpath"));
            spec_size = size(spectrum_data);
            if spec_size(2) ~= 4
                error("分光分布のデータは赤、緑、青、黒の4列が必要です。");
            end
            switch spec_size(1)
            case 101 % PR-650: 380nm - 780nm, 4n
                nm = 4; % intervals
                sp_cf = readmatrix(file_path + "/CMFs/cfSP1975_PR650.txt");
                sp_cf = sp_cf(:, 2:4); % remove wavelength information
                ss_cf = readmatrix(file_path + "/CMFs/ss_cone_fundamentals_4nm.txt");
                ss_cf = ss_cf(1:101, 2:4); % remove wavelength information
                xyzj_cmf = readmatrix(file_path + "/CMFs/xyzjcmf_PR650.txt");
                xyzj_cmf = xyzj_cmf(:, 2:4);
                xyz_cmf = readmatrix(file_path + "/CMFs/xyzcmf_PR650.txt");
                xyz_cmf = xyz_cmf(:, 2:4);
            case 401 % SpectroCAL: 380nm - 780nm, 1nm
                nm = 1; % intervals
                sp_cf = readmatrix(file_path + "/CMFs/cfSP1975_1nm.txt");
                sp_cf = sp_cf(1:401, 2:4); % remove wavelength information
                ss_cf = readmatrix(file_path + "/CMFs/ss_cone_fundamentals_1nm.txt");
                ss_cf = ss_cf(1:401, 2:4); % remove wavelength information
                xyzj_cmf = readmatrix(file_path + "/CMFs/xyzjcmf_1nm.txt");
                xyzj_cmf = xyzj_cmf(1:401, 2:4);
                xyz_cmf = readmatrix(file_path + "/CMFs/xyzcmf_1nm.txt");
                xyz_cmf = xyz_cmf(21:421, 2:4);
            otherwise
                error("分光分布は101行または401行でなければなりません。");
            end

            % spectrum of K (equal to black: (R, G, B) = (0, 0, 0))
            k_spectrum = spectrum_data(:, 4);
            % difference of each spectrum between RGB and K
            rgb_spectrum = spectrum_data(:, 1:3) - k_spectrum;


            % make LMS matricies
            % lms values for K
            self.lmsk = sp_cf' * k_spectrum * 683 * nm;
            % matrix for conversion between rgb and lms
            self.rgb2lms = sp_cf' * rgb_spectrum * 683 * nm + self.lmsk;
            self.lms2rgb = inv(self.rgb2lms);

            % make Stockman_Sharpe LMS matrices
            % lms values for K
            self.sslmsk = ss_cf' * k_spectrum * 683 * nm;
            % matrix for conversion between rgb and lms
            self.rgb2sslms = ss_cf' * rgb_spectrum * 683 * nm + self.sslmsk;
            self.sslms2rgb = inv(self.rgb2sslms);

            % make XYZ (modified by Judd) matrices
            self.xyzjk = xyzj_cmf' * k_spectrum * 683 * nm;
            self.rgb2xyzj = xyzj_cmf' * rgb_spectrum * 683 * nm + self.xyzjk;
            self.xyzj2rgb = inv(self.rgb2xyzj);

            % make XYZ matrices
            self.xyzk = xyz_cmf' * k_spectrum * 683 * nm;
            self.rgb2xyz = xyz_cmf' * rgb_spectrum * 683 * nm + self.xyzk;
            self.xyz2rgb = inv(self.rgb2xyz);
        end

        function rgb = lms_to_linear_rgb(self, lms, option)
            % LMS色空間から線形RGB色空間への変換
            %
            % 構文
            %   rgb_data = rgb_converter.lms_to_linear_rgb(lms_data, cf_option);
            %
            % 引数
            %   rgb_converter:
            %     RgbConverterクラスのインスタンス。
            %   lms_data:
            %     LMS色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            %   cf_option:
            %     錐体分光感度。以下の2種のうちどちらかを文字列で指定する。
            %     "sp75": Smith-Pokorny, 1975
            %     "ss00": Stockman-Sharpe, 2000
            %
            % 返り値
            %   rgb_data:
            %     線形RGB色空間のデータ。ディスプレイの色域で0~1に正規化されていて、
            %     0未満もしくは1より大きい値はディスプレイで呈示できない色であることを示す。
            arguments
                self (1, 1) tnt.RgbConverter
                lms (:, :, :) double
                option (1, 1) string
            end

            switch option
            case "sp75"
                rgb = tnt.three_channel_convert(self, lms, @(s, d) s.lms2rgb * (d - s.lmsk));
            case "ss00"
                rgb = tnt.three_channel_convert(self, lms, @(s, d) s.sslms2rgb * (d - s.sslmsk));
            otherwise
                error("cone fundamentals option must be either of sp75 or ss00.");
            end
        end

        function lms = linear_rgb_to_lms(self, rgb, option)
            % 線形RGB色空間からLMS色空間への変換
            %
            % 構文
            %   lms_data = rgb_converter.linear_rgb_to_lms(rgb_data, cf_option);
            %
            % 引数
            %   rgb_converter:
            %     RgbConverterクラスのインスタンス。
            %   rgb_data:
            %     線形RGB色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            %     ディスプレイの色域で0~1に正規化されていて、
            %     0未満もしくは1より大きい値はディスプレイで呈示できない色であることを示す。
            %   cf_option:
            %     錐体分光感度。以下の2種のうちどちらかを文字列で指定する。
            %     "sp75": Smith-Pokorny, 1975
            %     "ss00": Stockman-Sharpe, 2000
            %
            % 返り値
            %   lms_data:
            %     LMS色空間のデータ。
            arguments
                self (1, 1) tnt.RgbConverter
                rgb (:, :, :) double
                option (1, 1) string
            end

            switch option
            case "sp75"
                lms = tnt.three_channel_convert(self, rgb, @(s, d) (s.rgb2lms * d) + s.lmsk);
            case "ss00"
                lms = tnt.three_channel_convert(self, rgb, @(s, d) (s.rgb2sslms * d) + s.sslmsk);
            otherwise
                error("cone fundamentals option must be either of sp75 or ss00.");
            end
        end

        function rgb = xyzj_to_linear_rgb(self, xyzj)
            % Judd modified XYZ色空間から線形RGB色空間への変換
            %
            % 構文
            %   rgb_data = rgb_converter.xyzj_to_linear_rgb(xyzj_data);
            %
            % 引数
            %   rgb_converter:
            %     RgbConverterクラスのインスタンス。
            %   xyzj_data:
            %     Judd modified XYZ色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            %
            % 返り値
            %   rgb_data:
            %     線形RGB色空間のデータ。ディスプレイの色域で0~1に正規化されていて、
            %     0未満もしくは1より大きい値はディスプレイで呈示できない色であることを示す。
            arguments
                self (1, 1) tnt.RgbConverter
                xyzj (:, :, :) double
            end

            rgb = tnt.three_channel_convert(self, xyzj, @(s, d) s.xyzj2rgb * (d - s.xyzjk));
        end

        function xyzj = linear_rgb_to_xyzj(self, rgb)
            % 線形RGB色空間からJudd modified XYZ色空間への変換
            %
            % 構文
            %   xyzj_data = rgb_converter.linear_rgb_to_xyzj(rgb_data);
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
            %   xyzj_data:
            %     Judd modified XYZ色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            arguments
                self (1, 1) tnt.RgbConverter
                rgb (:, :, :) double
            end

            xyzj = tnt.three_channel_convert(self, rgb, @(s, d) (s.rgb2xyzj * d) + s.xyzjk);
        end

        function rgb = xyz_to_linear_rgb(self, xyz)
            % CIE 1931 XYZ色空間から線形RGB色空間への変換
            %
            % 構文
            %   rgb_data = rgb_converter.xyz_to_linear_rgb(xyz_data);
            %
            % 引数
            %   rgb_converter:
            %     RgbConverterクラスのインスタンス。
            %   xyz_data:
            %     LMS色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            %
            % 返り値
            %   rgb_data:
            %     線形RGB色空間のデータ。ディスプレイの色域で0~1に正規化されていて、
            %     0未満もしくは1より大きい値はディスプレイで呈示できない色であることを示す。
            arguments
                self (1, 1) tnt.RgbConverter
                xyz (:, :, :) double
            end

            rgb = tnt.three_channel_convert(self, xyz, @(s, d) s.xyz2rgb * (d - s.xyzk));
        end

        function xyz = linear_rgb_to_xyz(self, rgb)
            % 線形RGB色空間からCIE 1931 XYZ色空間への変換
            %
            % 構文
            %   xyz_data = rgb_converter.linear_rgb_to_xyz(rgb_data);
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
            %   xyz_data:
            %     LMS色空間のデータ。3xN行列またはMxNx3の画像を変換可能。
            arguments
                self (1, 1) tnt.RgbConverter
                rgb (:, :, :) double
            end

            xyz = tnt.three_channel_convert(self, rgb, @(s, d) (s.rgb2xyz * d) + s.xyzk);
        end
    end
end
