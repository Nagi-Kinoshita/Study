x=[0 45 90 135 180 225 270 315];

%L_stim
y=[0.238 0.281 0.264 0.205 0.175 0.151 0.158 0.189];
color_all=readmatrix('color_all.csv');
b=bar(x,y);
b.FaceColor = 'flat';
for i=1:8
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    b.CData(i,:) = color;
end
ax=gca;
ax.FontSize=13.5;
title('L錐体刺激量')
xlabel('色相(degree)');
ylabel('L錐体刺激量');
saveas(gcf,'L_stim.png');

%M_stim
y=[0.194 0.235 0.245 0.215 0.193 0.167 0.158 0.165];
color_all=readmatrix('color_all.csv');
b=bar(x,y);
b.FaceColor = 'flat';
for i=1:8
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    b.CData(i,:) = color;
end
ax=gca;
ax.FontSize=13.5;
title('M錐体刺激量');
xlabel('色相(degree)');
ylabel('M錐体刺激量');
saveas(gcf,'M_stim.png');

%S_stim
y=[0.133 0.095 0.072 0.08 0.112 0.143 0.163 0.164];
color_all=readmatrix('color_all.csv');
b=bar(x,y);
b.FaceColor = 'flat';
for i=1:8
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    b.CData(i,:) = color;
end
ax=gca;
ax.FontSize=13.5;
title('S錐体刺激量');
xlabel('色相(degree)');
ylabel('S錐体刺激量');
saveas(gcf,'S_stim.png');

%ipRGC_stim
y=[0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2];
color_all=readmatrix('color_all.csv');
b=bar(x,y);
b.FaceColor = 'flat';
for i=1:8
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    b.CData(i,:) = color;
end
ax=gca;
ax.FontSize=13.5;
title('ipRGC刺激量');
xlabel('色相(degree)');
ylabel('ipRGC刺激量');
ylim([0 0.22])
saveas(gcf,'ipRGC_stim.png');



x=[1 2 3 4 5];
color_all=readmatrix('color_all2.csv');
%L_stim
y=[0.2424 0.2474 0.238 0.2511 0.2503];
b=bar(x,y);
b.FaceColor = 'flat';
for i=1:5
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    b.CData(i,:) = color;
end
ax=gca;
ax.FontSize=13.5;
xlabel('ipRGC強度');
ylabel('L錐体刺激量');
ylim([0 0.3])
saveas(gcf,'L_stim_0degree.png');

%M_stim
y=[0.1786 0.1806 0.194 0.1792 0.1766];
b=bar(x,y);
b.FaceColor = 'flat';
for i=1:5
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    b.CData(i,:) = color;
end
ax=gca;
ax.FontSize=13.5;
xlabel('ipRGC強度');
ylabel('M錐体刺激量');
ylim([0 0.25])
saveas(gcf,'M_stim_0degree.png');

%S_stim
y=[0.124 0.121 0.133 0.123 0.13];
b=bar(x,y);
b.FaceColor = 'flat';
for i=1:5
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    b.CData(i,:) = color;
end
ax=gca;
ax.FontSize=13.5;
xlabel('ipRGC強度');
ylabel('S錐体刺激量');
ylim([0 0.2])
saveas(gcf,'S_stim_0degree.png');

%ipRGC_stim
y=[0.16 0.18 0.2 0.22 0.24];
b=bar(x,y);
b.FaceColor = 'flat';
for i=1:5
    for j=1:3
        color(j)=color_all(i,j)/255;
    end
    b.CData(i,:) = color;
end
ax=gca;
ax.FontSize=13.5;
title('ipRGC刺激量');
xlabel('ipRGC強度');
ylabel('ipRGC刺激量');
saveas(gcf,'ipRGC_stim_0degree.png');