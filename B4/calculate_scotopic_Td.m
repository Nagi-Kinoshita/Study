function Scotopic_Td = calculate_scotopic_Td(Y,Rod)
L = Y*683; % luminance of adaptation filed (unit:cd/m2) 

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





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H = L*M_2;

S = 0.021323-0.0095623*(7.75-5.75*((((H*a)/846)^0.41) / ((((H*a)/846)^0.41)+2)));% (18)


A = (y-y_0)*S;  %  20≦y≦83 (19)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% integrated formula1 (20)
Du = (7.75-5.75*((((H*a)/846)^0.41) / ((((H*a)/846)^0.41)+2)))+A;  % (20)
  
D = Rod*1700;

d = Du;
r = d/2; 

Scotopic_Td = D*((r^2)*pi);
end