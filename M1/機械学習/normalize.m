function result = normalize(data, global_min, global_max, fb)
    if iscell(data) % data がセル配列の場合
        result = cellfun(@(x) normalize_single(x, global_min, global_max, fb), data, 'UniformOutput', false);
    else % data が通常の配列の場合
        result = normalize_single(data, global_min, global_max, fb);
    end
end

function result = normalize_single(data, global_min, global_max, fb)
    if fb == 1
        result = (data - global_min) ./ (global_max - global_min);
    else
        result = data .* (global_max - global_min) + global_min;
    end
end