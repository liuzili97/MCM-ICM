% 非线性优化问题（非线性表达式 s.t. 约束条件）
% 例如求非线性表达式为 f(x)=\sum{i=1}^{11} b_i * \log(x_i+t_i) - b_i * \log(t_i)的最大值
% 约束条件为x_i>=0 (i=1,2,...11) 以及 \sum_{i=1}^{11} x_i=100000000

% gaoptimset('PlotFcns',@gaplotbestf)为options的参数，可以画出下降图，如果画出来不合适，可以使用
% gaoptimset('Generations',100,'PlotFcns',@gaplotbestf)来限定迭代次数，这样输出的图的横坐标就限制在100内
% 在工具箱里面也可以设置plot的参数

% 如果有非线性约束，见http://blog.csdn.net/qq_37043191/article/details/77898335
% 如果有整数约束，则在GUI的IntConIndex中填写如[1 3 5]（表示x1,x3,x5为整数）
% 01问题则在IntConIndex中填写[1 2 ....]，再将每个变量上限下限填为1和0

% 以下内容保存为fun.m
function f =fun(x)
  b= [0.903, 0.501, 0.655 , 1.075 , 0.965 , 0.629 , 1.429 , 1.275 , 0.755 , 1.701 , 1.219];
  t= [60202000,22027551,105132543,2929453717 ,71205991,95780211,36908000,48132000,111949554,62312533,51877376];
  f=b(1)*log(t(1)+x(1))-b(1)*log(t(1));
  for i=2:11
    f = f+b(i)*log(t(i)+x(i))-b(i)*log(t(i));  
  end
  f=-f; % 转化为求最小值
end

% [x,fval] =fmincon('函数名',ga(@函数名, 变量个数, A, b, Aeq, beq),A ,b ,Aeq ,beq);
% [x,fval] =ga(@fun,11,-eye(11,11),zeros(11,1),ones(1,11),[100000000],[],[],[],gaoptimset('PlotFcns',@gaplotbestf));
% [x,fval] =fmincon('fun',ga(@fun,11,-eye(11,11),zeros(11,1),ones(1,11),[100000000]),-eye(11,11),zeros(11,1),ones(1,11),[100000000]);