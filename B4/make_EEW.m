clear
Y=0.23;
Target_Lum=Y*683;
Equal_energy_target_design(Target_Lum);
lb=zeros([1 22]);
ub=zeros([1 22]);
medium=zeros([1 22]);
for i=1:22
    ub(i)=5;
    medium(i)=0.5;
end
EEW=fmincon(@LED_light,medium,[],[],[],[],lb,ub);
writematrix(EEW,'Equal_energy_white.csv');
s=serialport("COM3",460800);
configureTerminator(s,"CR");
EEW_ASCII=make_ASCII(EEW);
writeline(s,EEW_ASCII);