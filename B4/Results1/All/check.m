load hald
x = [ones(size(heat)),ingredients];
y = heat;
b = regress(y,x);
yfit = x*b;
resid = y - yfit;
ci = bootci(1000,{@(bootr)regress(yfit+bootr,x),resid},'Type','normal')
slopes = b(2:end)';
lowerBarLengths = slopes-ci(1,2:end);
upperBarLengths = ci(2,2:end)-slopes;
errorbar(1:4,slopes,lowerBarLengths,upperBarLengths)
xlim([0 5])
title('Coefficient Confidence Intervals')