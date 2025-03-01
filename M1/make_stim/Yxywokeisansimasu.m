LED_stim = readmatrix("LED_stim_all4.csv");
XYZ_sens = readmatrix("XYZ_sens.csv");
ipRGC_sens = readmatrix("ipRGC_sens.csv");
uv = readmatrix("u_v_prime.csv");
ALL_coefficient_multi=readmatrix("ALL_coefficient_multi4.csv");

for i = 1:8
    u = uv(1, i);
    v = uv(2, i);
    Y = 400 / 683;
    x = (9 * u) / (6 * u - 16 * v + 12);
    y = (4 * v) / (6 * u - 16 * v + 12);
    
    % ここでYxyとipRGC_lowを出力
    fprintf('Iteration %d: Y = %.4f, x = %.4f, y = %.4f, ipRGC_low = %.4f, ipRGC_high = %.4f\n', i, Y, x, y, 0.34, 0.51);

    % LED_stim_lowの処理
    LED_stim_low = LED_stim(2 * (i - 1) + 1, :);
    LED_stim_one=[LED_stim_low 1];
    spectrum=LED_stim_one*(ALL_coefficient_multi');
    X=0;Y=0;Z=0;ipRGC=0;
    for j=1:391
        X=X+spectrum(j)*XYZ_sens(1,j);
        Y=Y+spectrum(j)*XYZ_sens(2,j);
        Z=Z+spectrum(j)*XYZ_sens(3,j);
        ipRGC=ipRGC+spectrum(j)*ipRGC_sens(j);
    end
    x = X / (X + Y + Z);
    y = Y / (X + Y + Z);
    
    % ここでXYZ(2)とxyとipRGCを出力
    %fprintf('LED_stim_low: Y = %.4f, x = %.4f, y = %.4f, ipRGC = %.4f\n', Y, x, y, ipRGC);

    % LED_stim_highの処理
    LED_stim_high = LED_stim(2 * i, :);
    LED_stim_one=[LED_stim_high 1];
    spectrum=LED_stim_one*(ALL_coefficient_multi');
    X=0;Y=0;Z=0;ipRGC=0;
    for j=1:391
        X=X+spectrum(j)*XYZ_sens(1,j);
        Y=Y+spectrum(j)*XYZ_sens(2,j);
        Z=Z+spectrum(j)*XYZ_sens(3,j);
        ipRGC=ipRGC+spectrum(j)*ipRGC_sens(j);
    end
    x = X / (X + Y + Z);
    y = Y / (X + Y + Z);
    
    % ここでXYZ(2)とxyとipRGCを出力
    fprintf('LED_stim_high: Y = %.4f, x = %.4f, y = %.4f, ipRGC = %.4f\n', Y, x, y, ipRGC);
    fprintf("\n");
end
