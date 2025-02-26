function [im, precisions, channel_order] = read(file_path, precision, channel_index)
    % OpenEXRの画像を1つのLxMxN(高さx幅xチャンネル数)の行列として読み込む。
    %
    % 構文(省略)
    %   im = tnt.exr.read(file_path);
    %
    % 構文(詳細)
    %   [im, precisions, channel_order] = tnt.exr.read(file_path, precision, channel_index);
    %
    % 引数
    %   file_path:
    %     OpenEXR画像ファイルへのパス。
    %   precision:
    %     返される画像行列の型を文字列で指定する。利用可能なものは以下。
    %     "single", "double", "int8", "int16", "int32", "int64", "uint8", "uint16", "uint32", "uint64", "logical", "char"
    %     指定を省略することができ、その場合はデフォルトの "single" が指定される。
    %     画像データは "uint32", "single", または半精度浮動小数(16bit float)で保存されている。
    %   channel_index:
    %     返される画像行列において、取り出すチャンネルとそれらを重ねる順番を文字列(string)配列で指定する。
    %     例: 画像内に "X", "Y", "Z" という名前のチャンネルが順に存在したとき
    %       ["Z", "Y", "X"] とすると、逆順になる。
    %         im(:, :, 1) がZチャンネルデータ
    %         im(:, :, 2) がYチャンネルデータ
    %         im(:, :, 3) がXチャンネルデータ
    %       "Y" とすると、Yチャンネルのデータのみ取り出される。
    %         im(:, :, 1) がYチャンネルデータ(imのサイズはMxNx1になる)
    %       省略すると、画像に保存されている順になる
    %         im(:, :, 1) がXチャンネルデータ
    %         im(:, :, 2) がYチャンネルデータ
    %         im(:, :, 3) がZチャンネルデータ
    %
    %  返り値
    %    im:
    %      画像行列。
    %    precisions:
    %      画像のチャンネルデータの保存精度を "uint32", "single", "half"(半精度浮動少数) の配列で表す。
    %      precision(i) は im(:, :, i) のチャンネルデータの精度を示す(iは自然数)。
    %    channel_order:
    %      画像のチャンネルの名前を文字列配列で表す。
    %      channel_order(i) は im(:, :, i) のチャンネルの名前を表す(iは自然数)。
    arguments
        file_path (1, 1) string
        precision (1, :) string = []
        channel_index (1, :) string = []
    end

    if isempty(precision)
        precision = "single";
    elseif length(precision) > 1
        error("型は配列ではなく1つの文字列で指定してください。");
    end
    available_types = ["single", "double", "int8", "int16", "int32", "int64", "uint8", "uint16", "uint32", "uint64", "logical", "char"];
    if ~ismember(precision, available_types)
        error("画像データを指定された名前の型に変換できません。");
    end

    exr = tnt.exr.mex.read(file_path);
    if isempty(channel_index)
        indices = 1:length(exr);
    elseif ~all(ismember(channel_index, [exr.name]))
        error("指定された名前のチャンネルはありません。");
    else
        indices = zeros(1, length(channel_index));
        for i = 1:length(channel_index)
            indices(i) = find([exr.name] == channel_index(i), 1);
        end
    end

    im_size_2d = size(exr(1).image);
    im = zeros(im_size_2d(1), im_size_2d(2), length(indices), precision);
    for i = 1:length(indices)
        im(:, :, i) = cast(exr(indices(i)).image, precision);
    end

    reordered_exr = exr(indices);
    precisions = [reordered_exr.precision];
    channel_order = [reordered_exr.name];
end