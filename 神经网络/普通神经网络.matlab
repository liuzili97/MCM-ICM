banana=[1 2 3 1 2 3 4 5 6 2 ];
pen=[2 3 7 2 3 4 5 3 9 2 ];
potato_actual=(banana*1+pen*2)/3;
potato_actual=[1.6 2.6 5.6 1.6 2.6 3.6 4.6 3.6 8.0 2.0];

[input,ps1]=mapminmax([banana;pen]);
[target,ps2]=mapminmax([potato_actual]);

net=newff(input,target,6,{'tansig','purelin'},'trainlm');
net.trainParam.epochs=1000;
net.trainParam.goal=0.00001;
LP.lr=0.000001;

net=train(net,input,target);
banana1=[2 1 3 5 9 9];
pen1=[1 2 8 2 10 3];
potato_actual1=(banana1*1+pen1*2)/3;
input1=mapminmax(‘apply',[banana1;pen1],ps1);

output1=net(input1);
prediction1=mapminmax('reverse',output1,ps2);

set(0,'defaultfigurecolor','w')
figure
plot(potato_actual1,'*','color',[222 87 18]/255);hold on
plot(prediction1,'-o','color',[244 208 0]/255,...
'linewidth',2,'MarkerSize',14,'MarkerEdgecolor',[138 151 123]/255);
legend('actua value','prediction1'),title('预测其他数据')
xlabel('potato1'),ylabel('weight')
 set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
    'XMinorTick', 'on', 'YMinorTick', 'on', 'YGrid', 'on', ...
    'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3],'LineWidth', 1)

figure
output=net(input);
prediction=mapminmax('reverse',output,ps2);

plot(potato_actual,'*','color',[29 131 8]/255);hold on
plot(prediction,'-o','color',[244 208 0]/255,...
'linewidth',2,'MarkerSize',14,'MarkerEdgecolor',[138 151 123]/255);
legend('actua value','prediction')
title('预测本身10个数据')
xlabel('potato'),ylabel('weight')
 set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
    'XMinorTick', 'on', 'YMinorTick', 'on', 'YGrid', 'on', ...
    'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3],'LineWidth', 1)
