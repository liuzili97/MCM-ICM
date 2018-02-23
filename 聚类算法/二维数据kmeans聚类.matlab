x1=5*[randn(500,1)+5,randn(500,1)+5];
x2=5*[randn(500,1)+5,randn(500,1)-5];
x3=5*[randn(500,1)-5,randn(500,1)+5];
x4=5*[randn(500,1)-5,randn(500,1)-5];
x5=5*[randn(500,1),randn(500,1)];
all=[x1;x2;x3;x4;x5];  %生成2500*2的数组
plot(x1(:,1),x1(:,2),'r.');hold on
plot(x2(:,1),x2(:,2),'g.');...
plot(x3(:,1),x3(:,2),'k.');...
plot(x4(:,1),x4(:,2),'y.');...
plot(x5(:,1),x5(:,2),'b.');
IDX=kmeans(all,5); %这里用K-均值算法
y=pdist(all);
z=linkage(y);
t=cluster(z,'cutoff',1.2);
for k=1:2500
    text(all(k,1),all(k,2),num2str(IDX(k)));
end