function sol
	% dx/dt=y
	% dy/dt=z
	% dz/dt=x^3-x-y-0.3175z
	% 初值x(0)=0,y(0)=1,z(0)=2
	function dx=fun(t,x)
	    dx(1)=x(2);
	    dx(2)=x(3);
	    dx(3)=x(1)^3-x(1)-x(2)-0.3175*x(3);
	    dx=dx(:);
	end

	% [t,x]=ode45(@fun,求解区间,初值)
	[t,x]=ode45(@fun,[0:0.01:2],[0,1,2])
	% plot3(x(:,1),x(:,2),x(:,3))
end