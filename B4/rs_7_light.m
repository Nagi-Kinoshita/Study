clear
format long
s=serialport("COM3",460800);
configureTerminator(s,"CR");
setting=readmatrix("LED_8_times_5_intensity2.csv");
%setting=readmatrix("LED_8_times_5_intensity_ipRGC.csv");
gamma=readmatrix('gamma.csv');
EEW_gamma=zeros([1 22]);
EEW=readmatrix("Equal_energy_white.csv");%1種類しか生成されない
for j=1:22
    EEW_gamma(j)=100*((EEW(j)/100)^gamma(j));
end
separator='';
setting_x=zeros([1 22]);
EEW_answer=zeros([40 22]);%最終的にはzeros([40 22])にする。
random_stim=zeros([1 22]);
Test_stim=readmatrix('Test_stim.csv');

Name="Kinoshita";%被験者の名前
Exp_Number=2;%実験ごとに変える、1と3の時は上限に合わせてもらって、2と4の時は下限に合わせてもらう


ListenChar(2); % キー入力がmatlabをジャマしないように。
AssertOpenGL; % OpenGLが使えるかどうかのチェック。
KbName('UnifyKeyNames'); % OSで共通のキー配置にする。
lum_mag=[0.8,0.9,1,1.1,1.2];
default_mag=[0.2,3];
rng(Exp_Number);
random_order=randperm(40);
white=zeros([1 40]);
change=100;
EEW_change=zeros([1 22]);
Times=zeros([1 40]);
datetime.setDefaultFormats('default','yyyy_MM_dd_HH_mm_ss')
Exp_start=datetime;

%Practice
for i=1:3
    count=0;
    check=0;
    x=2*i-rem(Exp_Number,2);    
    for j=1:22
        setting_x(j)=Test_stim(x,j);
    end
    setting_ASCII=make_ASCII(setting_x);
    EEW_change_gamma=EEW_gamma*default_mag(rem(i,2)+1);
    for j=1:22
        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
    end
    writeline(s,'pre0');
    pause(2);
    for j=1:19
        setting_change_ASCII=make_ASCII(setting_x*j/20);
        writeline(s,setting_change_ASCII);
        pause(0.05);
    end
    while 1
        writeline(s,setting_ASCII);
        pause(2);
        for j=1:19
            setting_change_ASCII=make_ASCII(setting_x+(EEW_change-setting_x)*j/20);
            writeline(s,setting_change_ASCII);
            pause(0.05);
        end
        t1=datetime;
        while 1
            [ keyIsDown, times, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(KbName('8'))%'8'でもいい、KbName(56)
                    EEW_change_gamma=EEW_change_gamma+EEW_gamma/change;
                    for j=1:22
                        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
                    end
                    white_setting_ASCII=make_ASCII(EEW_change);
                    writeline(s,white_setting_ASCII);
                elseif keyCode(KbName('2'))%'2'でもいい
                    EEW_change_gamma=EEW_change_gamma-EEW_gamma/change;
                    for j=1:22
                        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
                    end
                    white_setting_ASCII=make_ASCII(EEW_change);
                    writeline(s,white_setting_ASCII);                    
                elseif keyCode(KbName('return'))%EnterのKbNameって何？←return
                    check=1;
                end
            end
            if check==1
                break;
            end
            t2=datetime;
            if(seconds(t2-t1)>4)
                break;                
            end           
        end
        rng(count+i+x);
        random_stim_number=randperm(40);
        for j=1:10
            rng(count+i+x+j);
            random_lum=randperm(5);
            for k=1:22
                random_stim(k)=setting(random_stim_number(j),k);
            end
            random_stim=random_stim*lum_mag(random_lum(1));%ここは消してもよい
            random_stim_ASCII=make_ASCII(random_stim);
            writeline(s,random_stim_ASCII);
            pause(0.1);
        end
        if check==1
            break;
        end
        count=count+1;
    end
    finish_test=i
end

%Exp
for i=1:40
    count=0;
    start=datetime;
    check=0;
    x=random_order(i);    
    for j=1:22
        setting_x(j)=setting(x,j);
    end
    x_bar=x;
    if rem(Exp_Number,3)==1
        x_bar=x_bar+1;
    end
    amari=rem(x_bar,2);
    setting_ASCII=make_ASCII(setting_x);
    EEW_change_gamma=EEW_gamma*default_mag(amari+1);
    for j=1:22
        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
    end
    white(x)=default_mag(amari+1);
    writeline(s,'pre0');
    if i==21
        while 1
            [ keyIsDown, times, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(KbName('return'))%EnterのKbNameって何？←return
                    break;
                end
            end
        end        
    end
    pause(2);
    for j=1:19
        setting_change_ASCII=make_ASCII(setting_x*j/20);
        writeline(s,setting_change_ASCII);
        pause(0.05);
    end
    while 1
        writeline(s,setting_ASCII);
        pause(2);
        for j=1:19
            setting_change_ASCII=make_ASCII(setting_x+(EEW_change-setting_x)*j/20);
            writeline(s,setting_change_ASCII);
            pause(0.05);
        end
        t1=datetime;
        while 1
            [ keyIsDown, times, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(KbName('8'))%'8*'でもいい、KbName(56)
                    white(x)=white(x)+1/change;
                    EEW_change_gamma=EEW_change_gamma+EEW_gamma/change;
                    for j=1:22
                        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
                    end
                    white_setting_ASCII=make_ASCII(EEW_change);
                    writeline(s,white_setting_ASCII);
                elseif keyCode(KbName('2'))%'2@'でもいい
                    white(x)=white(x)-1/change;
                    EEW_change_gamma=EEW_change_gamma-EEW_gamma/change;
                    for j=1:22
                        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
                    end
                    white_setting_ASCII=make_ASCII(EEW_change);
                    writeline(s,white_setting_ASCII);                    
                elseif keyCode(KbName('return'))%EnterのKbNameって何？←return
                    fin=datetime;
                    check=1;
                end
            end
            if check==1
                break;
            end
            t2=datetime;
            if(seconds(t2-t1)>4)
                break;                
            end           
        end
        rng(count+i+x);
        random_stim_number=randperm(40);
        for j=1:10
            rng(count+i+x+j)
            random_lum=randperm(5);
            for k=1:22
                random_stim(k)=setting(random_stim_number(j),k);
            end
            random_stim=random_stim*lum_mag(random_lum(1));%ここは消してもよい
            random_stim_ASCII=make_ASCII(random_stim);
            writeline(s,random_stim_ASCII);
            pause(0.1);
        end
        if check==1
            break;
        end
        count=count+1;
    end
    for j=1:22
        EEW_answer(x,j)=EEW_change(j);
    end
    finish=i
    Times(x)=seconds(fin-start);
end
writeline(s,'pre0');
SaveFileName=strjoin([Name,'_result',num2str(Exp_Number),'_magnification_',string(Exp_start),'.csv'],separator);
writematrix(white,SaveFileName);
SaveFileName=strjoin([Name,'_result',num2str(Exp_Number),'_LED_stim_',string(Exp_start),'.csv'],separator);
writematrix(EEW_answer,SaveFileName);
SaveFileName=strjoin([Name,'_result',num2str(Exp_Number),'_time_',string(Exp_start),'.csv'],separator);
writematrix(Times,SaveFileName);
%先輩方が使ってるテンキーの方がいいかも