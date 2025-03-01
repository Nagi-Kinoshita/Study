clear;
clc;
%%%これは　A unified formula for light-adapted pupil size という論文を参考に計算したものです。

%%%これは　pupil diameter を求める計算式をまとめたものです。

all_stim=readmatrix("ipRGC_48.csv");
i=8;
for j=1:32
    stim(j)=all_stim(i,j);
end
XYZ_lum=calculate_X_Y_Z_lum(stim);
cell_out=calculate_cell_out(stim);

%%%%%%%%%%%%%%%% display background luminance, unit cd/m^2

L = XYZ_lum(4)*683; % luminance of adaptation filed (unit:cd/m2) 

%%%%%%%%%%%%%%%% display information

distence = 40; %distence from eye of participant to display (unit:cm) 
deg_1 = (distence*2*pi)/360;

dispraySize_cm = [7.5,7.5];%[w,h] display size (unit:cm)

dis_w_deg = dispraySize_cm(1)/deg_1;
dis_h_deg = dispraySize_cm(2)/deg_1;

% area in deg^2
a = dis_w_deg * dis_h_deg; % display area  (unit:deg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   other informations

M_2 = 1;   %(17) both eyes( = 1) or monoculars( = 2) 
y = 24; % age of the participant 
y_0 = 23.58; % mean age of participants 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%% calculat pupil size models %%%%%
%%%%%%%%%%%%%%%% Holloday(1926)
D_h = 7*exp(-0.1007*L^0.4)
% 6.3294

%%%%%%%%%%%%%%%% Crawford(1936)
D_c = 5-2.2*tanh(0.61151+0.447*log(L))
%3.8006

%%%%%%%%%%%%%%%% Moon and Spencer(1944)
D_m = 4.9-3*tanh(0.4*log(L)-0.00114)
%4.9034
D_ms = 4.9-3*tanh(0.4*log(L))
%4.9000

%%%%%%%%%%%%%%%% De groot and Gebhard(1952)
D_dg = 7.175*exp(-0.00092*(7.597+log(L))^3)
%4.7933

%%%%%%%%%%%%%%%% Stanley and Davies (1995) 
Dsd = 7.75-5.75*((((L*a)/846)^0.41) / ((((L*a)/846)^0.41)+2))
%5.7430

%%%%%%%%%%%%%%%% barten (1999) 精度悪い
Db = 5-3*tanh(0.4*(log(L*a)-log(1600)))
%5.5536

%%%%%%%%%%%%%%%% Blackie and Howland (1999)
Dbh = 5.697-0.658*log(L)+0.07*log(L)^2
%5.6970



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F = L*a*M_2; %(17.5)

H = L*M_2;

S = 0.021323-0.0095623*(7.75-5.75*((((H*a)/846)^0.41) / ((((H*a)/846)^0.41)+2)));% (18)


A = (y-y_0)*S;  %  20≦y≦83 (19)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% integrated formula1 (20)
Du = (7.75-5.75*((((H*a)/846)^0.41) / ((((H*a)/846)^0.41)+2)))+A  % (20)

% integrated formula2 (21)
Du_2 = (7.75-5.75*((((F*1)/846)^0.41) / ((((F*1)/846)^0.41)+2)))+(y-y_0)*(0.02132-0.009562*(7.75-5.75*((((F*1)/846)^0.41) / ((((F*1)/846)^0.41)+2))))
  
D = cell_out(4)*1700;

d = Du;
r = d/2; 

Scotopic_Td = D*((r^2)*pi)
 
 