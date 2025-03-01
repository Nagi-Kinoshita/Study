clear
Target_Lum=400;
Equal_energy_target_design(Target_Lum);
lb=zeros([1 26]);
ub=2*ones([1 26]);
%medium=10*ones([1 26]);
%optimoptions(@ga)
%options = optimoptions(@fmincon,'MaxFunctionEvaluations', 30000,'OptimalityTolerance', 1.0000e-04,'ConstraintTolerance',1.0000e-04)
%EEW=fmincon(@LED_light,medium,[],[],[],[],lb,ub);
EEW=ga(@LED_light,26,[],[],[],[],lb,ub);
writematrix(EEW,'Equal_energy_white2.csv');

%{
s=serialport("COM3",460800);
configureTerminator(s,"CR");
EEW_ASCII=make_ASCII(EEW);
writeline(s,EEW_ASCII);
%}