%把下三角相关系数矩阵粘贴到纯文本文件ch.txt中  
%如
%1.0
%0.2 1.0
%0.4 0.5 1.0
clc,clear  
a=textread('ch.txt');   
d=1-abs(a);  %进行数据变换，把相关系数转化为距离  
d=tril(d);   %提出d矩阵的下三角部分  
b=nonzeros(d); %去掉d中的0元素  
b=b';  %化成行向量  
z=linkage(b,'complete');  %按最长距离法聚类  
y=cluster(z,'maxclust',2);%把变量划分成两类，注:也可3类，底下记得修改  
ind1=find(y==1);  %显示第一类对应的变量编号  
ind2=find(y==2);  %显示第二类对应的变量编号  
ind1=ind1';  
ind2=ind2';  
h=dendrogram(z);  %画聚类图  
ind1,ind2  
set(h,'Color','k','LineWidth',2.0);%把聚类图线的颜色修改成黑色，线宽加粗  