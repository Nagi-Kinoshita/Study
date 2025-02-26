clear

x = 0:1:50;
y1 = 6720 + 720 * x;
y2 = 6300 + 307.2 * x;
y3 = 9900 + 230.4 * x;

plot(x, y2, 'LineWidth', 2)  % 線の太さを2に設定
hold on
plot(x, y3, 'LineWidth', 2)  % 線の太さを2に設定

xlabel("年数")
ylabel("純収益")
% 凡例を左上に配置し、フォントサイズを14に設定
legend("案2", "案3", 'FontSize', 14, 'Location', 'northwest')

