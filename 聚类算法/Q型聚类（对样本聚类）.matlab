clc,clear;  
a=[1,0;1,1;3,2;4,3;2,5];  %共5个样本,每个样本两个指标。欲将5个样本分为3类 
a=zscore(a);              %数据标准化处理  
y=pdist(a,'cityblock');   %求a的行向量之间的绝对距离 
% http://blog.sciencenet.cn/blog-531885-589056.html 各种距离
yc=squareform(y);         %变换成距离方阵  
z=linkage(y);             %产生等级聚类图  
[h,t]=dendrogram(z);      %画聚类图  
T=cluster(z,'maxclust',3);%把对象分成3份，参数可自行修改成2,4,5等，记得将下一行i值修改  
for i=1:3;  
    tm=find(T==i);        %求第i类的对象  
    tm=reshape(tm,1,length(tm));%变成行向量  
    fprintf('第%d类的有%s\n',i,int2str(tm));%显示分类结果  
end  