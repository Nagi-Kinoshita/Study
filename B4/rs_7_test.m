clear
format long
s=serialport("COM3",460800);
configureTerminator(s,"CR");
setting=readmatrix("LED_8_times_5_intensity_test.csv");
gamma=readmatrix('gamma.csv');
setting_gamma=zeros([20 22]);
EEW_gamma=zeros([1 22]);
for i=1:20
    for j=1:22
        setting_gamma(i,j)=100*((setting(i,j)/100)^gamma(j));
    end
end
EEW=readmatrix("Equal_energy_white.csv");%1種類しか生成されない
for j=1:22
    EEW_gamma(j)=100*((EEW(j)/100)^gamma(j));
end
separator='';
setting_x=zeros([1 22]);
EEW_answer=zeros([20 22]);%最終的にはzeros([40 22])にする。
random_stim=zeros([1 22]);


Name="Kinoshita";%被験者の名前
Exp_Number=1;%実験ごとに変える


ListenChar(2); % キー入力がmatlabをジャマしないように。
AssertOpenGL; % OpenGLが使えるかどうかのチェック。
KbName('UnifyKeyNames'); % OSで共通のキー配置にする。
lum_mag=[0.8,0.9,1,1.1,1.2];
default_mag=[0.1,0.2,3,4];
random_order=randperm(20);
Lum_order=randperm(20);
white=zeros([1 20]);
change=100;
EEW_change=zeros([1 22]);
for i=1:20
    check=0;
    x=random_order(i);
    for j=1:22
        setting_x(j)=setting(x,j);
    end
    setting_ASCII=make_ASCII(setting_x);
    EEW_change_gamma=EEW_gamma*default_mag(rem(Lum_order(i),4)+1);
    for j=1:22
        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
    end
    white(x)=default_mag(rem(Lum_order(i),4)+1);
    writeline(s,'pre0');
    if i==20
        pause(10);
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
                if keyCode(KbName('UpArrow'))%'8*'でもいい、KbName(56)
                    white(x)=white(x)+1/change;
                    EEW_change_gamma=EEW_change_gamma+EEW_gamma/change;
                    for j=1:22
                        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
                    end
                    white_setting_ASCII=make_ASCII(EEW_change);
                    writeline(s,white_setting_ASCII);
                elseif keyCode(KbName('DownArrow'))%'2@'でもいい
                    white(x)=white(x)-1/change;
                    EEW_change_gamma=EEW_change_gamma-EEW_gamma/change;
                    for j=1:22
                        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
                    end
                    white_setting_ASCII=make_ASCII(EEW_change);
                    writeline(s,white_setting_ASCII);                    
                elseif keyCode(KbName('space'))%EnterのKbNameって何？←Return
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
        random_stim_number=randperm(20);
        for j=1:10
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
    end
    for j=1:22
        EEW_answer(x,j)=EEW_change(j);
    end
end

SaveFileName=strjoin([Name,'_result',num2str(Exp_Number),'_magnification.csv'],separator);
writematrix(white,SaveFileName);
SaveFileName=strjoin([Name,'_result',num2str(Exp_Number),'_LED_stim.csv'],separator);
writematrix(EEW_answer,SaveFileName);