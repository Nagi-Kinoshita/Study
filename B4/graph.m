white_x=0.31382;
white_y=0.331;%D65 CIE 1964 10°測色標準観察者　
white_u_prime=(4*white_x)/(-2*white_x+12*white_y+3);
white_v_prime=(9*white_y)/(-2*white_x+12*white_y+3);
u_v_prime=zeros([2 8]);
separator='';
distance=0.055;
for i=1:8
    u_v_prime(1,i)=white_u_prime+distance*cos(i*pi/4);
    u_v_prime(2,i)=white_v_prime+distance*sin(i*pi/4);
end
x=zeros([1 8]);
y=zeros([1 8]);
for i=1:8
    x(i)=u_v_prime(1,i);
    y(i)=u_v_prime(2,i);
end
plot(x,y,'o')
xlabel('u’');
ylabel('v’');
for i=1:7
    name=strjoin(["  ",num2str(i*45),"deg"],separator);
    text(x(i),y(i),name)
end
text(x(8),y(8),'0deg');