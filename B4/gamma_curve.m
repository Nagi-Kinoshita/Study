clear
gamma=1.1;

x=linspace(0,1,101);
y=10.6*(x.^gamma);
plot(x,y);
hold on
x2=[0 0.1 0.4 0.7 1];
y2=[0 1.07 4.26 7.44 10.6];
scatter(x2,y2,'MarkerEdgeColor','r','MarkerFaceColor','r')
ax=gca;
ax.FontSize=13;
xlabel('チャンネル入力');
ylabel('放射輝度(Le)');
legend('ガンマカーブ','実測値','Location','northeastoutside')
saveas(gcf,'gamma_curve.png');
