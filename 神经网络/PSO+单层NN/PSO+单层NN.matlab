%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 该代码为基于PSO和BP网络的预测，保存为PSO.m%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 清空环境
clc
clear

%读取数据
%load data input_train input_test output_train output_test

%节点个数
inputnum=2;
hiddennum=3;
outputnum=1;

%训练数据
input1=[1 2 3 1 2 3 4 5 6 2 ]; %输入(2个指标)
input2=[2 3 7 2 3 4 5 3 9 2 ];
output1=[1.6 2.6 5.6 1.6 2.6 3.6 4.6 3.6 8.0 2.0]; %输出
[inputn,inputps]=mapminmax([input1;input2]); %输入数据归一化
[outputn,outputps]=mapminmax(output1); %输出数据归一化
%测试数据 
inputt1=[1 3 5];
inputt2=[2 7 3];
outputt1=[1.6 5.5 4.6];
inputtn=mapminmax('apply',[inputt1;inputt2],inputps); %输入数据归一化
%预测数据
in1=[1 3 5];
in2=[2 7 3];
inn=mapminmax('apply',[in1;in2],inputps); %输入数据归一化
%构建网络
net=newff(inputn,outputn,hiddennum);
% 参数初始化
%粒子群算法中的两个参数
c1 = 1.49445;
c2 = 1.49445;

maxgen=10;   % 进化次数<----------------------------------------  
sizepop=20;   %种群规模<---------------------------------------
wmax=0.9;
wmin=0.4;

Vmax=1;
Vmin=-1;
popmax=5;
popmin=-5;
Dim=inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum;

%% 产生初始粒子和速度
for i=1:sizepop
    %随机产生一个种群
    pop(i,:)=5*rands(1,Dim);    %初始种群
    vov(i,:)=rands(1,Dim);  %初始化速度
    %计算适应度
    fitness(i)=fun(pop(i,:),inputnum,hiddennum,outputnum,net,inputn,outputn,inputps,outputps);   %染色体的适应度
end

% 个体极值和群体极值
[bestfitness bestindex]=min(fitness);
zbest=pop(bestindex,:);   %全局最佳
gbest=pop;    %个体最佳
fitnessgbest=fitness;   %个体最佳适应度值
fitnesszbest=bestfitness;   %全局最佳适应度值

%% 迭代寻优
for i=1:maxgen
    %粒子位置和速度更新
    for j=1:sizepop
        w=wmax-(wmax-wmin)*j/maxgen;
        %速度更新
        %length(gbest(j,:));
        %length(pop(j,1:Dim))
        vov(j,:) = w*vov(j,:) + c1*rand*(gbest(j,:) - pop(j,1:Dim)) + c2*rand*(zbest - pop(j,1:Dim));
        vov(j,find(vov(j,:)>Vmax))=Vmax;
        vov(j,find(vov(j,:)<Vmin))=Vmin;
        
        %种群更新
        pop(j,1:Dim)=pop(j,1:Dim)+0.5*vov(j,:);
        pop(j,find(pop(j,1:Dim)>popmax))=popmax;
        pop(j,find(pop(j,1:Dim)<popmin))=popmin;
        
        %引入变异算子，重新初始化粒子
        if rand>0.9
            k=ceil(21*rand);
            pop(j,k)=rand;
        end
       
        %新粒子适应度值
        fitness(j)=fun(pop(j,1:Dim),inputnum,hiddennum,outputnum,net,inputn,outputn,inputps,outputps);
    end
    %%个体极值和群体极值更新
    for j=1:sizepop
    %个体最优更新
    if fitness(j) < fitnessgbest(j)
        gbest(j,:) = pop(j,1:Dim);
        fitnessgbest(j) = fitness(j);
    end
    
    %群体最优更新 
    if fitness(j) < fitnesszbest
        zbest = pop(j,1:Dim);
        fitnesszbest = fitness(j);
    end
    
    end
    %%每代最优值记录到yy数组中
    yy(i)=fitnesszbest;    
        
end

%% 结果分析
plot(yy)
title(['适应度曲线  ' '终止代数＝' num2str(maxgen)],'fontsize',12);
xlabel('进化代数','fontsize',12);ylabel('适应度','fontsize',12);

x=zbest;
%% 把最优初始阀值权值赋予网络预测
% %用遗传算法优化的BP网络进行值预测
w1=x(1:inputnum*hiddennum);
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);
w2=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);
B2=x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);

net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);
net.b{1}=reshape(B1,hiddennum,1);
net.b{2}=B2;

%% BP网络训练
%网络进化参数
net.trainParam.epochs=100;
net.trainParam.lr=0.1;
net.trainParam.goal=0.0000001;

%网络训练
[net,tr]=train(net,inputn,outputn);

%% BP网络预测
%数据归一化
%预测训练数据
inputn_test=mapminmax('apply',[input1;input2],inputps);
an=sim(net,inputn_test);
%test_simu=mapminmax('reverse',[output1],outputps);
anss=mapminmax('reverse',[an],outputps);
error=output1-anss;

figure(2)
plot(error)
title('仿真预测误差','fontsize',12);
xlabel('仿真次数','fontsize',12);ylabel('误差百分值','fontsize',12);

plot(output1,'*','color',[29 131 8]/255);hold on
plot(anss,'-o','color',[244 208 0]/255,...
'linewidth',2,'MarkerSize',14,'MarkerEdgecolor',[138 151 123]/255);
legend('actua value','prediction')
title('预测本身数据')
xlabel('potato'),ylabel('weight')
 set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
    'XMinorTick', 'on', 'YMinorTick', 'on', 'YGrid', 'on', ...
    'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3],'LineWidth', 1)

%预测测试数据
an=sim(net,inputtn);
anss=mapminmax('reverse',[an],outputps);
error=outputt1-anss;

figure(3)
plot(error)
title('仿真预测误差','fontsize',12);
xlabel('仿真次数','fontsize',12);ylabel('误差百分值','fontsize',12);

plot(outputt1,'*','color',[29 131 8]/255);hold on
plot(anss,'-o','color',[244 208 0]/255,...
'linewidth',2,'MarkerSize',14,'MarkerEdgecolor',[138 151 123]/255);
legend('actua value','prediction')
title('预测测试数据')
xlabel('potato'),ylabel('weight')
 set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
    'XMinorTick', 'on', 'YMinorTick', 'on', 'YGrid', 'on', ...
    'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3],'LineWidth', 1)

%预测
an=sim(net,inn);
anss=mapminmax('reverse',[an],outputps)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%以下保存为fun.m%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function error = fun(x,inputnum,hiddennum,outputnum,net,inputn,outputn,inputps,outputps)
%该函数用来计算适应度值
%x          input     个体
%inputnum   input     输入层节点数
%outputnum  input     隐含层节点数
%net        input     网络
%inputn     input     训练输入数据
%outputn    input     训练输出数据

%error      output    个体适应度值

%提取 BP神经网络初始权值和阈值，x为个体
w1=x(1:inputnum*hiddennum);
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);
w2=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);
B2=x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);
 
%网络权值赋值
net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);
net.b{1}=reshape(B1,hiddennum,1);
net.b{2}=reshape(B2,outputnum,1);
%BP神经网络构建
net=newff(inputn,outputn,hiddennum);
net.trainParam.epochs=100;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00001;
net.trainParam.show=100;
net.trainParam.showWindow=0;

%BP神经网络训练
net=train(net,inputn,outputn);

%网络训练
an=sim(net,inputn);
output=mapminmax('reverse',[outputn],outputps);
anss=mapminmax('reverse',[an],outputps);
error=sum(abs(anss-output));

