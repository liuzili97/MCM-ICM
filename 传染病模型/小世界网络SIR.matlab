%小世界网络SIR http://blog.csdn.net/sqyx008/article/details/62049395

%SIRModel.m
function y=SIRModel(t,x,lambda1,lambda2,mu,i0)
y=[-lambda1*i0*x(1)-lambda2*x(1)*x(2),(1-mu)*(lambda1*i0*x(1)+lambda2*x(1)*x(2)),mu*(lambda1*i0*x(1)+lambda2*x(1)*x(2))]';

%Command Window 各个参数网页中有
ts=0:1:100;
lambda1=500;
lambda2=20;
mu=0.9925;
i0=5e-7;
x0=[1,0,0];
[t,x] = ode45(@(t,x) SIRModel(t,x,lambda1,lambda2,mu,i0), ts, x0);
plot(t,x(:,1),t,x(:,2),'.',t,x(:,3),'*');
xlabel('时间/天');
ylabel('比例');
legend('易感节点','传播节点','移出节点');
title('λ1=500，λ2=20，μ=99.25%');