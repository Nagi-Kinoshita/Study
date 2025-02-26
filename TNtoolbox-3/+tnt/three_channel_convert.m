function converted = three_channel_convert(converter, d, convert_fn)
    switch vec3_array_or_image(d)
    case "vec3_array"
        converted = convert_fn(converter, d);
    case "image"
        [h, w, ~] = size(d);
        d = permute(d, [3, 1, 2]);
        d = reshape(d, 3, w * h);
        d = convert_fn(converter, d);
        d = reshape(d, 3, h, w);
        converted = permute(d, [2, 3, 1]);
    otherwise
        error("Only 3xN matrix or MxNx3 image are supported.");
    end
end

function flag = vec3_array_or_image(d)
    flag = "other";
    s = size(d);

    if length(s) == 2 && s(1) == 3
        flag = "vec3_array";
    elseif length(s) == 3 && s(3) == 3
        flag = "image";
    end
end