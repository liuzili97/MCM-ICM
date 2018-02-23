% 求解非线性约束问题
% 待优化表达式f(x, y)=x^3-y^3+x*y+2*x^2
% 约束条件为x^2+y^2<=6和x*y=2
% 创建以下函数并保存为fun.m
function f=fun(x)
	f=x(1)^3-x(2)^3+x(1)*x(2)+2*x(1)^2;
end

% 创建约束条件的函数文件并保存为fcontr.m
function [c, d]=fcontr(x)
	c=x(1)^2+x(2)^2-6; % c为不等式约束，需转化为<=0的格式
	d=x*y-2; % d为等式约束，需化为=0的格式
end

% [x fval exitflag]=fmincon('fun',[1 2],[],[],[],[],[],[],'fcontr');