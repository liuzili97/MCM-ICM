function sol
	% dy=(y+3t)/t^2
	% 初值y(0)=2

	function dx=fun(t,x)
	    dx(1)=(x(1)+3*t)/t^2;
	    dx=dx(:);
	end

	[t,x]=ode45(@fun,[1:0.01:4],[-2])
	plot(t,x)
end