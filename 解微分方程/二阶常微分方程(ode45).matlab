function sol
    % 高阶常微分方程 d2y=-t*y+exp(t)*dy+3*sin(2*t)
    % 初值 y(0)=2,dy(0)=8
    tspan=[3.9 4.0]; %求解区间
    y0=[2 8]; %初值
    [t,x]=ode45(@odefun,tspan,y0);
    plot(t,x(:,1),'-o',t,x(:,2),'-*')
    legend('y1','y2')
    title('y'' ''=-t*y + e^t*y'' +3sin2t')
    xlabel('t')
    ylabel('y')
    function y=odefun(t,x)
        y=zeros(2,1); % 列向量 x(1)代表y,x(2)代表dy
        y(1)=x(2);    % 这里y(1)代表dy,y(2)代表d2y
        y(2)=-t*x(1)+exp(t)*x(2)+3*sin(2*t);
    end
end