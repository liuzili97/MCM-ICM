% 简单移动平均只适合近期预测,并且使预测目标发展趋势变化不大的情况
clc,clear
y=[533.8 574.6 606.9 649.8 705.1 772.0 816.4 892.7 963.9 1015.1 1102.7];  % 已有的时间序列数据
m=length(y);
n=[2:5]; %n 为移动平均的项数 
for i=1:length(n)
%由于 n 的取值不同，yhat 的长度不一致，下面使用了细胞数组 
    for j=1:m-n(i)+1
        yhat{i}(j)=sum(y(j:j+n(i)-1))/n(i); 
    end
    predict(i)=yhat{i}(end);
    error(i)=sqrt(mean((y(n(i)+1:m)-yhat{i}(1:end-1)).^2)); 
end
predict,error