clear
%LED_20_stim=readmatrix('LED_low_stim_spectrum.csv');
LED_20_stim=readmatrix('LED_high_stim_spectrum.csv');
%LED_20_stim=readmatrix('white_stim.csv');
L_sens=readmatrix("L_sens.csv");
M_sens=readmatrix("M_sens.csv");
S_sens=readmatrix("S_sens.csv");
Rod_sens=readmatrix("Rod_sens.csv");
ipRGC_sens=readmatrix("ipRGC_sens.csv");
XYZ_sens=readmatrix("XYZ_sens.csv");
S_out=zeros([5 4]);
M_out=zeros([5 4]);
L_out=zeros([5 4]);
Rod_out=zeros([5 4]);
X=zeros([5 4]);
Y=zeros([5 4]);
Z=zeros([5 4]);
x=zeros([5 4]);
y=zeros([5 4]);
ipRGC_out=zeros([5 4]);
scotopic_Td=zeros([5 4]);
syou=0;
amari=0;
%{
for i=1:20
    [syou,amari]=quorem(sym(i-1),sym(4));
    for j=1:391
        L_out(syou+1,amari+1)=L_out(syou+1,amari+1)+LED_20_stim(i,j)*L_sens(j);
        M_out(syou+1,amari+1)=M_out(syou+1,amari+1)+LED_20_stim(i,j)*M_sens(j);
        S_out(syou+1,amari+1)=S_out(syou+1,amari+1)+LED_20_stim(i,j)*S_sens(j);
        Rod_out(syou+1,amari+1)=Rod_out(syou+1,amari+1)+LED_20_stim(i,j)*Rod_sens(j);
        ipRGC_out(syou+1,amari+1)=ipRGC_out(syou+1,amari+1)+LED_20_stim(i,j)*ipRGC_sens(j);
        X(syou+1,amari+1)=X(syou+1,amari+1)+LED_20_stim(i,j)*XYZ_sens(1,j);
        Y(syou+1,amari+1)=Y(syou+1,amari+1)+LED_20_stim(i,j)*XYZ_sens(2,j);
        Z(syou+1,amari+1)=Z(syou+1,amari+1)+LED_20_stim(i,j)*XYZ_sens(3,j);
    end
    x(syou+1,amari+1)=X(syou+1,amari+1)/(X(syou+1,amari+1)+Y(syou+1,amari+1)+Z(syou+1,amari+1));
    y(syou+1,amari+1)=Y(syou+1,amari+1)/(X(syou+1,amari+1)+Y(syou+1,amari+1)+Z(syou+1,amari+1)); 
    scotopic_Td(syou+1,amari+1)=calculate_scotopic_Td(Y(syou+1,amari+1),Rod_out(syou+1,amari+1));
end
%}
%{
x_graph=390:1:780;
for i=1:5
    for j=1:4
        for k=1:391
            y_graph(k)=LED_20_stim(4*(i-1)+j,k);
        end
        plot(x_graph,y_graph);
        hold on
    end
    legend('Low','Middle-low','Middle-high','High','Location','northeastoutside')
    degree=45*(i+2);
    if i==5
        degree=315;
    end
    titlename=degree+"degree";
    title(titlename,'FontSize',15);
    hold off
    filename=degree+"degree_high_spectrum.png";
    saveas(gcf,filename);
end
%}
%{
writematrix(L_out,"L_low_data.csv");
writematrix(M_out,"M_low_data.csv");
writematrix(S_out,"S_low_data.csv");
writematrix(Rod_out,"Rod_low_data.csv");
writematrix(ipRGC_out,"ipRGC_low_data.csv");
writematrix(X,"X_low_data.csv");
writematrix(Y,"Y_low_data.csv");
writematrix(Z,"Z_low_data.csv");
writematrix(x,"x_color_low_data.csv");
writematrix(y,"y_color_low_data.csv");
%}
%writematrix(Y,"Y_high_data.csv");
%}

