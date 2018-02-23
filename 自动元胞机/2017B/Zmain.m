function Zmain()
%nl:车道长度;nc:车道数目;fp:车道入口处新进入车辆的概率;dt:仿真步长时间;nt:仿真时间;tcinfo:车辆行驶相关参数
[nl,nc,fp,dt,nt] = ZGetBasicInfo();
tcinfo=ZGetTrafficiInfo(); %随机慢化概率、元胞最大速度、随机换道概率、收费站位置、自动驾驶汽车比例
%生成元胞空间
cellspace=ZGenerateCellSpace(nl,nc,tcinfo);
%开始仿真
ZTrafficSimulating(cellspace,fp,dt,nt,tcinfo);
end