clc;
clear all;
% 求车辆的流量随车辆密度(从0到1)变化的规律
T=3030;
P=0.3; % 随机慢化的概率
v_max=6; % vn在0,1,...6中取值
L=2000; % 单车道,道路总长为2000个格子(是个环,头尾相接),放N个车
dens=0.002; %给定初始车辆密度 
p=1; %统计流量密度数组 
while dens<=1 
    N=fix(dens*L); %车辆数目,N一定小于L
    m=1;
    % 产生N辆车的初始随机速度
    v_matrix=randperm(N); % randperm产生1,2,...,N的打乱了的数字
    for i=1:N
        v_matrix(i)=mod(v_matrix(i),v_max+1); % 将速度投射到合理范围
    end
    % 产生初始随机位置,N个车放入单车道中(L个格子)
    [a,b]=find(randperm(L)<=N);
    loc_matrix=b; % 位置从小到大排列,如5辆车时,434,509,1513,1917
    %变化规则 
    for i=1:T
        %定义车头间距,如果两辆车在相邻格子中,则车头间距认为是0
        if loc_matrix(N)>loc_matrix(1) 
            % (以1到2000为序),计算1917格子的车-->2000-->1-->434格子车头的距离
            % 这里的N的一开始的编号,之后N对应的位置并不一定是1-2000中最大的
            headways(N)=L-loc_matrix(N)+loc_matrix(1)-1;
        else
            headways(N)=loc_matrix(1)-loc_matrix(N)-1;
        end
        for j=N-1:-1:1
            if loc_matrix(j+1)>loc_matrix(j)
                headways(j)=loc_matrix(j+1)-loc_matrix(j)-1;
            else
                headways(j)=L+loc_matrix(j+1)-loc_matrix(j)-1;
            end
        end
        
        %速度变化 
        v_matrixNS1=min([v_max-1,v_matrix(1),max(0,headways(1)-1)]);
        %随机慢化概率 %最大速度 %网格的数量
        v_matrix(N)=min([v_max,v_matrix(N)+1,headways(N)+v_matrixNS1]); %NS规则下第N辆车的速度估计值
        for j=N-1:-1:1 
            v_matrixNS=min([v_max-1,v_matrix(j+1),max(0,headways(j+1)-1)]); %NS规则下前一辆车的速度估计值
            v_matrix(j)=min([v_max,v_matrix(j)+1,headways(j)+v_matrixNS]); %NS规则下第j辆车的前一辆车的速度估计值
        end
        
        %以概率P随机慢化
        if rand()<P;
            v_matrix=max(v_matrix-1,0); %随机慢化规则下的速度变化
        end
        %位置更新
        for j=N:-1:1
            loc_matrix(j)=loc_matrix(j)+v_matrix(j);
            if loc_matrix(j)>=L
                loc_matrix(j)=loc_matrix(j)-L; %NS规则下第j辆车的位置更新
            end
        end
        
        %采集数据作图
        if i>L+1000 %采用每组的后30个变量取平均
            speed(m)=sum(v_matrix)/N; %求取平均速度
            m=m+1;
        end
    end
    flow(p)=(sum(speed)/30)*dens; %不同密度下的流量数组 
    density(p)=dens;
    dens=dens+0.01;
    p=p+1;
end
plot(density,flow)