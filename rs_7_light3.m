clear
format long
s=serialport("COM3",460800);
configureTerminator(s,"CR");
setting1=readmatrix("ALL_stim_low2.csv");
setting2=readmateiz("ALL_stim_high2.csv");
gamma=readmatrix('gamma.csv');
EEW_gamma=zeros([1 26]);
EEW=readmatrix("Equal_energy_white.csv");%1種類しか生成されない
for j=1:26
    EEW_gamma(j)=100*((EEW(j)/100)^gamma(j));
end
separator='';
setting_x=zeros([1 26]);
random_stim=zeros([1 26]);
Test_stim=readmatrix('Test_stim.csv');

Name="Oda";%被験者の名前
Exp_Number=1;


ListenChar(2); % キー入力がmatlabをジャマしないように。
AssertOpenGL; % OpenGLが使えるかどうかのチェック。
KbName('UnifyKeyNames'); % OSで共通のキー配置にする。
lum_mag=[0.8,0.9,1,1.1,1.2];
default_mag=[0.66,2.1];
rng(Exp_Number);
random_order1=randperm(25);
rng(Exp_Number+4);
random_order2=randperm(25);%実験刺激の順番決め

white1=zeros([1 25]);
white2=zeros([1 25]);
change=100;
EEW_change=zeros([1 26]);
datetime.setDefaultFormats('default','yyyy_MM_dd_HH_mm_ss')
Exp_start=datetime;

writeline(s,'pre0');
%Practice
for i=1:3
    count=0;
    check=0;
    x=rem(Exp_number-1+2*(i-1),5)+1;   
    for j=1:26
        setting_x(j)=Test_stim(x,j);
    end
    setting_ASCII=make_ASCII(setting_x);
    EEW_change_gamma=EEW_gamma*default_mag(rem(i,2)+1);
    for j=1:26
        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
    end

    while 1
        writeline(s,setting_ASCII);
        if count==0
            pause(2);
        else
            t1=datetime;
            while 1
                [ keyIsDown, times, keyCode ] = KbCheck;
                if keyIsDown
                    if keyCode(KbName('return'))%EnterのKbNameって何？←return
                        check=1;
                    end
                end
                if check==1
                    break;
                end
                t2=datetime;
                if(seconds(t2-t1)>2)
                    break;                
                end
            end             
        end
        if check==1
            break;
        end
        rng(count+i+x);
        random_stim_number=randperm(25);
        for j=1:10
            rng(count+i+x+j);
            random_lum=randperm(5);
            for k=1:26
                random_stim(k)=setting2(random_stim_number(j),k);
            end
            random_stim=random_stim*lum_mag(random_lum(1));%ここは消してもよい
            random_stim_ASCII=make_ASCII(random_stim);
            writeline(s,random_stim_ASCII);
            pause(0.1);
        end
        count=count+1;
 
        white_setting_ASCII=make_ASCII(EEW_change);
        writeline(s,white_setting_ASCII);           
        t1=datetime;
        while 1
            [ keyIsDown, times, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(KbName('8'))%'8'でもいい、KbName(56)
                    EEW_change_gamma=EEW_change_gamma+EEW_gamma/change;
                    for j=1:26
                        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
                    end
                    white_setting_ASCII=make_ASCII(EEW_change);
                    writeline(s,white_setting_ASCII);
                elseif keyCode(KbName('2'))%'2'でもいい
                    EEW_change_gamma=EEW_change_gamma-EEW_gamma/change;
                    for j=1:26
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
        if check==1
            break;
        end

        for j=1:19
            setting_change_ASCII=make_ASCII(EEW_change+(setting_x-EEW_change)*j/20);
            writeline(s,setting_change_ASCII);
            pause(0.05);
        end   
    end
    finish_test=i
end

%Exp_low
for i=1:25
    count=0;
    check=0;
    x=random_order1(i);    
    for j=1:26
        setting_x(j)=setting1(x,j);
    end
    x_bar=x;
    if rem(Exp_Number,2)==1
        x_bar=x_bar+1;
    end
    amari=rem(x_bar,2);
    setting_ASCII=make_ASCII(setting_x);
    EEW_change_gamma=EEW_gamma*default_mag(amari+1);
    for j=1:26
        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
    end
    white1(x)=default_mag(amari+1);%倍率
    while 1
        writeline(s,setting_ASCII);
        if count==0
            pause(2);
        else
            t1=datetime;
            while 1
                [ keyIsDown, times, keyCode ] = KbCheck;
                if keyIsDown
                    if keyCode(KbName('return'))%EnterのKbNameって何？←return
                        check=1;
                    end
                end
                if check==1
                    break;
                end
                t2=datetime;
                if(seconds(t2-t1)>2)
                    break;                
                end
            end             
        end
        if check==1
            break;
        end

        rng(count+i+x);
        random_stim_number=randperm(25);
        for j=1:10
            rng(count+i+x+j)
            random_lum=randperm(5);
            for k=1:26
                random_stim(k)=setting2(random_stim_number(j),k);
            end
            random_stim=random_stim*lum_mag(random_lum(1));%ここは消してもよい
            random_stim_ASCII=make_ASCII(random_stim);
            writeline(s,random_stim_ASCII);
            pause(0.1);
        end
        count=count+1;

        t1=datetime;
        while 1
            [ keyIsDown, times, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(KbName('8'))%'8*'でもいい、KbName(56)
                    white1(x)=white1(x)+1/change;
                    EEW_change_gamma=EEW_change_gamma+EEW_gamma/change;
                    for j=1:26
                        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
                    end
                    white_setting_ASCII=make_ASCII(EEW_change);
                    writeline(s,white_setting_ASCII);
                elseif keyCode(KbName('2'))%'2@'でもいい
                    white1(x)=white1(x)-1/change;
                    EEW_change_gamma=EEW_change_gamma-EEW_gamma/change;
                    for j=1:26
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
        if check==1
            break;
        end

        for j=1:19
            setting_change_ASCII=make_ASCII(EEW_change+(setting_x-EEW_change)*j/20);
            writeline(s,setting_change_ASCII);
            pause(0.05);
        end
    end
    finish=i
end
writeline(s,'pre0');
SaveFileName=strjoin([Name,'_result',num2str(Exp_Number),'_magnification_low_',string(Exp_start),'.csv'],separator);
writematrix(white1,SaveFileName);

while 1
    [ keyIsDown, times, keyCode ] = KbCheck;
    if keyIsDown
        if keyCode(KbName('return'))%EnterのKbNameって何？←return
            break;
        end
    end            
end     

writeline(s,make_ASCII(EEW));
pause(10);

%Exp_high
for i=1:25
    count=0;
    check=0;
    x=random_order2(i);    
    for j=1:26
        setting_x(j)=setting2(x,j);
    end
    x_bar=x;
    if rem(Exp_Number,2)==1
        x_bar=x_bar+1;
    end
    amari=rem(x_bar,2);
    setting_ASCII=make_ASCII(setting_x);
    EEW_change_gamma=EEW_gamma*default_mag(amari+1);
    for j=1:26
        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
    end
    white2(x)=default_mag(amari+1);%倍率
    while 1
        writeline(s,setting_ASCII);
        if count==0
            pause(2);
        else
            t1=datetime;
            while 1
                [ keyIsDown, times, keyCode ] = KbCheck;
                if keyIsDown
                    if keyCode(KbName('return'))%EnterのKbNameって何？←return
                        check=1;
                    end
                end
                if check==1
                    break;
                end
                t2=datetime;
                if(seconds(t2-t1)>2)
                    break;                
                end
            end             
        end
        if check==1
            break;
        end

        rng(count+i+x);
        random_stim_number=randperm(25);
        for j=1:10
            rng(count+i+x+j)
            random_lum=randperm(5);
            for k=1:26
                random_stim(k)=setting1(random_stim_number(j),k);
            end
            random_stim=random_stim*lum_mag(random_lum(1));%ここは消してもよい
            random_stim_ASCII=make_ASCII(random_stim);
            writeline(s,random_stim_ASCII);
            pause(0.1);
        end
        count=count+1;

        t1=datetime;
        while 1
            [ keyIsDown, times, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(KbName('8'))%'8*'でもいい、KbName(56)
                    white2(x)=white2(x)+1/change;
                    EEW_change_gamma=EEW_change_gamma+EEW_gamma/change;
                    for j=1:26
                        EEW_change(j)=100*((EEW_change_gamma(j)/100)^(1/gamma(j)));
                    end
                    white_setting_ASCII=make_ASCII(EEW_change);
                    writeline(s,white_setting_ASCII);
                elseif keyCode(KbName('2'))%'2@'でもいい
                    white2(x)=white2(x)-1/change;
                    EEW_change_gamma=EEW_change_gamma-EEW_gamma/change;
                    for j=1:26
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
        if check==1
            break;
        end

        for j=1:19
            setting_change_ASCII=make_ASCII(EEW_change+(setting_x-EEW_change)*j/20);
            writeline(s,setting_change_ASCII);
            pause(0.05);
        end
    end
    finish=i+25
end
writeline(s,'pre0');
SaveFileName=strjoin([Name,'_result',num2str(Exp_Number),'_magnification_high_',string(Exp_start),'.csv'],separator);
writematrix(white2,SaveFileName);