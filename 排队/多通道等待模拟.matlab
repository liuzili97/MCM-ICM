function [num,pass]=computing(tim0)

    seat=[0 0 0];%服务员属性
    pass=rand(1,4);%顾客信息：序号、到达时间、特殊要求时间、正常理发时间
    pass(5)=0;%理发员
    pass(6)=0;%离开时间
    pass(7)=0;%等待时间
    num=1;%服务人数初始化
    tim=0;%时间计数器
    temp=0;%顾客到达时间间隔

    while tim<=tim0 
        pass(num,1)=num;  %装入序号
        pass(num,2)=rand;
        pass(num,3)=rand;
        pass(num,4)=rand;

        %计算顾客到达时间间隔
        if pass(num,2)<=0.07 %到达时间间隔为2分钟的概率为0.07
           temp=2;
        elseif pass(num,2)<=0.17
                temp=3;
        elseif pass(num,2)<=0.69
                temp=4;
        elseif pass(num,2)<=0.89
                temp=5;
        else
                temp=6;
        end
        tim=tim+temp;   %装入顾客到达时间
        pass(num,2)=tim;
        if pass(num,3)<=0.1 %有特殊要求时间的顾客出现概率为0.1
            pass(num,3)=4;  %装入需要特殊服务的时间
        else pass(num,3)=0;
        end
        num=num+1;
    end
    num=num-1;

    for i=1:num
        %计算顾客的理发席位(坐座位时优先级为1,2,3)
        if seat(1)<=pass(i,2)+pass(i,7) %如果这个顾客的到达时间+等待时间超过座位释放时间
            pass(i,5)=1; %由1号服务员理发
            temp1=timinge1(1,pass(i,4)); %理发时间
            seat(1)=pass(i,2)+pass(i,3)+temp1; %座位释放时间
            pass(i,4)=temp1;  %装入正常理发所需时间
        elseif seat(2)<=pass(i,2)+pass(i,7)
                pass(i,5)=2;  %由2号服务员理发
                temp1=timinge1(2,pass(i,4));
                seat(2)=pass(i,2)+pass(i,3)+temp1;
                pass(i,4)=temp1; %装入正常理发所需时间
        elseif seat(3)<=pass(i,2)+pass(i,7)
                pass(i,5)=3; %由2号服务员理发
                temp1=timinge1(3,pass(i,4));
                seat(3)=pass(i,2)+pass(i,3)+temp1;
                pass(i,4)=temp1;                
        else               %计算等待时间
                x=seat(1);
                y=1; 
                if x>seat(2)
                    x=seat(2);
                    y=2;
                end
                if x>seat(3)
                    x=seat(3);
                    y=3;
                end %找到最早释放座位的理发师
                pass(i,5)=y;
                 temp1=timinge1(y,pass(i,4));
                 pass(i,7)=seat(y)-pass(i,2);
                 seat(y)=seat(y)+temp1+pass(i,3);
                 pass(i,4)=temp1;
        end
        pass(i,6)=pass(i,2)+pass(i,3)+pass(i,4)+pass(i,7);
    end

function xxxx=timinge1(vect1,vect) %得到第vect1号服务员理发所花的时间
    switch vect1 %第vect1号服务员理发
        case 1    
           if vect<=0.18
                xxxx=8;
           elseif vect<=0.4
                xxxx=9;
           elseif vect<=0.77
                xxxx=10;
           else xxxx=11;
           end
       case 2    
           if vect<=0.18
                xxxx=10;
           elseif vect<=0.37
                xxxx=11;
           elseif vect<=0.72
                xxxx=12;
           else xxxx=13;
           end
        otherwise  
            if vect<=0.15
                xxxx=12;
            elseif vect<=0.37
                xxxx=13;
            elseif vect<=0.74
                xxxx=14;
            else xxxx=15;
            end
end

% [num,pass]=computing(1000)
% csvwrite('data.csv',pass)