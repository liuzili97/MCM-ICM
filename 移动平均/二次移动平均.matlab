% 二次移动平均,适合时间序列出现直线增加或者减少的变动趋势
% 来自《数学建模算法与应用》P478
% 运用y的数据预测后两年
clc,clear
%load y.txt %把原始数据保存在纯文本文件 y.txt 中 
y=[676 825 774 716 940 1159 1384 1524 1668 1688 1958 2031 2234 2566 2820 3006 3093 3277 3514 3770 4107]
m1=length(y);
n=6; %n 为移动平均的项数
for i=1:m1-n+1
    yhat1(i)=sum(y(i:i+n-1))/n; 
end
yhat1 
m2=length(yhat1); 
for i=1:m2-n+1
    yhat2(i)=sum(yhat1(i:i+n-1))/n; 
end
yhat2
plot(1:21,y,'*') 
a21=2*yhat1(end)-yhat2(end) 
b21=2*(yhat1(end)-yhat2(end))/(n-1) 
predict1=a21+b21
predict2=a21+2*b21