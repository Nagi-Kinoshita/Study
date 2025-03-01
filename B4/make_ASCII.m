function setting = make_ASCII(intensity)
    temp_setting="scp";
    ch=readmatrix("channel.csv");%3*22
    separator='';
    for j=1:22
        for k=1:3
            if (ch(k,j)~=0)
                temp_setting=strjoin([temp_setting,num2str(ch(k,j),4),',',num2str(intensity(j),4),','],separator);
            end
        end
    end
    setting_copy=char(temp_setting);
    setting=setting_copy(1:end-1);
end