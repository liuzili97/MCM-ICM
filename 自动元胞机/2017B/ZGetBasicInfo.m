function [nl,nc,fp,dt,nt]=ZGetBasicInfo()
ex=importdata('basicinfo.txt');
ex=ex.data;
nl=ex(1); %车道长度
nc=ex(2); %车道数目
fp=ex(3); %车道入口处新进入车辆的概率
dt=ex(4); %仿真步长时间
nt=ex(5); %仿真时间
end