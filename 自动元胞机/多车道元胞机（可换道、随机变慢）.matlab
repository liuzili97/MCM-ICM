%%%%%%%%%%%%%%%%%%%%%%%%将文件命名为move_forward.m%%%%%%%%%%%%%%%%%%%%%%%%
function [loc_matrix,v,vmax,traffic_count]=move_forward(loc_matrix,v,vmax,loc_matrixlength,cc); %每调用一次
    %%%%%%%%%%%%%%%%%set%%%%%%%%%%%%%%%%%
    p_new_car=0.8;
    p_auto_car=0;
    max_speed=4;

    [L,W]=size(loc_matrix); % loc_matrix为每个车道的状态矩阵,大小为[length, lane numbers]
    gap=zeros(L,W); % 距离矩阵,表示该位置的车道前方多远处有车
    
    P=0.4; % 随机变慢概率
    P_change_lane=0.1; % 随机变道概率
    
    count=cc; %表示这一轮已经有多少辆车通过了
    t_response=1;% response time 1s v_pre=0;
    %%%%%%%%%%%%%%%%%%%%%%%%%对每一条车道,更新每一辆车的前车距离%%%%%%%%%%%%%%%%%%
    for lanes=1:W; % 遍历每一条车道
        temp=find(loc_matrix(1:L,lanes)>=1); % 找到该车道上有车的位置。loc_matrix为0时表示无车
        nn=length(temp); % nn表示该车道上车的数目
        for k=1:nn; % 遍历每辆车
            i=temp(k); % i表示这辆车在车道上的位置
            if(k==nn)
                gap(i,lanes)=999;
                continue;
            end
            gap(i,lanes)=temp(k+1)-temp(k)-1; % 求这辆车与该车道前一辆车的距离
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    for lanes=1:W; 
        temp=find(loc_matrix(1:L,lanes)>0); 
        nn=length(temp); % nn表示该车道上车的数目
        temp=flipud(temp);% 对矩阵进行上下翻转
        if(nn>0)
            i=temp(1); % 从后往前数第一辆车的位置(最后一辆车)
            pos=i+v(i,lanes); % v为每个车道的速度矩阵
            temp(1)=pos; % 更新最后一辆车的位置
            v_pre=v(i,lanes); % 记录最后一辆车的速度(初始速度)
            if(loc_matrix(i,lanes)==1) % common car need to consider safety
                if(pos>loc_matrixlength) 
                    count=count+1; % 记录离开的车的数量
                    loc_matrix(i,lanes)=0; % 这个格子的车离开后,格子的状态、速度、vm均变为0
                    v(i,lanes)=0;
                    vmax(i,lanes)=0;
                else
                    rand_num=rand(2); %产生2个随机数,第一个判断是否考虑转向,第二个判断转弯方向
                    new_lanes=lanes;
                    if rand_num(1)<P_change_lane
                        if rand_num(2)<0.5 & lanes>1 & any(loc_matrix(i:pos,lanes-1))==0 
                            if i>vmax & any(loc_matrix(i-vmax:i,lanes-1))==0 % 这里考虑后车时采取比较保险的策略.保证i>vmax是为了防止程序出错(越界)
                                new_lanes=lanes-1;
                            end
                        elseif rand_num(2)>=0.5 & lanes<W & any(loc_matrix(i:pos,lanes+1))==0
                            if i>vmax & any(loc_matrix(i-vmax:i,lanes+1))==0   
                                new_lanes=lanes+1;
                            end
                        end
                    end
                            
                    loc_matrix(pos,new_lanes)=loc_matrix(i,lanes); 
                    v(pos,new_lanes)=min(v(i,lanes)+1,vmax(i,lanes)); 
                    vmax(pos,new_lanes)=vmax(i,lanes); 
                    loc_matrix(i,lanes)=0;
                    v(i,lanes)=0;
                    vmax(i,lanes)=0;
                end
             end
            if(loc_matrix(i,lanes)==2) % Self-driving car speed up
                if(pos>loc_matrixlength)  % 和上面一模一样?
                    count=count+1;
                    loc_matrix(i,lanes)=0;
                    v(i,lanes)=0;
                    vmax(i,lanes)=0;
                else
                    rand_num=rand(2);
                    new_lanes=lanes;
                    if rand_num(1)<P_change_lane
                        if rand_num(2)<0.5 & lanes>1 & any(loc_matrix(i:pos,lanes-1))==0 
                            if i>vmax & any(loc_matrix(i-vmax:i,lanes-1))==0 % 这里考虑后车时采取比较保险的策略
                                new_lanes=lanes-1;
                            end
                        elseif rand_num(2)>=0.5 & lanes<W & any(loc_matrix(i:pos,lanes+1))==0
                            if i>vmax & any(loc_matrix(i-vmax:i,lanes+1))==0   
                                new_lanes=lanes+1;
                            end
                        end
                    end
                    
                    loc_matrix(pos,new_lanes)=loc_matrix(i,lanes); 
                    v(pos,new_lanes)=min(v(i,lanes)+1,vmax(i,lanes)); 
                    vmax(pos,new_lanes)=vmax(i,lanes); 
                    loc_matrix(i,lanes)=0;
                    v(i,lanes)=0;
                    vmax(i,lanes)=0;
                end
            end
        end
        for k=2:nn;% 下面的temp已经经过翻转,所以是从后往前递推
            i=temp(k); % i,j分别为某一车道上(倒数第二,倒数第一辆车);(倒数第三,倒数第二辆车)...(第一,第二辆车)的位置
            if rand()<P % 随机慢化
                v(i, lanes)=max(v(i, lanes)-1,0);
            end
            j=temp(k-1); 
            if(v(i,lanes)<=j-i-1) % 如果单位时间前一辆车的移动距离不足以撞上后一辆
                pos=i+v(i,lanes); % 前一辆车移动到新位置pos(仍然在j的前面)
                temp(k)=pos; % 更新前一辆车的位置
                safety_dis=v(i,lanes)*t_response; 
                if(loc_matrix(i,lanes)==1) % common car need to consider safety
                    if(safety_dis>gap(i,lanes)) % 如果更新前与前车距离小于安全距离则一边靠近一边减速 not safe %disp(’not safe’); 
                        if(pos>loc_matrixlength)
                            count=count+1; 
                            loc_matrix(i,lanes)=0; 
                            v_pre=max(v(i,lanes)-1,1); % 如果要离开了,记录减速后的速度?
                            v(i,lanes)=0; 
                            vmax(i,lanes)=0;
                        else
                            rand_num=rand(2);
                            new_lanes=lanes;
                            if rand_num(1)<P_change_lane
                                if rand_num(2)<0.5 & lanes>1 & any(loc_matrix(i:pos,lanes-1))==0 
                                    if i>vmax & any(loc_matrix(i-vmax:i,lanes-1))==0 % 这里考虑后车时采取比较保险的策略
                                        new_lanes=lanes-1;
                                    end
                                elseif rand_num(2)>=0.5 & lanes<W & any(loc_matrix(i:pos,lanes+1))==0
                                    if i>vmax & any(loc_matrix(i-vmax:i,lanes+1))==0   
                                        new_lanes=lanes+1;
                                    end
                                end
                            end
                            
                            loc_matrix(pos,new_lanes)=loc_matrix(i,lanes); 
                            v(pos,new_lanes)=max(v(i,lanes)-1,1); % 到达下一个位置即temp(k)时速度已经变慢
                            vmax(pos,new_lanes)=vmax(i,lanes); 
                            loc_matrix(i,lanes)=0; 
                            v_pre=v(i,lanes); % 如果不会离开,记录减速前的速度?
                            v(i,lanes)=0;
                            vmax(i,lanes)=0;
                        end
                    else % % 如果更新前与前车距离大于安全距离则一边靠近一边加速if safe, accelerate
                           %disp(’safe’);
                        if(pos>loc_matrixlength)
                            count=count+1;
                            loc_matrix(i,lanes)=0;
                            v_pre=v(i,lanes);%record the v before moving v(i,lanes)=0;
                            vmax(i,lanes)=0;
                        else
                            %%%%%%%%%随机变道%%%%%%%%%%%%
                            rand_num=rand(2);
                            new_lanes=lanes;
                            if rand_num(1)<P_change_lane
                                if rand_num(2)<0.5 & lanes>1 & any(loc_matrix(i:pos,lanes-1))==0 
                                    if i>vmax & any(loc_matrix(i-vmax:i,lanes-1))==0 % 这里考虑后车时采取比较保险的策略
                                        new_lanes=lanes-1;
                                    end
                                elseif rand_num(2)>=0.5 & lanes<W & any(loc_matrix(i:pos,lanes+1))==0
                                    if i>vmax & any(loc_matrix(i-vmax:i,lanes+1))==0   
                                        new_lanes=lanes+1;
                                    end
                                end
                            end
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            loc_matrix(pos,new_lanes)=loc_matrix(i,lanes); 
                            v(pos,new_lanes)=min(v(i,lanes)+1,vmax(i,lanes)); % 到达下一个位置即temp(k)时速度已经变快
                            vmax(pos,new_lanes)=vmax(i,lanes);
                            loc_matrix(i,lanes)=0;
                            v_pre=v(i,lanes);%record the v before moving
                            v(i,lanes)=0;
                            vmax(i,lanes)=0;
                        end
                    end
                end
                if(loc_matrix(i,lanes)==2)%self-driving car accelerate 
                    if(pos>loc_matrixlength)
                        %loc_matrix(pos,lanes)=loc_matrix(i,lanes);
                        %v(pos,lanes)=min(v(i,lanes)+1,vmax(i,lanes));
                        %vmax(pos,lanes)=vmax(i,lanes)
                        count=count+1;
                        loc_matrix(i,lanes)=0;
                        v_pre=v(i,lanes);
                        v(i,lanes)=0;
                        vmax(i,lanes)=0;
                    else
                        %%%%%%%%%%无人驾驶汽车不考虑随机变道%%%%%%%%%%%%%%%
                        loc_matrix(pos,lanes)=loc_matrix(i,lanes); 
                        v(pos,lanes)=min(v(i,lanes)+1,vmax(i,lanes)); 
                        vmax(pos,lanes)=vmax(i,lanes); 
                        loc_matrix(i,lanes)=0;
                        v_pre=v(i,lanes);
                        v(i,lanes)=0;
                        vmax(i,lanes)=0;
                    end
                end
            else % 如果单位时间前一辆车的移动距离足以撞上后一辆
                pos=j-1;% 记录后一辆车的前一个位置 move next to the former car temp(k)=pos;
                if(pos>loc_matrixlength)
                    count=count+1;
                    loc_matrix(i,lanes)=0;
                    v_pre=v(i,lanes);
                    v(i,lanes)=0;
                    vmax(i,lanes)=0;
                else
                    %%%%%这里认为无人驾驶汽车在要撞上前车时跟车行驶%%%%%%%%%%
                    loc_matrix(pos,lanes)=loc_matrix(i,lanes); % 前一辆车移动到後一辆车的前一个位置上
                    if(j<=loc_matrixlength) % 如果j还没有离开
                        v(pos,lanes)=v(j,lanes); % 认为到达后一辆车(j的)前一个位置的车(i)的速度和后一辆车(j)相同
                    else
                        v(pos,lanes)=v(i,lanes);
                    end
                    %v(pos,lanes)=v(i,lanes);
                    vmax(pos,lanes)=vmax(i,lanes);
                    loc_matrix(i,lanes)=0;
                    v_pre=v(i,lanes);
                    v(i,lanes)=0;
                    vmax(i,lanes)=0;
                end
            end
        end         
    end
    [loc_matrix,v,vmax]=new_cars(loc_matrix,v,vmax,p_new_car,p_auto_car,max_speed);
    traffic_count=count;
end

%%%%%%%%%%%%%%%%%%%%%%%%将文件命名为new_cars.m%%%%%%%%%%%%%%%%%%%%%%%%
function [loc_matrix,v,vmax]=new_cars(loc_matrix_1,v_1,vmax_1,probc,probv,max_speed); 
    [L,W]=size(loc_matrix_1);
    loc_matrix=loc_matrix_1;
    v=v_1;
    vmax=vmax_1;
    for lanes=1:W;
        if(rand<=probc) %generate a car for a lane according to time distribution %disp(rand);
            if(rand<probv(1)) %generate a self-driving vehicle in possibility p 
                loc_matrix(1,lanes)=2;
                vmax(1,lanes)=max_speed;
                v(1,lanes)=round(rand*max_speed)+1;%random initial speed
            else %generate a non-self-driving vehicle in possibility 1-p 
                loc_matrix(1,lanes)=1;
                vmax(1,lanes)=max_speed;
                v(1,lanes)=round(rand*max_speed)+1;%random initial speed
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%单独建立一个.m文件%%%%%%%%%%%%%%%%%%%%%%%%
data=[];
%%%%%%%%%%%%%%%%%%%set%%%%%%%%%%%%%%%%
length=100;
lane_num=8;
p_new_car=0.8;
p_auto_car=0;
max_speed=4;

ca_show=zeros(length,100,lane_num); %第一维为车道长度,第二维为时间维,第三维为车道
for j=1:100
    [loc_matrix,v,vmax]=new_cars(zeros(length,lane_num),zeros(length,lane_num),zeros(length,lane_num),p_new_car,p_auto_car,max_speed); % 注意这里改了在move_forward里面也要改
    traffic_count=0;
    for i=1:1000
        [loc_matrix,v,vmax,traffic_count]=move_forward(loc_matrix,v,vmax,100,traffic_count);
        ca_show(:,2:end,:)=ca_show(:,1:end-1,:);
        for i=1:lane_num
            ca_show(:,1,i)=loc_matrix(:,i);
        end
        %imshow([loc_matrix(:,2) 0.5*ones(length(loc_matrix(:,1)),1) loc_matrix(:,3) 0.5*ones(length(loc_matrix(:,1)),1) loc_matrix(:,4) 0.5*ones(length(loc_matrix(:,1)),1)...
        %    loc_matrix(:,5) 0.5*ones(length(loc_matrix(:,1)),1) loc_matrix(:,6) 0.5*ones(length(loc_matrix(:,1)),1) loc_matrix(:,7)],'InitialMagnification','fit')
        %figure(1)
        imshow(ca_show(:,:,1),'InitialMagnification','fit')
        xlabel('t')
        ylabel('one lane')
        %figure(2)
        %imshow(loc_matrix,'InitialMagnification','fit')
        
        pause(0.03)
    end
    data=[data traffic_count];
end
disp(mean(data))