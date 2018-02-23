% 加权移动平均，适合时间序列没有明显的趋势变动时的情况
y=[6.35 6.20 6.22 6.66 7.15 7.89 8.72 8.94 9.28 9.8]; % 已有的时间序列数据
m=length(y);
w=[1/6;1/6;2/6;2/6]; % 权重
n=4; % 时间序列长度,必须有n==length(w)
yhat=[];
for i=1:m-n+1
   yhat(i)=y(i:i+n-1)*w;
end
err=abs(y(n+1:m)-yhat(1:end-1))./y(n+1:m)
T_err=1-sum(yhat(1:end-1))/sum(y(n+1:m))
predict=yhat(end)/(1-T_err) % 使用平均误差对结果进行修正

